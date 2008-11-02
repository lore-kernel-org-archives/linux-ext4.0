From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Sun, 2 Nov 2008 07:27:27 +0200
Message-ID: <20081102052727.GK5994@lh.kyla.fi>
References: <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz> <20080818165131.GC6491@skywalker> <20080819032410.GE3392@webber.adilger.int> <20080819091339.GE14799@duck.suse.cz> <20080819105111.GK8997@lh.kyla.fi> <20080820102533.GA5979@atrey.karlin.mff.cuni.cz> <20080820190704.GD3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:38093 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbYKBFsf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Nov 2008 01:48:35 -0400
Content-Disposition: inline
In-Reply-To: <20080820190704.GD3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Sorry for duplicates, forgot to use email instead of bugzilla web
interface.]

I now have found an ext3 filesystem for which this bug happens pretty
reproducibly on 2.6.27.4. Increasing commit interval seems to help it happen,
otherwise the journal can be aborted and then the bug no longer happens. I do
realize that this report is for the ext2 bug, but I hope finding a similar bug
on ext3 might help (and even if this is a separate bug, this information should
help resolve it).

Here's how to do it:

1. bunzip2 the attached filesystem image hdb.10000097.bz2

(I did the following inside qemu, hence /dev/hdb)

2. mount /dev/hdb /mnt -t ext3 -o errors=continue,commit=300
3. cd /mnt
4. timeout 30 cp -r doc doc2 >&/dev/null (or manually break cp after 30
seconds, it's jammed anyway)
6. find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
7. mkdir tmp >&/dev/null
8. echo whoah >tmp/filu 2>/dev/null
9. rm -rf /mnt/* >&/dev/null
10. while completing rm -rf, the following oops occurs:

------------------------------------------------------------
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
block = 4294967295, count = 1
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
block = 4294967295, count = 1
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
block = 4294967295, count = 1
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
block = 4294967295, count = 1
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
block = 4294967295, count = 1
EXT3-fs unexpected failure: !jh->b_committed_data;
inconsistent data on disk
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks in system zones -
Block = 8234, count = 1
EXT3-fs unexpected failure: !jh->b_committed_data;
inconsistent data on disk
ext3_forget: aborting transaction: IO failure in __ext3_journal_forget
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks in system zones -
Block = 42, count = 3
EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
block = 25630524, count = 1
EXT3-fs error (device hdb) in ext3_free_blocks_sb: Readonly filesystem
EXT3-fs unexpected failure: !jh->b_committed_data;
inconsistent data on disk
BUG: unable to handle kernel paging request at c13fbbfc
IP: [<c02de4f9>] read_block_bitmap+0xa3/0x147
*pde = 07886163 *pte = 013fb160
Oops: 0000 [#1] DEBUG_PAGEALLOC

Pid: 817, comm: rm Not tainted (2.6.27.4 #1)
EIP: 0060:[<c02de4f9>] EFLAGS: 00000206 CPU: 0
EIP is at read_block_bitmap+0xa3/0x147
EAX: ffffdfff EBX: c13fc820 ECX: c13fc000 EDX: 00002001
ESI: c74b15b0 EDI: c7aae400 EBP: c7b7acd0 ESP: c7b7aca0
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rm (pid: 817, ti=c7b7a000 task=c78a1ce0 task.ti=c7b7a000)
Stack: 00000001 00000000 00000000 c7aaf1c0 00000246 c79cdc00 00000001 00000000
       c13fc000 00000000 00000001 c163b37c c7b7ad28 c02de66f c0315003 c740aadc
       c7b7ad10 c7440000 c7aaf1c0 00000029 0000202a c7aae400 c7440000 c79cdcac
Call Trace:
 [<c02de66f>] ? ext3_free_blocks_sb+0x93/0x3d6
 [<c0315003>] ? journal_forget+0xff/0x1aa
 [<c02edd83>] ? __ext3_journal_forget+0x19/0x3f
 [<c02de9dd>] ? ext3_free_blocks+0x2b/0x7f
 [<c02e3f8c>] ? ext3_clear_blocks+0x137/0x159
 [<c02e4072>] ? ext3_free_data+0xc4/0x133
 [<c02e4320>] ? ext3_free_branches+0x23f/0x247
 [<c02e4189>] ? ext3_free_branches+0xa8/0x247
 [<c02e4189>] ? ext3_free_branches+0xa8/0x247
 [<c02e498d>] ? ext3_truncate+0x665/0x8ad
 [<c0316062>] ? journal_start+0xb2/0x112
 [<c031608d>] ? journal_start+0xdd/0x112
 [<c0316062>] ? journal_start+0xb2/0x112
 [<c02ebb53>] ? ext3_journal_start_sb+0x29/0x4a
 [<c02e4ca4>] ? ext3_delete_inode+0xcf/0xdb
 [<c02e4bd5>] ? ext3_delete_inode+0x0/0xdb
 [<c02774b3>] ? generic_delete_inode+0x62/0xd5
 [<c0277639>] ? generic_drop_inode+0x113/0x16a
 [<c02765ac>] ? iput+0x47/0x4e
 [<c026d9f4>] ? do_unlinkat+0xc3/0x13d
 [<c054484f>] ? mutex_unlock+0x8/0xa
 [<c026fb0b>] ? vfs_readdir+0x60/0x85
 [<c026f84c>] ? filldir64+0x0/0xd7
 [<c026fbc7>] ? sys_getdents64+0x97/0xa1
 [<c026db66>] ? sys_unlinkat+0x23/0x36
 [<c0202f1e>] ? syscall_call+0x7/0xb
 =======================
Code: 26 00 0f 88 94 00 00 00 8b 87 8c 02 00 00 89 45 e4 8b 55 e8 0f af 50 10
8b 40 34 03 50 14 8b 03 89 45 ec 8b 4e 14 89 4d f0 29 d0 <0f> a3 01 19 c0 85 c0
74 11 8b 43 04 89 45 ec 29 d0 0f a3 01 19
EIP: [<c02de4f9>] read_block_bitmap+0xa3/0x147 SS:ESP 0068:c7b7aca0
---[ end trace 780108b88e07a03e ]---
------------------------------------------------------------

	Sami
