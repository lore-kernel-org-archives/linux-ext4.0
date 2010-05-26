From: tytso@mit.edu
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart V2
Date: Wed, 26 May 2010 10:47:51 -0400
Message-ID: <20100526144751.GE29528@thunk.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
 <20100525133241.GF5556@thunk.org>
 <87632ckqcy.fsf@openvz.org>
 <20100525214447.GA14530@thunk.org>
 <87hblvqb6c.fsf@openvz.org>
 <87pr0ilw3n.fsf_-_@openvz.org>
 <20100526132352.GA29528@thunk.org>
 <87k4qqlp1g.fsf@openvz.org>
 <20100526144545.GD29528@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46374 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0EZOrx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 May 2010 10:47:53 -0400
Content-Disposition: inline
In-Reply-To: <20100526144545.GD29528@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 26, 2010 at 10:45:45AM -0400, tytso@MIT.EDU wrote:
> OK, but why not have the truncate *always* restart its job after
> restarting the transaction?  #1, it's relatively rare in most
> workloads that we need to restart the transaction at all in the first
> place, and #2, it's easier to test if we always restart the truncate,
> and #3, it's not like we'll be doing that much extra work if we
> restart the truncate and the file wasn't extended significantly...
> 

Like this.... (note how much simpler this patch is compared to earlier
versions)

						- Ted

ext4: restart ext4_ext_remove_space() after transaction restart

From: Dmitry Monakhov <dmonakhov@openvz.org>

If i_data_sem was internally dropped due to transaction restart, it is
necessary to restart path look-up because extents tree was possibly
modified by ext4_get_block().

https://bugzilla.kernel.org/show_bug.cgi?id=15827

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ffcaa11..0a47bec 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -107,11 +107,8 @@ static int ext4_ext_truncate_extend_restart(handle_t *handle,
 	if (err <= 0)
 		return err;
 	err = ext4_truncate_restart_trans(handle, inode, needed);
-	/*
-	 * We have dropped i_data_sem so someone might have cached again
-	 * an extent we are going to truncate.
-	 */
-	ext4_ext_invalidate_cache(inode);
+	if (err == 0)
+		err = -EAGAIN;
 
 	return err;
 }
@@ -2359,7 +2356,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	int depth = ext_depth(inode);
 	struct ext4_ext_path *path;
 	handle_t *handle;
-	int i = 0, err = 0;
+	int i, err;
 
 	ext_debug("truncate since %u\n", start);
 
@@ -2368,23 +2365,26 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
+again:
 	ext4_ext_invalidate_cache(inode);
 
 	/*
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
+	depth = ext_depth(inode);
 	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
 		return -ENOMEM;
 	}
+	path[0].p_depth = depth;
 	path[0].p_hdr = ext_inode_hdr(inode);
 	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
 		err = -EIO;
 		goto out;
 	}
-	path[0].p_depth = depth;
+	i = err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
@@ -2478,6 +2478,8 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
+	if (err == -EAGAIN)
+		goto again;
 	ext4_journal_stop(handle);
 
 	return err;
