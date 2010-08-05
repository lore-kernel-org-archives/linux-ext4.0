From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Adding error check for ext4_mb_regular_allocator call.
Date: Thu, 5 Aug 2010 16:28:34 -0400
Message-ID: <20100805202834.GK2901@thunk.org>
References: <1281033248-29627-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55645 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934330Ab0HEU2j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 16:28:39 -0400
Content-Disposition: inline
In-Reply-To: <1281033248-29627-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I cleaned up the error path handling in ext4_mb_new_blocks() as well
as lightly editing your commit before adding it to the ext4 patch
tree.

						- Ted

commit 6c7a120ac6c62316ab1fc78dfc0a7b13f3bfcbff
Author: Aditya Kali <adityakali@google.com>
Date:   Thu Aug 5 16:22:24 2010 -0400

    ext4: Adding error check after calling ext4_mb_regular_allocator()
    
    If the bitmap block on disk is bad, ext4_mb_load_buddy() returns an
    error. This error is returned to the caller,
    ext4_mb_regular_allocator() and then to ext4_mb_new_blocks().  But
    ext4_mb_new_blocks() did not check for the return value of
    ext4_mb_regular_allocator() and would repeatedly try to load the
    bitmap block. The fix simply catches the return value and exits out of
    the 'repeat' loop after cleanup.
    
    We also take the opportunity to clean up the error handling in
    ext4_mb_new_blocks().
    
    Google-Bug-Id: 2853530
    
    Signed-off-by: Aditya Kali <adityakali@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3da2828..1f360f0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4253,7 +4253,7 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
  * to usual allocation
  */
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
-				 struct ext4_allocation_request *ar, int *errp)
+				struct ext4_allocation_request *ar, int *errp)
 {
 	int freed;
 	struct ext4_allocation_context *ac = NULL;
@@ -4297,7 +4297,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		inquota = ar->len;
 		if (ar->len == 0) {
 			*errp = -EDQUOT;
-			goto out3;
+			goto out;
 		}
 	}
 
@@ -4305,13 +4305,13 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	if (!ac) {
 		ar->len = 0;
 		*errp = -ENOMEM;
-		goto out1;
+		goto out;
 	}
 
 	*errp = ext4_mb_initialize_context(ac, ar);
 	if (*errp) {
 		ar->len = 0;
-		goto out2;
+		goto out;
 	}
 
 	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
@@ -4320,7 +4320,9 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		ext4_mb_normalize_request(ac, ar);
 repeat:
 		/* allocate space in core */
-		ext4_mb_regular_allocator(ac);
+		*errp = ext4_mb_regular_allocator(ac);
+		if (*errp)
+			goto errout;
 
 		/* as we've just preallocated more space than
 		 * user requested orinally, we store allocated
@@ -4331,7 +4333,7 @@ repeat:
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
 		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
-		if (*errp ==  -EAGAIN) {
+		if (*errp == -EAGAIN) {
 			/*
 			 * drop the reference that we took
 			 * in ext4_mb_use_best_found
@@ -4342,12 +4344,10 @@ repeat:
 			ac->ac_b_ex.fe_len = 0;
 			ac->ac_status = AC_STATUS_CONTINUE;
 			goto repeat;
-		} else if (*errp) {
+		} else if (*errp)
+		errout:
 			ext4_discard_allocated_blocks(ac);
-			ac->ac_b_ex.fe_len = 0;
-			ar->len = 0;
-			ext4_mb_show_ac(ac);
-		} else {
+		else {
 			block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
 			ar->len = ac->ac_b_ex.fe_len;
 		}
@@ -4356,19 +4356,19 @@ repeat:
 		if (freed)
 			goto repeat;
 		*errp = -ENOSPC;
+	}
+
+	if (*errp) {
 		ac->ac_b_ex.fe_len = 0;
 		ar->len = 0;
 		ext4_mb_show_ac(ac);
 	}
-
 	ext4_mb_release_context(ac);
