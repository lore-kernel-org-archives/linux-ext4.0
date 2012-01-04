From: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH] ext4: make local symbol ext4_initxattrs static
Date: Wed, 4 Jan 2012 14:51:20 +0100
Message-ID: <20120104135120.GA12859@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:49291 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab2ADNsR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 08:48:17 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_initxattrs symbol is used only in this file, so it should be
declared static.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/ext4/xattr_security.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
index 34e4350..e247f8b 100644
--- a/fs/ext4/xattr_security.c
+++ b/fs/ext4/xattr_security.c
@@ -48,8 +48,9 @@ ext4_xattr_security_set(struct dentry *dentry, const char *name,
 			      name, value, size, flags);
 }
 
-int ext4_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		    void *fs_info)
+static int
+ext4_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		void *fs_info)
 {
 	const struct xattr *xattr;
 	handle_t *handle = fs_info;
-- 
1.7.1
