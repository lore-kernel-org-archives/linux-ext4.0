From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [2.6 patch] make ext3_xattr_list() static
Date: Fri, 29 Feb 2008 11:23:18 -0800
Message-ID: <1204312998.12826.1.camel@localhost.localdomain>
References: <20080227212051.GN29269@cs181133002.pp.htv.fi>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53102 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYB2TYa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 14:24:30 -0500
In-Reply-To: <20080227212051.GN29269@cs181133002.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-02-27 at 23:20 +0200, Adrian Bunk wrote:
> This patch makes the needlessly global ext3_xattr_list() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

ext4 version.


ext4: make ext4_xattr_list() static

From: Mingming Cao <cmm@us.ibm.com>

This patch makes the needlessly global ext4_xattr_list() static.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---

 fs/ext4/xattr.c |    4 +++-
 fs/ext4/xattr.h |    7 -------
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -99,6 +99,8 @@ static struct buffer_head *ext4_xattr_cache_find(struct inode *,
 						 struct mb_cache_entry **);
 static void ext4_xattr_rehash(struct ext4_xattr_header *,
 			      struct ext4_xattr_entry *);
+static int ext4_xattr_list(struct inode *inode, char *buffer,
+			   size_t buffer_size);

 static struct mb_cache *ext4_xattr_cache;

@@ -427,7 +429,7 @@ cleanup:
  * Returns a negative error number on failure, or the number of bytes
  * used / required on success.
  */
-int
+static int
 ext4_xattr_list(struct inode *inode, char *buffer, size_t buffer_size)
 {
 	int i_error, b_error;
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 6b1ae1c..148a4df 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -67,7 +67,6 @@ extern struct xattr_handler ext4_xattr_security_handler;
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);

 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ext4_xattr_list(struct inode *, char *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);

@@ -89,12 +88,6 @@ ext4_xattr_get(struct inode *inode, int name_index, const char *name,
 }

 static inline int
-ext4_xattr_list(struct inode *inode, void *buffer, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int
 ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	       const void *value, size_t size, int flags)
 {
