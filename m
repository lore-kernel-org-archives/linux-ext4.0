From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [OOPs] ext4: fixpoint divide exception at ext4_fill_super+0x141c/0x2908
Date: Tue, 25 Aug 2009 11:09:56 +0530
Message-ID: <4A93792C.2000705@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36468 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbZHYFjy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 01:39:54 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp07.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7P5dtVQ007028
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 15:39:55 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7P5dtf11290250
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 15:39:55 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7P5dsZg030553
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 15:39:55 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Found kernel bug - fixpoint divide exception
While working with fsfuzzer

Environment: 2.6.31-rc7
Architecture: s390 and ppc64

------------[ cut here ]------------ 

Kernel BUG at 000003e00429d934 [verbose debug info unavailable] 

fixpoint divide exception: 0009 [#1] SMP 

Modules linked in: ext4 jbd2 crc16 loop autofs4 lockd sunrpc ipv6 
qeth_l2 qeth
q
dio vmur ccwgroup dm_round_robin dm_multipath scsi_dh sd_mod scsi_mod 
multipath
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod dasd_fba_mod
dasd_eck
d_mod dasd_mod ext3 jbd 

CPU: 2 Not tainted 2.6.31-rc6 #1 

Process mount (pid: 2675, task: 000000003ed06038, ksp: 0000000036217920) 

Krnl PSW : 0704200180000000 000003e00429d934 (ext4_fill_super+0x1478/0x2908
[ext
4]) 

            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3 

Krnl GPRS: 0000000000000100 0000000000000100 0000000000000006 
000000002fc61800
            0000000000000000 0000000000000100 000000002fc61800 
000000002fc61800
            000000003143a800 00000000000000e0 0000000000000000 
000000003eb0d800
            000003e00427c000 000003e0042b8958 000003e00429d87c 
0000000036217b10
Krnl Code: 000003e00429d928: b9160050           llgfr   %r5,%r0 

            000003e00429d92c: a7490000           lghi    %r4,0 

            000003e00429d930: b987004a           dlgr    %r4,%r10 

           >000003e00429d934: b91600a5           llgfr   %r10,%r5 

            000003e00429d938: a53f80d0           llill   %r3,32976 

            000003e00429d93c: a7ad000c           mghi    %r10,12 

            000003e00429d940: b904002a           lgr     %r2,%r10
            000003e00429d944: 1895               lr      %r9,%r5
Call Trace:
([<000003e00429d87c>] ext4_fill_super+0x13c0/0x2908 [ext4])
  [<00000000000f46f2>] get_sb_bdev+0x13e/0x19c
  [<000003e00429230e>] ext4_get_sb+0x2e/0x40 [ext4]
  [<00000000000f3f98>] vfs_kern_mount+0xc0/0x168
  [<00000000000f40ac>] do_kern_mount+0x58/0x114
  [<000000000010e558>] do_mount+0x798/0x830
  [<000000000010e6a0>] SyS_mount+0xb0/0x100
  [<00000000000266be>] sysc_noemu+0x10/0x16
  [<0000004e53f234e2>] 0x4e53f234e2
Last Breaking-Event-Address:
  [<000003e00429d8d8>] ext4_fill_super+0x141c/0x2908 [ext4]

---[ end trace b5563edf9c0c9b52 ]---

*P.S. If you need any information please let me know. Please cc me as I 
am not subscribed to the list.

Thanks and Regards
R.Nageswara Sastry

