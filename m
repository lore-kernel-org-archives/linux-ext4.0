From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH] fs/jbd: set pointer = NULL, after kfree it.
Date: Mon, 24 Dec 2012 10:39:07 +0800
Message-ID: <50D7C04B.6010109@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:53480 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2LXCiO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Dec 2012 21:38:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  set pointer = NULL, after call journal_destroy_revoke_table.
    in journal_destroy_revoke_table, it will call kfree to free the buffer.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/jbd/revoke.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 25c713e..d6457b0 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -295,6 +295,7 @@ int journal_init_revoke(journal_t *journal, int hash_size)
 
 fail1:
 	journal_destroy_revoke_table(journal->j_revoke_table[0]);
+	journal->j_revoke_table[0] = NULL;
 fail0:
 	return -ENOMEM;
 }
@@ -303,10 +304,14 @@ fail0:
 void journal_destroy_revoke(journal_t *journal)
 {
 	journal->j_revoke = NULL;
-	if (journal->j_revoke_table[0])
+	if (journal->j_revoke_table[0]) {
 		journal_destroy_revoke_table(journal->j_revoke_table[0]);
-	if (journal->j_revoke_table[1])
+		journal->j_revoke_table[0] = NULL;
+	}
+	if (journal->j_revoke_table[1]) {
 		journal_destroy_revoke_table(journal->j_revoke_table[1]);
+		journal->j_revoke_table[1] = NULL;
+	}
 }
 
 
-- 
1.7.10.4
