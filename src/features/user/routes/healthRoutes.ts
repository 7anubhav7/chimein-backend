/* eslint-disable @typescript-eslint/no-unused-vars */
import express, { Router, Request, Response } from 'express';
import moment from 'moment';
import axios from 'axios';
import { performance } from 'perf_hooks';
import HTTTP_STATUS from 'http-status-codes';
import { config } from '@root/config';

class HealthRoutes {
  private router: Router;

  constructor() {
    this.router = express.Router();
  }

  public health(): Router {
    this.router.get('/health', (req: Request, res: Response) => {
      res.status(HTTTP_STATUS.OK).send(`Health: Server instance is healthy with process id ${process.pid} on ${moment().format('LL')}`);
    });
    return this.router;
  }

  public env(): Router {
    this.router.get('/env', (req: Request, res: Response) => {
      res.status(HTTTP_STATUS.OK).send(`This is the ${config.NODE_ENV} environment after change`);
    });
    return this.router;
  }

  public instance(): Router {
    this.router.get('/instance', async (req: Request, res: Response) => {
      try {
        // Step 1: Get the token from IMDSv2
        const tokenResponse = await axios.put('http://169.254.169.254/latest/api/token', null, {
          headers: { 'X-aws-ec2-metadata-token-ttl-seconds': '21600' }, // 6 hours
          timeout: 1000
        });

        const token = tokenResponse.data;

        // Step 2: Use the token to fetch metadata (instance-id)
        const response = await axios.get('http://169.254.169.254/latest/meta-data/instance-id', {
          headers: { 'X-aws-ec2-metadata-token': token },
          timeout: 1000
        });

        res
          .status(HTTTP_STATUS.OK)
          .send(`Server is running on EC2 instance with id ${response.data} and process id ${process.pid} on ${moment().format('LL')}`);
      } catch (error) {
        res.status(HTTTP_STATUS.INTERNAL_SERVER_ERROR).send('Could not fetch instance ID');
      }
    });
    return this.router;
  }

  public fiboRoutes(): Router {
    this.router.get('/fibo/:num', async (req: Request, res: Response) => {
      try {
        const { num } = req.params;
        const start: number = performance.now();
        const result: number = this.fibo(parseInt(num, 10));
        const end: number = performance.now();

        // Default in case metadata fails
        let instanceId = 'unavailable';

        try {
          // Step 1: Get IMDSv2 token
          const tokenResponse = await axios.put('http://169.254.169.254/latest/api/token', null, {
            headers: { 'X-aws-ec2-metadata-token-ttl-seconds': '21600' }, // 6 hours
            timeout: 1000
          });

          const token = tokenResponse.data;

          // Step 2: Fetch instance-id using token
          const response = await axios.get('http://169.254.169.254/latest/meta-data/instance-id', {
            headers: { 'X-aws-ec2-metadata-token': token },
            timeout: 1000
          });

          instanceId = response.data;
        } catch (err) {
          console.error('Metadata fetch (IMDSv2) failed:');
        }

        res
          .status(HTTTP_STATUS.OK)
          .send(
            `Fibonacci of ${num} is ${result}, took ${end - start}ms, running on EC2 instance ${instanceId}, process id ${process.pid}, ${moment().format('LL')}`
          );
      } catch (error) {
        res.status(500).send('Error computing Fibonacci');
      }
    });
    return this.router;
  }

  //For checking auto scaling by calling fibo series of very high number
  private fibo(data: number): number {
    if (data < 2) {
      return 1;
    } else {
      return this.fibo(data - 2) + this.fibo(data - 1);
    }
  }
}
export const healthRoutes: HealthRoutes = new HealthRoutes();
