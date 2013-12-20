From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/21] reiserfs: prefix ACL symbols with reiserfs_
Date: Fri, 20 Dec 2013 05:16:36 -0800
Message-ID: <20131220132521.164507154@bombadil.infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com,
 Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>,
 reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
 Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline;
 filename=0001-reiserfs-prefix-ACL-symbols-with-reiserfs_.patch
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/xattr_acl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 06c04f7..6f721ea 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -16,7 +16,7 @@ static int reiserfs_set_acl(struct reiserfs_transaction_handle *th,
 			    struct posix_acl *acl);
 
 static int
-posix_acl_set(struct dentry *dentry, const char *name, const void *value,
+reiserfs_posix_acl_set(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags, int type)
 {
 	struct inode *inode = dentry->d_inode;
@@ -65,7 +65,7 @@ posix_acl_set(struct dentry *dentry, const char *name, const void *value,
 }
 
 static int
-posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
+reiserfs_posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
 		size_t size, int type)
 {
 	struct posix_acl *acl;
@@ -88,7 +88,7 @@ posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
 /*
  * Convert from filesystem to in-memory representation.
  */
-static struct posix_acl *posix_acl_from_disk(const void *value, size_t size)
+static struct posix_acl *reiserfs_posix_acl_from_disk(const void *value, size_t size)
 {
 	const char *end = (char *)value + size;
 	int n, count;
@@ -158,7 +158,7 @@ static struct posix_acl *posix_acl_from_disk(const void *value, size_t size)
 /*
  * Convert from in-memory to filesystem representation.
  */
-static void *posix_acl_to_disk(const struct posix_acl *acl, size_t * size)
+static void *reiserfs_posix_acl_to_disk(const struct posix_acl *acl, size_t * size)
 {
 	reiserfs_acl_header *ext_acl;
 	char *e;
@@ -257,7 +257,7 @@ struct posix_acl *reiserfs_get_acl(struct inode *inode, int type)
 	} else if (retval < 0) {
 		acl = ERR_PTR(retval);
 	} else {
-		acl = posix_acl_from_disk(value, retval);
+		acl = reiserfs_posix_acl_from_disk(value, retval);
 	}
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
@@ -307,7 +307,7 @@ reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
 	}
 
 	if (acl) {
-		value = posix_acl_to_disk(acl, &size);
+		value = reiserfs_posix_acl_to_disk(acl, &size);
 		if (IS_ERR(value))
 			return (int)PTR_ERR(value);
 	}
@@ -499,8 +499,8 @@ static size_t posix_acl_access_list(struct dentry *dentry, char *list,
 const struct xattr_handler reiserfs_posix_acl_access_handler = {
 	.prefix = POSIX_ACL_XATTR_ACCESS,
 	.flags = ACL_TYPE_ACCESS,
-	.get = posix_acl_get,
-	.set = posix_acl_set,
+	.get = reiserfs_posix_acl_get,
+	.set = reiserfs_posix_acl_set,
 	.list = posix_acl_access_list,
 };
 
@@ -519,7 +519,7 @@ static size_t posix_acl_default_list(struct dentry *dentry, char *list,
 const struct xattr_handler reiserfs_posix_acl_default_handler = {
 	.prefix = POSIX_ACL_XATTR_DEFAULT,
 	.flags = ACL_TYPE_DEFAULT,
-	.get = posix_acl_get,
-	.set = posix_acl_set,
+	.get = reiserfs_posix_acl_get,
+	.set = reiserfs_posix_acl_set,
 	.list = posix_acl_default_list,
 };
-- 
1.7.10.4



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
