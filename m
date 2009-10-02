From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: fix ext4_dirty_inode() compile warning
Date: Fri, 2 Oct 2009 09:22:18 -0700
Message-ID: <6601abe90910020922g4e6a59e7mcc4eeda5cd7b4d1f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:6489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbZJBQWT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 12:22:19 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id n92GMLxl028691
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 09:22:22 -0700
Received: from pxi4 (pxi4.prod.google.com [10.243.27.4])
	by wpaz13.hot.corp.google.com with ESMTP id n92GMJRq027272
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 09:22:19 -0700
Received: by pxi4 with SMTP id 4so1301281pxi.23
        for <linux-ext4@vger.kernel.org>; Fri, 02 Oct 2009 09:22:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

Apparently my patch for

   ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode

didn't play well if CONFIG_JBD_DEBUG wasn't defined.

Here are two patches that fix it.  I don't know if the jbd_debug() call has
any importance or not; you can choose which is better perhaps?

Thanks,
Curt

==============================================

Remove jbd_debug() call from ext4_inode_dirty()

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>

--- fs/ext4/inode.c.orig	2009-10-02 09:04:36.000000000 -0700
+++ fs/ext4/inode.c	2009-10-02 09:05:31.000000000 -0700
@@ -5851,14 +5851,12 @@ int ext4_mark_inode_dirty(handle_t *hand
  */
 void ext4_dirty_inode(struct inode *inode)
 {
-	handle_t *current_handle = ext4_journal_current_handle();
 	handle_t *handle;

 	handle = ext4_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;

-	jbd_debug(5, "marking dirty.  outer handle=%p\n", current_handle);
 	ext4_mark_inode_dirty(handle, inode);

 	ext4_journal_stop(handle);

==============================================

Make sure ext4_inode_dirty() compiles if CONFIG_JBD_DEBUG is not defined.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>

--- fs/ext4/inode.c.orig	2009-10-02 09:04:36.000000000 -0700
+++ fs/ext4/inode.c	2009-10-02 09:07:31.000000000 -0700
@@ -5851,7 +5851,9 @@ int ext4_mark_inode_dirty(handle_t *hand
  */
 void ext4_dirty_inode(struct inode *inode)
 {
+#ifdef CONFIG_JBD_DEBUG
 	handle_t *current_handle = ext4_journal_current_handle();
+#endif
 	handle_t *handle;

 	handle = ext4_journal_start(inode, 2);
