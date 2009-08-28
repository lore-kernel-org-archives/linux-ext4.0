From: pravin shelar <Pravin.Shelar@Sun.COM>
Subject: Re: [RFC] new INCOMPAT flag for extended directory data
Date: Fri, 28 Aug 2009 11:19:46 +0530
Message-ID: <4A976FFA.4030604@sun.com>
References: <20090505202524.GL3209@webber.adilger.int>
 <20090820014058.GY5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_/LsvVqespgsiKeIDF+DCtQ)"
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59353 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZH1GDH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 02:03:07 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id n7S5mThW002050
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 05:48:42 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP200500NZ05200@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Fri,
 28 Aug 2009 13:48:29 +0800 (SGT)
In-reply-to: <20090820014058.GY5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_/LsvVqespgsiKeIDF+DCtQ)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

Hi
Here is code for ext4 extended dirent data feature.

these RFC patches adds facility in ext4 to have user data in every ext4 dirent.
lustre assigns cluserwide unique id to every inode in system, so we have added 
user data field in ext4 dirent to map filename to id efficiently.

i would like to get feedback on this as it might have some conflict with 64 bit 
inode work (which is in discussion phase).

patch[1] removes dx_root struct so that "." and ".." dirent can have extra data.
patch[2] add user data field to ext4 dirent.
patch[3] e2fs package changes for dirdata feature.

Thanks,
Pravin.

Andreas Dilger wrote:
> On May 05, 2009  14:25 -0600, Andreas Dilger wrote:
>> we're looking to store some extended data in each directory entry
>> for Lustre, to hold a 128-bit filesystem-unique file identifier
>> in the dirent.  If we ever wanted to look at 64-bit or larger
>> inode numbers we would need to do the same.
>>
>> In order to detect the presence of this extra data in the dirent, we
>> would want to use the high bits in d_type (say bits 0xf0).  This part
>> of d_type could be a flag for the presence of 4 different types of
>> data (which limits the number of different kinds of data).  The d_type
>> would mask off the high bits in get_dtype() so as not to confuse filldir.
> 
> Ted,
> could we at least reserve the INCOMPAT_DIRDATA flag to avoid conflicts:
> 
> #define EXT4_FEATURE_INCOMPAT_DIRDATA 0x1000
> 
> reserve the high 4 bits of d_type:
> 
> #define EXT4_DIRENT_LUFID 0x10	/* Lustre 128-bit unique file identifier */
> 
> 0x20, 0x40, and 0x80 would be available for future expansion (e.g. high
> 32 bits of inode number).  If needed, type 0x80 can be extended by adding
> a 1-byte subtype after the length byte, though I doubt this would be needed.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 


--Boundary_(ID_/LsvVqespgsiKeIDF+DCtQ)
Content-type: text/x-diff; name=ext4-kill-dx_root.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ext4-kill-dx_root.patch

