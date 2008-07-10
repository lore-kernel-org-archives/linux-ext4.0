From: Ric Wheeler <rwheeler@redhat.com>
Subject: suspiciously good fsck times?
Date: Thu, 10 Jul 2008 13:29:22 -0400
Message-ID: <487646F2.9030706@redhat.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbYGJR3Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2008 13:29:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Repost to the list - this was mistakingly sent to linux-ext4-owner)

Just to be mean, I have been trying to test the fsck speed of ext4 with
lots of small files.  The test I ran uses fs_mark to fill a 1TB Seagate
drive with 45.6 million 20k files (distributed between 256 subdirectories).

Running on ext3, "fsck -f" takes about one hour.

Running on ext4, with uninit_bg, the same fsck is finished in a bit over
5 minutes - more than 10x faster.  (Without uninit_bg, the fsck takes
about 10 minutes).

Is this too good to be true? Below is the fsck run itself, the tree is
Ted's latest git tree and his 1.41 WIP tools,

ric


[root@localhost Perf]# time /sbin/fsck.ext4 -t -t -f /dev/sdb1
e4fsck 1.41-WIP (07-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 40632k/69424k (36424k/4209k), time: 204.95/78.22/25.58
Pass 1: I/O read: 11140MB, write: 0MB, rate: 54.35MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 70184k/61968k (51803k/18382k), time: 76.47/50.27/ 8.77
Pass 2: I/O read: 3023MB, write: 0MB, rate: 39.53MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 70184k/61968k (59256k/10929k), time:
281.72/128.59/34.35
Pass 3A: Memory used: 70184k/61968k (59256k/10929k), time:  0.00/ 0.00/
0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 70184k/61968k (51803k/18382k), time:  0.03/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 37.86MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 70184k/44968k (27354k/42831k), time:  2.37/ 2.36/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 70184k/240k (64619k/5566k), time: 19.40/ 5.52/ 0.29
Pass 5: I/O read: 34MB, write: 0MB, rate: 1.75MB/s
/dev/sdb1: 45600268/61054976 files (0.0% non-contiguous),
232657574/244190000 blocks
Memory used: 70184k/240k (64889k/5296k), time: 303.54/136.48/34.65
I/O read: 14198MB, write: 1MB, rate: 46.77MB/s

real    5m3.993s
user    2m16.477s
sys     0m35.041s
