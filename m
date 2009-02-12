From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: Fix to read empty directory blocks correctly in
 64k blocksize filesystems
Date: Thu, 12 Feb 2009 14:42:36 +0800
Message-ID: <4993C4DC.1040305@cn.fujitsu.com>
References: <4990FAE4.1080009@cn.fujitsu.com> <20090210152049.GF30689@mini-me.lan> <20090211054816.GP3209@webber.adilger.int> <20090211151547.GK29220@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZBLGnA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 01:43:00 -0500
In-Reply-To: <20090211151547.GK29220@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Feb 11, 2009 at 12:48:16AM -0500, Andreas Dilger wrote:
>   
>> I'm glad that the MAX_REC_LEN value is being kept, because "0" is
>> too easily hit due to disk corruption.
>>
>>     
>
> I'm not too worried about that, actually.  If there is a disk
> corruption, we will detect it easily enough no matter which encoding
> we use.  I am thinking though that neither 65535 nor 0 is the best way
> of encoding 65536.  In fact, I would suggest the encoding 0x01.
> Specifically, I suggest:
>
> 	     (rec_len & 65532) | ((rec_len >> 16) & 3)
>
> This encodes valid rec_len values in the range 0 through 2**18-4, and
> allows for maximum block sizes of up to 256k.  To retain backwards
> compatibility, and to allow for a 256k blocksize, we can have a
> special case where a rec_len of either 0 or 65535 means
> EXT4_BLOCK_SIZE(s).
>
> It's unlikely we'll see VM pages of up to 256k, but at some point we
> might find that the Linux VM has been enhanced to support filesystem
> block sizes > than the VM page size, at which point it might be useful
> for some applications to allow very large filesystem block sizes.
>
>     	 	      	       	    	  	     - Ted
>   

Hi, Ted

  As your advice, I have changed the patch. Thanks.

[PATCH] ext4: Fix support for empty directory blocks in 64k blocksize filesystems

The rec_len field in the directory entry is 16 bits, so there was a
problem representing rec_len for filesystems with a 64k block size in
the case where the directory entry takes the entire 64k block.
Unfortunately, there were two schemes that were proposed; one where
all zeros meant 65536 and one where all ones (65535) meant 65536.
E2fsprogs used 0, whereas the kernel used 65535.  Oops.  Fortunately
this case happens extremely rarely, with the most common case being
the lost+found directory, created by mke2fs.

So we will be liberal in what we accept, and accept both encodings,
but we will encode 65536 as 0x01. Use this algorithm:

        (rec_len & 65532) | ((rec_len >> 16) & 3)

This encodes valid rec_len values in the range 0 through 2**18-4, and
allows for maximum block sizes of up to 256k.  To retain backwards
compatibility, and to allow for a 256k blocksize, we can have a
special case where a rec_len of either 0 or 65535 means
EXT4_BLOCK_SIZE(s).

It's unlikely we'll see VM pages of up to 256k, but at some point we
might find that the Linux VM has been enhanced to support filesystem
block sizes > than the VM page size, at which point it might be useful
for some applications to allow very large filesystem block sizes.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/ext4/dir.c   |   16 ++++++++-----
 fs/ext4/ext4.h  |   16 +++++++-------
 fs/ext4/namei.c |   63 ++++++++++++++++++++++++++++++------------------------
 3 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 2df2e40..5bc0199 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -67,7 +67,8 @@ int ext4_check_dir_entry(const char *function, struct inode *dir,
 			 unsigned int offset)
 {
 	const char *error_msg = NULL;
-	const int rlen = ext4_rec_len_from_disk(de->rec_len);
+	const int rlen = ext4_rec_len_from_disk(de->rec_len,
+						dir->i_sb->s_blocksize);
 
 	if (rlen < EXT4_DIR_REC_LEN(1))
 		error_msg = "rec_len is smaller than minimal";
@@ -178,10 +179,11 @@ revalidate:
 				 * least that it is non-zero.  A
 				 * failure will be detected in the
 				 * dirent test below. */
-				if (ext4_rec_len_from_disk(de->rec_len)
-						< EXT4_DIR_REC_LEN(1))
+				if (ext4_rec_len_from_disk(de->rec_len,
+					sb->s_blocksize) < EXT4_DIR_REC_LEN(1))
 					break;
-				i += ext4_rec_len_from_disk(de->rec_len);
+				i += ext4_rec_len_from_disk(de->rec_len,
+					sb->s_blocksize);
 			}
 			offset = i;
 			filp->f_pos = (filp->f_pos & ~(sb->s_blocksize - 1))
@@ -203,7 +205,8 @@ revalidate:
 				ret = stored;
 				goto out;
 			}
