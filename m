From: Sachin Sant <sachinp@in.ibm.com>
Subject: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Wed, 02 Sep 2009 16:48:46 +0530
Message-ID: <4A9E5496.8050909@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47306 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZIBLSr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 07:18:47 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id n82BGQxY031095
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 21:16:26 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n82BH9AG1777864
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 21:17:10 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n82BIlLQ007349
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 21:18:47 +1000
Received: from sachinp.in.ibm.com (sachinp.in.ibm.com [9.124.158.28] (may be forged))
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id n82BIlIc007346
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 21:18:47 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While executing fsstress against ext4 with 2.6.31-rc8 on a
powerpc box, ran into the following Bug.

------------[ cut here ]------------
cpu 0x0: Vector: 700 (Program Check) at [c0000000f3ae3970]
    pc: c000000000280f28: .jbd2_journal_commit_transaction+0x8ac/0x1bfc
    lr: c000000000280e58: .jbd2_journal_commit_transaction+0x7dc/0x1bfc
    sp: c0000000f3ae3bf0
   msr: 8000000000029032
  current = 0xc0000000f315c7d0
  paca    = 0xc000000000b62600
    pid   = 23139, comm = kjournald2
kernel BUG at fs/jbd2/commit.c:533!
enter ? for help
[c0000000f3ae3dd0] c000000000289c60 .kjournald2+0x198/0x46c
[c0000000f3ae3ed0] c0000000000a86a0 .kthread+0xac/0xb8
[c0000000f3ae3f90] c00000000002ab3c .kernel_thread+0x54/0x70
0:mon> 

Ext4 FS was created and mounted using :

/usr/local/e2fsprogs/sbin/mkfs.ext4 -b 4096 /dev/sda4
mount -t ext4 -o errors=panic,data=journal /dev/sda4 /mnt/tmp/

Register information from xmon debugger :
0:mon> r
R00 = 0000000000000001   R16 = c0000000334e0160
R01 = c0000000f3ae3bf0   R17 = 0000000000000000
R02 = c000000000a6f1e8   R18 = 0000000000000000
R03 = c0000000e87c9024   R19 = 0000000000000001
R04 = c0000000334e0100   R20 = 0000000000000001
R05 = 0000000000000409   R21 = 0000000000000409
R06 = 0000000000000000   R22 = c0000000f3ae3c78
R07 = c0000000f315c7d0   R23 = 0000000000000000
R08 = c000000000b62600   R24 = c0000000e87c9000
R09 = 00000000000000a0   R25 = c0000000334e0170
R10 = c0000000f3ae0080   R26 = c0000000334e0100
R11 = 0000000100051657   R27 = c0000000334e0150
R12 = 0000000024000088   R28 = c0000000f3ae3c78
R13 = c000000000b62600   R29 = c0000000f315c7d0
R14 = c0000000008325c8   R30 = c0000000009ec158
R15 = c0000000e87c939c   R31 = 0000000000000000
pc  = c000000000280f28 .jbd2_journal_commit_transaction+0x8ac/0x1bfc
lr  = c000000000280e58 .jbd2_journal_commit_transaction+0x7dc/0x1bfc
msr = 8000000000029032   cr  = 24000084
ctr = 0000000000000000   xer = 0000000020000001   trap =  700
0:mon>

e2fsprog utility version is :

# /usr/local/e2fsprogs/sbin/mkfs.ext4 -V
mke2fs 1.41.6 (30-May-2009)
        Using EXT2FS Library version 1.41.6

Let me know if i can provide any other information.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

