From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] unexport journal_update_superblock
Date: Mon, 31 Mar 2008 01:40:41 +0300
Message-ID: <20080330224041.GJ28445@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53031 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbYC3Wky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:54 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch removes the unused EXPORT_SYMBOL(journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 27 Feb 2008

66cbc7390d66cdeb83a3f81d7ec1ea71d6f6e2c8 foobar
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..5c2ebb7 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(journal_set_features);
 EXPORT_SYMBOL(journal_create);
 EXPORT_SYMBOL(journal_load);
 EXPORT_SYMBOL(journal_destroy);
-EXPORT_SYMBOL(journal_update_superblock);
 EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);

