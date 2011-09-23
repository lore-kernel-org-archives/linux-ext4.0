From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext2/xattr_security.c: local functions should be static
Date: Fri, 23 Sep 2011 13:51:24 -0700
Message-ID: <201109231351.24566.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <jack@suse.cz>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail209.messagelabs.com ([216.82.255.3]:4184 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1IWUvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 16:51:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This quiets the sparse noise:

warning: symbol 'ext2_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@suse.cz>

---

diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index c922adc..ed1a5d5 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -46,7 +46,7 @@ ext2_xattr_security_set(struct dentry *dentry, const char *name,
 			      value, size, flags);
 }
 
-int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		    void *fs_info)
 {
 	const struct xattr *xattr;
