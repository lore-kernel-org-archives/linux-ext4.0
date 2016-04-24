From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix data exposure after a crash
Date: Sun, 24 Apr 2016 00:55:51 -0400
Message-ID: <20160424045551.GI20980@thunk.org>
References: <1459354767-8693-1-git-send-email-jack@suse.cz>
 <1459354767-8693-2-git-send-email-jack@suse.cz>
 <20160424034813.GG20980@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Weller.Huang@cn.bosch.com,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160424034813.GG20980@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I had to add a !IS_NOQUOTA check:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 576f64a..250c2df 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -693,6 +693,7 @@ out_sem:
 		if (map->m_flags & EXT4_MAP_NEW &&
 		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
 		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
+		    !IS_NOQUOTA(inode) &&
 		    ext4_should_order_data(inode)) {
 			ret = ext4_jbd2_file_inode(handle, inode);
 			if (ret)


In order to prevent crashes when writing to the quota file (see
below).

Cheers,

				- Ted

generic/244		[00:42:13]run fstests generic/244 at 2016-04-24 00:42:13
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8128a126>] jbd2_journal_file_inode+0x35/0xde
PGD 0 
Oops: 0000 [#1] SMP 
CPU: 0 PID: 3316 Comm: setquota Not tainted 4.6.0-rc4-ext4-00002-gc66f90b #246
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff88007aa8f440 ti: ffff88007a970000 task.ti: ffff88007a970000
RIP: 0010:[<ffffffff8128a126>]  [<ffffffff8128a126>] jbd2_journal_file_inode+0x35/0xde
RSP: 0018:ffff88007a973980  EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffff88007a973a18 RCX: 00000000a8bac810
RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88007bbbc440
RBP: ffff88007b9b8e00 R08: 0000000000000002 R09: ffff88007a973950
R10: 0000000000000003 R11: 47ffffffffffffff R12: 0000000000000000
R13: ffff88007a838000 R14: ffff88007bbbc440 R15: 0000000000000001
FS:  00007f8bf247c700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000007ab85000 CR4: 00000000000006f0
Stack:
 ffff88007a973a18 ffff880079dbd5f0 ffff880079dbd670 0000000000000000
 ffff88007bbbc440 ffffffff8123f810 ffff88007b8b3a88 ffff88007b8b3a88
 ffff88007b8b3a88 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8123f810>] ? ext4_map_blocks+0x45e/0x47d
 [<ffffffff8123fe0d>] ? ext4_getblk+0x3c/0x140
 [<ffffffff8123ff1d>] ? ext4_bread+0xc/0x60
 [<ffffffff81259598>] ? ext4_quota_write+0xe1/0x19d
 [<ffffffff81206b8f>] ? write_blk+0x2f/0x66
 [<ffffffff81206c8d>] ? get_free_dqblk+0x64/0x8f
 [<ffffffff81207545>] ? do_insert_tree+0x4c/0x384
 [<ffffffff812077fc>] ? do_insert_tree+0x303/0x384
 [<ffffffff812077fc>] ? do_insert_tree+0x303/0x384
 [<ffffffff812077fc>] ? do_insert_tree+0x303/0x384
 [<ffffffff811ad0c1>] ? __kmalloc+0x134/0x1a7
 [<ffffffff81207906>] ? qtree_write_dquot+0x89/0x15e
 [<ffffffff81207bd9>] ? qtree_read_dquot+0x1d6/0x1e3
 [<ffffffff81202b91>] ? dquot_acquire+0x8f/0xf9
 [<ffffffff812577e3>] ? ext4_acquire_dquot+0x76/0x94
 [<ffffffff81204198>] ? dqget+0x273/0x430
 [<ffffffff81204972>] ? dquot_get_dqblk+0xf/0x32
 [<ffffffff81208861>] ? quota_getquota+0x5f/0x111
 [<ffffffff811abba1>] ? cache_alloc_debugcheck_after.isra.17+0x4d/0x15a


   	    
