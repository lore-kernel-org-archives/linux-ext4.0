From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: move_extent improve bh vanishing success factor
Date: Wed, 5 Nov 2014 11:53:49 -0500
Message-ID: <20141105165349.GE27083@thunk.org>
References: <1413620984-7736-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40452 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbaKEQx5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Nov 2014 11:53:57 -0500
Content-Disposition: inline
In-Reply-To: <1413620984-7736-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 18, 2014 at 12:29:44PM +0400, Dmitry Monakhov wrote:
> Xiaoguang Wang has reported sporadic EBUSY failures of ext4/302
> Unfortunetly there is nothing we can do if some other task holds
> BH's refenrence. So we must return EBUSY in this case. From other
> point we can decrease false positive report raito. One of such
> cases is filesystem under ENOSPC conditions. We should try to kick
> the journal regardless to number of free blocks.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied but I did modify the patch slightly because we weren't
actually properly handling the ENOSPC case (we were checking for the
wrong error code).

						- Ted

commit 88c6b61ff1cfb4013a3523227d91ad11b2892388
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Nov 5 11:52:38 2014 -0500

    ext4: move_extent improve bh vanishing success factor
    
    Xiaoguang Wang has reported sporadic EBUSY failures of ext4/302
    Unfortunetly there is nothing we can do if some other task holds BH's
    refenrence.  So we must return EBUSY in this case.  But we can try
    kicking the journal to see if the other task releases the bh reference
    after the commit is complete.  Also decrease false positives by
    properly checking for ENOSPC and retrying the allocation after kicking
    the journal --- which is done by ext4_should_retry_alloc().
    
    [ Modified by tytso to properly check for ENOSPC. ]
    
    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 9f2311b..503ea15 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -273,6 +273,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	int replaced_count = 0;
 	int from = data_offset_in_page << orig_inode->i_blkbits;
 	int blocks_per_page = PAGE_CACHE_SIZE >> orig_inode->i_blkbits;
+	struct super_block *sb = orig_inode->i_sb;
 
 	/*
 	 * It needs twice the amount of ordinary journal buffers because
@@ -405,10 +406,13 @@ unlock_pages:
 	page_cache_release(pagep[1]);
 stop_journal:
 	ext4_journal_stop(handle);
+	if (*err == -ENOSPC &&
+	    ext4_should_retry_alloc(sb, &retries))
+		goto again;
 	/* Buffer was busy because probably is pinned to journal transaction,
 	 * force transaction commit may help to free it. */
-	if (*err == -EBUSY && ext4_should_retry_alloc(orig_inode->i_sb,
-						      &retries))
+	if (*err == -EBUSY && retries++ < 4 && EXT4_SB(sb)->s_journal &&
+	    jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal))
 		goto again;
 	return replaced_count;
 
