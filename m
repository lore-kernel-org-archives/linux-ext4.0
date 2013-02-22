From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG] xfstests #68 with data=journal hang against 3.8-rc7 and
 'dev' branch
Date: Fri, 22 Feb 2013 14:46:21 -0500
Message-ID: <20130222194621.GA27489@thunk.org>
References: <20130217172208.GB4059@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49485 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab3BVTqZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2013 14:46:25 -0500
Content-Disposition: inline
In-Reply-To: <20130217172208.GB4059@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2013 at 01:22:08AM +0800, Zheng Liu wrote:
> Hi all,
> 
> Xfstests #68 will hang with data=journal in 3.8-rc7 and 'dev' branch. I
> remember that there has a patch for ext4 to fix filesystem freeze bug
> but I am not sure whether it can fix this bug and it has been applied
> into 'dev' branch.  So I file this bug here.

I've confirmed that I can reproduce this by using tmpfs imagea files
under KVM.  I can replicate the bug as far back as the 3.0 kernel, so
this is definitely not a recent regression.

					- Ted

kernel BUG at /tyt/linux/ext4/fs/jbd2/transaction.c:1986!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in:
Pid: 3399, comm: fstest Not tainted 3.8.0-rc3-00026-ge7b04ac #54 Bochs Bochs
EIP: 0060:[<c02b0bb7>] EFLAGS: 00010206 CPU: 0
EIP is at jbd2_journal_invalidatepage+0x1bb/0x238
EAX: 001c4025 EBX: f5f7ab38 ECX: 00000000 EDX: 00000246
ESI: f481d3c8 EDI: f5b87800 EBP: f4d3dcac ESP: f4d3dc7c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: b7666000 CR3: 34cef000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process fstest (pid: 3399, ti=f4d3c000 task=f4d208a0 task.ti=f4d3c000)
Stack:
 00001000 f5f7ab38 f5f7ab38 00000001 f5b87b80 f5b87814 00000000 f7bbc788
 00000000 f7bbc788 f5f5f794 00000000 f4d3dcc4 c02741b1 f5b87800 c02315a0
 f5f5f794 00000030 f4d3dccc c027524d f4d3dcd8 c01e9cab f7bbc788 f4d3dce8
Call Trace:
 [<c02741b1>] __ext4_journalled_invalidatepage+0x60/0x66
 [<c02315a0>] ? sync_mapping_buffers+0x1e7/0x1e7
 [<c027524d>] ext4_journalled_invalidatepage+0xd/0x22
 [<c01e9cab>] do_invalidatepage+0x21/0x24
 [<c01e9cfd>] truncate_inode_page+0x4f/0x70
 [<c01e9dc6>] truncate_inode_pages_range+0xa8/0x206
 [<c01e9fd3>] truncate_inode_pages+0x11/0x15
 [<c01ea01f>] truncate_pagecache+0x48/0x64
 [<c0277f2f>] ext4_setattr+0x3cc/0x464
 [<c0277b63>] ? ext4_mark_inode_dirty+0x1b3/0x1b3
 [<c02200fd>] notify_change+0x1b1/0x272
 [<c08077ea>] ? mutex_lock_nested+0x26/0x2f
 [<c020c576>] do_truncate+0x69/0x82
 [<c0217ae7>] do_last+0x8af/0x8d6
 [<c0215aca>] ? inode_permission+0x45/0x47
 [<c0215b66>] ? link_path_walk+0x9a/0x3ab
 [<c0217bab>] path_openat+0x9d/0x2bc
 [<c0199afe>] ? lock_release_holdtime.part.21+0x5d/0x63
 [<c0199693>] ? trace_hardirqs_off+0xb/0xd
 [<c021800f>] do_filp_open+0x26/0x62
 [<c022116d>] ? __alloc_fd+0xbd/0xc8
 [<c020d0b5>] do_sys_open+0x58/0xd1
 [<c020d154>] sys_open+0x26/0x2e
 [<c0809748>] syscall_call+0x7/0xb
 [<c0800000>] ? no_context+0x67/0x1a5
Code: 68 7d 00 00 8b 45 e0 e8 da 88 55 00 89 d8 e8 39 ee ff ff 8b 45 e4 e8 67 83 55 00 89 d8 e8 c6 ec ff ff 8b 03 a9 00 00 08 00 74 02 <0f> 0b f0 80 23 df f0 8
3 bf f0 80 63 01 fd f0 80
EIP: [<c02b0bb7>] jbd2_journal_invalidatepage+0x1bb/0x238 SS:ESP 0068:f4d3dc7c
