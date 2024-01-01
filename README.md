## Simon32/64 Module
This code offers a light weight 32/64 encryption module. the architecture is shown in the images below. The operation is completely unrolled for maximum
throughput and latency. As such there are 32 instantiations of the round and key-expansion blocks that feed into each other.

### High-Level Architecture
![image](https://github.com/okenna10/FPGA_exponential_function/assets/101345398/30266687-6cdd-449f-b5fb-228ac344644a)

### Round Function
![image](https://github.com/okenna10/Simon32-64-Encryption/assets/101345398/fa5e90b3-2a19-4ae5-b138-c7553264e489)

### Key-expansion Module
![image](https://github.com/okenna10/FPGA_exponential_function/assets/101345398/15b3a6ca-369c-42ea-a1d1-06d7b7660c7e)
