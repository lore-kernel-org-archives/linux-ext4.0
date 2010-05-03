From: Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 10/39] whiteout: Split of ext2_append_link() from ext2_add_link()
Date: Mon,  3 May 2010 16:12:09 -0700
Message-ID: <1272928358-20854-11-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Jan Blunck <jblunck@suse.de>,
	Valerie Aurora <vaurora@redhat.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

The ext2_append_link() is later used to find or append a directory
entry to whiteout.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/dir.c |   70 ++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 7516957..57207a9 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -472,9 +472,10 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 }
 
 /*
- *	Parent is locked.
+ * Find or append a given dentry to the parent directory
  */
-int ext2_add_link (struct dentry *dentry, struct inode *inode)
+static ext2_dirent * ext2_append_entry(struct dentry * dentry,
+				       struct page ** page)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	const char *name = dentry->d_name.name;
@@ -482,13 +483,10 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 	unsigned chunk_size = ext2_chunk_size(dir);
 	unsigned reclen = EXT2_DIR_REC_LEN(namelen);
 	unsigned short rec_len, name_len;
-	struct page *page = NULL;
-	ext2_dirent * de;
+	ext2_dirent * de = NULL;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	loff_t pos;
-	int err;
 
 	/*
 	 * We take care of directory expansion in the same loop.
@@ -498,20 +496,19 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 	for (n = 0; n <= npages; n++) {
 		char *dir_end;
 
-		page = ext2_get_page(dir, n, 0);
-		err = PTR_ERR(page);
-		if (IS_ERR(page))
+		*page = ext2_get_page(dir, n, 0);
+		de = ERR_PTR(PTR_ERR(*page));
+		if (IS_ERR(*page))
 			goto out;
-		lock_page(page);
-		kaddr = page_address(page);
+		lock_page(*page);
+		kaddr = page_address(*page);
 		dir_end = kaddr + ext2_last_byte(dir, n);
 		de = (ext2_dirent *)kaddr;
 		kaddr += PAGE_CACHE_SIZE - reclen;
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
-				name_len = 0;
-				rec_len = chunk_size;
+				de->name_len = 0;
 				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
 				goto got_it;
@@ -519,12 +516,11 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 			if (de->rec_len == 0) {
 				ext2_error(dir->i_sb, __func__,
 					"zero-length directory entry");
-				err = -EIO;
+				de = ERR_PTR(-EIO);
 				goto out_unlock;
 			}
-			err = -EEXIST;
 			if (ext2_match (namelen, name, de))
-				goto out_unlock;
+				goto got_it;
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
 			rec_len = ext2_rec_len_from_disk(de->rec_len);
 			if (!de->inode && rec_len >= reclen)
@@ -533,13 +529,48 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 				goto got_it;
 			de = (ext2_dirent *) ((char *) de + rec_len);
 		}
-		unlock_page(page);
-		ext2_put_page(page);
+		unlock_page(*page);
+		ext2_put_page(*page);
 	}
+
 	BUG();
-	return -EINVAL;
 
 got_it:
+	return de;
+	/* OFFSET_CACHE */
+out_unlock:
+	unlock_page(*page);
+	ext2_put_page(*page);
+out:
+	return de;
+}
+
+/*
+ *	Parent is locked.
+ */
+int ext2_add_link (struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned short rec_len, name_len;
+	ext2_dirent * de;
+	struct page *page;
+	loff_t pos;
+	int err;
+
+	de = ext2_append_entry(dentry, &page);
+	if (IS_ERR(de))
+		return PTR_ERR(de);
+
+	err = -EEXIST;
+	if (ext2_match (namelen, name, de))
+		goto out_unlock;
+
+got_it:
+	name_len = EXT2_DIR_REC_LEN(de->name_len);
+	rec_len = ext2_rec_len_from_disk(de->rec_len);
+
 	pos = page_offset(page) +
 		(char*)de - (char*)page_address(page);
 	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
@@ -563,7 +594,6 @@ got_it:
 	/* OFFSET_CACHE */
 out_put:
 	ext2_put_page(page);
-out:
 	return err;
 out_unlock:
 	unlock_page(page);
-- 
1.6.3.3

