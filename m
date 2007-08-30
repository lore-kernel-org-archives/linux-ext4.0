From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 8][PATCH 1/1]Add journal checksums
Date: Thu, 30 Aug 2007 10:08:29 -0700
Message-ID: <1188493709.6594.19.camel@localhost.localdomain>
References: <1183275505.4010.136.camel@localhost.localdomain>
	 <20070710231601.798304e0.akpm@linux-foundation.org>
	 <1184154399.3867.44.camel@dhcp4.linsyssoft.com>
	 <1185951857.3875.6.camel@dhcp4.linsyssoft.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59972 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245AbXH3RIP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2007 13:08:15 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7UH9cis020413
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2007 13:09:38 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7UH8E9A509994
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2007 13:08:14 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7UH8EoU017799
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2007 13:08:14 -0400
In-Reply-To: <1185951857.3875.6.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-08-01 at 12:34 +0530, Girish Shilamkar wrote:
> On Wed, 2007-07-11 at 17:16 +0530, Girish Shilamkar wrote:
> 
> > I will make the changes and send an incremental patch.
> > 
> Hi,
> 	I have made the changes and attached the incremental patch as per the
> review.
> 
> This is the actual changelog which was missing in the original patch.
> 
> ------
> The journal checksum feature adds two new flags i.e 
> JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT and JBD2_FEATURE_COMPAT_CHECKSUM.
> 
> JBD2_FEATURE_CHECKSUM flag indicates that the commit block contains the
> checksum for the blocks described by the descriptor blocks.
> Due to checksums, writing of the commit record no longer needs to be
> synchronous. Now commit record can be sent to disk without waiting for
> descriptor blocks to be written to disk. This behavior is controlled
> using JBD2_FEATURE_ASYNC_COMMIT flag. Older kernels/e2fsck should not be
> able to recover the journal with _ASYNC_COMMIT hence it is made
> incompat.
> The commit header has been extended to hold the checksum along with the
> type of the checksum.
> 
> For recovery in pass scan checksums are verified to ensure the sanity
> and completeness(in case of _ASYNC_COMMIT) of every transaction.
> -----

Hit kernel oops when run fsstress test on ext4-patch-queue with -o
journal_checksum.

BUG: unable to handle kernel NULL pointer dereference at virtual address
00000000 
 printing eip:
c118ba5d
*pdpt = 000000002560a001
*pde = 0000000000000000
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c118ba5d>]    Not tainted VLI
EFLAGS: 00010257   (2.6.23-rc4-autokern1 #1)
EIP is at crc32_be+0x3d/0x9c
eax: 7e78a276   ebx: 76a2787e   ecx: 00000400   edx: 00000000
esi: 00000000   edi: 00000000   ebp: f56e5200   esp: e61f9e90
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kjournald2 (pid: 5388, ti=e61f8000 task=e3efc000 task.ti=e61f8000)
Stack: ef5fffc0 00000016 c10c762d 0000055e 00000000 00000000 00001000 00000000 
       f50e3e80 7e78a276 00000008 00000000 00000544 eb46aab4 eb46aabc 00000155 
       f585f800 e1e1c968 00000000 eb059428 0000055e 00000000 00000000 e3efc000 
Call Trace:
 [<c10c762d>] jbd2_journal_commit_transaction+0x92a/0x128d
 [<c1029e51>] autoremove_wake_function+0x0/0x33
 [<c1029e51>] autoremove_wake_function+0x0/0x33
 [<c10214f4>] try_to_del_timer_sync+0x42/0x48
 [<c10ca4fd>] kjournald2+0x130/0x307
 [<c1029e51>] autoremove_wake_function+0x0/0x33
 [<c129171c>] __sched_text_start+0x364/0x3ff
 [<c1029e51>] autoremove_wake_function+0x0/0x33
 [<c10ca3cd>] kjournald2+0x0/0x307
 [<c1029a27>] kthread+0x34/0x55
 [<c10299f3>] kthread+0x0/0x55
 [<c1003173>] kernel_thread_helper+0x7/0x10
 =======================
Code: 42 30 d8 0f b6 c0 c1 eb 08 33 1c 85 e0 ae 2a c1 49 74 05 f6 c2 03 75 e5 83 f9 03 76 4c 89 ce 83 ea 04 83 e6 03 c1 e9 02 83 c2 04 <33> 1a 0f b6 c3 c1 eb 08 33 1c 85 e0 ae 2a c1 0f b6 c3 c1 eb 08 
EIP: [<c118ba5d>] crc32_be+0x3d/0x9c SS:ESP 0068:e61f9e90
