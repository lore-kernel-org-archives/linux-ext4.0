From: Jan Kara <jack@suse.cz>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Wed, 11 Sep 2013 00:19:00 +0200
Message-ID: <20130910221900.GA9805@quack.suse.cz>
References: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net>
 <20130731190245.GC28018@quack.suse.cz>
 <alpine.DEB.2.00.1308091031450.17790@cobra.newdream.net>
 <20130809212425.GB1050@quack.suse.cz>
 <alpine.DEB.2.00.1308091504320.14125@cobra.newdream.net>
 <20130812125256.GB4596@quack.suse.cz>
 <alpine.DEB.2.00.1308121106320.29150@cobra.newdream.net>
 <20130813103416.GA12197@quack.suse.cz>
 <alpine.DEB.2.00.1308221633080.475@cobra.newdream.net>
 <20130823204810.GB12980@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Sage Weil <sage@inktank.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3IJWTE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 18:19:04 -0400
Content-Disposition: inline
In-Reply-To: <20130823204810.GB12980@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 23-08-13 22:48:10, Jan Kara wrote:
> On Thu 22-08-13 16:35:15, Sage Weil wrote:
> > On Tue, 13 Aug 2013, Jan Kara wrote:
> > > On Mon 12-08-13 11:13:06, Sage Weil wrote:
> > > > Full dmesg is attached.
> > >   Hum, nothing interesting in there...
> > > 
> > > > Our QA seems to hit this with some regularity.  Let me know if there's 
> > > > some combination of patches that would help shed more light!
> > >   If they can run with attached debug patch it could maybe sched some more
> > > light. Please send also your System.map file together with the dmesg of the
> > > kernel when the crash happens so that I can map addresses to function
> > > names... Thanks!
> > 
> > Okay, finally hit it again:
> > 
> > <6>[75193.192249] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,user_xattr,user_xattr
> > <3>[77877.426658] Dirtying buffer without jh at 4302720297: state 218c029,jh added from 0xffffffff8127ab1d at 4302720297, removed from 0xffffffff8127b5b0 at 4302720296
> > <4>[77877.441200] ------------[ cut here ]------------
> > <4>[77877.445845] WARNING: CPU: 7 PID: 26045 at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1380 jbd2_journal_dirty_metadata+0x1f1/0x2e0()
> > 
> > <4>[77877.497349] CPU: 7 PID: 26045 Comm: ceph-osd Not tainted 3.11.0-rc5-ceph-00061-g546140d #1
> > <4>[77877.505649] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
> > <4>[77877.513213]  0000000000000564 ffff880131ca1938 ffffffff81642d85 ffff8802272ef290
> > <4>[77877.520694]  0000000000000000 ffff880131ca1978 ffffffff8104985c ffff880131ca19a0
> > <4>[77877.528218]  ffff88020f695aa0 0000000000000000 ffff880214c48b40 ffff88020be55000
> > <4>[77877.535756] Call Trace:
> > <4>[77877.538279]  [<ffffffff81642d85>] dump_stack+0x46/0x58
> > <4>[77877.543439]  [<ffffffff8104985c>] warn_slowpath_common+0x8c/0xc0
> > <4>[77877.549548]  [<ffffffff810498aa>] warn_slowpath_null+0x1a/0x20
> > <4>[77877.555413]  [<ffffffff8127adb1>] jbd2_journal_dirty_metadata+0x1f1/0x2e0
> > <4>[77877.562288]  [<ffffffff812578c3>] __ext4_handle_dirty_metadata+0xa3/0x140
> > <4>[77877.569155]  [<ffffffff81268e23>] ext4_xattr_release_block+0x103/0x1f0
> > <4>[77877.575723]  [<ffffffff812692b0>] ext4_xattr_block_set+0x1e0/0x910
> > <4>[77877.581990]  [<ffffffff8126a58b>] ext4_xattr_set_handle+0x38b/0x4a0
> > <4>[77877.588335]  [<ffffffff810af7cd>] ? trace_hardirqs_on+0xd/0x10
> > <4>[77877.594188]  [<ffffffff8126a765>] ext4_xattr_set+0xc5/0x140
> > <4>[77877.599837]  [<ffffffff8126b177>] ext4_xattr_user_set+0x47/0x50
> > <4>[77877.605779]  [<ffffffff811a3fee>] generic_setxattr+0x6e/0x90
> > <4>[77877.611514]  [<ffffffff811a48eb>] __vfs_setxattr_noperm+0x7b/0x1c0
> > <4>[77877.617773]  [<ffffffff811a4af4>] vfs_setxattr+0xc4/0xd0
> > <4>[77877.623103]  [<ffffffff811a4c3e>] setxattr+0x13e/0x1e0
> > <4>[77877.628317]  [<ffffffff81181ec7>] ? __sb_start_write+0xe7/0x1b0
> > <4>[77877.634260]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > <4>[77877.640428]  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
> > <4>[77877.645847]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > <4>[77877.652015]  [<ffffffff8119e902>] ? mnt_clone_write+0x12/0x30
> > <4>[77877.657897]  [<ffffffff811a50de>] SyS_fsetxattr+0xbe/0x100
> > <4>[77877.663405]  [<ffffffff81653782>] system_call_fastpath+0x16/0x1b
> > <4>[77877.669488] ---[ end trace bb7933908cd5a32a ]---
>   I was scratching my head for a while how this could happen but I think I
> see the race now. Think we have two inodes A and B which share the same
> xattr block (so &BHDR(bh)->h_refcount == 2). Now we are changing xattrs for
> both inodes in parallel - that can easily happen because xattr locking is
> generally per inode (EXT4_I(inode)->xattr_sem). The following race then
> happens:
> CPU1					CPU2
> ext4_xattr_release_block()		ext4_xattr_release_block()
> lock_buffer(bh);
> /* False */
> if (BHDR(bh)->h_refcount == cpu_to_le32(1))
> } else {
> 	le32_add_cpu(&BHDR(bh)->h_refcount, -1);
> 	unlock_buffer(bh);
> 					lock_buffer(bh);
> 					/* True */
> 					if (BHDR(bh)->h_refcount == cpu_to_le32(1))
> 						get_bh(bh);
> 						ext4_free_blocks()
> 							...
> 							jbd2_journal_forget()
> 								jbd2_journal_unfile_buffer()
> 								-> JH is gone
> 	error = ext4_handle_dirty_xattr_block(handle, inode, bh);
> 	-> triggers warning
> 
> Now easy fix would be to move ext4_handle_dirty_xattr_block() before
> unlock_buffer() but I don't really like that because of locking
> constraints. I'll think about it...
  So finally I've got back to this. Attached is a somewhat ugly patch that
should fix this issue. Can you please test it? Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--sdtB3X0nJg68CQEu
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-jbd2-warning-under-heavy-xattr-load.patch"

>From f70fdf2341118eddc2ad1d5ef29498097b3630ef Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 11 Sep 2013 00:04:25 +0200
Subject: [PATCH] ext4: Fix jbd2 warning under heavy xattr load

When heavily exercising xattr code the assertion that
jbd2_journal_dirty_metadata() shouldn't return error was triggered:

WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1237
jbd2_journal_dirty_metadata+0x1ba/0x260()

CPU: 0 PID: 8877 Comm: ceph-osd Tainted: G    W 3.10.0-ceph-00049-g68d04c9 #1
Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
 ffffffff81a1d3c8 ffff880214469928 ffffffff816311b0 ffff880214469968
 ffffffff8103fae0 ffff880214469958 ffff880170a9dc30 ffff8802240fbe80
 0000000000000000 ffff88020b366000 ffff8802256e7510 ffff880214469978
Call Trace:
 [<ffffffff816311b0>] dump_stack+0x19/0x1b
 [<ffffffff8103fae0>] warn_slowpath_common+0x70/0xa0
 [<ffffffff8103fb2a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81267c2a>] jbd2_journal_dirty_metadata+0x1ba/0x260
 [<ffffffff81245093>] __ext4_handle_dirty_metadata+0xa3/0x140
 [<ffffffff812561f3>] ext4_xattr_release_block+0x103/0x1f0
 [<ffffffff81256680>] ext4_xattr_block_set+0x1e0/0x910
 [<ffffffff8125795b>] ext4_xattr_set_handle+0x38b/0x4a0
 [<ffffffff810a319d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81257b32>] ext4_xattr_set+0xc2/0x140
 [<ffffffff81258547>] ext4_xattr_user_set+0x47/0x50
 [<ffffffff811935ce>] generic_setxattr+0x6e/0x90
 [<ffffffff81193ecb>] __vfs_setxattr_noperm+0x7b/0x1c0
 [<ffffffff811940d4>] vfs_setxattr+0xc4/0xd0
 [<ffffffff8119421e>] setxattr+0x13e/0x1e0
 [<ffffffff811719c7>] ? __sb_start_write+0xe7/0x1b0
 [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
 [<ffffffff8118c65c>] ? fget_light+0x3c/0x130
 [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
 [<ffffffff8118f1f8>] ? __mnt_want_write+0x58/0x70
 [<ffffffff811946be>] SyS_fsetxattr+0xbe/0x100
 [<ffffffff816407c2>] system_call_fastpath+0x16/0x1b

The reason for the warning is that buffer_head passed into
jbd2_journal_dirty_metadata() didn't have journal_head attached. This is
caused by the following race of two ext4_xattr_release_block() calls:

CPU1                                CPU2
ext4_xattr_release_block()          ext4_xattr_release_block()
lock_buffer(bh);
/* False */
if (BHDR(bh)->h_refcount == cpu_to_le32(1))
} else {
  le32_add_cpu(&BHDR(bh)->h_refcount, -1);
  unlock_buffer(bh);
                                    lock_buffer(bh);
                                    /* True */
                                    if (BHDR(bh)->h_refcount == cpu_to_le32(1))
                                      get_bh(bh);
                                      ext4_free_blocks()
                                        ...
                                        jbd2_journal_forget()
                                          jbd2_journal_unfile_buffer()
                                          -> JH is gone
  error = ext4_handle_dirty_xattr_block(handle, inode, bh);
  -> triggers the warning

We fix the problem by moving ext4_handle_dirty_xattr_block() under the
buffer lock. Sadly this cannot be done in nojournal mode as that
function can call sync_dirty_buffer() which would deadlock. Luckily in
nojournal mode the race is harmless (we only dirty already freed buffer)
and thus for nojournal mode we leave the dirtying outside of the buffer
lock.

Reported-by: Sage Weil <sage@inktank.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c081e34..dc99e17 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -517,8 +517,8 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 }
 
 /*
- * Release the xattr block BH: If the reference count is > 1, decrement
- * it; otherwise free the block.
+ * Release the xattr block BH: If the reference count is > 1, decrement it;
+ * otherwise free the block.
  */
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
@@ -538,16 +538,31 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		if (ce)
 			mb_cache_entry_free(ce);
 		get_bh(bh);
+		unlock_buffer(bh);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
-		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
+		/*
+		 * Beware of this ugliness: Releasing of xattr block references
+		 * from different inodes can race and so we have to protect
+		 * from a race where someone else frees the block (and releases
+		 * its journal_head) before we are done dirtying the buffer. In
+		 * nojournal mode this race is harmless and we actually cannot
+		 * call ext4_handle_dirty_xattr_block() with locked buffer as
+		 * that function can call sync_dirty_buffer() so for that case
+		 * we handle the dirtying after unlocking the buffer.
+		 */
+		if (ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		unlock_buffer(bh);
-		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
+		if (!ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
-- 
1.8.1.4


--sdtB3X0nJg68CQEu--
