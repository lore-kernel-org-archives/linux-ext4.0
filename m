From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
Date: Sat,  5 Jul 2014 19:16:02 -0400
Message-ID: <1404602162-16730-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47065 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaGEXQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 19:16:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are spending a lot of time explaining to users what this error
means.  Let's try to improve the message to avoid this problem.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/mballoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7f72f50..2dcb936 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -752,8 +752,8 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 
 	if (free != grp->bb_free) {
 		ext4_grp_locked_error(sb, group, 0, 0,
-				      "%u clusters in bitmap, %u in gd; "
-				      "block bitmap corrupt.",
+				      "block bitmap and bg descriptor "
+				      "inconsistent: %u vs %u free clusters",
 				      free, grp->bb_free);
 		/*
 		 * If we intend to continue, we consider group descriptor
-- 
2.0.0

