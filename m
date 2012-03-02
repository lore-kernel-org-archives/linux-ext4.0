From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Add comments to definition of ext4_io_end_t
Date: Fri,  2 Mar 2012 08:43:45 -0800
Message-ID: <1330706625-24701-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:35897 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab2CBQtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 11:49:04 -0500
Received: by faaa19 with SMTP id a19so72217faa.1
        for <linux-ext4@vger.kernel.org>; Fri, 02 Mar 2012 08:49:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This should make it more clear what this structure is used
for, and how some of the (mutually exclusive) fields are
used to keep page cache references.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/ext4.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..4dc34ed 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -192,18 +192,25 @@ struct ext4_io_page {
 
 #define MAX_IO_PAGES 128
 
+/*
+ * For converting uninitialized extents on a work queue.
+ *
+ * 'page' is only used from the writepage() path; 'pages' is only used for
+ * buffered writes; they are used to keep page references until conversion
+ * takes place.  For AIO/DIO, neither field is filled in.
+ */
 typedef struct ext4_io_end {
 	struct list_head	list;		/* per-file finished IO list */
 	struct inode		*inode;		/* file being written to */
 	unsigned int		flag;		/* unwritten or not */
-	struct page		*page;		/* page struct for buffer write */
+	struct page		*page;		/* for writepage() path */
 	loff_t			offset;		/* offset in the file */
 	ssize_t			size;		/* size of the extent */
 	struct work_struct	work;		/* data work queue */
 	struct kiocb		*iocb;		/* iocb struct for AIO */
 	int			result;		/* error value for AIO */
-	int			num_io_pages;
-	struct ext4_io_page	*pages[MAX_IO_PAGES];
+	int			num_io_pages;   /* for writepages() */
+	struct ext4_io_page	*pages[MAX_IO_PAGES]; /* for writepages() */
 } ext4_io_end_t;
 
 struct ext4_io_submit {
-- 
1.7.7.3

