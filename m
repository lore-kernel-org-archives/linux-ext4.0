From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: remove an unneeded NULL check
Date: Tue, 24 Jan 2012 11:41:09 +0300
Message-ID: <20120124084109.GC29097@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17175 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab2AXIlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jan 2012 03:41:16 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We dereference "bh" unconditionally a couple lines down to find
"by->b_size".  This function is never called with a NULL "bh" so I have
removed the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 164c560..a4a0234 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -91,17 +91,17 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 		return 0;
 
 	if (filp)
-		ext4_error_file(filp, function, line, bh ? bh->b_blocknr : 0,
+		ext4_error_file(filp, function, line, bh->b_blocknr,
 				"bad entry in directory: %s - offset=%u(%u), "
 				"inode=%u, rec_len=%d, name_len=%d",
-				error_msg, (unsigned) (offset%bh->b_size),
+				error_msg, (unsigned) (offset % bh->b_size),
 				offset, le32_to_cpu(de->inode),
 				rlen, de->name_len);
 	else
-		ext4_error_inode(dir, function, line, bh ? bh->b_blocknr : 0,
+		ext4_error_inode(dir, function, line, bh->b_blocknr,
 				"bad entry in directory: %s - offset=%u(%u), "
 				"inode=%u, rec_len=%d, name_len=%d",
-				error_msg, (unsigned) (offset%bh->b_size),
+				error_msg, (unsigned) (offset % bh->b_size),
 				offset, le32_to_cpu(de->inode),
 				rlen, de->name_len);
 
