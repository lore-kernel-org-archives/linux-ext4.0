From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] block: Add Kconfig help which notes that ext4 needs CONFIG_LSF
Date: Tue,  6 Jan 2009 12:21:30 -0500
Message-ID: <1231262490-15594-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38100 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZAFRVc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 12:21:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 1ab7c15..e10f4c1 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -64,6 +64,12 @@ config LSF
 	  Say Y here if you want to be able to handle very large files (2TB
 	  and larger), otherwise say N.
 
+	  The ext4 filesystem requires that this feature be enabled in
+	  order to support filesystems that have the huge_file feature
+	  enabled.    Otherwise, it will refuse to mount any filesystems
+	  that use the huge_file feature, which is enabled by default
+	  by mke2fs.ext4.
+
 	  If unsure, say Y.
 
 config BLK_DEV_BSG
-- 
1.6.0.4.8.g36f27.dirty

