From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Tue, 12 Dec 2006 17:48:49 +0100
Message-ID: <457EDD71.2030909@bull.net>
References: <m3vekwtqnp.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010601050902070802050208"
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38915 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbWLLQuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Dec 2006 11:50:55 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3vekwtqnp.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------010601050902070802050208
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Alex Tomas wrote:
> this patch implements locality groups idea in a very
> simplified form. the policy is silly and ->sync_inodes()
> not very well tested on different workloads. 
> 
> thanks, Alex

Hi Alex,
I applied your patches to a 2.6.19-rc6 kernel. After creating and 
mounting an ext4 filesystem with options extents,mballoc,delalloc,
the system crashes while copying a file into the ext4 partition.
I set some kernel debugging options and rebuilt the kernel. Here is the 
oops I've got:

EXT4 FS on sdc1, internal journal
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: delayed allocation enabled
BUG: spinlock bad magic on CPU#2, pdflush/264
Unable to handle kernel NULL pointer dereference at 00000000000001ac RIP:
  [<ffffffff80360011>] spin_bug+0x67/0xa5
PGD 27d97067 PUD 28370067 PMD 0
Oops: 0000 [1] SMP
CPU 2
Modules linked in: qla2xxx
Pid: 264, comm: pdflush Not tainted 2.6.19-rc6 #3
RIP: 0010:[<ffffffff80360011>]  [<ffffffff80360011>] spin_bug+0x67/0xa5
RSP: 0018:ffff81007d6a7db0  EFLAGS: 00010206
RAX: 0000000000000031 RBX: ffff810076630020 RCX: ffffffff806f48d8
RDX: ffffffff806f48d8 RSI: 0000000000000046 RDI: ffffffff806f48c0
RBP: 00000000000000a0 R08: 00000000ffffffff R09: 0000000000008000
R10: ffffffff808bfc78 R11: ffffffff808bfc78 R12: ffffffff805bfdc9
R13: ffff81002dbd0000 R14: ffff810076630000 R15: ffff81007d6a7e60
FS:  0000000000000000(0000) GS:ffff81007df14740(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000001ac CR3: 00000000282cd000 CR4: 00000000000006e0
Process pdflush (pid: 264, threadinfo ffff81007d6a6000, task 
ffff81007db3b140)
Stack:  ffff810076630020 ffff81002daa4160 ffff810076630000 ffffffff803600ef
  ffff810076630020 ffffffff802f2bf4 ffff81007d6a7e60 ffff81002dbd0000
  ffff81002dbd0070 ffff81007d6a7e60 00000000fffffffc ffff81007df19d70
Call Trace:
  [<ffffffff803600ef>] _raw_spin_lock+0x19/0x7d
  [<ffffffff802f2bf4>] ext4_lg_sync_inodes+0xec/0x196
  [<ffffffff80245207>] keventd_create_kthread+0x0/0x64
  [<000000010004a823>]


Code: 44 8b 85 0c 01 00 00 8b 53 04 48 85 ed 48 8d 85 98 02 00 00
RIP  [<ffffffff80360011>] spin_bug+0x67/0xa5
  RSP <ffff81007d6a7db0>
CR2: 00000000000001ac


The crash occurs because ei->i_locality_group is not well initialized.
The patch in attachment fixes the problem on my system (x86_64).

   Valérie



--------------010601050902070802050208
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="ext4_fix_oops_in_lg_sync_inodes.patch"
Content-Disposition: inline;
 filename="ext4_fix_oops_in_lg_sync_inodes.patch"

Index: linux-2.6.19-rc6/fs/ext4/lg.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/lg.c	2006-12-12 17:23:46.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/lg.c	2006-12-12 17:24:53.000000000 +0100
@@ -66,7 +66,7 @@ extern int __writeback_single_inode(stru
 struct ext4_locality_group *ext4_lg_find_group(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_locality_group *lg;
+	struct ext4_locality_group *lg = NULL;
 	struct list_head *cur;
 
 	rcu_read_lock();

--------------010601050902070802050208--
