From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] Fix buffer head reference leak in no-journal mode
Date: Thu, 9 Jul 2009 10:10:55 -0700
Message-ID: <6601abe90907091010u526b84afxdbb0ea00c4ab2fd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:1463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZGIRLA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jul 2009 13:11:00 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n69HAvfi015967
	for <linux-ext4@vger.kernel.org>; Thu, 9 Jul 2009 18:10:58 +0100
Received: from wf-out-1314.google.com (wfg23.prod.google.com [10.142.7.23])
	by zps36.corp.google.com with ESMTP id n69HAtM3014584
	for <linux-ext4@vger.kernel.org>; Thu, 9 Jul 2009 10:10:55 -0700
Received: by wf-out-1314.google.com with SMTP id 23so75366wfg.2
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jul 2009 10:10:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We found a problem with buffer head reference leaks when using an ext4
partition without a journal.  In particular, calls to ext4_forget() would
not to a brelse() on the input buffer head, which will cause pages they
belong to to not be reclaimable.

Further investigation showed that all places where ext4_journal_forget() and
ext4_journal_revoke() are called are subject to the same problem.  The patch
below changes __ext4_journal_forget/__ext4_journal_revoke to do an explicit
release of the buffer head when the journal handle isn't valid.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
diff -Naur orig/fs/ext4/ext4_jbd2.c new/fs/ext4/ext4_jbd2.c
--- orig/fs/ext4/ext4_jbd2.c	2009-07-09 09:51:41.000000000 -0700
+++ new/fs/ext4/ext4_jbd2.c	2009-07-09 09:52:10.000000000 -0700
@@ -43,6 +43,8 @@
 			ext4_journal_abort_handle(where, __func__, bh,
 						  handle, err);
 	}
+	else
+		brelse(bh);
 	return err;
 }

@@ -57,6 +59,8 @@
 			ext4_journal_abort_handle(where, __func__, bh,
 						  handle, err);
 	}
+	else
+		brelse(bh);
 	return err;
 }

diff -Naur orig/fs/ext4/ext4_jbd2.h new/fs/ext4/ext4_jbd2.h
--- orig/fs/ext4/ext4_jbd2.h	2009-07-09 09:51:41.000000000 -0700
+++ new/fs/ext4/ext4_jbd2.h	2009-07-09 09:52:10.000000000 -0700
@@ -131,9 +131,11 @@
 int __ext4_journal_get_write_access(const char *where, handle_t *handle,
 				struct buffer_head *bh);

+/* When called with an invalid handle, this will still do a put on the BH */
 int __ext4_journal_forget(const char *where, handle_t *handle,
 				struct buffer_head *bh);

+/* When called with an invalid handle, this will still do a put on the BH */
 int __ext4_journal_revoke(const char *where, handle_t *handle,
 				ext4_fsblk_t blocknr, struct buffer_head *bh);

diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2009-07-09 09:51:41.000000000 -0700
+++ new/fs/ext4/inode.c	2009-07-09 09:51:52.000000000 -0700
@@ -75,16 +75,14 @@
  * but there may still be a record of it in the journal, and that record
  * still needs to be revoked.
  *
- * If the handle isn't valid we're not journaling so there's nothing to do.
+ * If the handle isn't valid we're not journaling, but we still need to
+ * call into ext4_journal_revoke() to put the buffer head.
  */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 			struct buffer_head *bh, ext4_fsblk_t blocknr)
 {
 	int err;

-	if (!ext4_handle_valid(handle))
-		return 0;
