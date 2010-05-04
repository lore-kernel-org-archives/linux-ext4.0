From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Remove extraneous newlines in ext4_msg() calls
Date: Tue, 4 May 2010 13:55:27 -0700
Message-ID: <AANLkTimAvzJuUthxtix9y02DKIZgFCQBRAEA9KTQRaS2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:61512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab0EDUza (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 16:55:30 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [10.3.21.7])
	by smtp-out.google.com with ESMTP id o44KtTJR004028
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 13:55:29 -0700
Received: from qyk35 (qyk35.prod.google.com [10.241.83.163])
	by hpaq7.eem.corp.google.com with ESMTP id o44KtR3Z004468
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 13:55:28 -0700
Received: by qyk35 with SMTP id 35so6083687qyk.26
        for <linux-ext4@vger.kernel.org>; Tue, 04 May 2010 13:55:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This removes extraneous newlines that are sent to ext4_msg().

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2010-05-04 13:46:06.000000000 -0700
+++ new/fs/ext4/inode.c	2010-05-04 13:49:18.000000000 -0700
@@ -2282,7 +2282,7 @@ static int mpage_da_map_blocks(struct mp
 		ext4_msg(mpd->inode->i_sb, KERN_CRIT,
 			 "delayed block allocation failed for inode %lu at "
 			 "logical offset %llu with max blocks %zd with "
-			 "error %d\n", mpd->inode->i_ino,
+			 "error %d", mpd->inode->i_ino,
 			 (unsigned long long) next,
 			 mpd->b_size >> mpd->inode->i_blkbits, err);
 		printk(KERN_CRIT "This should not happen!!  "
@@ -2941,7 +2941,7 @@ retry:
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
-			       "%ld pages, ino %lu; err %d\n", __func__,
+			       "%ld pages, ino %lu; err %d", __func__,
 				wbc->nr_to_write, inode->i_ino, ret);
 			goto out_writepages;
 		}
@@ -3016,7 +3016,7 @@ retry:
 	if (pages_skipped != wbc->pages_skipped)
 		ext4_msg(inode->i_sb, KERN_CRIT,
 			 "This should not happen leaving %s "
-			 "with nr_to_write = %ld ret = %d\n",
+			 "with nr_to_write = %ld ret = %d",
 			 __func__, wbc->nr_to_write, ret);

 	/* Update index */
diff -uprN orig/fs/ext4/super.c new/fs/ext4/super.c
--- orig/fs/ext4/super.c	2010-05-04 13:46:06.000000000 -0700
+++ new/fs/ext4/super.c	2010-05-04 13:49:18.000000000 -0700
@@ -3001,7 +3001,7 @@ no_journal:
 	err = ext4_setup_system_zone(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize system "
-			 "zone (%d)\n", err);
+			 "zone (%d)", err);
 		goto failed_mount4;
 	}
