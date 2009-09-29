From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Make non-journal fsync work properly.  (Version
	3)
Date: Tue, 29 Sep 2009 10:09:57 -0400
Message-ID: <20090929140957.GC24383@mit.edu>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com> <20090908050614.GA10477@mit.edu> <1252424465.17646.7.camel@bobble.smo.corp.google.com> <20090908220504.GS22901@mit.edu> <1252517664.18594.3.camel@bobble.smo.corp.google.com> <1253925545.22432.57.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59868 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZI2OJ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2009 10:09:59 -0400
Content-Disposition: inline
In-Reply-To: <1253925545.22432.57.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 25, 2009 at 05:39:05PM -0700, Frank Mayhar wrote:
> This patch follows Aneesh' suggestion of just calling
> sync_dirty_buffer() directly.  Sorry about the delay, I've been busy
> 
> Teach ext4_write_inode() about non-journal mode in a better way,
> suggested upstream.  Instead of using ext4_do_update_inode(), it
> now calls sync_dirty_buffer() directly.  Also handle possible
> error return from that function.
> 
> Signed-off-by: Frank Mayhar <fmayhar@google.com>

Since the V2 version of your patch has already been merged, what I've
added to the ext4 patch queue was the delta patch between V2 and V3
version of the patch.

					- Ted

commit 49130f6fbdaf8d9f3a39e316ed285ca2ff520122
Author: Frank Mayhar <fmayhar@google.com>
Date:   Tue Sep 29 10:07:47 2009 -0400

    ext4: Avoid updating the inode table bh twice in no journal mode
    
    This is a cleanup of commit 91ac6f4.  Since ext4_mark_inode_dirty()
    has already called ext4_mark_iloc_dirty(), which in turn calls
    ext4_do_update_inode(), it's not necessary to have ext4_write_inode()
    call ext4_do_update_inode() in no journal mode.  Indeed, it would be
    duplicated work.
    
    Reviewed-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Frank Mayhar <fmayhar@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bfc867a..7afb697 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4986,8 +4986,7 @@ static int ext4_inode_blocks_set(handle_t *handle,
  */
 static int ext4_do_update_inode(handle_t *handle,
 				struct inode *inode,
-				struct ext4_iloc *iloc,
-				int do_sync)
+				struct ext4_iloc *iloc)
 {
 	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -5088,22 +5087,10 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
-	/*
-	 * If we're not using a journal and we were called from
-	 * ext4_write_inode() to sync the inode (making do_sync true),
-	 * we can just use sync_dirty_buffer() directly to do our dirty
-	 * work.  Testing s_journal here is a bit redundant but it's
-	 * worth it to avoid potential future trouble.
-	 */
-	if (EXT4_SB(inode->i_sb)->s_journal == NULL && do_sync) {
-		BUFFER_TRACE(bh, "call sync_dirty_buffer");
-		sync_dirty_buffer(bh);
-	} else {
-		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-		rc = ext4_handle_dirty_metadata(handle, inode, bh);
-		if (!err)
-			err = rc;
-	}
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	rc = ext4_handle_dirty_metadata(handle, inode, bh);
+	if (!err)
+		err = rc;
 	ei->i_state &= ~EXT4_STATE_NEW;
 
 out_brelse:
@@ -5171,8 +5158,16 @@ int ext4_write_inode(struct inode *inode, int wait)
 		err = ext4_get_inode_loc(inode, &iloc);
 		if (err)
 			return err;
-		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
-					   inode, &iloc, wait);
+		if (wait)
+			sync_dirty_buffer(iloc.bh);
+		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
+			ext4_error(inode->i_sb, __func__,
+				   "IO error syncing inode, "
+				   "inode=%lu, block=%llu",
+				   inode->i_ino,
+				   (unsigned long long)iloc.bh->b_blocknr);
+			err = -EIO;
+		}
 	}
 	return err;
 }
@@ -5468,7 +5463,7 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	get_bh(iloc->bh);
 
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
-	err = ext4_do_update_inode(handle, inode, iloc, 0);
+	err = ext4_do_update_inode(handle, inode, iloc);
 	put_bh(iloc->bh);
 	return err;
 }
