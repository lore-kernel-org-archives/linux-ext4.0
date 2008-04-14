From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] unexport journal_update_superblock
Date: Mon, 14 Apr 2008 21:13:27 +0300
Message-ID: <20080414181327.GC6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765547AbYDNSQ0@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
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
