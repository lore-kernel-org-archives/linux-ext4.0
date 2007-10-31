From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix 64KB blocksize in ext3 directories
Date: Wed, 31 Oct 2007 16:39:57 +0100
Message-ID: <20071031153957.GB25466@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34023 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756060AbXJaPkA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Oct 2007 11:40:00 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi Andrew,

  looking at the commit messages it seems the patch fixing overflow of
rec_len in ext3 directories when using 64KB blocksize got lost (I'm not
surprised given the churn of the patches in this area for 2.6.24-rc1 ;).
Anyway, the patch is attached. It should make it into 2.6.24 (or nasty
things would happen if somebody actually try 64KB blocksize in ext3).

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

With 64KB blocksize, a directory entry can have size 64KB which does not fit
into 16 bits we have for entry lenght. So we store 0xffff instead and convert
value when read from / written to disk. The patch also converts some places
to use ext3_next_entry() when we are changing them anyway.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/ext3/dir.c linux-2.6.24-rc1-1-ext3_64k_blocksize/fs/ext3/dir.c
--- linux-2.6.24-rc1/fs/ext3/dir.c	2007-10-24 20:43:56.000000000 +0200
+++ linux-2.6.24-rc1-1-ext3_64k_blocksize/fs/ext3/dir.c	2007-10-24 20:45:01.000000000 +0200
@@ -67,7 +67,7 @@ int ext3_check_dir_entry (const char * f
 			  unsigned long offset)
 {
 	const char * error_msg = NULL;
-	const int rlen = le16_to_cpu(de->rec_len);
+	const int rlen = ext3_rec_len_from_disk(de->rec_len);
 
 	if (rlen < EXT3_DIR_REC_LEN(1))
 		error_msg = "rec_len is smaller than minimal";
@@ -173,10 +173,10 @@ revalidate:
 				 * least that it is non-zero.  A
 				 * failure will be detected in the
 				 * dirent test below. */
-				if (le16_to_cpu(de->rec_len) <
+				if (ext3_rec_len_from_disk(de->rec_len) <
 						EXT3_DIR_REC_LEN(1))
 					break;
-				i += le16_to_cpu(de->rec_len);
+				i += ext3_rec_len_from_disk(de->rec_len);
 			}
 			offset = i;
 			filp->f_pos = (filp->f_pos & ~(sb->s_blocksize - 1))
@@ -197,7 +197,7 @@ revalidate:
 				ret = stored;
 				goto out;
 			}
-			offset += le16_to_cpu(de->rec_len);
+			offset += ext3_rec_len_from_disk(de->rec_len);
 			if (le32_to_cpu(de->inode)) {
 				/* We might block in the next section
 				 * if the data destination is
@@ -219,7 +219,7 @@ revalidate:
 					goto revalidate;
 				stored ++;
 			}
-			filp->f_pos += le16_to_cpu(de->rec_len);
+			filp->f_pos += ext3_rec_len_from_disk(de->rec_len);
 		}
 		offset = 0;
 		brelse (bh);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/ext3/namei.c linux-2.6.24-rc1-1-ext3_64k_blocksize/fs/ext3/namei.c
--- linux-2.6.24-rc1/fs/ext3/namei.c	2007-10-24 20:43:56.000000000 +0200
+++ linux-2.6.24-rc1-1-ext3_64k_blocksize/fs/ext3/namei.c	2007-10-24 20:45:58.000000000 +0200
@@ -177,6 +177,15 @@ static int ext3_dx_add_entry(handle_t *h
 			     struct inode *inode);
 
 /*
+ * p is at least 6 bytes before the end of page
+ */
+static inline struct ext3_dir_entry_2 *ext3_next_entry(struct ext3_dir_entry_2 *p)
+{
+	return (struct ext3_dir_entry_2 *)((char*)p +
+		ext3_rec_len_from_disk(p->rec_len));
+}
+
+/*
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
@@ -280,7 +289,7 @@ static struct stats dx_show_leaf(struct 
 			space += EXT3_DIR_REC_LEN(de->name_len);
 			names++;
 		}
-		de = (struct ext3_dir_entry_2 *) ((char *) de + le16_to_cpu(de->rec_len));
+		de = ext3_next_entry(de);
 	}
 	printk("(%i)\n", names);
 	return (struct stats) { names, space, 1 };
@@ -547,14 +556,6 @@ static int ext3_htree_next_block(struct 
 
 
 /*
- * p is at least 6 bytes before the end of page
- */
-static inline struct ext3_dir_entry_2 *ext3_next_entry(struct ext3_dir_entry_2 *p)
-{
-	return (struct ext3_dir_entry_2 *)((char*)p + le16_to_cpu(p->rec_len));
-}
-
-/*
  * This function fills a red-black tree with information from a
  * directory block.  It returns the number directory entries loaded
  * into the tree.  If there is an error it is returned in err.
@@ -720,7 +721,7 @@ static int dx_make_map (struct ext3_dir_
 			cond_resched();
 		}
 		/* XXX: do we need to check rec_len == 0 case? -Chris */
-		de = (struct ext3_dir_entry_2 *) ((char *) de + le16_to_cpu(de->rec_len));
+		de = ext3_next_entry(de);
 	}
 	return count;
 }
