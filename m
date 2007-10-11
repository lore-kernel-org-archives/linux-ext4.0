From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 11 Oct 2007 13:18:49 +0200
Message-ID: <20071011111849.GC7125@duck.suse.cz>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1191285346.11737.58.camel@localhost.localdomain> <20071004131207.65406a7b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, sho@tnes.nec.co.jp, jack@suse.cz,
	clameter@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36320 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751456AbXJKK4H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 06:56:07 -0400
Content-Disposition: inline
In-Reply-To: <20071004131207.65406a7b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 04-10-07 13:12:07, Andrew Morton wrote:
> On Mon, 01 Oct 2007 17:35:46 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > ext2: Avoid rec_len overflow with 64KB block size
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > With 64KB blocksize, a directory entry can have size 64KB which does not fit
> > into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> > value when read from / written to disk.
> 
> This patch clashes in non-trivial ways with
> ext2-convert-to-new-aops-fix.patch and perhaps other things which are
> already queued for 2.6.24 inclusion, so I'll need to ask for an updated
> patch, please.
> 
> Also, I'm planing on merging the ext2 reservations code into 2.6.24, so if
> we're aiming for complete support of 64k blocksize in 2.6.24's ext2,
> additional testing and checking will be needed.
  OK, attached is a patch diffed against 2.6.23-rc9-mm2 - does that work
fine for you?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

------

With 64KB blocksize, a directory entry can have size 64KB which does not fit
into 16 bits we have for entry lenght. So we store 0xffff instead and convert
value when read from / written to disk.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-mm/fs/ext2/dir.c linux-2.6.23-mm-1-ext2_64k_rec_len/fs/ext2/dir.c
--- linux-2.6.23-mm/fs/ext2/dir.c	2007-10-11 12:08:16.000000000 +0200
+++ linux-2.6.23-mm-1-ext2_64k_rec_len/fs/ext2/dir.c	2007-10-11 12:14:24.000000000 +0200
@@ -28,6 +28,24 @@
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
+static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
+{
+	unsigned len = le16_to_cpu(dlen);
+
+	if (len == EXT2_MAX_REC_LEN)
+		return 1 << 16;
+	return len;
+}
+
+static inline __le16 ext2_rec_len_to_disk(unsigned len)
+{
+	if (len == (1 << 16))
+		return cpu_to_le16(EXT2_MAX_REC_LEN);
+	else if (len > (1 << 16))
+		BUG();
+	return cpu_to_le16(len);
+}
+
 /*
  * ext2 uses block-sized chunks. Arguably, sector-sized ones would be
  * more robust, but we have what we have
@@ -106,7 +124,7 @@ static void ext2_check_page(struct page 
 	}
 	for (offs = 0; offs <= limit - EXT2_DIR_REC_LEN(1); offs += rec_len) {
 		p = (ext2_dirent *)(kaddr + offs);
-		rec_len = le16_to_cpu(p->rec_len);
+		rec_len = ext2_rec_len_from_disk(p->rec_len);
 
 		if (rec_len < EXT2_DIR_REC_LEN(1))
 			goto Eshort;
@@ -204,7 +222,8 @@ static inline int ext2_match (int len, c
  */
 static inline ext2_dirent *ext2_next_entry(ext2_dirent *p)
 {
-	return (ext2_dirent *)((char*)p + le16_to_cpu(p->rec_len));
+	return (ext2_dirent *)((char*)p +
+			ext2_rec_len_from_disk(p->rec_len));
 }
 
 static inline unsigned 
@@ -316,7 +335,7 @@ ext2_readdir (struct file * filp, void *
 					return 0;
 				}
 			}
-			filp->f_pos += le16_to_cpu(de->rec_len);
+			filp->f_pos += ext2_rec_len_from_disk(de->rec_len);
 		}
 		ext2_put_page(page);
 	}
