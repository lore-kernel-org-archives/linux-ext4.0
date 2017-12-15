From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 13/24] ext4: switch to fscrypt_get_symlink()
Date: Fri, 15 Dec 2017 09:42:14 -0800
Message-ID: <20171215174225.31583-14-ebiggers3@gmail.com>
References: <20171215174225.31583-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20171215174225.31583-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/symlink.c | 43 ++++++-------------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index a2006c9af1d9..dd05af983092 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -28,59 +28,28 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 					   struct delayed_call *done)
 {
 	struct page *cpage = NULL;
-	char *caddr, *paddr = NULL;
-	struct fscrypt_str cstr, pstr;
-	struct fscrypt_symlink_data *sd;
-	int res;
-	u32 max_size = inode->i_sb->s_blocksize;
+	const void *caddr;
+	unsigned int max_size;
+	const char *paddr;
 
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
-	res = fscrypt_get_encryption_info(inode);
-	if (res)
-		return ERR_PTR(res);
-
 	if (ext4_inode_is_fast_symlink(inode)) {
-		caddr = (char *) EXT4_I(inode)->i_data;
+		caddr = EXT4_I(inode)->i_data;
 		max_size = sizeof(EXT4_I(inode)->i_data);
 	} else {
 		cpage = read_mapping_page(inode->i_mapping, 0, NULL);
 		if (IS_ERR(cpage))
 			return ERR_CAST(cpage);
 		caddr = page_address(cpage);
+		max_size = inode->i_sb->s_blocksize;
 	}
 
-	/* Symlink is encrypted */
-	sd = (struct fscrypt_symlink_data *)caddr;
-	cstr.name = sd->encrypted_path;
-	cstr.len  = le16_to_cpu(sd->len);
-	if ((cstr.len + sizeof(struct fscrypt_symlink_data) - 1) > max_size) {
-		/* Symlink data on the disk is corrupted */
-		res = -EFSCORRUPTED;
-		goto errout;
-	}
-
-	res = fscrypt_fname_alloc_buffer(inode, cstr.len, &pstr);
-	if (res)
-		goto errout;
-	paddr = pstr.name;
-
-	res = fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
-	if (res)
-		goto errout;
-
-	/* Null-terminate the name */
-	paddr[pstr.len] = '\0';
+	paddr = fscrypt_get_symlink(inode, caddr, max_size, done);
 	if (cpage)
 		put_page(cpage);
-	set_delayed_call(done, kfree_link, paddr);
 	return paddr;
-errout:
-	if (cpage)
-		put_page(cpage);
-	kfree(paddr);
-	return ERR_PTR(res);
 }
 
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
