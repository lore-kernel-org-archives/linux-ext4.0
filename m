From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Proposal draft for data checksumming for ext4
Date: Mon, 28 Apr 2014 14:16:27 -0600
Message-ID: <05B7E436-A365-41C5-91F6-07E3B3B59B53@dilger.ca>
References: <alpine.LFD.2.00.1403201736280.8407@localhost.localdomain> <20140320175950.GJ9070@birch.djwong.org> <87a9b5ctls.fsf@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_01CD7AC3-7C56-4120-9BE3-493960936E8B"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57760 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaD1UQy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2014 16:16:54 -0400
Received: by mail-pd0-f169.google.com with SMTP id y13so5222024pdi.0
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2014 13:16:53 -0700 (PDT)
In-Reply-To: <87a9b5ctls.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_01CD7AC3-7C56-4120-9BE3-493960936E8B
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_0F9FC055-1247-4184-8868-7D77501316AD"


--Apple-Mail=_0F9FC055-1247-4184-8868-7D77501316AD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Apr 28, 2014, at 10:21 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
>> On Thu, Mar 20, 2014 at 05:40:06PM +0100, Luk=E1=9A Czerner wrote:
>>> There are also other problems we should be concerned with. Ext4 file =
system
>>> does have support for metadata checksumming so all the metadata does =
have
>>> its own checksum. While we can avoid unnecessarily checksuming =
inodes, group
>>> descriptors and basicall all statically positioned metadata, we =
still have
>>> dynamically allocated metadata blocks such as extent blocks. These =
block
>>> do not have to be checksummed but we would still have space reserved =
in the
>>> checksum table.
>>=20
>> Don't forget directory blocks--they (should) have checksums too, so =
you can
>> skip those.
>=20
> Just quick note: We can hide checksum for directory inside
> ext4_dir_entry_2 for a special dirs '.' or '..' simply by increasing
> ->rec_len which make this feature compatible with older FS

First note - the htree index information for each directory is already
stored after the ".." entry in block 0 of the directory.

Also note that there is also a feature we developed for Lustre named
"dirdata" (EXT4_FEATURE_INCOMPAT_DIRDATA is already reserved) that
allows storing more information with each directory entry[*].  We
use this to store a 128-bit identifier with each object so that it is
unique across the cluster, so it is available efficiently for readdir.

We've needed to modify the handling of the htree index data so that
it properly skips the extended directory entry (patch attached), and
this also cleans up this code a bit to conform to modern coding style.
Without this patch, the htree code assumes that the dx_info struct is
immediately following hard-coded "." and ".." entries and does not
actually check the de->rec_len for these entries to determine the right
amount of data to skip.

The patch is based on an older kernel and may not apply directly to
mainline, but is required for any similar changes in this area.

That said, I think that Darrick's metadata checksum patches already
store per-directory-block checksums at the end of the directory in
a dummy entry, so I'm not sure what else is needed here?

Cheers, Andreas

[*] for reference the dirdata patch is at =
http://git.hpdd.intel.com/?p=3Dfs/lustre-release.git;a=3Dblob;f=3Dldiskfs/=
kernel_patches/patches/sles11sp2/ext4-data-in-dirent.patch


--Apple-Mail=_0F9FC055-1247-4184-8868-7D77501316AD
Content-Disposition: attachment;
	filename=ext4-kill-dx_root.patch
Content-Type: application/octet-stream;
	name="ext4-kill-dx_root.patch"
Content-Transfer-Encoding: 7bit

diff -r -u linux-stage.orig/fs/ext4/namei.c linux-stage/fs/ext4/namei.c
--- linux-stage.orig/fs/ext4/namei.c	2012-12-31 15:03:28.000000000 -0500
+++ linux-stage/fs/ext4/namei.c	2012-12-31 15:06:16.000000000 -0500
@@ -115,22 +115,13 @@
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
@@ -220,6 +211,17 @@
 	ext3_rec_len_from_disk(p->rec_len));
 }
  