@@ -822,7 +823,7 @@ static inline int search_dirblock(struct
 			return 1;
 		}
 		/* prevent looping on a bad block */
-		de_len = le16_to_cpu(de->rec_len);
+		de_len = ext3_rec_len_from_disk(de->rec_len);
 		if (de_len <= 0)
 			return -1;
 		offset += de_len;
@@ -1130,7 +1131,7 @@ dx_move_dirents(char *from, char *to, st
 		rec_len = EXT3_DIR_REC_LEN(de->name_len);
 		memcpy (to, de, rec_len);
 		((struct ext3_dir_entry_2 *) to)->rec_len =
-				cpu_to_le16(rec_len);
+				ext3_rec_len_to_disk(rec_len);
 		de->inode = 0;
 		map++;
 		to += rec_len;
@@ -1149,13 +1150,12 @@ static struct ext3_dir_entry_2* dx_pack_
 
 	prev = to = de;
 	while ((char*)de < base + size) {
-		next = (struct ext3_dir_entry_2 *) ((char *) de +
-						    le16_to_cpu(de->rec_len));
+		next = ext3_next_entry(de);
 		if (de->inode && de->name_len) {
 			rec_len = EXT3_DIR_REC_LEN(de->name_len);
 			if (de > to)
 				memmove(to, de, rec_len);
-			to->rec_len = cpu_to_le16(rec_len);
+			to->rec_len = ext3_rec_len_to_disk(rec_len);
 			prev = to;
 			to = (struct ext3_dir_entry_2 *) (((char *) to) + rec_len);
 		}
@@ -1229,8 +1229,8 @@ static struct ext3_dir_entry_2 *do_split
 	/* Fancy dance to stay within two buffers */
 	de2 = dx_move_dirents(data1, data2, map + split, count - split);
 	de = dx_pack_dirents(data1,blocksize);
-	de->rec_len = cpu_to_le16(data1 + blocksize - (char *) de);
-	de2->rec_len = cpu_to_le16(data2 + blocksize - (char *) de2);
+	de->rec_len = ext3_rec_len_to_disk(data1 + blocksize - (char *) de);
+	de2->rec_len = ext3_rec_len_to_disk(data2 + blocksize - (char *) de2);
 	dxtrace(dx_show_leaf (hinfo, (struct ext3_dir_entry_2 *) data1, blocksize, 1));
 	dxtrace(dx_show_leaf (hinfo, (struct ext3_dir_entry_2 *) data2, blocksize, 1));
 
@@ -1300,7 +1300,7 @@ static int add_dirent_to_buf(handle_t *h
 				return -EEXIST;
 			}
 			nlen = EXT3_DIR_REC_LEN(de->name_len);
-			rlen = le16_to_cpu(de->rec_len);
+			rlen = ext3_rec_len_from_disk(de->rec_len);
 			if ((de->inode? rlen - nlen: rlen) >= reclen)
 				break;
 			de = (struct ext3_dir_entry_2 *)((char *)de + rlen);
@@ -1319,11 +1319,11 @@ static int add_dirent_to_buf(handle_t *h
 
 	/* By now the buffer is marked for journaling */
 	nlen = EXT3_DIR_REC_LEN(de->name_len);
-	rlen = le16_to_cpu(de->rec_len);
+	rlen = ext3_rec_len_from_disk(de->rec_len);
 	if (de->inode) {
 		struct ext3_dir_entry_2 *de1 = (struct ext3_dir_entry_2 *)((char *)de + nlen);
-		de1->rec_len = cpu_to_le16(rlen - nlen);
-		de->rec_len = cpu_to_le16(nlen);
+		de1->rec_len = ext3_rec_len_to_disk(rlen - nlen);
+		de->rec_len = ext3_rec_len_to_disk(nlen);
 		de = de1;
 	}
 	de->file_type = EXT3_FT_UNKNOWN;
@@ -1400,17 +1400,18 @@ static int make_indexed_dir(handle_t *ha
 
 	/* The 0th block becomes the root, move the dirents out */
 	fde = &root->dotdot;
-	de = (struct ext3_dir_entry_2 *)((char *)fde + le16_to_cpu(fde->rec_len));
+	de = (struct ext3_dir_entry_2 *)((char *)fde +
+			ext3_rec_len_from_disk(fde->rec_len));
 	len = ((char *) root) + blocksize - (char *) de;
 	memcpy (data1, de, len);
 	de = (struct ext3_dir_entry_2 *) data1;
 	top = data1 + len;
-	while ((char *)(de2=(void*)de+le16_to_cpu(de->rec_len)) < top)
+	while ((char *)(de2 = ext3_next_entry(de)) < top)
 		de = de2;
-	de->rec_len = cpu_to_le16(data1 + blocksize - (char *) de);
+	de->rec_len = ext3_rec_len_to_disk(data1 + blocksize - (char *) de);
 	/* Initialize the root; the dot dirents already exist */
 	de = (struct ext3_dir_entry_2 *) (&root->dotdot);
-	de->rec_len = cpu_to_le16(blocksize - EXT3_DIR_REC_LEN(2));
+	de->rec_len = ext3_rec_len_to_disk(blocksize - EXT3_DIR_REC_LEN(2));
 	memset (&root->info, 0, sizeof(root->info));
 	root->info.info_length = sizeof(root->info);
 	root->info.hash_version = EXT3_SB(dir->i_sb)->s_def_hash_version;
@@ -1490,7 +1491,7 @@ static int ext3_add_entry (handle_t *han
 		return retval;
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
 	de->inode = 0;
-	de->rec_len = cpu_to_le16(blocksize);
+	de->rec_len = ext3_rec_len_to_disk(blocksize);
 	return add_dirent_to_buf(handle, dentry, inode, de, bh);
 }
 
@@ -1553,7 +1554,7 @@ static int ext3_dx_add_entry(handle_t *h
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
-		node2->fake.rec_len = cpu_to_le16(sb->s_blocksize);
+		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
 		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
@@ -1651,9 +1652,9 @@ static int ext3_delete_entry (handle_t *
 			BUFFER_TRACE(bh, "get_write_access");
 			ext3_journal_get_write_access(handle, bh);
 			if (pde)
-				pde->rec_len =
-					cpu_to_le16(le16_to_cpu(pde->rec_len) +
-						    le16_to_cpu(de->rec_len));
+				pde->rec_len = ext3_rec_len_to_disk(
+					ext3_rec_len_from_disk(pde->rec_len) +
+					ext3_rec_len_from_disk(de->rec_len));
 			else
 				de->inode = 0;
 			dir->i_version++;
@@ -1661,10 +1662,9 @@ static int ext3_delete_entry (handle_t *
 			ext3_journal_dirty_metadata(handle, bh);
 			return 0;
 		}
-		i += le16_to_cpu(de->rec_len);
+		i += ext3_rec_len_from_disk(de->rec_len);
 		pde = de;
-		de = (struct ext3_dir_entry_2 *)
-			((char *) de + le16_to_cpu(de->rec_len));
+		de = ext3_next_entry(de);
 	}
 	return -ENOENT;
 }
@@ -1798,13 +1798,12 @@ retry:
 	de = (struct ext3_dir_entry_2 *) dir_block->b_data;
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = cpu_to_le16(EXT3_DIR_REC_LEN(de->name_len));
+	de->rec_len = ext3_rec_len_to_disk(EXT3_DIR_REC_LEN(de->name_len));
 	strcpy (de->name, ".");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
-	de = (struct ext3_dir_entry_2 *)
-			((char *) de + le16_to_cpu(de->rec_len));
+	de = ext3_next_entry(de);
 	de->inode = cpu_to_le32(dir->i_ino);
-	de->rec_len = cpu_to_le16(inode->i_sb->s_blocksize-EXT3_DIR_REC_LEN(1));
+	de->rec_len = ext3_rec_len_to_disk(inode->i_sb->s_blocksize-EXT3_DIR_REC_LEN(1));
 	de->name_len = 2;
 	strcpy (de->name, "..");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
@@ -1856,8 +1855,7 @@ static int empty_dir (struct inode * ino
 		return 1;
 	}
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
-	de1 = (struct ext3_dir_entry_2 *)
-			((char *) de + le16_to_cpu(de->rec_len));
+	de1 = ext3_next_entry(de);
 	if (le32_to_cpu(de->inode) != inode->i_ino ||
 			!le32_to_cpu(de1->inode) ||
 			strcmp (".", de->name) ||
@@ -1868,9 +1866,9 @@ static int empty_dir (struct inode * ino
 		brelse (bh);
 		return 1;
 	}
-	offset = le16_to_cpu(de->rec_len) + le16_to_cpu(de1->rec_len);
-	de = (struct ext3_dir_entry_2 *)
-			((char *) de1 + le16_to_cpu(de1->rec_len));
+	offset = ext3_rec_len_from_disk(de->rec_len) +
+			ext3_rec_len_from_disk(de1->rec_len);
+	de = ext3_next_entry(de1);
 	while (offset < inode->i_size ) {
 		if (!bh ||
 			(void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
@@ -1899,9 +1897,8 @@ static int empty_dir (struct inode * ino
 			brelse (bh);
 			return 0;
 		}
-		offset += le16_to_cpu(de->rec_len);
-		de = (struct ext3_dir_entry_2 *)
-				((char *) de + le16_to_cpu(de->rec_len));
+		offset += ext3_rec_len_from_disk(de->rec_len);
+		de = ext3_next_entry(de);
 	}
 	brelse (bh);
 	return 1;
@@ -2255,8 +2252,7 @@ retry:
 }
 
 #define PARENT_INO(buffer) \
-	((struct ext3_dir_entry_2 *) ((char *) buffer + \
-	le16_to_cpu(((struct ext3_dir_entry_2 *) buffer)->rec_len)))->inode
+	(ext3_next_entry((struct ext3_dir_entry_2 *)(buffer))->inode)
 
 /*
  * Anybody can rename anything with this: the permission checks are left to the
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/include/linux/ext3_fs.h linux-2.6.24-rc1-1-ext3_64k_blocksize/include/linux/ext3_fs.h
--- linux-2.6.24-rc1/include/linux/ext3_fs.h	2007-10-24 20:44:03.000000000 +0200
+++ linux-2.6.24-rc1-1-ext3_64k_blocksize/include/linux/ext3_fs.h	2007-10-24 20:45:01.000000000 +0200
@@ -656,6 +656,26 @@ struct ext3_dir_entry_2 {
 #define EXT3_DIR_ROUND			(EXT3_DIR_PAD - 1)
 #define EXT3_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT3_DIR_ROUND) & \
 					 ~EXT3_DIR_ROUND)
+#define EXT3_MAX_REC_LEN		((1<<16)-1)
+
+static inline unsigned ext3_rec_len_from_disk(__le16 dlen)
+{
+	unsigned len = le16_to_cpu(dlen);
+
+	if (len == EXT3_MAX_REC_LEN)
+		return 1 << 16;
+	return len;
+}
+
+static inline __le16 ext3_rec_len_to_disk(unsigned len)
+{
+	if (len == (1 << 16))
+		return cpu_to_le16(EXT3_MAX_REC_LEN);
+	else if (len > (1 << 16))
+		BUG();
+	return cpu_to_le16(len);
+}
+
 /*
  * Hash Tree Directory indexing
  * (c) Daniel Phillips, 2001
