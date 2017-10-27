From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH 1/2] ext4: dirdata feature
Date: Fri, 27 Oct 2017 14:34:34 -0600
Message-ID: <1DDB6FA0-C555-4985-B647-FA6C2A64BF5B@dilger.ca>
References: <20171027172221.14072-1-artem.blagodarenko@gmail.com>
 <20171027172221.14072-2-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F007999A-B0DF-4880-A7CA-93245E653B31";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:55872 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbdJ0Uel (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 16:34:41 -0400
Received: by mail-io0-f194.google.com with SMTP id p186so15233181ioe.12
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 13:34:40 -0700 (PDT)
In-Reply-To: <20171027172221.14072-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F007999A-B0DF-4880-A7CA-93245E653B31
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> This patch implements feature which allows ext4 fs users (e.g. Lustre)
> to store data in ext4 dirent. Data is stored in ext4 dirent after
> file-name, this space is accounted in de->rec_len.
> Flag EXT4_DIRENT_LUFID added to d_type if extra data
> is present.
>=20
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

A couple of minor code style comments inline.

> ---
> fs/ext4/dir.c    |  17 +++++---
> fs/ext4/ext4.h   |  85 +++++++++++++++++++++++++++++++++++---
> fs/ext4/inline.c |  14 +++----
> fs/ext4/namei.c  | 122 =
++++++++++++++++++++++++++++++++++++++++++-------------
> fs/ext4/super.c  |   3 +-
> 5 files changed, 193 insertions(+), 48 deletions(-)
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index b04e882179c6..282279b66385 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -441,12 +441,17 @@ int ext4_htree_store_dirent(struct file =
*dir_file, __u32 hash,
> 	struct fname *fname, *new_fn;
> 	struct dir_private_info *info;
> 	int len;
> -
> +	int extra_data =3D 0;

(style) blank line after variable declaration

> 	info =3D dir_file->private_data;
> 	p =3D &info->root.rb_node;
>=20
> 	/* Create and allocate the fname structure */
> -	len =3D sizeof(struct fname) + ent_name->len + 1;
> +	if (dirent->file_type & ~EXT4_FT_MASK)
> +		extra_data =3D ext4_get_dirent_data_len(dirent);
> +
> +	len =3D sizeof(struct fname) + dirent->name_len + extra_data + =
1;
> +
> +
> 	new_fn =3D kzalloc(len, GFP_KERNEL);
> 	if (!new_fn)
> 		return -ENOMEM;
> @@ -455,7 +460,7 @@ int ext4_htree_store_dirent(struct file *dir_file, =
__u32 hash,
> 	new_fn->inode =3D le32_to_cpu(dirent->inode);
> 	new_fn->name_len =3D ent_name->len;
> 	new_fn->file_type =3D dirent->file_type;
> -	memcpy(new_fn->name, ent_name->name, ent_name->len);
> +	memcpy(new_fn->name, ent_name->name, ent_name->len + =
extra_data);
> 	new_fn->name[ent_name->len] =3D 0;
>=20
> 	while (*p) {
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index e2abe01c8c6b..aaaed29caa67 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1111,6 +1111,7 @@ struct ext4_inode_info {
>  * Mount flags set via mount options or defaults
>  */
> #define EXT4_MOUNT_NO_MBCACHE		0x00001 /* Do not use mbcache */
> +#define EXT4_MOUNT_DIRDATA		0x00002 /* Data in directory =
entries*/
> #define EXT4_MOUNT_GRPID		0x00004	/* Create files with =
directory's group */
> #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging =
messages */
> #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on =
errors */
> @@ -1804,7 +1805,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		=
ENCRYPT)
> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
> 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED =
| \
> -					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
> +					 EXT4_FEATURE_INCOMPAT_LARGEDIR =
| \
> +					 EXT4_FEATURE_INCOMPAT_DIRDATA)
> #define EXT4_FEATURE_RO_COMPAT_SUPP	=
(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> 					 =
EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
> 					 =
EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
> @@ -1965,6 +1967,45 @@ struct ext4_dir_entry_tail {
>=20
> #define EXT4_FT_DIR_CSUM	0xDE
>=20
> +#define EXT4_FT_MASK		0xf
> +
> +#if EXT4_FT_MAX > EXT4_FT_MASK
> +#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
> +#endif
> +
> +/*
> + * d_type has 4 unused bits, so it can hold four types data. these =
different
> + * type of data (e.g. lustre data, high 32 bits of 64-bit inode =
number) can be
> + * stored, in flag order, after file-name in ext4 dirent.
> +*/
> +/*
> + * this flag is added to d_type if ext4 dirent has extra data after
> + * filename. this data length is variable and length is stored in =
first byte
> + * of data. data start after filename NUL byte.
> + * This is used by Lustre FS.
> +  */
> +#define EXT4_DIRENT_LUFID		0x10
> +#define EXT4_DIRENT_INODE		0x20
> +#define DIRENT_INODE_LEN		2
> +
> +#define EXT4_LUFID_MAGIC    0xAD200907UL
> +struct ext4_dentry_param {
> +	__u32  edp_magic;	/* EXT4_LUFID_MAGIC */
> +	char   edp_len;		/* size of edp_data in bytes */
> +	char   edp_data[0];	/* packed array of data */
> +} __attribute__((packed));
> +
> +static inline unsigned char *ext4_dentry_get_data(struct super_block =
*sb,
> +		struct ext4_dentry_param* p)
> +{
> +	if (!ext4_has_feature_dirdata(sb))
> +		return NULL;
> +	if (p && p->edp_magic =3D=3D EXT4_LUFID_MAGIC)
> +		return &p->edp_len;
> +	else
> +		return NULL;
> +}
> +
> /*
>  * EXT4_DIR_PAD defines the directory entries boundaries
>  *
> @@ -1972,8 +2013,11 @@ struct ext4_dir_entry_tail {
>  */
> #define EXT4_DIR_PAD			4
> #define EXT4_DIR_ROUND			(EXT4_DIR_PAD - 1)
> -#define EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + =
EXT4_DIR_ROUND) & \
> +#define __EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + =
EXT4_DIR_ROUND) & \
> 					 ~EXT4_DIR_ROUND)
> +#define EXT4_DIR_REC_LEN(de)		(__EXT4_DIR_REC_LEN(de->name_len =
+\
> +					ext4_get_dirent_data_len(de)))
> +
> #define EXT4_MAX_REC_LEN		((1<<16)-1)
>=20
> /*
> @@ -2376,7 +2420,10 @@ extern int ext4_find_dest_de(struct inode *dir, =
struct inode *inode,
> 			     struct buffer_head *bh,
> 			     void *buf, int buf_size,
> 			     struct ext4_filename *fname,
> -			     struct ext4_dir_entry_2 **dest_de);
> +			     struct ext4_dir_entry_2 **dest_de,
> +			     bool is_dotdot,
> +			     bool *write_short_dotdot,
> +			     unsigned short dotdot_reclen);
> void ext4_insert_dentry(struct inode *inode,
> 			struct ext4_dir_entry_2 *de,
> 			int buf_size,
> @@ -2392,10 +2439,16 @@ static const unsigned char =
ext4_filetype_table[] =3D {
>=20
> static inline  unsigned char get_dtype(struct super_block *sb, int =
filetype)
> {
> -	if (!ext4_has_feature_filetype(sb) || filetype >=3D EXT4_FT_MAX)
> +	int fl_index =3D filetype & EXT4_FT_MASK;
> +
> +	if (!ext4_has_feature_filetype(sb) || fl_index >=3D EXT4_FT_MAX)
> 		return DT_UNKNOWN;
>=20
> -	return ext4_filetype_table[filetype];
> +	if (!test_opt(sb, DIRDATA))
> +		return (ext4_filetype_table[fl_index]);
> +
> +	return (ext4_filetype_table[fl_index]) |
> +		(filetype & ~EXT4_FT_MASK);
> }
> extern int ext4_check_all_de(struct inode *dir, struct buffer_head =
*bh,
> 			     void *buf, int buf_size);
> @@ -3271,6 +3324,28 @@ static inline void =
ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>=20
> extern const struct iomap_ops ext4_iomap_ops;
>=20
> +/*
> + * Compute the total directory entry data length.
> + * This includes the filename and an implicit NUL terminator (always =
present),
> + * and optional extensions.  Each extension has a bit set in the high =
4 bits of
> + * de->file_type, and the extension length is the first byte in each =
entry.
> + */
> +static inline int ext4_get_dirent_data_len(struct ext4_dir_entry_2 =
*de)
> +{
> +	char *len =3D de->name + de->name_len + 1 /* NUL terminator */;
> +	int dlen =3D 0;
> +	__u8 extra_data_flags =3D (de->file_type & ~EXT4_FT_MASK) >> 4;
> +
> +	while (extra_data_flags) {
> +		if (extra_data_flags & 1) {
> +			dlen +=3D *len + (dlen =3D=3D 0);
> +			len +=3D *len;
> +		}
> +		extra_data_flags >>=3D 1;
> +	}
> +	return dlen;
> +}
> +
> #endif	/* __KERNEL__ */
>=20
> #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 28c5c3abddb3..1405d315ae20 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1026,7 +1026,7 @@ static int ext4_add_dirent_to_inline(handle_t =
*handle,
> 	struct ext4_dir_entry_2 *de;
>=20
> 	err =3D ext4_find_dest_de(dir, inode, iloc->bh, inline_start,
> -				inline_size, fname, &de);
> +				inline_size, fname, &de, 0, NULL, 0);
> 	if (err)
> 		return err;
>=20
> @@ -1103,7 +1103,7 @@ static int ext4_update_inline_dir(handle_t =
*handle, struct inode *dir,
> 	int old_size =3D EXT4_I(dir)->i_inline_size - =
EXT4_MIN_INLINE_DATA_SIZE;
> 	int new_size =3D get_max_inline_xattr_value_size(dir, iloc);
>=20
> -	if (new_size - old_size <=3D EXT4_DIR_REC_LEN(1))
> +	if (new_size - old_size <=3D __EXT4_DIR_REC_LEN(1))
> 		return -ENOSPC;
>=20
> 	ret =3D ext4_update_inline_data(handle, dir,
> @@ -1384,7 +1384,7 @@ int htree_inlinedir_to_tree(struct file =
*dir_file,
> 			fake.name_len =3D 1;
> 			strcpy(fake.name, ".");
> 			fake.rec_len =3D ext4_rec_len_to_disk(
> -						=
EXT4_DIR_REC_LEN(fake.name_len),
> +						=
__EXT4_DIR_REC_LEN(fake.name_len),
> 						inline_size);
> 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
> 			de =3D &fake;
> @@ -1394,7 +1394,7 @@ int htree_inlinedir_to_tree(struct file =
*dir_file,
> 			fake.name_len =3D 2;
> 			strcpy(fake.name, "..");
> 			fake.rec_len =3D ext4_rec_len_to_disk(
> -						=
EXT4_DIR_REC_LEN(fake.name_len),
> +						=
__EXT4_DIR_REC_LEN(fake.name_len),
> 						inline_size);
> 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
> 			de =3D &fake;
> @@ -1492,8 +1492,8 @@ int ext4_read_inline_dir(struct file *file,
> 	 * So we will use extra_offset and extra_size to indicate them
> 	 * during the inline dir iteration.
> 	 */
> -	dotdot_offset =3D EXT4_DIR_REC_LEN(1);
> -	dotdot_size =3D dotdot_offset + EXT4_DIR_REC_LEN(2);
> +	dotdot_offset =3D __EXT4_DIR_REC_LEN(1);
> +	dotdot_size =3D dotdot_offset + __EXT4_DIR_REC_LEN(2);
> 	extra_offset =3D dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
> 	extra_size =3D extra_offset + inline_size;
>=20
> @@ -1528,7 +1528,7 @@ int ext4_read_inline_dir(struct file *file,
> 			 * failure will be detected in the
> 			 * dirent test below. */
> 			if (ext4_rec_len_from_disk(de->rec_len, =
extra_size)
> -				< EXT4_DIR_REC_LEN(1))
> +				< __EXT4_DIR_REC_LEN(1))
> 				break;
> 			i +=3D ext4_rec_len_from_disk(de->rec_len,
> 						    extra_size);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index c1cf020d1889..ccb6ca477bab 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -249,7 +249,8 @@ static unsigned dx_get_count(struct dx_entry =
*entries);
> static unsigned dx_get_limit(struct dx_entry *entries);
> static void dx_set_count(struct dx_entry *entries, unsigned value);
> static void dx_set_limit(struct dx_entry *entries, unsigned value);
> -static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
> +static inline unsigned dx_root_limit(struct inode *dir,
> +		struct ext4_dir_entry_2 *dot_de, unsigned infosize);
> static unsigned dx_node_limit(struct inode *dir);
> static struct dx_frame *dx_probe(struct ext4_filename *fname,
> 				 struct inode *dir,
> @@ -551,10 +552,16 @@ static inline void dx_set_limit(struct dx_entry =
*entries, unsigned value)
> 	((struct dx_countlimit *) entries)->limit =3D =
cpu_to_le16(value);
> }
>=20
> -static inline unsigned dx_root_limit(struct inode *dir, unsigned =
infosize)
> +static inline unsigned dx_root_limit(struct inode *dir,
> +		struct ext4_dir_entry_2 *dot_de, unsigned infosize)
> {
> -	unsigned entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(1) -
> -		EXT4_DIR_REC_LEN(2) - infosize;
> +	struct ext4_dir_entry_2 *dotdot_de;
> +	unsigned entry_space;
> +
> +	BUG_ON(dot_de->name_len !=3D 1);
> +	dotdot_de =3D ext4_next_entry(dot_de, dir->i_sb->s_blocksize);
> +	entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(dot_de) -
> +			 EXT4_DIR_REC_LEN(dotdot_de) - infosize;
>=20
> 	if (ext4_has_metadata_csum(dir->i_sb))
> 		entry_space -=3D sizeof(struct dx_tail);
> @@ -563,7 +570,7 @@ static inline unsigned dx_root_limit(struct inode =
*dir, unsigned infosize)
>=20
> static inline unsigned dx_node_limit(struct inode *dir)
> {
> -	unsigned entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(0);
> +	unsigned entry_space =3D dir->i_sb->s_blocksize - =
__EXT4_DIR_REC_LEN(0);
>=20
> 	if (ext4_has_metadata_csum(dir->i_sb))
> 		entry_space -=3D sizeof(struct dx_tail);
> @@ -675,7 +682,7 @@ static struct stats dx_show_leaf(struct inode =
*dir,
> 				       (unsigned) ((char *) de - base));
> #endif
> 			}
> -			space +=3D EXT4_DIR_REC_LEN(de->name_len);
> +			space +=3D EXT4_DIR_REC_LEN(de);
> 			names++;
> 		}
> 		de =3D ext4_next_entry(de, size);
> @@ -785,10 +792,14 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
> 				      root->info.info_length);
>=20
> 	if (dx_get_limit(entries) !=3D dx_root_limit(dir,
> -						   =
root->info.info_length)) {
> +				(struct ext4_dir_entry_2*) =
frame->bh->b_data,
> +				root->info.info_length)) {
> 		ext4_warning_inode(dir, "dx entry: limit %u !=3D root =
limit %u",
> 				   dx_get_limit(entries),
> -				   dx_root_limit(dir, =
root->info.info_length));
> +				   dx_root_limit(dir,
> +						 (struct =
ext4_dir_entry_2*)
> +						 frame->bh->b_data,
> +						 =
root->info.info_length));
> 		goto fail;
> 	}
>=20
> @@ -980,7 +991,7 @@ static int htree_dirblock_to_tree(struct file =
*dir_file,
> 	de =3D (struct ext4_dir_entry_2 *) bh->b_data;
> 	top =3D (struct ext4_dir_entry_2 *) ((char *) de +
> 					   dir->i_sb->s_blocksize -
> -					   EXT4_DIR_REC_LEN(0));
> +					   __EXT4_DIR_REC_LEN(0));
> #ifdef CONFIG_EXT4_FS_ENCRYPTION
> 	/* Check if the directory is encrypted */
> 	if (ext4_encrypted_inode(dir)) {
> @@ -1563,6 +1574,7 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 	inode =3D NULL;
> 	if (bh) {
> 		__u32 ino =3D le32_to_cpu(de->inode);
> +
> 		brelse(bh);
> 		if (!ext4_valid_inum(dir->i_sb, ino)) {
> 			EXT4_ERROR_INODE(dir, "bad inode number: %u", =
ino);
> @@ -1631,7 +1643,7 @@ dx_move_dirents(char *from, char *to, struct =
dx_map_entry *map, int count,
> 	while (count--) {
> 		struct ext4_dir_entry_2 *de =3D (struct ext4_dir_entry_2 =
*)
> 						(from + (map->offs<<2));
> -		rec_len =3D EXT4_DIR_REC_LEN(de->name_len);
> +		rec_len =3D EXT4_DIR_REC_LEN(de);
> 		memcpy (to, de, rec_len);
> 		((struct ext4_dir_entry_2 *) to)->rec_len =3D
> 				ext4_rec_len_to_disk(rec_len, =
blocksize);
> @@ -1655,7 +1667,7 @@ static struct ext4_dir_entry_2* =
dx_pack_dirents(char *base, unsigned blocksize)
> 	while ((char*)de < base + blocksize) {
> 		next =3D ext4_next_entry(de, blocksize);
> 		if (de->inode && de->name_len) {
> -			rec_len =3D EXT4_DIR_REC_LEN(de->name_len);
> +			rec_len =3D EXT4_DIR_REC_LEN(de);
> 			if (de > to)
> 				memmove(to, de, rec_len);
> 			to->rec_len =3D ext4_rec_len_to_disk(rec_len, =
blocksize);
> @@ -1786,10 +1798,13 @@ int ext4_find_dest_de(struct inode *dir, =
struct inode *inode,
> 		      struct buffer_head *bh,
> 		      void *buf, int buf_size,
> 		      struct ext4_filename *fname,
> -		      struct ext4_dir_entry_2 **dest_de)
> +		      struct ext4_dir_entry_2 **dest_de,
> +		      bool is_dotdot,
> +		      bool *write_short_dotdot,
> +		      unsigned short dotdot_reclen)
> {
> 	struct ext4_dir_entry_2 *de;
> -	unsigned short reclen =3D EXT4_DIR_REC_LEN(fname_len(fname));
> +	unsigned short reclen =3D __EXT4_DIR_REC_LEN(fname_len(fname));
> 	int nlen, rlen;
> 	unsigned int offset =3D 0;
> 	char *top;
> @@ -1802,10 +1817,26 @@ int ext4_find_dest_de(struct inode *dir, =
struct inode *inode,
> 			return -EFSCORRUPTED;
> 		if (ext4_match(fname, de))
> 			return -EEXIST;
> -		nlen =3D EXT4_DIR_REC_LEN(de->name_len);
> +		nlen =3D EXT4_DIR_REC_LEN(de);
> 		rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
> +		/* Check first for enough space for the full entry */
> 		if ((de->inode ? rlen - nlen : rlen) >=3D reclen)
> 			break;
> +		/* Then for dotdot entries, check for the smaller space
> +		 * required for just the entry, no FID */
> +		if (is_dotdot) {
> +			if ((de->inode ? rlen - nlen : rlen) >=3D
> +			    dotdot_reclen) {
> +				*write_short_dotdot =3D true;
> +				break;
> +			}
> +			/* The new ".." entry mut be written over the
> +			 * previous ".." entry, which is the first
> +			 * entry traversed by this scan.  If it doesn't
> +			 * fit, something is badly wrong, so -EIO. */
> +			return -EIO;
> +		}
> +
> 		de =3D (struct ext4_dir_entry_2 *)((char *)de + rlen);
> 		offset +=3D rlen;
> 	}
> @@ -1824,7 +1855,8 @@ void ext4_insert_dentry(struct inode *inode,
>=20
> 	int nlen, rlen;
>=20
> -	nlen =3D EXT4_DIR_REC_LEN(de->name_len);
> +	nlen =3D EXT4_DIR_REC_LEN(de);
> +
> 	rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
> 	if (de->inode) {
> 		struct ext4_dir_entry_2 *de1 =3D
> @@ -1848,21 +1880,45 @@ void ext4_insert_dentry(struct inode *inode,
>  * space.  It will return -ENOSPC if no space is available, and -EIO
>  * and -EEXIST if directory entry already exists.
>  */
> -static int add_dirent_to_buf(handle_t *handle, struct ext4_filename =
*fname,
> +static int add_dirent_to_buf(handle_t *handle,
> +			     struct dentry *dentry,
> +			     struct ext4_filename *fname,
> 			     struct inode *dir,
> 			     struct inode *inode, struct =
ext4_dir_entry_2 *de,
> 			     struct buffer_head *bh)
> {
> 	unsigned int	blocksize =3D dir->i_sb->s_blocksize;
> 	int		csum_size =3D 0;
> -	int		err;
> +	unsigned short	reclen, dotdot_reclen =3D 0;
> +	int		 err, dlen =3D 0;
> +	bool		is_dotdot =3D false, write_short_dotdot =3D =
false;
> +	unsigned char	*data;
> +	int namelen =3D dentry->d_name.len;
>=20
> 	if (ext4_has_metadata_csum(inode->i_sb))
> 		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>=20
> +	data =3D ext4_dentry_get_data(inode->i_sb, (struct =
ext4_dentry_param *)
> +						dentry->d_fsdata);
> +	if (data)
> +		dlen =3D (*data) + 1;
> +
> +	is_dotdot =3D (namelen =3D=3D 2 &&
> +		     memcmp(dentry->d_name.name, "..", 2) =3D=3D 0);
> +
> +	/* dotdot entries must be in the second place in a directory =
block,
> +	 * so calculate an alternate length without the dirdata so they =
can
> +	 * always be made to fit in the existing slot */
> +	if (is_dotdot)
> +		dotdot_reclen =3D __EXT4_DIR_REC_LEN(namelen);
> +
> +	reclen =3D __EXT4_DIR_REC_LEN(namelen + dlen + 3);
> +
> 	if (!de) {
> 		err =3D ext4_find_dest_de(dir, inode, bh, bh->b_data,
> -					blocksize - csum_size, fname, =
&de);
> +					blocksize - csum_size, fname, =
&de,
> +					is_dotdot,
> +					&write_short_dotdot, =
dotdot_reclen);
> 		if (err)
> 			return err;
> 	}
> @@ -1876,6 +1932,13 @@ static int add_dirent_to_buf(handle_t *handle, =
struct ext4_filename *fname,
> 	/* By now the buffer is marked for journaling */
> 	ext4_insert_dentry(inode, de, blocksize, fname);
>=20
> +	/* If we're writing the short form of "dotdot", don't add the =
data section */

Wrap at 80 columns.  Maybe just drop "the"x2 to shorten it?

> +	if (data && !write_short_dotdot) {
> +		de->name[namelen] =3D 0;
> +		memcpy(&de->name[namelen + 1], data, *(char *) data);

(style) no space after typecast

> +		de->file_type |=3D EXT4_DIRENT_LUFID;
> +	}
>=20

> 	/*
> 	 * XXX shouldn't update any times until successful
> 	 * completion of syscall, but too many callers depend
> @@ -1970,7 +2033,7 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
>=20
> 	/* Initialize the root; the dot dirents already exist */
> 	de =3D (struct ext4_dir_entry_2 *) (&root->dotdot);
> -	de->rec_len =3D ext4_rec_len_to_disk(blocksize - =
EXT4_DIR_REC_LEN(2),
> +	de->rec_len =3D ext4_rec_len_to_disk(blocksize - =
__EXT4_DIR_REC_LEN(2),
> 					   blocksize);
> 	memset (&root->info, 0, sizeof(root->info));
> 	root->info.info_length =3D sizeof(root->info);
> @@ -1978,7 +2041,8 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
> 	entries =3D root->entries;
> 	dx_set_block(entries, 1);
> 	dx_set_count(entries, 1);
> -	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
> +	dx_set_limit(entries, dx_root_limit(dir,
> +					 fde, sizeof(root->info)));
>=20
> 	/* Initialize as for dx_probe */
> 	fname->hinfo.hash_version =3D root->info.hash_version;
> @@ -2006,7 +2070,7 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
> 		goto out_frames;
> 	}
>=20
> -	retval =3D add_dirent_to_buf(handle, fname, dir, inode, de, =
bh2);
> +	retval =3D add_dirent_to_buf(handle, NULL, fname, dir, inode, =
de, bh2);
> out_frames:
> 	/*
> 	 * Even if the block split failed, we have to properly write
> @@ -2083,7 +2147,7 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
> 			bh =3D NULL;
> 			goto out;
> 		}
> -		retval =3D add_dirent_to_buf(handle, &fname, dir, inode,
> +		retval =3D add_dirent_to_buf(handle, dentry, &fname, =
dir, inode,
> 					   NULL, bh);
> 		if (retval !=3D -ENOSPC)
> 			goto out;
> @@ -2112,7 +2176,7 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
> 		initialize_dirent_tail(t, blocksize);
> 	}
>=20
> -	retval =3D add_dirent_to_buf(handle, &fname, dir, inode, de, =
bh);
> +	retval =3D add_dirent_to_buf(handle, dentry, &fname, dir, inode, =
de, bh);
> out:
> 	ext4_fname_free_filename(&fname);
> 	brelse(bh);
> @@ -2154,7 +2218,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> 	if (err)
> 		goto journal_error;
>=20
> -	err =3D add_dirent_to_buf(handle, fname, dir, inode, NULL, bh);
> +	err =3D add_dirent_to_buf(handle, NULL, fname, dir, inode, NULL, =
bh);
> 	if (err !=3D -ENOSPC)
> 		goto cleanup;
>=20
> @@ -2279,7 +2343,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> 		err =3D PTR_ERR(de);
> 		goto cleanup;
> 	}
> -	err =3D add_dirent_to_buf(handle, fname, dir, inode, de, bh);
> +	err =3D add_dirent_to_buf(handle, NULL, fname, dir, inode, de, =
bh);
> 	goto cleanup;
>=20
> journal_error:
> @@ -2545,7 +2609,7 @@ struct ext4_dir_entry_2 =
*ext4_init_dot_dotdot(struct inode *inode,
> {
> 	de->inode =3D cpu_to_le32(inode->i_ino);
> 	de->name_len =3D 1;
> -	de->rec_len =3D =
ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
> +	de->rec_len =3D ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de),
> 					   blocksize);
> 	strcpy(de->name, ".");
> 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
> @@ -2555,11 +2619,11 @@ struct ext4_dir_entry_2 =
*ext4_init_dot_dotdot(struct inode *inode,
> 	de->name_len =3D 2;
> 	if (!dotdot_real_len)
> 		de->rec_len =3D ext4_rec_len_to_disk(blocksize -
> -					(csum_size + =
EXT4_DIR_REC_LEN(1)),
> +					(csum_size + =
__EXT4_DIR_REC_LEN(1)),
> 					blocksize);
> 	else
> 		de->rec_len =3D ext4_rec_len_to_disk(
> -				EXT4_DIR_REC_LEN(de->name_len), =
blocksize);
> +				EXT4_DIR_REC_LEN(de), blocksize);
> 	strcpy(de->name, "..");
> 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
>=20
> @@ -2688,7 +2752,7 @@ bool ext4_empty_dir(struct inode *inode)
> 	}
>=20
> 	sb =3D inode->i_sb;
> -	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)) {
> +	if (inode->i_size < __EXT4_DIR_REC_LEN(1) + =
__EXT4_DIR_REC_LEN(2)) {
> 		EXT4_ERROR_INODE(inode, "invalid size");
> 		return true;
> 	}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b0915b734a38..ead9406d9cff 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1339,7 +1339,7 @@ enum {
> 	Opt_data_err_abort, Opt_data_err_ignore, =
Opt_test_dummy_encryption,
> 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, =
Opt_offgrpjquota,
> 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
> -	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
> +	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err, Opt_dirdata,
> 	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version, =
Opt_dax,
> 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
> 	Opt_lazytime, Opt_nolazytime, Opt_debug_want_extra_isize,
> @@ -1400,6 +1400,7 @@ static const match_table_t tokens =3D {
> 	{Opt_noquota, "noquota"},
> 	{Opt_quota, "quota"},
> 	{Opt_usrquota, "usrquota"},
> +	{Opt_dirdata, "dirdata"},
> 	{Opt_prjquota, "prjquota"},
> 	{Opt_barrier, "barrier=3D%u"},
> 	{Opt_barrier, "barrier"},
> --
> 2.13.5 (Apple Git-94)
>=20


Cheers, Andreas






--Apple-Mail=_F007999A-B0DF-4880-A7CA-93245E653B31
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ85hbpIg59Q01vtYRAvvyAKCl3fBItp944wRII9wMvKKskEuSsgCgpYxI
bmWCMLczme4QvDKaIE03Jw4=
=fIbH
-----END PGP SIGNATURE-----

--Apple-Mail=_F007999A-B0DF-4880-A7CA-93245E653B31--