+struct dx_root_info *dx_get_dx_info(char *buf)
+{
+	struct ext4_dir_entry_2 *de = buf;
+
+	/* get dotdot first, then dx_info is right after dotdot entry */
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(1));
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(2));
+
+	return (struct dx_root_info *)de;
+}
+
 /*
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
@@ -374,7 +375,7 @@
 {
 	unsigned count, indirect;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info *dx_info;
 	struct buffer_head *bh;
 	struct dx_frame *frame = frame_in;
 	u32 hash;
@@ -382,17 +383,18 @@
 	frame->bh = NULL;
 	if (!(bh = ext4_bread (NULL,dir, 0, 0, err)))
 		goto fail;
-	root = (struct dx_root *) bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
-	    root->info.hash_version != DX_HASH_HALF_MD4 &&
-	    root->info.hash_version != DX_HASH_LEGACY) {
-		ext4_warning(dir->i_sb, "Unrecognised inode hash code %d for directory "
-                             "#%lu", root->info.hash_version, dir->i_ino);
+
+	dx_info = dx_get_dx_info(bh->b_data);
+	if (dx_info->hash_version != DX_HASH_TEA &&
+	    dx_info->hash_version != DX_HASH_HALF_MD4 &&
+	    dx_info->hash_version != DX_HASH_LEGACY) {
+		ext4_warning(dir->i_sb, "Unknown inode hash code %u for "
+			    "directory %lu", dx_info->hash_version, dir->i_ino);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = dx_info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -400,27 +402,25 @@
 		ext4fs_dirhash(d_name->name, d_name->len, hinfo);
 	hash = hinfo->hash;
 
-	if (root->info.unused_flags & 1) {
+	if (dx_info->unused_flags & 1) {
 		ext4_warning(dir->i_sb, "Unimplemented inode hash flags: %#06x",
-			     root->info.unused_flags);
+			     dx_info->unused_flags);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
 
-	if ((indirect = root->info.indirect_levels) > 1) {
+	indirect = dx_info->indirect_levels;
+	if (indirect > 1) {
 		ext4_warning(dir->i_sb, "Unimplemented inode hash depth: %#06x",
-			     root->info.indirect_levels);
+			     dx_info->indirect_levels);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
 
-	entries = (struct dx_entry *) (((char *)&root->info) +
-				       root->info.info_length);
-
-	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
+	entries = (struct dx_entry *)((char *)dx_info + dx_info->info_length);
+	if (dx_get_limit(entries) != dx_root_limit(dir, dx_info->info_length)) {
 		ext4_warning(dir->i_sb, "dx entry: limit != root limit");
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
@@ -504,7 +505,7 @@
 	if (frames[0].bh == NULL)
 		return;
 
-	if (((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels)
+	if (dx_get_dx_info(frames[0].bh->b_data)->indirect_levels)
 		brelse(frames[1].bh);
 	brelse(frames[0].bh);
 }
@@ -1400,17 +1403,16 @@
 	const char	*name = dentry->d_name.name;
 	int		namelen = dentry->d_name.len;
 	struct buffer_head *bh2;
-	struct dx_root	*root;
+	struct dx_root_info *dx_info;
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
 
 	blocksize =  dir->i_sb->s_blocksize;
 	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
@@ -1420,18 +1422,18 @@
 		brelse(bh);
 		return retval;
 	}
-	root = (struct dx_root *) bh->b_data;
+
+	dot_de = (struct ext4_dir_entry_2 *)bh->b_data;
+	dotdot_de = ext4_next_entry(dot_de, blocksize);
 
 	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len, blocksize));
-	if ((char *) de >= (((char *) root) + blocksize)) {
+	de = ext4_next_entry(dotdot_de, blocksize);
+	if ((char *)de >= bh->b_data + blocksize) {
 		EXT4_ERROR_INODE(dir, "invalid rec_len for '..'");
 		brelse(bh);
 		return -EIO;
 	}
-	len = ((char *) root) + blocksize - (char *) de;
+	len = (char *)dot_de + blocksize - (char *)de;
 
 	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append(handle, dir, &block, &retval);
@@ -1450,19 +1453,21 @@
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
+			le16_to_cpu(dot_de->rec_len), blocksize);
+
+	/* initialize hashing dx_info */
+	dx_info = dx_get_dx_info(bh->b_data);
+	memset(dx_info, 0, sizeof(*dx_info));
+	dx_info->info_length = sizeof(*dx_info);
+	dx_info->hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
+	entries = (void *)dx_info + sizeof(*dx_info);
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
@@ -1732,7 +1740,7 @@
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels = 1;
+			dx_get_dx_info(frames->bh->b_data)->indirect_levels = 1;
 
 			/* Add new access path frame */
 			frame = frames + 1;

--Apple-Mail=_0F9FC055-1247-4184-8868-7D77501316AD
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



--Apple-Mail=_0F9FC055-1247-4184-8868-7D77501316AD--

--Apple-Mail=_01CD7AC3-7C56-4120-9BE3-493960936E8B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU163G3Kl2rkXzB/gAQIAqxAArLYhG67cSadV6BU3/iAqyjjsQlNUII8D
ZrXCn0YfC1XCPeK0cyDcwdCn0cpj3MhRslVX55cFZeKQ2b4CUVfF7C7S+Yfr2R5u
qATmqFcWLHNDFqMekmcHSLVJn9XFQeBOPT+pI2Hj91x+9Qui+4P7Dwdz2uXgNCFn
SJcSHd0+vPi/CkwWg2WJHt3bNTxFAQ3j0eRhMXqYWAWPWRgNFe6sEygdBINAxBvq
Z9afscA/WH8kTor0kKary8oiSWT1zFsCiJVGDl1rL4mio4zF9rxSL+QHN234RPQW
uHsGD6VNHO69MOo22KcAn4kh55joHuXxUVOY874hEkZjw3N0DNFwpytKHhPCu0dx
SCzr2KRZNltpYc5cN3seLq3pJO3F06sh5ynTlOLgQf85/L+i4yxyl42FCAJMaVaV
TI0T7H9vjTnF+GxhbZvJ5CPpPcErA7x0y8uvJFtZH+a8RXWci7fBjXdR36mWIE6s
c7rxMUObuJglkN/yf2ppyEmMPRDBhPP6m9O0CgZNWIrMeakuwMt1hOb3sfLbCXfv
Nzny0ZTcme/INIZXfF8463f81ZZFzOn6rLrAWVf/yTj8S6Y0m1k4qvRk3VODoe5r
Jxc2vMgSJnqbIG5D/gvjK2Cakj+6e6jdEiFjqECHNxUtKeGZrU3LNYxHCWREpCCN
gRwI0hjbrGw=
=WUsx
-----END PGP SIGNATURE-----

--Apple-Mail=_01CD7AC3-7C56-4120-9BE3-493960936E8B--
