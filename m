From: Jan Kara <jack@suse.cz>
Subject: [PATCH] vfs: export filemap_fdatawrite_range()
Date: Wed, 4 Jun 2008 17:54:31 +0200
Message-ID: <20080604155431.GG16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46400 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409AbYFDPyc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 11:54:32 -0400
Received: from duck.suse.cz (duck.suse.cz [10.20.1.74])
	by mail.suse.cz (Postfix) with ESMTP id 682C362808B
	for <linux-ext4@vger.kernel.org>; Wed,  4 Jun 2008 17:54:31 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this is just a trivial export needed for ordered mode rewrite.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

From: Jan Kara <jack@suse.cz>
Date: Wed, 21 May 2008 17:05:23 +0200
Subject: [PATCH] vfs: export filemap_fdatawrite_range()

Make filemap_fdatawrite_range() function public, so that it can later
be used in ordered mode rewrite by JBD/JBD2.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 ++
 mm/filemap.c       |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

Index: linux-2.6-linus/include/linux/fs.h
===================================================================
--- linux-2.6-linus.orig/include/linux/fs.h
+++ linux-2.6-linus/include/linux/fs.h
@@ -1741,6 +1741,8 @@ extern int wait_on_page_writeback_range(
 				pgoff_t start, pgoff_t end);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end, int sync_mode);
+extern int filemap_fdatawrite_range(struct address_space *mapping,
+				loff_t start, loff_t end);
 
 extern long do_fsync(struct file *file, int datasync);
 extern void sync_supers(void);
Index: linux-2.6-linus/mm/filemap.c
===================================================================
--- linux-2.6-linus.orig/mm/filemap.c
+++ linux-2.6-linus/mm/filemap.c
@@ -236,11 +236,12 @@ int filemap_fdatawrite(struct address_sp
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
