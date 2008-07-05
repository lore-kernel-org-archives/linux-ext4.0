From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 37/52] vfs: export filemap_fdatawrite_range()
Date: Sat,  5 Jul 2008 13:36:03 -0400
Message-ID: <1215279378-30504-38-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33025 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753964AbYGERg2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:28 -0400
In-Reply-To: <1215279378-30504-37-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Make filemap_fdatawrite_range() function public, so that it can later
be used in ordered mode rewrite by JBD/JBD2.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 ++
 mm/filemap.c       |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d490779..d06f8e2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1741,6 +1741,8 @@ extern int wait_on_page_writeback_range(struct address_space *mapping,
 				pgoff_t start, pgoff_t end);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end, int sync_mode);
+extern int filemap_fdatawrite_range(struct address_space *mapping,
+				loff_t start, loff_t end);
 
 extern long do_fsync(struct file *file, int datasync);
 extern void sync_supers(void);
diff --git a/mm/filemap.c b/mm/filemap.c
index 1e6a7d3..65d9d9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -236,11 +236,12 @@ int filemap_fdatawrite(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_fdatawrite);
 
-static int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
+int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 				loff_t end)
 {
 	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
 }
+EXPORT_SYMBOL(filemap_fdatawrite_range);
 
 /**
  * filemap_flush - mostly a non-blocking flush
-- 
1.5.6.rc3.1.g36b7.dirty

