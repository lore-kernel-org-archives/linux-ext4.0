From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make ext3_xattr_list() static
Date: Wed, 27 Feb 2008 23:20:51 +0200
Message-ID: <20080227212051.GN29269@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49156 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760330AbYB0VWB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:01 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch makes the needlessly global ext3_xattr_list() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ext3/xattr.c |    4 +++-
 fs/ext3/xattr.h |    7 -------
 2 files changed, 3 insertions(+), 8 deletions(-)

8fb5e610acafcbef4a9980042902c9269abf51b6 diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index fb89c29..4f9f187 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -99,6 +99,8 @@ static struct buffer_head *ext3_xattr_cache_find(struct inode *,
 						 struct mb_cache_entry **);
 static void ext3_xattr_rehash(struct ext3_xattr_header *,
 			      struct ext3_xattr_entry *);
+static int ext3_xattr_list(struct inode *inode, char *buffer,
+			   size_t buffer_size);
 
 static struct mb_cache *ext3_xattr_cache;
 
@@ -427,7 +429,7 @@ cleanup:
  * Returns a negative error number on failure, or the number of bytes
  * used / required on success.
  */
-int
+static int
 ext3_xattr_list(struct inode *inode, char *buffer, size_t buffer_size)
 {
 	int i_error, b_error;
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
index 6b1ae1c..148a4df 100644
--- a/fs/ext3/xattr.h
+++ b/fs/ext3/xattr.h
@@ -67,7 +67,6 @@ extern struct xattr_handler ext3_xattr_security_handler;
 extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
 
 extern int ext3_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ext3_xattr_list(struct inode *, char *, size_t);
 extern int ext3_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext3_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
 
@@ -89,12 +88,6 @@ ext3_xattr_get(struct inode *inode, int name_index, const char *name,
 }
 
 static inline int
-ext3_xattr_list(struct inode *inode, void *buffer, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int
 ext3_xattr_set(struct inode *inode, int name_index, const char *name,
 	       const void *value, size_t size, int flags)
 {
