Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:48579 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKAv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:00:51 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 03/10] ext2: fix coding style for dir.c
Date: Tue, 13 Nov 2018 08:04:41 +0800
Message-Id: <20181113000448.16023-4-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/dir.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 3b8114def693..9fd1ad886f9f 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -196,7 +196,7 @@ static bool ext2_check_page(struct page *page, int quiet)
 	return false;
 }
 
-static struct page * ext2_get_page(struct inode *dir, unsigned long n,
+static struct page *ext2_get_page(struct inode *dir, unsigned long n,
 				   int quiet)
 {
 	struct address_space *mapping = dir->i_mapping;
@@ -220,8 +220,8 @@ static struct page * ext2_get_page(struct inode *dir, unsigned long n,
  *
  * len <= EXT2_NAME_LEN and de != NULL are guaranteed by caller.
  */
-static inline int ext2_match (int len, const char * const name,
-					struct ext2_dir_entry_2 * de)
+static inline int ext2_match(int len, const char * const name,
+					struct ext2_dir_entry_2 *de)
 {
 	if (len != de->name_len)
 		return 0;
@@ -425,7 +425,7 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
 	return de;
 }
 
-struct ext2_dir_entry_2 * ext2_dotdot (struct inode *dir, struct page **p)
+struct ext2_dir_entry_2 *ext2_dotdot(struct inode *dir, struct page **p)
 {
 	struct page *page = ext2_get_page(dir, 0, 0);
 	ext2_dirent *de = NULL;
@@ -443,7 +443,7 @@ ino_t ext2_inode_by_name(struct inode *dir, const struct qstr *child)
 	struct ext2_dir_entry_2 *de;
 	struct page *page;
 	
-	de = ext2_find_entry (dir, child, &page);
+	de = ext2_find_entry(dir, child, &page);
 	if (de) {
 		res = le32_to_cpu(de->inode);
 		ext2_put_page(page);
@@ -481,7 +481,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 /*
  *	Parent is locked.
  */
-int ext2_add_link (struct dentry *dentry, struct inode *inode)
+int ext2_add_link(struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = d_inode(dentry->d_parent);
 	const char *name = dentry->d_name.name;
@@ -490,7 +490,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 	unsigned reclen = EXT2_DIR_REC_LEN(namelen);
 	unsigned short rec_len, name_len;
 	struct page *page = NULL;
-	ext2_dirent * de;
+	ext2_dirent *de;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
@@ -580,7 +580,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
  */
-int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
+int ext2_delete_entry(struct ext2_dir_entry_2 *dir, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr = page_address(page);
@@ -664,7 +664,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-int ext2_empty_dir (struct inode * inode)
+int ext2_empty_dir(struct inode *inode)
 {
 	struct page *page = NULL;
 	unsigned long i, npages = dir_pages(inode);
-- 
2.17.2