-			offset += ext4_rec_len_from_disk(de->rec_len);
+			offset += ext4_rec_len_from_disk(de->rec_len,
+					sb->s_blocksize);
 			if (le32_to_cpu(de->inode)) {
 				/* We might block in the next section
 				 * if the data destination is
@@ -225,7 +228,8 @@ revalidate:
 					goto revalidate;
 				stored++;
 			}
-			filp->f_pos += ext4_rec_len_from_disk(de->rec_len);
+			filp->f_pos += ext4_rec_len_from_disk(de->rec_len,
+						sb->s_blocksize);
 		}
 		offset = 0;
 		brelse(bh);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aafc9eb..e0c5962 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -864,22 +864,22 @@ struct ext4_dir_entry_2 {
 					 ~EXT4_DIR_ROUND)
 #define EXT4_MAX_REC_LEN		((1<<16)-1)
 
-static inline unsigned ext4_rec_len_from_disk(__le16 dlen)
+static inline unsigned ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
 {
 	unsigned len = le16_to_cpu(dlen);
 
-	if (len == EXT4_MAX_REC_LEN)
-		return 1 << 16;
-	return len;
+	if (len == EXT4_MAX_REC_LEN || len == 0)
+		return blocksize;
+	return (len & 65532) | ((len & 3) << 16);
 }
 
 static inline __le16 ext4_rec_len_to_disk(unsigned len)
 {
-	if (len == (1 << 16))
-		return cpu_to_le16(EXT4_MAX_REC_LEN);
-	else if (len > (1 << 16))
+	if (len == (1 << 18))
+		return cpu_to_le16(0);
+	else if (len > (1 << 18))
 		BUG();
-	return cpu_to_le16(len);
+	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
 }
 
 /*
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ba702bd..165b378 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -184,10 +184,10 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
  * p is at least 6 bytes before the end of page
  */
 static inline struct ext4_dir_entry_2 *
-ext4_next_entry(struct ext4_dir_entry_2 *p)
+ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
 {
 	return (struct ext4_dir_entry_2 *)((char *)p +
-		ext4_rec_len_from_disk(p->rec_len));
+		ext4_rec_len_from_disk(p->rec_len, blocksize));
 }
 
 /*
@@ -294,7 +294,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 			space += EXT4_DIR_REC_LEN(de->name_len);
 			names++;
 		}
-		de = ext4_next_entry(de);
+		de = ext4_next_entry(de, size);
 	}
 	printk("(%i)\n", names);
 	return (struct stats) { names, space, 1 };
@@ -585,7 +585,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
 					   EXT4_DIR_REC_LEN(0));
-	for (; de < top; de = ext4_next_entry(de)) {
+	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
 		if (!ext4_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
@@ -663,7 +663,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	}
 	if (start_hash < 2 || (start_hash ==2 && start_minor_hash==0)) {
 		de = (struct ext4_dir_entry_2 *) frames[0].bh->b_data;
-		de = ext4_next_entry(de);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 		if ((err = ext4_htree_store_dirent(dir_file, 2, 0, de)) != 0)
 			goto errout;
 		count++;
@@ -732,7 +732,7 @@ static int dx_make_map (struct ext4_dir_entry_2 *de, int size,
 			cond_resched();
 		}
 		/* XXX: do we need to check rec_len == 0 case? -Chris */
-		de = ext4_next_entry(de);
+		de = ext4_next_entry(de, size);
 	}
 	return count;
 }
@@ -832,7 +832,8 @@ static inline int search_dirblock(struct buffer_head *bh,
 			return 1;
 		}
 		/* prevent looping on a bad block */
-		de_len = ext4_rec_len_from_disk(de->rec_len);
+		de_len = ext4_rec_len_from_disk(de->rec_len,
+						dir->i_sb->s_blocksize);
 		if (de_len <= 0)
 			return -1;
 		offset += de_len;
@@ -996,7 +997,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 		de = (struct ext4_dir_entry_2 *) bh->b_data;
 		top = (struct ext4_dir_entry_2 *) ((char *) de + sb->s_blocksize -
 				       EXT4_DIR_REC_LEN(0));
