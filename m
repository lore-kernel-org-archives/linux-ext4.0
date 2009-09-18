From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 2/2] ext4: Handle nested ext4_journal_start/stop calls
	without a journal
Date: Fri, 18 Sep 2009 14:33:04 -0700
Message-ID: <6601abe90909181433l67e7764w6416ae5975b78c3f@mail.gmail.com>
References: <6601abe90909171455g597fe672g1ca6d426e609f937@mail.gmail.com>
	 <20090918055010.GN2537@webber.adilger.int>
	 <6601abe90909181133g27458301nb3aae756e473541c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:25121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZIRVdG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 17:33:06 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id n8ILX7qi030859
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 22:33:08 +0100
Received: from pzk42 (pzk42.prod.google.com [10.243.19.170])
	by wpaz33.hot.corp.google.com with ESMTP id n8ILX4vR020876
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 14:33:05 -0700
Received: by pzk42 with SMTP id 42so476587pzk.31
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 14:33:04 -0700 (PDT)
In-Reply-To: <6601abe90909181133g27458301nb3aae756e473541c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's version 2, thanks to Andreas' suggestion.

Curt


This patch fixes a problem with handling nested calls to
ext4_journal_start/ext4_journal_stop, when there is no journal present.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

Taking Andreas' suggestion, what I'm calling "an allocated handle that
doesn't use a journal" is now identified by a value in the range

   [1, 4095]

A handle with value 0 (NULL) still represents "an unallocated handle."

I added a comment atop ext4_handle_valid() to indicate that sending it a
NULL pointer was just wrong.

diff -uprN orig/fs/ext4/ext4_jbd2.h new/fs/ext4/ext4_jbd2.h
--- orig/fs/ext4/ext4_jbd2.h	2009-09-18 14:04:15.000000000 -0700
+++ new/fs/ext4/ext4_jbd2.h	2009-09-18 14:17:31.000000000 -0700
@@ -161,11 +161,13 @@ int __ext4_handle_dirty_metadata(const c
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);

-#define EXT4_NOJOURNAL_HANDLE	((handle_t *) 0x1)
+#define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)

+/* Note:  Do not use this for NULL handles.  This is only to determine if
+ * a properly allocated handle is using a journal or not. */
 static inline int ext4_handle_valid(handle_t *handle)
 {
-	if (handle == EXT4_NOJOURNAL_HANDLE)
+	if ((unsigned long)handle < EXT4_NOJOURNAL_MAX_REF_COUNT)
 		return 0;
 	return 1;
 }
diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2009-09-18 14:04:15.000000000 -0700
+++ new/fs/ext4/inode.c	2009-09-18 14:17:31.000000000 -0700
@@ -4931,12 +4931,14 @@ int ext4_write_inode(struct inode *inode
 		err = ext4_force_commit(inode->i_sb);
 	} else {
 		struct ext4_iloc iloc;
+		handle_t *handle = ext4_journal_start(inode, 1);

 		err = ext4_get_inode_loc(inode, &iloc);
 		if (err)
 			return err;
-		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
-					   inode, &iloc, wait);
+		err = ext4_do_update_inode(handle, inode, &iloc, wait);
+
+		ext4_journal_stop(handle);
 	}
 	return err;
 }
diff -uprN orig/fs/ext4/namei.c new/fs/ext4/namei.c
--- orig/fs/ext4/namei.c	2009-09-18 14:04:15.000000000 -0700
+++ new/fs/ext4/namei.c	2009-09-18 14:17:31.000000000 -0700
@@ -2076,7 +2076,8 @@ int ext4_orphan_del(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0;

-	if (!ext4_handle_valid(handle))
+	/* ext4_handle_valid() assumes a valid handle_t pointer */
+	if (handle && !ext4_handle_valid(handle))
 		return 0;

 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
diff -uprN orig/fs/ext4/super.c new/fs/ext4/super.c
--- orig/fs/ext4/super.c	2009-09-18 14:04:15.000000000 -0700
+++ new/fs/ext4/super.c	2009-09-18 14:17:31.000000000 -0700
@@ -198,6 +198,36 @@ void ext4_itable_unused_set(struct super
 		bg->bg_itable_unused_hi = cpu_to_le16(count >> 16);
 }

+
+/* Just increment the non-pointer handle value */
+static handle_t *ext4_get_nojournal(void)
+{
+	handle_t *handle = current->journal_info;
+	unsigned long ref_cnt = (unsigned long)handle;
+
+	BUG_ON(ref_cnt >= EXT4_NOJOURNAL_MAX_REF_COUNT);
+
+	ref_cnt++;
+	handle = (handle_t *)ref_cnt;
+
+	current->journal_info = handle;
+	return handle;
+}
+
+
+/* Decrement the non-pointer handle value */
+static void ext4_put_nojournal(handle_t *handle)
+{
+	unsigned long ref_cnt = (unsigned long)handle;
+
+	BUG_ON(ref_cnt == 0);
+
+	ref_cnt--;
+	handle = (handle_t *)ref_cnt;
+
+	current->journal_info = handle;
+}
+
 /*
  * Wrappers for jbd2_journal_start/end.
  *
@@ -224,11 +254,7 @@ handle_t *ext4_journal_start_sb(struct s
 		}
 		return jbd2_journal_start(journal, nblocks);
 	}
-	/*
-	 * We're not journaling, return the appropriate indication.
-	 */
-	current->journal_info = EXT4_NOJOURNAL_HANDLE;
-	return current->journal_info;
+	return ext4_get_nojournal();
 }

 /*
@@ -244,11 +270,7 @@ int __ext4_journal_stop(const char *wher
 	int rc;

 	if (!ext4_handle_valid(handle)) {
-		/*
-		 * Do this here since we don't call jbd2_journal_stop() in
-		 * no-journal mode.
-		 */
-		current->journal_info = NULL;
+		ext4_put_nojournal(handle);
 		return 0;
 	}
 	sb = handle->h_transaction->t_journal->j_private;
