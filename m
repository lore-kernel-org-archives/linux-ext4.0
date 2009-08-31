From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ext4: fix cache flish in ext4_sync_file
Date: Mon, 31 Aug 2009 21:35:53 +0200
Message-ID: <20090831193553.GA2672@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44702 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbZHaTfv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 15:35:51 -0400
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id n7VJZrVL002778
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 21:35:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-7.2) id n7VJZrct002775
	for linux-ext4@vger.kernel.org; Mon, 31 Aug 2009 21:35:53 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to flush the write cache unconditionally in ->fsync, otherwise
writes into already allocated blocks can get lost.  Writes into fully
allocated files are very common when using disk images for
virtualization, and without this fix can easily lose data after
an fdatasync, which is the typical implementation for a cache flush on
the virtual drive.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ext4/fsync.c
===================================================================
--- linux-2.6.orig/fs/ext4/fsync.c
+++ linux-2.6/fs/ext4/fsync.c
@@ -92,9 +92,9 @@ int ext4_sync_file(struct file *file, st
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
-		if (journal && (journal->j_flags & JBD2_BARRIER))
-			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
+	if (journal && (journal->j_flags & JBD2_BARRIER))
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
 }
