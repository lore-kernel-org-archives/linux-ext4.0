From: Josef Bacik <jbacik@redhat.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Fri, 18 Jul 2008 06:51:52 -0400
Message-ID: <20080718105152.GB15844@unused.rdu.redhat.com>
References: <20080717135746.GB14133@unused.rdu.redhat.com> <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com> <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com> <20080717141655.GD14133@unused.rdu.redhat.com> <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com> <20080717143332.GE14133@unused.rdu.redhat.com> <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com> <20080717144342.GA15844@unused.rdu.redhat.com> <20080717230905.GI6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org,
	Johannes Weiner <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbYGRLLy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 07:11:54 -0400
Content-Disposition: inline
In-Reply-To: <20080717230905.GI6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 05:09:05PM -0600, Andreas Dilger wrote:
> On Jul 17, 2008  10:43 -0400, Josef Bacik wrote:
> > Yeah thats a hard to answer question, one that I will leave up to others
> > who have been doing this much longer than I.  My thought is remount-ro
> > is there to keep you from crashing, so if you have errors=continue then
> > you expect to live with the consequences.  Course if that bit gets flipped
> > via corruption thats not good either.
> 
> It shouldn't cause the kernel to crash, but it should definitely return
> an error to the application.  This is probably one of the code paths
> that the Coverity folks were reporting on in FAST this year where on-disk
> errors are not propagated to the application.

Ok, please revert the previous patch and apply this one.  On errors=continue we
will just abort the handle which should keep the NULL pointer dereference from
happening and return an error back to the application.  Please let me know how
this works Vegard, and thanks alot for testing all this.

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c
+++ linux-2.6/fs/ext3/inode.c
@@ -2023,13 +2023,27 @@ static void ext3_clear_blocks(handle_t *
 		unsigned long count, __le32 *first, __le32 *last)
 {
 	__le32 *p;
+	int ret;
+
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext3_journal_dirty_metadata");
-			ext3_journal_dirty_metadata(handle, bh);
+			ret = ext3_journal_dirty_metadata(handle, bh);
+			if (ret) {
+				ext3_std_error(inode->i_sb, ret);
+				return;
+			}
 		}
-		ext3_mark_inode_dirty(handle, inode);
-		ext3_journal_test_restart(handle, inode);
+		ret = ext3_mark_inode_dirty(handle, inode);
+		if (ret)
+			return;
+
+		ret = ext3_journal_test_restart(handle, inode);
+		if (ret) {
+			ext3_std_error(inode->i_sb, ret);
+			return;
+		}
+
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
 			ext3_journal_get_write_access(handle, bh);
Index: linux-2.6/fs/ext3/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext3/balloc.c
+++ linux-2.6/fs/ext3/balloc.c
@@ -498,6 +498,7 @@ void ext3_free_blocks_sb(handle_t *handl
 		ext3_error (sb, "ext3_free_blocks",
 			    "Freeing blocks not in datazone - "
 			    "block = "E3FSBLK", count = %lu", block, count);
+		err = -EIO;
 		goto error_return;
 	}
 
@@ -535,6 +536,7 @@ do_more:
 			    "Freeing blocks in system zones - "
 			    "Block = "E3FSBLK", count = %lu",
 			    block, count);
+		err = -EIO;
 		goto error_return;
 	}
 
Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -167,7 +167,15 @@ static void ext3_handle_error(struct sup
 		EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
 		if (journal)
 			journal_abort(journal, -EIO);
+	} else {
+		handle_t *handle = current->journal_info;
+		if (handle && !is_handle_aborted(handle)) {
+			if (!handle->h_err)
+				handle->h_err = -EIO;
+			journal_abort_handle(handle);
+		}
 	}
+
 	if (test_opt (sb, ERRORS_RO)) {
 		printk (KERN_CRIT "Remounting filesystem read-only\n");
 		sb->s_flags |= MS_RDONLY;
