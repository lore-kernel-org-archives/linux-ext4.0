From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Fri, 5 Oct 2012 09:28:53 -0400
Message-ID: <20121005132853.GC21358@thunk.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
 <20121005124027.GA21358@thunk.org>
 <87a9w1ax91.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53969 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab2JEN2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 09:28:55 -0400
Content-Disposition: inline
In-Reply-To: <87a9w1ax91.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 05, 2012 at 05:01:30PM +0400, Dmitry Monakhov wrote:
> > This WARN_ON is triggering on the truncate path...
> Yeap, this is false positive one. We skip i_mutex on ext4_evict_inode
> This is strange xfsstress 269'th should caught that for me.
> I'll try to prepare workaround ASAP.

This is the patch which I'm currently testing.  If it passes I'll fold
it into your patch.  Anyone see any problems with it?

   	     	     	       	    	     - Ted

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f18e786..cd171dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -238,8 +238,10 @@ void ext4_evict_inode(struct inode *inode)
 	 * protection against it
 	 */
 	sb_start_intwrite(inode->i_sb);
+	mutex_lock(&inode->i_mutex);
 	handle = ext4_journal_start(inode, ext4_blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
+		mutex_unlock(&inode->i_mutex);
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
 		 * If we're going to skip the normal cleanup, we still need to
@@ -256,12 +258,14 @@ void ext4_evict_inode(struct inode *inode)
 	inode->i_size = 0;
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
+		mutex_unlock(&inode->i_mutex);
 		ext4_warning(inode->i_sb,
 			     "couldn't mark inode dirty (err %d)", err);
 		goto stop_handle;
 	}
 	if (inode->i_blocks)
 		ext4_truncate(inode);
+	mutex_unlock(&inode->i_mutex);
 
 	/*
 	 * ext4_ext_truncate() doesn't reserve any slop when it


