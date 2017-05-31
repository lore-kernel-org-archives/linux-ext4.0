From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 17/17] fs: convert ext2 to use write_one_page_since
Date: Wed, 31 May 2017 08:45:40 -0400
Message-ID: <20170531124540.8782-18-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sample the wb_err before changing the directory, so that we can catch
errors that occur since that point.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext2/dir.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 6e476c9929f8..073f096ac5e6 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -85,7 +85,8 @@ ext2_last_byte(struct inode *inode, unsigned long page_nr)
 	return last_byte;
 }
 
-static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len,
+				errseq_t since)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
@@ -100,7 +101,7 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	}
 
 	if (IS_DIRSYNC(dir)) {
-		err = write_one_page(page);
+		err = write_one_page_since(page, since);
 		if (!err)
 			err = sync_inode_metadata(dir, 1);
 	} else {
@@ -462,13 +463,14 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 			(char *) de - (char *) page_address(page);
 	unsigned len = ext2_rec_len_from_disk(de->rec_len);
 	int err;
+	errseq_t since = filemap_sample_wb_err(dir->i_mapping);
 
 	lock_page(page);
 	err = ext2_prepare_chunk(page, pos, len);
 	BUG_ON(err);
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type(de, inode);
-	err = ext2_commit_chunk(page, pos, len);
+	err = ext2_commit_chunk(page, pos, len, since);
 	ext2_put_page(page);
 	if (update_times)
 		dir->i_mtime = dir->i_ctime = current_time(dir);
@@ -494,6 +496,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 	char *kaddr;
 	loff_t pos;
 	int err;
+	errseq_t since = filemap_sample_wb_err(dir->i_mapping);
 
 	/*
 	 * We take care of directory expansion in the same loop.
@@ -560,7 +563,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type (de, inode);
-	err = ext2_commit_chunk(page, pos, rec_len);
+	err = ext2_commit_chunk(page, pos, rec_len, since);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
@@ -589,6 +592,7 @@ int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
 	ext2_dirent * pde = NULL;
 	ext2_dirent * de = (ext2_dirent *) (kaddr + from);
 	int err;
+	errseq_t since = filemap_sample_wb_err(inode->i_mapping);
 
 	while ((char*)de < (char*)dir) {
 		if (de->rec_len == 0) {
@@ -609,7 +613,7 @@ int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
 	if (pde)
 		pde->rec_len = ext2_rec_len_to_disk(to - from);
 	dir->inode = 0;
-	err = ext2_commit_chunk(page, pos, to - from);
+	err = ext2_commit_chunk(page, pos, to - from, since);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	EXT2_I(inode)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(inode);
@@ -628,6 +632,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 	struct ext2_dir_entry_2 * de;
 	int err;
 	void *kaddr;
+	errseq_t since = filemap_sample_wb_err(inode->i_mapping);
 
 	if (!page)
 		return -ENOMEM;
@@ -653,7 +658,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 	memcpy (de->name, "..\0", 4);
 	ext2_set_de_type (de, inode);
 	kunmap_atomic(kaddr);
-	err = ext2_commit_chunk(page, 0, chunk_size);
+	err = ext2_commit_chunk(page, 0, chunk_size, since);
 fail:
 	put_page(page);
 	return err;
-- 
2.9.4
