From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Wed, 20 Aug 2008 00:43:52 +0300
Message-ID: <20080819214351.GL8997@lh.kyla.fi>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:44988 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759620AbYHSVuf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 17:50:35 -0400
Content-Disposition: inline
In-Reply-To: <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2008 at 04:58:41PM +0200, Jan Kara wrote:
> From 06953717138efe3ad535e78343beb7204ac0d274 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 18 Aug 2008 16:45:11 +0200
> Subject: [PATCH] ext2: Check for corrupted group descriptor before using data in it
> 
> We have to check whether a group descriptor isn't corrupted in
> read_block_bitmap(). Otherwise ext2_valid_block_bitmap() will try
> to access bits outside of bitmap and Oops happens.

I think something similar is needed for ext3, or at least the
backtrace looks similar to me (tell me if you want me to file a
separate bug for it):

------------------------------------------------------------
[ 1303.485714] EXT3-fs unexpected failure: !jh->b_committed_data;
[ 1303.485714] inconsistent data on disk
[ 1303.485714] BUG: unable to handle kernel paging request at c7edfffc
[ 1303.485714] IP: [<c02ddca9>] read_block_bitmap+0xa3/0x147
[ 1303.485714] *pde = 00007067 *pte = 07edf160
[ 1303.485714] Oops: 0000 [#1] DEBUG_PAGEALLOC
[ 1303.485714]
[ 1303.485714] Pid: 17001, comm: rm Not tainted (2.6.27-rc3 #2)
[ 1303.485714] EIP: 0060:[<c02ddca9>] EFLAGS: 00000246 CPU: 0
[ 1303.485714] EIP is at read_block_bitmap+0xa3/0x147
[ 1303.485714] EAX: ffffffff EBX: c7ee0800 ECX: c7ee0000 EDX: 00000001
[ 1303.485714] ESI: c3c40690 EDI: c7abd000 EBP: c79c4c9c ESP: c79c4c6c
[ 1303.485714]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1303.485714] Process rm (pid: 17001, ti=c79c4000 task=c79189a0 task.ti=c79c4000)
[ 1303.485714] Stack: 00000246 00000001 00000246 c7abda3c c7413aa0 c5d7f800 00000000 00000000
[ 1303.485714]        c7ee0000 00000000 00000000 c3c25064 c79c4cf4 c02dde1f c3c405b0 c79c4ccc
[ 1303.485714]        c0317987 00000001 c0314a9b 00000029 0000002a c7abd000 c7440000 c5d7f8ac
[ 1303.485714] Call Trace:
[ 1303.485714]  [<c02dde1f>] ? ext3_free_blocks_sb+0x93/0x3d6
[ 1303.485714]  [<c0317987>] ? journal_revoke+0x81/0xe3
[ 1303.485714]  [<c0314a9b>] ? do_get_write_access+0x381/0x49c
[ 1303.485714]  [<c02ed428>] ? __ext3_journal_revoke+0x1e/0x44
[ 1303.485714]  [<c02de18d>] ? ext3_free_blocks+0x2b/0x7f
[ 1303.485714]  [<c02e3694>] ? ext3_clear_blocks+0x11f/0x141
[ 1303.485714]  [<c02e377a>] ? ext3_free_data+0xc4/0x133
[ 1303.485714]  [<c02e3a0e>] ? ext3_free_branches+0x225/0x22d
[ 1303.485714]  [<c02e3891>] ? ext3_free_branches+0xa8/0x22d
[ 1303.485714]  [<c02e3891>] ? ext3_free_branches+0xa8/0x22d
[ 1303.485714]  [<c02e407d>] ? ext3_truncate+0x667/0x8af
[ 1303.485714]  [<c03153e2>] ? journal_start+0xb2/0x112
[ 1303.485714]  [<c031540d>] ? journal_start+0xdd/0x112
[ 1303.485714]  [<c03153e2>] ? journal_start+0xb2/0x112
[ 1303.485714]  [<c02eb243>] ? ext3_journal_start_sb+0x29/0x4a
[ 1303.485714]  [<c02e4389>] ? ext3_delete_inode+0xc4/0xdb
[ 1303.485714]  [<c02e42c5>] ? ext3_delete_inode+0x0/0xdb
[ 1303.485714]  [<c0276c2b>] ? generic_delete_inode+0x62/0xd5
[ 1303.485714]  [<c0276db1>] ? generic_drop_inode+0x113/0x162
[ 1303.485714]  [<c0275d3c>] ? iput+0x47/0x4e
[ 1303.485714]  [<c02737a7>] ? dentry_iput+0x6b/0xb1
[ 1303.485714]  [<c0273859>] ? d_kill+0x1d/0x37
[ 1303.485714]  [<c027519b>] ? dput+0x58/0x10a
[ 1303.485714]  [<c026d2a4>] ? do_rmdir+0xa4/0xc3
[ 1303.485714]  [<c026d2f4>] ? sys_unlinkat+0x31/0x36
[ 1303.485714]  [<c0202f3e>] ? syscall_call+0x7/0xb
[ 1303.485714]  =======================
[ 1303.485714] Code: 26 00 0f 88 94 00 00 00 8b 87 8c 02 00 00 89 45 e4 8b 55 e8 0f af 50 10 8b 40 34 03 50 14 8b 03 89 45 ec 8b 4e 14 89 4d f0 29 d0 <0f> a3 0
1 19 c0 85 c0 74 11 8b 43 04 89 45 ec 29 d0 0f a3 01 19
[ 1303.485714] EIP: [<c02ddca9>] read_block_bitmap+0xa3/0x147 SS:ESP 0068:c79c4c6c
[ 1303.485714] ---[ end trace ba199677255b7e73 ]---
------------------------------------------------------------
$ addr2line -e vmlinux -i 0xc02ddca9
include/asm/bitops.h:305
fs/ext3/balloc.c:98
fs/ext3/balloc.c:167

     98         if (!ext3_test_bit(offset, bh->b_data))
     99                 /* bad block bitmap */
    100                 goto err_out;
------------------------------------------------------------

	Sami
