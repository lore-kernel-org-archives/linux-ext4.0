From: Jin Qian <jinqian@android.com>
Subject: [PATCH 1/1] ext4: don't put symlink in pagecache into highmem
Date: Mon,  5 Feb 2018 11:57:39 -0800
Message-ID: <20180205195739.9654-1-jinqian@android.com>
Cc: Jin Qian <jinqian@google.com>, stable@vger.kernel.org,
        Jin Qian <jinqian@android.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jin Qian <jinqian@google.com>

partial backport of 21fc61c73c3903c4c312d0802da01ec2b323d174.

ext4_encrypted_follow_link uses kmap() for cpage
  caddr = kmap(cpage);

_ext4_fname_disk_to_usr calls virt_to_page on the kmapped address.
  _ext4_fname_disk_to_usr()
    ext4_fname_decrypt()
      sg_init_one()
        sg_init_one(&src_sg, iname->name, iname->len);
          sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jin Qian <jinqian@android.com>
---
 fs/ext4/inode.c    |  1 +
 fs/ext4/namei.c    |  1 +
 fs/ext4/symlink.c  | 10 +++-------
 fs/inode.c         |  6 ++++++
 include/linux/fs.h |  1 +
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4df1cb19a243..f0cabc8c96cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4417,6 +4417,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			inode->i_op = &ext4_symlink_inode_operations;
 			ext4_set_aops(inode);
 		}
+		inode_nohighmem(inode);
 	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
 	      S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &ext4_special_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4c36dca486cc..32960b3ecd4f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3151,6 +3151,7 @@ static int ext4_symlink(struct inode *dir,
 	if ((disk_link.len > EXT4_N_BLOCKS * 4)) {
 		if (!encryption_required)
 			inode->i_op = &ext4_symlink_inode_operations;
+		inode_nohighmem(inode);
 		ext4_set_aops(inode);
 		/*
 		 * We cannot call page_symlink() with transaction started
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index e8e7af62ac95..287c3980fa0b 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -45,7 +45,7 @@ static const char *ext4_encrypted_follow_link(struct dentry *dentry, void **cook
 		cpage = read_mapping_page(inode->i_mapping, 0, NULL);
 		if (IS_ERR(cpage))
 			return ERR_CAST(cpage);
-		caddr = kmap(cpage);
+		caddr = page_address(cpage);
 		caddr[size] = 0;
 	}
 
@@ -75,16 +75,12 @@ static const char *ext4_encrypted_follow_link(struct dentry *dentry, void **cook
 	/* Null-terminate the name */
 	if (res <= plen)
 		paddr[res] = '\0';
-	if (cpage) {
-		kunmap(cpage);
+	if (cpage)
 		page_cache_release(cpage);
-	}
 	return *cookie = paddr;
 errout:
-	if (cpage) {
-		kunmap(cpage);
+	if (cpage)
 		page_cache_release(cpage);
-	}
 	kfree(paddr);
 	return ERR_PTR(res);
 }
diff --git a/fs/inode.c b/fs/inode.c
index b0edef500590..b95615f3fc50 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2028,3 +2028,9 @@ void inode_set_flags(struct inode *inode, unsigned int flags,
 				  new_flags) != old_flags));
 }
 EXPORT_SYMBOL(inode_set_flags);
+
+void inode_nohighmem(struct inode *inode)
+{
+	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
+}
+EXPORT_SYMBOL(inode_nohighmem);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c8decb7075d6..f746a59fcc88 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3066,5 +3066,6 @@ static inline bool dir_relax(struct inode *inode)
 }
 
 extern bool path_noexec(const struct path *path);
+extern void inode_nohighmem(struct inode *inode);
 
 #endif /* _LINUX_FS_H */
-- 
2.16.0.rc1.238.g530d649a79-goog
