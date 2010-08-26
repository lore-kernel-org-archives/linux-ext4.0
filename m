From: Dan Carpenter <error27@gmail.com>
Subject: [patch] ext4: checking NULL instead of ERR_PTR
Date: Thu, 26 Aug 2010 11:16:54 +0200
Message-ID: <20100826091619.GC20072@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Eric Sandeen <sandeen@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51352 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab0HZJRN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 05:17:13 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

d_path() returns an ERR_PTR and it doesn't return NULL.  This is in
ext4_error_file() and no one actually calls ext4_error_file().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..efaa27e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -429,7 +429,7 @@ void ext4_error_file(struct file *file, const char *function,
 	save_error_info(inode->i_sb, function, line);
 	va_start(args, fmt);
 	path = d_path(&(file->f_path), pathname, sizeof(pathname));
-	if (!path)
+	if (IS_ERR(path))
 		path = "(unknown)";
 	printk(KERN_CRIT
 	       "EXT4-fs error (device %s): %s:%d: inode #%lu "
