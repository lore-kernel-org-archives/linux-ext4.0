From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext3/xattr_seciruty.c: local functions should be static
Date: Fri, 23 Sep 2011 15:07:09 -0700
Message-ID: <201109231507.09998.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
	<akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail132.messagelabs.com ([216.82.242.115]:8271 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1IWWHW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 18:07:22 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quiets the sparse noise:

warning: symbol 'ext3_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 3c218b8..3f065f8 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -48,7 +48,7 @@ ext3_xattr_security_set(struct dentry *dentry, const char *name,
 			      name, value, size, flags);
 }
 
-int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		    void *fs_info)
 {
 	const struct xattr *xattr;
