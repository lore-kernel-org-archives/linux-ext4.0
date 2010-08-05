From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] Adding error check for ext4_mb_regular_allocator call.
Date: Thu,  5 Aug 2010 11:34:08 -0700
Message-ID: <1281033248-29627-1-git-send-email-adityakali@google.com>
Cc: tytso@mit.edu, Aditya Kali <adityakali@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:51114 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0HESej (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 14:34:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the bitmap block on disk is bad, the 'ext4_mb_load_buddy'
returns error. This error is returned to the caller
'ext4_mb_regular_allocator' and then to 'ext4_mb_new_blocks'. But
'ext4_mb_new_blocks' did not check for the return value of
'ext4_mb_regular_allocator' and would repeatedly try to load the
bitmap block. The fix simply catches the return value and exits out
of the 'repeat' loop after cleanup.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/ext4/mballoc.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0e83dfd..f8e99b9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4322,7 +4322,14 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		ext4_mb_normalize_request(ac, ar);
 repeat:
 		/* allocate space in core */
-		ext4_mb_regular_allocator(ac);
+		*errp = ext4_mb_regular_allocator(ac);
+		if (*errp) {
+			ext4_discard_allocated_blocks(ac);
+			ac->ac_b_ex.fe_len = 0;
+			ar->len = 0;
+			ext4_mb_show_ac(ac);
+			goto out4;
+		}
 
 		/* as we've just preallocated more space than
 		 * user requested orinally, we store allocated
@@ -4363,6 +4370,7 @@ repeat:
 		ext4_mb_show_ac(ac);
 	}
 
+out4:
 	ext4_mb_release_context(ac);
 
 out2:
-- 
1.7.1

