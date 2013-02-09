From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 02/12] jbd2: revert "jbd2: add COW fields to struct jbd2_journal_handle"
Date: Sat,  9 Feb 2013 16:53:42 -0500
Message-ID: <1360446832-12724-3-git-send-email-tytso@mit.edu>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47599 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758694Ab3BIVxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Feb 2013 16:53:54 -0500
In-Reply-To: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reverts commit 93737456d68ddcb86232f669b83da673dd12e351.

The cow-snapshots effort is no longer active, so remove these extra
fields to shrink down the handle structure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 include/linux/jbd2.h | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e0aafc4..24db725 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -397,35 +397,13 @@ struct jbd2_journal_handle
 	int			h_err;
 
 	/* Flags [no locking] */
-	unsigned int	h_sync:1;	/* sync-on-close */
-	unsigned int	h_jdata:1;	/* force data journaling */
-	unsigned int	h_aborted:1;	/* fatal error on handle */
-	unsigned int	h_cowing:1;	/* COWing block to snapshot */
-
-	/* Number of buffers requested by user:
-	 * (before adding the COW credits factor) */
-	unsigned int	h_base_credits:14;
-
-	/* Number of buffers the user is allowed to dirty:
-	 * (counts only buffers dirtied when !h_cowing) */
-	unsigned int	h_user_credits:14;
-
+	unsigned int	h_sync:		1;	/* sync-on-close */
+	unsigned int	h_jdata:	1;	/* force data journaling */
+	unsigned int	h_aborted:	1;	/* fatal error on handle */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	h_lockdep_map;
 #endif