-		for (; de < top; de = ext4_next_entry(de)) {
+		for (; de < top; de = ext4_next_entry(de, sb->s_blocksize)) {
 			int off = (block << EXT4_BLOCK_SIZE_BITS(sb))
 				  + ((char *) de - bh->b_data);
 
@@ -1137,7 +1138,7 @@ static struct ext4_dir_entry_2* dx_pack_dirents(char *base, int size)
 
 	prev = to = de;
 	while ((char*)de < base + size) {
-		next = ext4_next_entry(de);
+		next = ext4_next_entry(de, size);
 		if (de->inode && de->name_len) {
 			rec_len = EXT4_DIR_REC_LEN(de->name_len);
 			if (de > to)
@@ -1287,7 +1288,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 				return -EEXIST;
 			}
 			nlen = EXT4_DIR_REC_LEN(de->name_len);
-			rlen = ext4_rec_len_from_disk(de->rec_len);
+			rlen = ext4_rec_len_from_disk(de->rec_len,
+						      dir->i_sb->s_blocksize);
 			if ((de->inode? rlen - nlen: rlen) >= reclen)
 				break;
 			de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
@@ -1306,7 +1308,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 
 	/* By now the buffer is marked for journaling */
 	nlen = EXT4_DIR_REC_LEN(de->name_len);
-	rlen = ext4_rec_len_from_disk(de->rec_len);
+	rlen = ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 = (struct ext4_dir_entry_2 *)((char *)de + nlen);
 		de1->rec_len = ext4_rec_len_to_disk(rlen - nlen);
@@ -1380,7 +1382,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	/* The 0th block becomes the root, move the dirents out */
 	fde = &root->dotdot;
 	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len));
+		ext4_rec_len_from_disk(fde->rec_len, blocksize));
 	if ((char *) de >= (((char *) root) + blocksize)) {
 		ext4_error(dir->i_sb, __func__,
 			   "invalid rec_len for '..' in inode %lu",
@@ -1402,7 +1404,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	memcpy (data1, de, len);
 	de = (struct ext4_dir_entry_2 *) data1;
 	top = data1 + len;
-	while ((char *)(de2 = ext4_next_entry(de)) < top)
+	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
 		de = de2;
 	de->rec_len = ext4_rec_len_to_disk(data1 + blocksize - (char *) de);
 	/* Initialize the root; the dot dirents already exist */
@@ -1652,8 +1654,10 @@ static int ext4_delete_entry(handle_t *handle,
 			ext4_journal_get_write_access(handle, bh);
 			if (pde)
 				pde->rec_len = ext4_rec_len_to_disk(
-					ext4_rec_len_from_disk(pde->rec_len) +
-					ext4_rec_len_from_disk(de->rec_len));
+					ext4_rec_len_from_disk(pde->rec_len,
+						dir->i_sb->s_blocksize) +
+					ext4_rec_len_from_disk(de->rec_len,
+						dir->i_sb->s_blocksize));
 			else
 				de->inode = 0;
 			dir->i_version++;
@@ -1661,9 +1665,10 @@ static int ext4_delete_entry(handle_t *handle,
 			ext4_handle_dirty_metadata(handle, dir, bh);
 			return 0;
 		}
-		i += ext4_rec_len_from_disk(de->rec_len);
+		i += ext4_rec_len_from_disk(de->rec_len,
+					    dir->i_sb->s_blocksize);
 		pde = de;
-		de = ext4_next_entry(de);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	}
 	return -ENOENT;
 }
@@ -1827,7 +1832,7 @@ retry:
 	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len));
 	strcpy(de->name, ".");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
-	de = ext4_next_entry(de);
+	de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	de->inode = cpu_to_le32(dir->i_ino);
 	de->rec_len = ext4_rec_len_to_disk(inode->i_sb->s_blocksize -
 						EXT4_DIR_REC_LEN(1));
@@ -1885,7 +1890,7 @@ static int empty_dir(struct inode *inode)
 		return 1;
 	}
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	de1 = ext4_next_entry(de);
+	de1 = ext4_next_entry(de, sb->s_blocksize);
 	if (le32_to_cpu(de->inode) != inode->i_ino ||
 			!le32_to_cpu(de1->inode) ||
 			strcmp(".", de->name) ||
@@ -1896,9 +1901,9 @@ static int empty_dir(struct inode *inode)
 		brelse(bh);
 		return 1;
 	}
-	offset = ext4_rec_len_from_disk(de->rec_len) +
-		 ext4_rec_len_from_disk(de1->rec_len);
-	de = ext4_next_entry(de1);
+	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize) +
+		 ext4_rec_len_from_disk(de1->rec_len, sb->s_blocksize);
+	de = ext4_next_entry(de1, sb->s_blocksize);
 	while (offset < inode->i_size) {
 		if (!bh ||
 			(void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
@@ -1927,8 +1932,8 @@ static int empty_dir(struct inode *inode)
 			brelse(bh);
 			return 0;
 		}
-		offset += ext4_rec_len_from_disk(de->rec_len);
-		de = ext4_next_entry(de);
+		offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
+		de = ext4_next_entry(de, sb->s_blocksize);
 	}
 	brelse(bh);
 	return 1;
@@ -2297,8 +2302,8 @@ retry:
 	return err;
 }
 
-#define PARENT_INO(buffer) \
-	(ext4_next_entry((struct ext4_dir_entry_2 *)(buffer))->inode)
+#define PARENT_INO(buffer, size) \
+	(ext4_next_entry((struct ext4_dir_entry_2 *)(buffer), size)->inode)
 
 /*
  * Anybody can rename anything with this: the permission checks are left to the
@@ -2358,7 +2363,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
 		if (!dir_bh)
 			goto end_rename;
-		if (le32_to_cpu(PARENT_INO(dir_bh->b_data)) != old_dir->i_ino)
+		if (le32_to_cpu(PARENT_INO(dir_bh->b_data,
+				old_dir->i_sb->s_blocksize)) != old_dir->i_ino)
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
@@ -2430,7 +2436,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (dir_bh) {
 		BUFFER_TRACE(dir_bh, "get_write_access");
 		ext4_journal_get_write_access(handle, dir_bh);
-		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
+		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
+						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
 		ext4_handle_dirty_metadata(handle, old_dir, dir_bh);
 		ext4_dec_count(handle, old_dir);
-- 
1.5.3.8