Index: b/fs/ext4/namei.c
===================================================================
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -115,22 +115,13 @@ struct dx_entry
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
@@ -219,6 +210,16 @@ ext4_next_entry(struct ext4_dir_entry_2 
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
@@ -372,7 +373,7 @@ dx_probe(struct dentry *dentry, struct i
 {
 	unsigned count, indirect;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info * info;
 	struct buffer_head *bh;
 	struct dx_frame *frame = frame_in;
 	u32 hash;
@@ -382,46 +383,46 @@ dx_probe(struct dentry *dentry, struct i
 		dir = dentry->d_parent->d_inode;
 	if (!(bh = ext4_bread (NULL,dir, 0, 0, err)))
 		goto fail;
-	root = (struct dx_root *) bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
-	    root->info.hash_version != DX_HASH_HALF_MD4 &&
-	    root->info.hash_version != DX_HASH_LEGACY) {
+
+	info = dx_get_dx_info((struct ext4_dir_entry_2*)bh->b_data);
+	if (info->hash_version != DX_HASH_TEA &&
+	    info->hash_version != DX_HASH_HALF_MD4 &&
+	    info->hash_version != DX_HASH_LEGACY) {
 		ext4_warning(dir->i_sb, __func__,
 			     "Unrecognised inode hash code %d for directory "
-			     "#%lu", root->info.hash_version, dir->i_ino);
+			     "#%lu", info->hash_version, dir->i_ino);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	if (dentry)
 		ext4fs_dirhash(dentry->d_name.name, dentry->d_name.len, hinfo);
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
@@ -503,10 +504,12 @@ fail:
 
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
@@ -1424,17 +1427,16 @@ static int make_indexed_dir(handle_t *ha
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
 	dxtrace(printk("Creating index\n"));
@@ -1444,7 +1446,6 @@ static int make_indexed_dir(handle_t *ha
 		brelse(bh);
 		return retval;
 	}
-	root = (struct dx_root *) bh->b_data;
 
 	bh2 = ext4_append (handle, dir, &block, &retval);
 	if (!(bh2)) {
@@ -1454,11 +1455,13 @@ static int make_indexed_dir(handle_t *ha
 	EXT4_I(dir)->i_flags |= EXT4_INDEX_FL;
 	data1 = bh2->b_data;
 
+	dot_de = (struct ext4_dir_entry_2 *) bh->b_data;
+	dotdot_de = ext4_next_entry(dot_de);
+
 	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len));
-	len = ((char *) root) + blocksize - (char *) de;
+	de = (struct ext4_dir_entry_2 *)((char *)dotdot_de +
+		ext4_rec_len_from_disk(dotdot_de->rec_len));
+	len = ((char *) dot_de) + blocksize - (char *) de;
 	memcpy (data1, de, len);
 	de = (struct ext4_dir_entry_2 *) data1;
 	top = data1 + len;
@@ -1466,18 +1469,24 @@ static int make_indexed_dir(handle_t *ha
 		de = de2;
 	de->rec_len = ext4_rec_len_to_disk(data1 + blocksize - (char *) de);
 	/* Initialize the root; the dot dirents already exist */
-	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
-	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(2));
-	memset (&root->info, 0, sizeof(root->info));
-	root->info.info_length = sizeof(root->info);
-	root->info.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
-	entries = root->entries;
-	dx_set_block (entries, 1);
-	dx_set_count (entries, 1);
-	dx_set_limit (entries, dx_root_limit(dir, sizeof(root->info)));
+	dotdot_de->rec_len = ext4_rec_len_to_disk(blocksize -
+			le16_to_cpu(dot_de->rec_len));
+
+	/* initialize hashing info */
+	dx_info = dx_get_dx_info(dot_de);
+	memset (dx_info, 0, sizeof(*dx_info));
+	dx_info->info_length = sizeof(*dx_info);
+	dx_info->hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
+
+	entries = (void *)dx_info + sizeof(*dx_info);
+
+	dx_set_block(entries, 1);
+	dx_set_count(entries, 1);
+	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
-	hinfo.hash_version = root->info.hash_version;
+	hinfo.hash_version = dx_info->hash_version;
+
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	ext4fs_dirhash(name, namelen, &hinfo);
 	frame = frames;
@@ -1718,6 +1727,7 @@ static int ext4_dx_add_entry(handle_t *h
 				goto journal_error;
 			brelse (bh2);
 		} else {
+			struct dx_root_info * info;
 			dxtrace(printk("Creating second level index...\n"));
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
@@ -1726,7 +1736,9 @@ static int ext4_dx_add_entry(handle_t *h
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels = 1;
+			info = dx_get_dx_info((struct ext4_dir_entry_2*)
+					frames[0].bh->b_data);
+			info->indirect_levels = 1;
 
 			/* Add new access path frame */
 			frame = frames + 1;

--Boundary_(ID_/LsvVqespgsiKeIDF+DCtQ)--
