From: pravin shelar <Pravin.Shelar@Sun.COM>
Subject: [patch 1/2] remove dx_root struct
Date: Fri, 17 Jul 2009 22:59:35 +0530
Message-ID: <4A60B4FF.2040900@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_vyaxrBZR5tszK8/qpEuVHA)"
Cc: Andreas Dilger <adilger@Sun.COM>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:50390 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964918AbZGQRqG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 13:46:06 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id n6HHRo54016203
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 17:27:51 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMX00K00SFVG600@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Sat,
 18 Jul 2009 01:27:50 +0800 (SGT)
Received: from [129.150.33.148] ([unknown] [129.150.33.148])
 by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPSA id <0KMX00JXMSI5T5H0@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Sat, 18 Jul 2009 01:27:50 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_vyaxrBZR5tszK8/qpEuVHA)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

attached RFC patches adds facility in ext4 to have user data in every ext4 dirent.
lustre assigns cluserwide unique id to every inode in system, so we have added 
user data field in ext4 dirent to map filename to id efficiently.

i would like to get feedback on this as it might have some conflict with 64 bit 
inode work (which is in discussion phase). also please comment on INCOMPAT flag 
added.

patch[1] removes dx_root struct so that "." and ".." can have extra data.
patch[2] add user data field to ext4 dirent.

Thanks,
Pravin.

--Boundary_(ID_vyaxrBZR5tszK8/qpEuVHA)
Content-type: text/x-patch; name=ext4-dx-info.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ext4-dx-info.patch

this is cleanup patch which removes dx_root structure; this is reuqired
for next patch.

Index: b/fs/ext4/namei.c
===================================================================
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -105,22 +105,13 @@ struct dx_entry
  * hash version mod 4 should never be 0.  Sincerely, the paranoia department.
  */
 
-struct dx_root
+struct dx_root_info
 {
-	struct fake_dirent dot;
-	char dot_name[4];
-	struct fake_dirent dotdot;
-	char dotdot_name[4];
-	struct dx_root_info
-	{
-		__le32 reserved_zero;
-		u8 hash_version;
-		u8 info_length; /* 8 */
-		u8 indirect_levels;
-		u8 unused_flags;
-	}
-	info;
-	struct dx_entry	entries[0];
+	__le32 reserved_zero;
+	u8 hash_version;
+	u8 info_length; /* 8 */
+	u8 indirect_levels;
+	u8 unused_flags;
 };
 
 struct dx_node
