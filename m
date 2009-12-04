From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Remove blocks from inode prealloc list on failure
Date: Fri, 4 Dec 2009 11:14:40 -0800
Message-ID: <6601abe90912041114m37284332pd568e13ed5beee2b@mail.gmail.com>
References: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
	 <20091204094654.GB4272@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:20268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZLDTOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2009 14:14:38 -0500
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id nB4JEhci004327
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 11:14:44 -0800
Received: from pwj17 (pwj17.prod.google.com [10.241.219.81])
	by wpaz33.hot.corp.google.com with ESMTP id nB4JDaYk016070
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 11:14:41 -0800
Received: by pwj17 with SMTP id 17so2580200pwj.5
        for <linux-ext4@vger.kernel.org>; Fri, 04 Dec 2009 11:14:40 -0800 (PST)
In-Reply-To: <20091204094654.GB4272@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Can you name it as discard allocated blocks and add a comment saying why
> we don't need it for MB_GROUP_PA ? Otherwise
>
> Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This fixes a leak of blocks in an inode prealloc list if device failures
cause ext4_mb_mark_diskspace_used() to fail.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
diff -uprN orig/fs/ext4/mballoc.c new/fs/ext4/mballoc.c
--- orig/fs/ext4/mballoc.c	2009-12-01 09:27:25.000000000 -0800
+++ new/fs/ext4/mballoc.c	2009-12-04 11:09:03.000000000 -0800
@@ -3011,6 +3011,24 @@ static void ext4_mb_collect_stats(struct
 }

 /*
+ * Called on failure; free up any blocks from the inode PA for this
+ * context.  We don't need this for MB_GROUP_PA because we only change
+ * pa_free in ext4_mb_release_context(), but on failure, we've already
+ * zeroed out ac->ac_b_ex.fe_len, so group_pa->pa_free is not changed.
+ */
+static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
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
@@ -4295,6 +4313,7 @@ repeat:
 			ac->ac_status = AC_STATUS_CONTINUE;
 			goto repeat;
 		} else if (*errp) {
+			ext4_discard_allocated_blocks(ac);
 			ac->ac_b_ex.fe_len = 0;
 			ar->len = 0;
 			ext4_mb_show_ac(ac);
