From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 18/24] ubifs: switch to fscrypt_get_symlink()
Date: Fri, 15 Dec 2017 09:42:19 -0800
Message-ID: <20171215174225.31583-19-ebiggers3@gmail.com>
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
 fs/ubifs/file.c | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index dfe85069586e..3cfc578c42ea 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1662,49 +1662,17 @@ static const char *ubifs_get_link(struct dentry *dentry,
 					    struct inode *inode,
 					    struct delayed_call *done)
 {
-	int err;
-	struct fscrypt_symlink_data *sd;
 	struct ubifs_inode *ui = ubifs_inode(inode);
-	struct fscrypt_str cstr;
-	struct fscrypt_str pstr;
 
-	if (!ubifs_crypt_is_encrypted(inode))
+	if (!IS_ENCRYPTED(inode))
 		return ui->data;
 
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
-	err = fscrypt_get_encryption_info(inode);
-	if (err)
-		return ERR_PTR(err);
-
-	sd = (struct fscrypt_symlink_data *)ui->data;
-	cstr.name = sd->encrypted_path;
-	cstr.len = le16_to_cpu(sd->len);
-
-	if (cstr.len == 0)
-		return ERR_PTR(-ENOENT);
-
-	if ((cstr.len + sizeof(struct fscrypt_symlink_data) - 1) > ui->data_len)
-		return ERR_PTR(-EIO);
-
-	err = fscrypt_fname_alloc_buffer(inode, cstr.len, &pstr);
-	if (err)
-		return ERR_PTR(err);
-
-	err = fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
-	if (err) {
-		fscrypt_fname_free_buffer(&pstr);
-		return ERR_PTR(err);
-	}
-
-	pstr.name[pstr.len] = '\0';
-
-	set_delayed_call(done, kfree_link, pstr.name);
-	return pstr.name;
+	return fscrypt_get_symlink(inode, ui->data, ui->data_len, done);
 }
 
-
 const struct address_space_operations ubifs_file_address_operations = {
 	.readpage       = ubifs_readpage,
 	.writepage      = ubifs_writepage,
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
