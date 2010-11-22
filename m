From: Christoph Bartoschek <bartoschek@or.uni-bonn.de>
Subject: ext4_alloc_context occupies 150 GiB of memory and makes the system unusable
Date: Mon, 22 Nov 2010 13:23:25 +0100
Message-ID: <201011221323.25342.bartoschek@or.uni-bonn.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brical.or.uni-bonn.de ([131.220.141.99]:44937 "EHLO
	brical.or.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0KVMr5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Nov 2010 07:47:57 -0500
Received: from wse04.or.uni-bonn.de (bg-1.or.uni-bonn.de [131.220.141.100])
	by brical.or.uni-bonn.de (Postfix) with ESMTP id 042E63B6D6
	for <linux-ext4@vger.kernel.org>; Mon, 22 Nov 2010 13:23:26 +0100 (CET)
Received: from imap.or.uni-bonn.de (mailserver.or.uni-bonn.de [131.220.143.135])
	by wse04.or.uni-bonn.de (Postfix) with ESMTP id 86AFF4E11
	for <linux-ext4@vger.kernel.org>; Mon, 22 Nov 2010 13:23:26 +0100 (CET)
Received: from burns.bruehl.pontohonk.de (wse00.or.uni-bonn.de [131.220.143.130])
	by imap.or.uni-bonn.de (Postfix) with ESMTPS id 636D21FE9E
	for <linux-ext4@vger.kernel.org>; Mon, 22 Nov 2010 13:23:26 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have the problem that on one machine lots of memory is allocated for 
ext4_alloc_context.

I would like to know for what purpose the memory is allocated and why it is 
not given to processes that need memory.

The machine normally only uses a local ext4 for booting. The data it is 
working on comes from NFS.

Now there are several normally CPU-bound jobs running but they only get 1-2% 
of cputime because they are constantly swapping. They are swapping because of 
the 192 GiB the machine has 150 GiB are allocated for ext4_alloc_context.  
Here is the output of /dev/meminfo:

MemTotal:        198493288 kB
MemFree:            853372 kB
Buffers:               824 kB
Cached:              26108 kB
SwapCached:        6369336 kB
Active:           37073576 kB
Inactive:          1104932 kB
Active(anon):     37059712 kB
Inactive(anon):    1090980 kB
Active(file):        13864 kB
Inactive(file):      13952 kB
Unevictable:             0 kB
Mlocked:                 0 kB
SwapTotal:       209713148 kB
SwapFree:        149362056 kB
Dirty:                  16 kB
Writeback:               0 kB
AnonPages:        37642012 kB
Mapped:              13312 kB
Shmem:                   0 kB
Slab:            158765316 kB
SReclaimable:    158732380 kB
SUnreclaim:          32936 kB
KernelStack:          2968 kB
PageTables:         202500 kB
NFS_Unstable:            4 kB
Bounce:                  0 kB
WritebackTmp:            0 kB
CommitLimit:     308959792 kB
Committed_AS:     64376360 kB
VmallocTotal:  34359738367 kB
VmallocUsed:        736572 kB
VmallocChunk:  34358994676 kB



We see that Slab uses most of the memory. And within slab nearly everything is 
used for ext4_alloc_context. There is the output of slabtop:

 Active / Total Objects (% used)    : 364597 / 1070670469 (0.0%)
 Active / Total Slabs (% used)      : 52397 / 39688960 (0.1%)
 Active / Total Caches (% used)     : 107 / 193 (55.4%)
 Active / Total Size (% used)       : 159579.25K / 150697605.41K (0.1%)
 Minimum / Average / Maximum Object : 0.02K / 0.14K / 4096.00K

  OBJS     ACTIVE  USE OBJ SIZE    SLABS OBJ/SLAB CACHE SIZE NAME                   
1070187012      0   0%    0.14K 39636556       27 158546224K 
ext4_alloc_context



I see no reason why ext4 should use so much memory. What is it used for? And 
how can I release it to get it used for my processes. The overall system is 
very sluggish now. Here is top info for some computing jobs:

top - 13:06:06 up 10 days, 22:04,  5 users,  load average: 9.65, 9.74, 9.80
Tasks: 272 total,   1 running, 271 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.4%us,  0.3%sy,  0.0%ni, 46.5%id, 52.8%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:    193841M total,   192945M used,      895M free,        0M buffers
Swap:   204797M total,    61718M used,   143079M free,   163113M cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                                                                                                                                                                                                                                                        
19459 joachimi  20   0 23.6g  11g 4000 D    0  6.1 417:07.29 bonnRoute                                                                                                                                                                                                                                                                                                                      
 9329 bartosch  20   0 11.7g   9g 3436 D    0  5.3  38:55.70 chipbench                                                                                                                                                                                                                                                                                                                      
28845 bartosch  20   0 10.9g 5.0g 1028 D    0  2.6  28:27.45 chipbench                                                                                                                                                                                                                                                                                                                      
 6505 bartosch  20   0 10.7g 2.8g  976 D    0  1.5 289:24.73 chipbench                                                                                                                                                                                                                                                                                                                      
11061 bartosch  20   0  9.8g 1.5g  900 D    1  0.8 146:07.40 chipbench                                                                                                                                                                                                                                                                                                                      
11010 bartosch  20   0 5638m 1.5g 2800 D    0  0.8  82:48.69 chipbench                                                                                                                                                                                                                                                                                                                      
10946 bartosch  20   0 5952m 1.3g  936 D    0  0.7  80:57.63 chipbench                                                                                                                                                                                                                                                                                                                      
10976 bartosch  20   0 5563m 1.3g  936 D    1  0.7  77:53.40 chipbench                                                                                                                                                                                                                                                                                                                      
11030 bartosch  20   0 9807m 1.2g 4272 D    0  0.6 149:40.97 chipbench                                                                                                                                                                                                                                                                                                                      
 9330 bartosch  20   0 69572 7160  376 S    0  0.0   0:33.06 chipbench                                                                                                                                                                                                                                                                                                                      
10914 bartosch  20   0 81888 4668  480 S    0  0.0   0:48.84 chipbench                                                                                                                                                                                                                                                                                                                      
17065 bartosch  20   0 99.0m 3408  488 S    0  0.0   0:41.91 chipbench                                                                                                                                                                                                                                                                                                                      
11031 bartosch  20   0 75724 2988  496 S    0  0.0   0:53.41 chipbench


iotop shows that the jobs while not creating any normal I/O create lots of 
disk reads and spents nearly 100% for swapping:

Total DISK READ: 4.91 M/s | Total DISK WRITE: 0 B/s
  PID USER      DISK READ  DISK WRITE   SWAPIN    IO>    COMMAND                                                                                                                                                                                                                                                                                                                            
   79 root           0 B/s       0 B/s  0.00 % 94.34 % [kswapd0]
10946 bartosch    3.14 M/s       0 B/s 65.42 %  1.54 % chipbench
28845 bartosch  334.16 K/s       0 B/s 99.99 %  0.00 % chipbench
 6505 bartosch  194.28 K/s       0 B/s 99.99 %  0.00 % chipbench
10976 bartosch  147.65 K/s       0 B/s 99.99 %  0.00 % chipbench
11010 bartosch  170.97 K/s       0 B/s 95.03 %  0.00 % chipbench
11030 bartosch   85.48 K/s       0 B/s 77.11 %  0.00 % chipbench
11061 bartosch  174.85 K/s       0 B/s 99.00 %  0.00 % chipbench
19459 joachimi  155.42 K/s       0 B/s 83.84 %  0.00 % bonnRoute
 9329 bartosch  551.75 K/s       0 B/s 99.99 %  0.00 % chipbench


The problem appeared about after a week of uptime. The system is opensuse 
11.3:

Linux euler 2.6.34.7-0.5-desktop #1 SMP PREEMPT 2010-10-25 08:40:12 +0200 
x86_64 x86_64 x86_64 GNU/Linux


I would like to prevent a reboot. 

Thanks
Christoph
