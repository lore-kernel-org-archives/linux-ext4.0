From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: unexport jbd2_journal_update_superblock
Date: Sat, 26 Jul 2008 20:26:53 -0400
Message-ID: <1217118414-18636-3-git-send-email-tytso@mit.edu>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu>
 <1217118414-18636-2-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38616 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756246AbYG0A1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2008 20:27:05 -0400
In-Reply-To: <1217118414-18636-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove the unused EXPORT_SYMBOL(jbd2_journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b26c6d9..8207a01 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(jbd2_journal_set_features);
 EXPORT_SYMBOL(jbd2_journal_create);
 EXPORT_SYMBOL(jbd2_journal_load);
 EXPORT_SYMBOL(jbd2_journal_destroy);
-EXPORT_SYMBOL(jbd2_journal_update_superblock);
 EXPORT_SYMBOL(jbd2_journal_abort);
 EXPORT_SYMBOL(jbd2_journal_errno);
 EXPORT_SYMBOL(jbd2_journal_ack_err);
-- 
1.5.6.1.205.ge2c7.dirty

