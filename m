From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: Re: ext4 deadlocks
Date: Wed, 08 Oct 2008 10:19:11 +0530
Message-ID: <1223441351.4007.137.camel@localhost>
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net>
 <20081007214637.GA2009@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:62510 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYJHEtB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Oct 2008 00:49:01 -0400
In-reply-to: <20081007214637.GA2009@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-10-07 at 15:46 -0600, Andreas Dilger wrote:
> On Oct 07, 2008  15:29 -0500, Eric Sandeen wrote:
> > Jeremy Fitzhardinge wrote:
> > > I tried giving ext4 a spin on my rawhide system, and it appears to 
> > > deadlock pretty quickly: lots of processed blocked in either ext4 or jbd2.
> > > 
> > >  From the look of the sysrq-t dumps I captured, I think beagled is 
> > > what's triggering it by doing something with EAs. I haven't had any 
> > > lockups since I killed it off.
> > > 
> > > beagled       D 0000000000000000     0  3477      1
> > >  ffff880125809778 0000000000000082 0000000000000000 ffff88013b078150
> > >  ffffffff8187a780 ffffffff8187a780 ffff88010f8445c0 ffff88013badc5c0
> > >  ffff88010f844970 0000000100000001 0000000000000000 ffff88010f844970
> > > Call Trace:
> > >  [<ffffffff812170d8>] ? scsi_sg_alloc+0x48/0x4a
> > >  [<ffffffff8136d4ae>] __down_write_nested+0xa3/0xbd
> > >  [<ffffffff8136d4d3>] __down_write+0xb/0xd
> > >  [<ffffffff8136c813>] down_write+0x2f/0x33
> > >  [<ffffffffa04b30a8>] ext4_expand_extra_isize_ea+0x67/0x6f2 [ext4dev]
> > 
> > At first glance it seems that we're trying a down_write on the xattr_sem
> > here...
> > 
> > >  [<ffffffffa04762ed>] ? jbd2_journal_add_journal_head+0x113/0x1b0 [jbd2]
> > >  [<ffffffffa0476173>] ? jbd2_journal_put_journal_head+0x1a/0x56 [jbd2]
> > >  [<ffffffffa0471669>] ? jbd2_journal_get_write_access+0x31/0x38 [jbd2]
> > >  [<ffffffffa0471a6c>] ? jbd2_journal_extend+0x1af/0x1ca [jbd2]
> > >  [<ffffffffa0497f5c>] ext4_mark_inode_dirty+0x119/0x18b [ext4dev]
> > >  [<ffffffffa0498156>] ext4_dirty_inode+0xab/0xc3 [ext4dev]
> > >  [<ffffffff810e7310>] __mark_inode_dirty+0x38/0x194
> > >  [<ffffffffa04b0574>] ext4_mb_new_blocks+0x700/0x70f [ext4dev]
> > >  [<ffffffff8109f395>] ? mark_page_accessed+0x5f/0x6b
> > >  [<ffffffff810eb5ba>] ? __find_get_block+0x1af/0x1c1
> > >  [<ffffffff8136c3af>] ? __wait_on_bit+0x6f/0x7e
> > >  [<ffffffff810ec154>] ? sync_buffer+0x0/0x44
> > >  [<ffffffffa0493e50>] do_blk_alloc+0x9d/0xb3 [ext4dev]
> > >  [<ffffffffa0493eb5>] ext4_new_meta_blocks+0x34/0x76 [ext4dev]
> > >  [<ffffffffa0493f1b>] ext4_new_meta_block+0x24/0x26 [ext4dev]
> > >  [<ffffffffa04b2e79>] ext4_xattr_block_set+0x50e/0x6d6 [ext4dev]
> > >  [<ffffffffa04b39b4>] ext4_xattr_set_handle+0x281/0x3f0 [ext4dev]
> > 
> > Having already downed it here?
> > 
> > I'll look into it, not 100% sure what path gets us here (between
> > in-inode EAs and external block EAs) but I'll see.
> 
> This looks suspiciously like a similar bug fixed in the past by Kalpak,
> related to trying to grow large-inode space in ext4_expand_extra_isize_ea().

ext4_xattr_set_handle() eventually ends up calling
ext4_mark_inode_dirty() which tries to expand the inode by shifting the
EAs. This leads to the xattr_sem being downed again and leading to a
deadlock.

This patch makes sure that if ext4_xattr_set_handle() is in the
call-chain, ext4_mark_inode_dirty() will not expand the inode.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

Index: linux-2.6.27-rc7/fs/ext4/xattr.c
===================================================================
--- linux-2.6.27-rc7.orig/fs/ext4/xattr.c
+++ linux-2.6.27-rc7/fs/ext4/xattr.c
@@ -959,6 +959,7 @@ ext4_xattr_set_handle(handle_t *handle, 
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
 	};
+	unsigned long no_expand;
 	int error;
 
 	if (!name)
@@ -966,6 +967,9 @@ ext4_xattr_set_handle(handle_t *handle, 
 	if (strlen(name) > 255)
 		return -ERANGE;
 	down_write(&EXT4_I(inode)->xattr_sem);
+	no_expand = EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND;
+	EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
+
 	error = ext4_get_inode_loc(inode, &is.iloc);
 	if (error)
 		goto cleanup;
@@ -1042,6 +1046,8 @@ ext4_xattr_set_handle(handle_t *handle, 
 cleanup:
 	brelse(is.iloc.bh);
 	brelse(bs.bh);
+	if (no_expand == 0)
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return error;
 }

Thanks,
Kalpak