@@ -217,6 +208,16 @@ ext4_next_entry(struct ext4_dir_entry_2 
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
+struct dx_root_info * dx_get_dx_info(struct ext4_dir_entry_2 *de)
+{
+       /* get dotdot first */
+       de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(1));
+
+       /* dx root info is after dotdot entry */
+       de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(2));
+
+       return (struct dx_root_info *) de;
+}
 
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
 {
@@ -371,7 +372,7 @@ dx_probe(const struct qstr *d_name, stru
 {
 	unsigned count, indirect;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info * info;
 	struct buffer_head *bh;
 	struct dx_frame *frame = frame_in;
 	u32 hash;
@@ -379,18 +380,18 @@ dx_probe(const struct qstr *d_name, stru
 	frame->bh = NULL;
 	if (!(bh = ext4_bread (NULL,dir, 0, 0, err)))
 		goto fail;
-	root = (struct dx_root *) bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
-	    root->info.hash_version != DX_HASH_HALF_MD4 &&
-	    root->info.hash_version != DX_HASH_LEGACY) {
+	info = dx_get_dx_info((struct ext4_dir_entry_2*)bh->b_data);
+	if (info->hash_version != DX_HASH_TEA &&
+	    info->hash_version != DX_HASH_HALF_MD4 &&
+	    info->hash_version != DX_HASH_LEGACY) {
 		ext4_warning(dir->i_sb, __func__,
 			     "Unrecognised inode hash code %d",
-			     root->info.hash_version);
+			     info->hash_version);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -398,29 +399,28 @@ dx_probe(const struct qstr *d_name, stru
 		ext4fs_dirhash(d_name->name, d_name->len, hinfo);
 	hash = hinfo->hash;
 
-	if (root->info.unused_flags & 1) {
+	if (info->unused_flags & 1) {
 		ext4_warning(dir->i_sb, __func__,
 			     "Unimplemented inode hash flags: %#06x",
-			     root->info.unused_flags);
+			     info->unused_flags);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
 
-	if ((indirect = root->info.indirect_levels) > 1) {
+	if ((indirect = info->indirect_levels) > 1) {
 		ext4_warning(dir->i_sb, __func__,
 			     "Unimplemented inode hash depth: %#06x",
-			     root->info.indirect_levels);
+			     info->indirect_levels);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
 
-	entries = (struct dx_entry *) (((char *)&root->info) +
-				       root->info.info_length);
+	entries = (struct dx_entry *) (((char *)info) + info->info_length);
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
+						   info->info_length)) {
 		ext4_warning(dir->i_sb, __func__,
 			     "dx entry: limit != root limit");
 		brelse(bh);
@@ -502,10 +502,12 @@ fail:
 
 static void dx_release (struct dx_frame *frames)
 {
+	struct dx_root_info *info;
 	if (frames[0].bh == NULL)
 		return;
 
-	if (((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels)
+	info = dx_get_dx_info((struct ext4_dir_entry_2*)frames[0].bh->b_data);
+	if (info->indirect_levels)
 		brelse(frames[1].bh);
 	brelse(frames[0].bh);
 }
@@ -1392,17 +1394,16 @@ static int make_indexed_dir(handle_t *ha
 	const char	*name = dentry->d_name.name;
 	int		namelen = dentry->d_name.len;
 	struct buffer_head *bh2;
-	struct dx_root	*root;
 	struct dx_frame	frames[2], *frame;
 	struct dx_entry *entries;
-	struct ext4_dir_entry_2	*de, *de2;
+	struct ext4_dir_entry_2 *de, *de2, *dot_de, *dotdot_de;
 	char		*data1, *top;
 	unsigned	len;
 	int		retval;
 	unsigned	blocksize;
 	struct dx_hash_info hinfo;
 	ext4_lblk_t  block;
-	struct fake_dirent *fde;
+	struct dx_root_info *dx_info;
 
 	blocksize =  dir->i_sb->s_blocksize;
 	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
@@ -1412,20 +1413,20 @@ static int make_indexed_dir(handle_t *ha
 		brelse(bh);
 		return retval;
 	}
-	root = (struct dx_root *) bh->b_data;
+	dot_de = (struct ext4_dir_entry_2 *) bh->b_data;
 
 	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len, blocksize));
-	if ((char *) de >= (((char *) root) + blocksize)) {
+	dotdot_de = ext4_next_entry(dot_de, blocksize);
+	de = ext4_next_entry(dotdot_de, blocksize);
+	len = ((char *) dot_de) + blocksize - (char *) de;
+
+	if ((char *) de >= (((char *) dot_de) + blocksize)) {
 		ext4_error(dir->i_sb, __func__,
 			   "invalid rec_len for '..' in inode %lu",
 			   dir->i_ino);
 		brelse(bh);
 		return -EIO;
 	}
-	len = ((char *) root) + blocksize - (char *) de;
 
 	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append(handle, dir, &block, &retval);
@@ -1444,19 +1445,23 @@ static int make_indexed_dir(handle_t *ha
 	de->rec_len = ext4_rec_len_to_disk(data1 + blocksize - (char *) de,
 					   blocksize);
 	/* Initialize the root; the dot dirents already exist */
-	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
-	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(2),
-					   blocksize);
-	memset (&root->info, 0, sizeof(root->info));
-	root->info.info_length = sizeof(root->info);
-	root->info.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
-	entries = root->entries;
+	dotdot_de->rec_len = ext4_rec_len_to_disk(blocksize -
+				 le16_to_cpu(dot_de->rec_len), blocksize);
+
+	/* initialize hashing info */
+	dx_info = dx_get_dx_info(dot_de);
+	memset(dx_info, 0, sizeof(*dx_info));
+	dx_info->info_length = sizeof(*dx_info);
+	dx_info->hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
+
+	entries = (void *)dx_info + sizeof(*dx_info);
+
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
+	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
-	hinfo.hash_version = root->info.hash_version;
+	hinfo.hash_version = dx_info->hash_version;
 	if (hinfo.hash_version <= DX_HASH_TEA)
 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -1630,6 +1635,8 @@ static int ext4_dx_add_entry(handle_t *h
 				goto journal_error;
 			brelse (bh2);
 		} else {
+			struct dx_root_info *info;
+
 			dxtrace(printk(KERN_DEBUG
 				       "Creating second level index...\n"));
 			memcpy((char *) entries2, (char *) entries,
@@ -1639,7 +1646,9 @@ static int ext4_dx_add_entry(handle_t *h
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels = 1;
+			info = dx_get_dx_info((struct ext4_dir_entry_2*)
+					frames[0].bh->b_data);
+			info->indirect_levels = 1;
 
 			/* Add new access path frame */
 			frame = frames + 1;

--Boundary_(ID_vyaxrBZR5tszK8/qpEuVHA)--
