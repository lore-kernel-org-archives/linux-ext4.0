From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 15/24] jbd2: Add BH_JBDPrivateStart
Date: Tue, 17 Feb 2009 10:58:35 -0500
Message-ID: <1234886324-15105-16-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
 <1234886324-15105-6-git-send-email-tytso@mit.edu>
 <1234886324-15105-7-git-send-email-tytso@mit.edu>
 <1234886324-15105-8-git-send-email-tytso@mit.edu>
 <1234886324-15105-9-git-send-email-tytso@mit.edu>
 <1234886324-15105-10-git-send-email-tytso@mit.edu>
 <1234886324-15105-11-git-send-email-tytso@mit.edu>
 <1234886324-15105-12-git-send-email-tytso@mit.edu>
 <1234886324-15105-13-git-send-email-tytso@mit.edu>
 <1234886324-15105-14-git-send-email-tytso@mit.edu>
 <1234886324-15105-15-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35413 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZBQQDV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:03:21 -0500
In-Reply-To: <1234886324-15105-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

Add this so that file systems using JBD2 can safely allocate unused b_state
bits.

In this case, we add it so that Ocfs2 can define a single bit for tracking
the validation state of a buffer.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
(cherry picked from commit e97fcd95a4778a8caf1980c6c72fdf68185a0838)
---
 include/linux/jbd2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 66c3499..e8e9133 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -329,6 +329,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_JBDPrivateStart,	/* First bit available for private use by FS */
 };
 
 BUFFER_FNS(JBD, jbd)
-- 
1.5.6.3

