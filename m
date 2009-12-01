From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Remove blocks from inode prealloc list on failure
Date: Tue, 1 Dec 2009 10:17:02 -0800
Message-ID: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:32593 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZLASRD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Dec 2009 13:17:03 -0500
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id nB1IH7vX017736
	for <linux-ext4@vger.kernel.org>; Tue, 1 Dec 2009 18:17:07 GMT
Received: from pxi17 (pxi17.prod.google.com [10.243.27.17])
	by zps35.corp.google.com with ESMTP id nB1IGhv1014641
	for <linux-ext4@vger.kernel.org>; Tue, 1 Dec 2009 10:17:02 -0800
Received: by pxi17 with SMTP id 17so676824pxi.30
        for <linux-ext4@vger.kernel.org>; Tue, 01 Dec 2009 10:17:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a leak of blocks in an inode prealloc list if device failures
cause ext4_mb_mark_diskspace_used() to fail.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
diff -uprN orig/fs/ext4/mballoc.c new/fs/ext4/mballoc.c
--- orig/fs/ext4/mballoc.c	2009-12-01 09:27:25.000000000 -0800
+++ new/fs/ext4/mballoc.c	2009-12-01 09:28:38.000000000 -0800
@@ -3011,6 +3011,22 @@ static void ext4_mb_collect_stats(struct
 }

 /*
+ * Called on failure; free up any blocks from the inode PA for this
+ * context.
+ */
+static void ext4_discard_inode_pa(struct ext4_allocation_context *ac)
+{
+	struct ext4_prealloc_space *pa = ac->ac_pa;
+	int len;
+
+	if (pa && pa->pa_type == MB_INODE_PA) {
+		len = ac->ac_b_ex.fe_len;
+		pa->pa_free += len;
+	}
+
+}
+
+/*
  * use blocks preallocated to inode
  */
 static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
@@ -4295,6 +4311,7 @@ repeat:
 			ac->ac_status = AC_STATUS_CONTINUE;
 			goto repeat;
 		} else if (*errp) {
+			ext4_discard_inode_pa(ac);
 			ac->ac_b_ex.fe_len = 0;
 			ar->len = 0;
 			ext4_mb_show_ac(ac);