@@ -425,7 +444,7 @@ void ext2_set_link(struct inode *dir, st
 {
 	loff_t pos = page_offset(page) +
 			(char *) de - (char *) page_address(page);
-	unsigned len = le16_to_cpu(de->rec_len);
+	unsigned len = ext2_rec_len_from_disk(de->rec_len);
 	int err;
 
 	lock_page(page);
@@ -482,7 +501,7 @@ int ext2_add_link (struct dentry *dentry
 				/* We hit i_size */
 				name_len = 0;
 				rec_len = chunk_size;
-				de->rec_len = cpu_to_le16(chunk_size);
+				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
 				goto got_it;
 			}
@@ -496,7 +515,7 @@ int ext2_add_link (struct dentry *dentry
 			if (ext2_match (namelen, name, de))
 				goto out_unlock;
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
-			rec_len = le16_to_cpu(de->rec_len);
+			rec_len = ext2_rec_len_from_disk(de->rec_len);
 			if (!de->inode && rec_len >= reclen)
 				goto got_it;
 			if (rec_len >= name_len + reclen)
@@ -518,8 +537,8 @@ got_it:
 		goto out_unlock;
 	if (de->inode) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
-		de1->rec_len = cpu_to_le16(rec_len - name_len);
-		de->rec_len = cpu_to_le16(name_len);
+		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
+		de->rec_len = ext2_rec_len_to_disk(name_len);
 		de = de1;
 	}
 	de->name_len = namelen;
@@ -550,7 +569,8 @@ int ext2_delete_entry (struct ext2_dir_e
 	struct inode *inode = mapping->host;
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(ext2_chunk_size(inode)-1);
-	unsigned to = ((char*)dir - kaddr) + le16_to_cpu(dir->rec_len);
+	unsigned to = ((char*)dir - kaddr) +
+				ext2_rec_len_from_disk(dir->rec_len);
 	loff_t pos;
 	ext2_dirent * pde = NULL;
 	ext2_dirent * de = (ext2_dirent *) (kaddr + from);
@@ -574,7 +594,7 @@ int ext2_delete_entry (struct ext2_dir_e
 							&page, NULL);
 	BUG_ON(err);
 	if (pde)
-		pde->rec_len = cpu_to_le16(to - from);
+		pde->rec_len = ext2_rec_len_to_disk(to - from);
 	dir->inode = 0;
 	err = ext2_commit_chunk(page, pos, to - from);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
@@ -610,14 +630,14 @@ int ext2_make_empty(struct inode *inode,
 	memset(kaddr, 0, chunk_size);
 	de = (struct ext2_dir_entry_2 *)kaddr;
 	de->name_len = 1;
-	de->rec_len = cpu_to_le16(EXT2_DIR_REC_LEN(1));
+	de->rec_len = ext2_rec_len_to_disk(EXT2_DIR_REC_LEN(1));
 	memcpy (de->name, ".\0\0", 4);
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type (de, inode);
 
 	de = (struct ext2_dir_entry_2 *)(kaddr + EXT2_DIR_REC_LEN(1));
 	de->name_len = 2;
-	de->rec_len = cpu_to_le16(chunk_size - EXT2_DIR_REC_LEN(1));
+	de->rec_len = ext2_rec_len_to_disk(chunk_size - EXT2_DIR_REC_LEN(1));
 	de->inode = cpu_to_le32(parent->i_ino);
 	memcpy (de->name, "..\0", 4);
 	ext2_set_de_type (de, inode);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-mm/include/linux/ext2_fs.h linux-2.6.23-mm-1-ext2_64k_rec_len/include/linux/ext2_fs.h
--- linux-2.6.23-mm/include/linux/ext2_fs.h	2007-10-11 12:08:34.000000000 +0200
+++ linux-2.6.23-mm-1-ext2_64k_rec_len/include/linux/ext2_fs.h	2007-10-11 12:11:22.000000000 +0200
@@ -561,6 +561,7 @@ enum {
 #define EXT2_DIR_ROUND 			(EXT2_DIR_PAD - 1)
 #define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
+#define EXT2_MAX_REC_LEN		((1<<16)-1)
 
 static inline ext2_fsblk_t
 ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
