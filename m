From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_mb_initialize_context() forgets to
	initialize some fields
Date: Mon, 13 Jul 2009 09:46:53 -0400
Message-ID: <20090713134653.GD12833@mit.edu>
References: <20090710204754.18406.15771.stgit@mj.roinet.com> <4A57AB9A.4050208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Roskin <proski@gnu.org>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52439 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZGMNq7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 09:46:59 -0400
Content-Disposition: inline
In-Reply-To: <4A57AB9A.4050208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 10, 2009 at 03:59:06PM -0500, Eric Sandeen wrote:
> 
> At this point I think we are initializing almost all of the 22
> allocation context members and 16 of those are 0/NULL; perhaps it'd be
> simpler and/or more efficient to just start with a memset(0), but either
> way.

Agreed, it should be more efficient.  This is the patch which I just
added to the ext4 patch queue.

						- Ted

commit 848a5523c872ae84fbdbce6a3df933a4b7f63e0a
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jul 13 09:45:52 2009 -0400

    ext4: Fix ext4_mb_initialize_context() to initialize all fields
    
    Pavel Roskin pointed out that kmemcheck indicated that
    ext4_mb_store_history() was accessing uninitialized values of
    ac->ac_tail and ac->ac_buddy leading to garbage in the mballoc
    history.  Fix this by initializing the entire structure to all zeros
    first.
    
    Also, two fields were getting doubly initialized by the caller of
    ext4_mb_initialize_context, so remove them for efficiency's sake.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b8b0428..9d08b78 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4227,14 +4227,9 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ext4_get_group_no_and_offset(sb, goal, &group, &block);
 
 	/* set up allocation goals */
+	memset(ac, 0, sizeof(struct ext4_allocation_context));
 	ac->ac_b_ex.fe_logical = ar->logical;
-	ac->ac_b_ex.fe_group = 0;
-	ac->ac_b_ex.fe_start = 0;
-	ac->ac_b_ex.fe_len = 0;
 	ac->ac_status = AC_STATUS_CONTINUE;
-	ac->ac_groups_scanned = 0;
-	ac->ac_ex_scanned = 0;
-	ac->ac_found = 0;
 	ac->ac_sb = sb;
 	ac->ac_inode = ar->inode;
 	ac->ac_o_ex.fe_logical = ar->logical;
@@ -4245,15 +4240,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ac->ac_g_ex.fe_group = group;
 	ac->ac_g_ex.fe_start = block;
 	ac->ac_g_ex.fe_len = len;
-	ac->ac_f_ex.fe_len = 0;
 	ac->ac_flags = ar->flags;
-	ac->ac_2order = 0;
-	ac->ac_criteria = 0;
-	ac->ac_pa = NULL;
-	ac->ac_bitmap_page = NULL;
-	ac->ac_buddy_page = NULL;
-	ac->alloc_semp = NULL;
-	ac->ac_lg = NULL;
 
 	/* we have to define context: we'll we work with a file or
 	 * locality group. this is a policy, actually */
@@ -4521,10 +4508,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	}
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac) {
-		ac->ac_sb = sb;
-		ac->ac_inode = ar->inode;
-	} else {
+	if (!ac) {
 		ar->len = 0;
 		*errp = -ENOMEM;
 		goto out1;
