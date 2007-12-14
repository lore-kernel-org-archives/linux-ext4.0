From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC] truncate_mutex to read_write semaphore
Date: Fri, 14 Dec 2007 21:18:14 +0530
Message-ID: <1197647297-7009-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:35190 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXLNPsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2007 10:48:46 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBEFmYQ2025539
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:48:34 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBEFqKOE288702
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:52:20 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBEFmQvJ014713
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:48:27 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The series include the truncate_mutex to read write semaphore conversion. I am
marking below some of the test results.


For O_DIRECT workloads we won't see the contention on truncate mutex because we are
doing a get_block under inode->i_mutex.


For FIBMAP we won't see contention because the get_block get called under BKL.


threaded read with low memory
---------------------------

Top contenting locks were: (/proc/lock_stat output)

&q->__queue_lock:           12549 12572 10.65  3302.16    36818.78    46618 395721 3.47  49636.48  571453.47
&inode->i_data.tree_lock-W: 3970  4026  2.62   33.39      3508.74     25924 95164  5.33  949.59    80180.03
&inode->i_data.tree_lock-R: 1937  2002  2.52   22.05      1528.78     19543 141863 5.57  119.72    137126.60
&ei->truncate_mutex#2:      4553  4769  169.62 1028484.20 39334253.92 19610 47069  31.74 102280.63 680802.57

second run
---------

&q->__queue_lock:           12499 12535 3.76    247.71    19799.94    46341  405427  4.34  216.31    527282.59
&inode->i_data.tree_lock-W: 4009  4071  10.04   31.78     3434.95     25612  93458  7.29  61.87     78365.20
&inode->i_data.tree_lock-R: 1919  1973  4.43    30.93     1523.04     18953  142635 4.95  109.20    137098.84
&ei->truncate_mutex#2:      4346  4499  1546.39 896379.29 31107317.47 19051  48223  37.94 122579.25 628968.65

The above result implies that the threaded read with low memory (booted with
mem=512M on a 16 cpu x86-64) results in contention on truncate_mutex.


threaded read with low memory after converting to i_data_sem
---------------

&ei->i_data_sem-R:          0     0      0.00    0.00      0.00       18017  48801   38.12 3494783.37 22982474.21
&ei->i_data_sem-R:          0     0      0.00    0.00      0.00       18233  49118   45.09 4953783.87 32699001.46

As you can see from the /proc/lock_stat output above the write semaphore is
not taken at all.

threaded write
--------------
&ei->i_data_sem-W:         0     0      0.00     0.00      0.00         24    64163   41.04 2620905.32    16331786.48
&ei->i_data_sem-R:         0     0      0.00     0.00      0.00         13352 83969   51.40 1212864.74    2834511.75


Here we see some read semphore acquisition. We take read mode of the semaphore
to  not content in the overwrite case. We see no contention here because the
write gets done under inode->i_mutex

&sb->s_type->i_mutex_key#1:  313958  313962   3650.35 99510834.17  4881402594.11  314481   616528   37.22 7579553.97    54139119.82
  --------------------------
  &sb->s_type->i_mutex_key#1         313962 [<ffffffff8027aa80>] generic_file_aio_write+0x4f/0xc2
  &sb->s_type->i_mutex_key#1         0      [<ffffffff802a538c>] generic_file_llseek+0x36/0x98


second-run
---------

&ei->i_data_sem-W:     0    0  0.00  0.00   0.00   2       61143    41.56   9299754.45    15811211.79
&ei->i_data_sem-R:     0    0  0.00  0.00   0.00   13272   82442    68.40   1632405.22    2877135.32



&sb->s_type->i_mutex_key#1:  441031  441163 10873.77 144350457.93  4988289572.34  441679 742079   163.05    15158665.56    59655118.60
  --------------------------
   &sb->s_type->i_mutex_key#1 441163          [<ffffffff802a538c>] generic_file_llseek+0x36/0x98
   &sb->s_type->i_mutex_key#1 0               [<ffffffff8027aa80>] generic_file_aio_write+0x4f/0xc2



The test program is at http://www.radian.org/~kvaneesh/ext4/truncate_mutex/
The file system is modified to create highly fragmented file via frag.c
