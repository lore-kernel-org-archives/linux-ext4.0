From: Andrew Watts <akwatts@ymail.com>
Subject: [OOPS]: Kernel 3.1 (ext3?)
Date: Thu, 10 Nov 2011 08:29:37 -0500
Message-ID: <20111110132929.GA11417@zeus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.196]:21979 "HELO
	nm9-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754792Ab1KJNax (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 08:30:53 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I had the following kernel panic today on 3.1 (machine was compiling code
unattended). It would appear to be a bug/regression introduced sometime
between 2.6.39.4 and 3.1. 

Help would be much appreciated.

~ Andy

PS cross-posting to linux-ext4@ given the stack trace.

================


EIP: 0060:[<c114cd83>] EFLAGS: 00210082 CPU: 0
EIP is at init_once+0x13/0x50
EAX: f5406068 EBX: f5406000 ECX: c1962c63 EDX: c1781109
ESI: f5406000 EDI: f5406000 EBP: f0d2dc6c ESP: f0d2dc68
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process ar (pid 17281, ti=f0d2c000 task=f3060c50 tast.ti=f0d2c000)
Stack:
 f5c5aa00 f0d2dc7c c10d953b f5c5aa00 f6fa50c0 f0d2dca0 c10d97d6 00000000
 f5406000 f5406000 f5406000 00000000 00000000 f5c5aa00 f0d2dd34 c10dadf1
 f5803200 f1f5b2a0 f58b3030 f0d2dcd4 00000000 f0d2dccc 00000000 c114cd22
Call Trace:
 [<c10d953b>] setup_object+0x4b/0x60
 [<c10d97d6>] new_slab+0x126/0x1d0
 [<c10dadf1>] T.1022+0x131/0x340
 [<c114cd22>] ? ext3_alloc_inode+0x12/0x60
 [<c1141547>] ? ext3_getblk+0xd7/0x1d0
 [<c1051827>] ? wake_up_bit+0x57/0x60
 [<c114cd22>] ? ext3_alloc_inode+0x12/0x60
 [<c11091a0>] ? unlock_buffer+0x10/0x20
 [<c10db10a>] kmem_cache_alloc+0x10a/0x120
 [<c114cd22>] ? ext3_alloc_inode+0x12/0x60
 [<c114634e>] ? ext3_find_entry+0x3fe/0x5d0
 [<c114cd22>] ext3_alloc_inode+0x12/0x60
 [<c10f7ccc>] alloc_inode+0x1c/0x80
 [<c10f7d38>] new_inode_pseudo+0x8/0x30
 [<c10f7d72>] new_inode+0x12/0x40
 [<c113da8c>] ext3_new_inode+0x4c/0x900
 [<c1161db2>] ? journal_start+0x62/0xd0
 [<c1161de8>] ? journal_start+0x90/0xd0
 [<c114dac9>] ? ext3_journal_start_sb+0x29/0x50
 [<c114588c>] ext3_create+0x7c/0xe0
 [<c10edda3>] vfs_create+0x93/0xb0
 [<c10ee7fc>] do_last+0x38c/0x760
 [<c10ef6da>] path_openat+0x9a/0x340
 [<c10efa60>] do_filp_open+0x30/0x80
 [<c10db095>] ? kmem_cache_alloc+0x95/0x120
 [<c10ed088>] ? getname_flags+0x28/0x110
 [<c10f98d2>] ? alloc_fd+0x62/0xe0
 [<c10ed11b>] ? getname_flags+0xbb/0x110
 [<c10e367d>] do_sys_open+0xed/0x1e0
 [<c10e46c5>] ? vfs_read+0xf5/0x160
 [<c10e37d9>] sys_open+0x29/0x40
 [<c159f713>] sysenter_do_call+0x12/0x22
Code: 00 00 00 00 00 89 d0 5d c3 eb 0d 90 90 90 90 90 90 90 90 90
90 90 90 90 55 b9 63 2c 96 c1 89 e5 ba 09 11 78 c1 53 89 c3 8d 40
68 43 68 89 43 6c 8d 43 5c e8 cf 55 09 00 8d 43 7c b9 63 2c 96
EIP: [<c114cd83>] init_once+0x13/0x50 SS:ESP 0068:f0d2dc68
CR2: 00000000f5406068

