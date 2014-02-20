From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: make sure ex.fe_logical is initialized
Date: Thu, 20 Feb 2014 00:37:16 -0500
Message-ID: <1392874636-3712-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60274 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaBTFhX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 00:37:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The lowest levels of mballoc set all of the fields of struct
ext4_free_extent except for fe_logical, since they are just trying to
find the requested free set of blocks, and the logical block hasn't
been set yet.  This makes some static code checkers sad.  Set it to
various different debug values, which would be useful when
debugging mballoc if these values were to ever show up due to the
parts of mballoc triyng to use ac->ac_b_ex.fe_logical before it is
properly upper layers of mballoc failing to properly set, usually by
ext4_mb_use_best_found().

Addresses-Coverity-Id: #139697
Addresses-Coverity-Id: #139698
Addresses-Coverity-Id: #139699

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 04a5c75..0d42f63 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1808,6 +1808,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	ext4_lock_group(ac->ac_sb, group);
 	max = mb_find_extent(e4b, ac->ac_g_ex.fe_start,
 			     ac->ac_g_ex.fe_len, &ex);
+	ex.fe_logical = 0xDEADFA11; /* debug value */
 
 	if (max >= ac->ac_g_ex.fe_len && ac->ac_g_ex.fe_len == sbi->s_stripe) {
 		ext4_fsblk_t start;
@@ -1936,7 +1937,7 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 			 */
 			break;
 		}
