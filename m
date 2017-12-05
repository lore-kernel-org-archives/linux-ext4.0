From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 2/3] ext4: dirdata feature
Date: Mon, 4 Dec 2017 18:02:14 -0700
Message-ID: <9E70AB29-5164-47AD-9DE3-EEEF349BEEB1@dilger.ca>
References: <20171130151753.24986-1-artem.blagodarenko@gmail.com>
 <20171130151753.24986-3-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_66902FEE-33CD-4C85-AA5A-4A273A87D31C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:43245 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLEBCX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2017 20:02:23 -0500
Received: by mail-it0-f65.google.com with SMTP id u62so17500283ita.2
        for <linux-ext4@vger.kernel.org>; Mon, 04 Dec 2017 17:02:22 -0800 (PST)
In-Reply-To: <20171130151753.24986-3-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_66902FEE-33CD-4C85-AA5A-4A273A87D31C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 30, 2017, at 8:17 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Andreas Dilger <andreas.dilger@intel.com>
>=20
> This patch implements feature which allows ext4 fs users (e.g. Lustre)
> to store data in ext4 dirent. Data is stored in ext4 dirent after
> file-name, this space is accounted in de->rec_len.
> Flag EXT4_DIRENT_LUFID added to d_type if extra data
> is present.
>=20
> Make use of dentry->d_fsdata to pass fid to ext4. so no
> changes in ext4_add_entry() interface required.
>=20
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> fs/ext4/dir.c    |  17 ++++---
> fs/ext4/ext4.h   |  99 ++++++++++++++++++++++++++++++++++++++---
> fs/ext4/inline.c |  18 ++++----
> fs/ext4/namei.c  | 132 =
++++++++++++++++++++++++++++++++++++++++++-------------
> fs/ext4/super.c  |   3 +-
> 5 files changed, 218 insertions(+), 51 deletions(-)
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index b04e882179c6..0c4dddb0f07a 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -67,11 +67,11 @@ int __ext4_check_dir_entry(const char *function, =
unsigned int line,
> 	const int rlen =3D ext4_rec_len_from_disk(de->rec_len,
> 						dir->i_sb->s_blocksize);
>=20
> -	if (unlikely(rlen < EXT4_DIR_REC_LEN(1)))
> +	if (unlikely(rlen < EXT4_DIR_NAME_LEN(1)))
> 		error_msg =3D "rec_len is smaller than minimal";
> 	else if (unlikely(rlen % 4 !=3D 0))
> 		error_msg =3D "rec_len % 4 !=3D 0";
> -	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de->name_len)))
> +	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de)))
> 		error_msg =3D "rec_len is too small for name_len";
> 	else if (unlikely(((char *) de - buf) + rlen > size))
> 		error_msg =3D "directory entry across range";
> @@ -218,7 +218,8 @@ static int ext4_readdir(struct file *file, struct =
dir_context *ctx)
> 				 * failure will be detected in the
> 				 * dirent test below. */
> 				if (ext4_rec_len_from_disk(de->rec_len,
> -					sb->s_blocksize) < =
EXT4_DIR_REC_LEN(1))
> +						sb->s_blocksize) <

This could be aligned after second '(' on previous line.

> +						EXT4_DIR_NAME_LEN(1))

This should be aligned after 'if ('

> @@ -441,12 +442,18 @@ int ext4_htree_store_dirent(struct file =
*dir_file, __u32 hash,
> 	struct fname *fname, *new_fn;
> 	struct dir_private_info *info;
> 	int len;
> +	int extra_data =3D 0;
>=20
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

Remove extra blank line here.

> 	new_fn =3D kzalloc(len, GFP_KERNEL);
> 	if (!new_fn)
> 		return -ENOMEM;
> @@ -455,7 +462,7 @@ int ext4_htree_store_dirent(struct file *dir_file, =
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
> index e2abe01c8c6b..3678657d8e47 100644
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
> @@ -1965,6 +1967,56 @@ struct ext4_dir_entry_tail {
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
> + */
> +/*
> + * this flag is added to d_type if ext4 dirent has extra data after
> + * filename. this data length is variable and length is stored in =
first byte
> + * of data. data start after filename NUL byte.
> + * This is used by Lustre FS.
> + */
> +#define EXT4_DIRENT_LUFID		0x10
> +#define EXT4_DIRENT_INODE		0x20
> +#define DIRENT_INODE_LEN		2

Shouldn't DIRENT_INODE_LEN be 4 bytes?  This should probably be added in =
the
next patch in any case.

> +
> +#define EXT4_LUFID_MAGIC    0xAD200907UL
> +
> +struct ext4_dirent_data_header {
> +	/* length of this header + the whole data blob */
> +	__u8	ddh_length;
> +} __packed;
> +
> +struct ext4_dirent_lufid {
> +	struct ext4_dirent_data_header	dl_header; /* 1 + 16n */
> +	__u8				dl_data[0];
> +} __packed;
> +
> +struct ext4_dentry_param {
> +	__u32				edp_magic; /* EXT4_LUFID_MAGIC =
*/
> +	struct ext4_dirent_lufid	edp_lufid;
> +} __packed;
> +
> +static inline struct ext4_dirent_data_header *
> +	ext4_dentry_get_data(struct super_block *sb,

IMHO, this declaration would be formatted better like:

static inline
struct ext4_dirent_data_header *ext4_dentry_get_data(struct super_block =
*sb,
						    struct =
ext4_dentry_param *p)

> +{
> +	if (!ext4_has_feature_dirdata(sb))
> +		return NULL;
> +	if (p && p->edp_magic =3D=3D EXT4_LUFID_MAGIC)
> +		return &p->edp_lufid.dl_header;
> +	else
> +		return NULL;
> +}
> +
> /*
>  * EXT4_DIR_PAD defines the directory entries boundaries
>  *
> @@ -1972,8 +2024,14 @@ struct ext4_dir_entry_tail {
>  */
> #define EXT4_DIR_PAD			4
> #define EXT4_DIR_ROUND			(EXT4_DIR_PAD - 1)
> -#define EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + =
EXT4_DIR_ROUND) & \
> +
> +/* the name + inode data without  any extra dirdata */

two spaces before "any"

> +#define EXT4_DIR_NAME_LEN(name_len)	(((name_len) + 8 + =
EXT4_DIR_ROUND) & \
> 					 ~EXT4_DIR_ROUND)
> +/* the total size of the dirent including any extra data */

... extra dirdata

> +#define EXT4_DIR_REC_LEN(de)		(EXT4_DIR_NAME_LEN(de->name_len =
+\
> +					ext4_get_dirent_data_len(de)))
> +
> #define EXT4_MAX_REC_LEN		((1<<16)-1)
>=20
> /*
> @@ -2376,7 +2434,10 @@ extern int ext4_find_dest_de(struct inode *dir, =
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
> @@ -2392,10 +2453,16 @@ static const unsigned char =
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
> @@ -3271,6 +3338,28 @@ static inline void =
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

I think what Darrick had intended here was to cast the dirdata into =
struct
ext4_dirent_data_header so that "*len" was not being used directly:

	struct ext4_dirent_data_header *ddh =3D (void *)(de->name + =
de->name_len + 1);

> +	int dlen =3D 0;
> +	__u8 extra_data_flags =3D (de->file_type & ~EXT4_FT_MASK) >> 4;
> +
> +	while (extra_data_flags) {
> +		if (extra_data_flags & 1) {
> +			dlen +=3D *len + (dlen =3D=3D 0);
> +			len +=3D *len;
> +		}

Then ddh->ddh_length is accessed here instead of "*len" like, maybe with
a helper like:

#define ext4_dirdata_next(ddh) \
	(struct ext4_dirent_data_header *)((char *)ddh + =
ddh->ddh_length)

		if (extra_data_flags & 1) {
			dlen +=3D ddh->ddh_length + (dlen =3D=3D 0);
			ddh =3D ext4_dirdata_next(ddh);
		}

> +		extra_data_flags >>=3D 1;
> +	}
> +	return dlen;
> +}
> +
> #endif	/* __KERNEL__ */
>=20
> #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 28c5c3abddb3..666891dc03cd 100644
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
> +	if (new_size - old_size <=3D EXT4_DIR_NAME_LEN(1))
> 		return -ENOSPC;
>=20
> 	ret =3D ext4_update_inline_data(handle, dir,
> @@ -1384,8 +1384,8 @@ int htree_inlinedir_to_tree(struct file =
*dir_file,
> 			fake.name_len =3D 1;
> 			strcpy(fake.name, ".");
> 			fake.rec_len =3D ext4_rec_len_to_disk(
> -						=
EXT4_DIR_REC_LEN(fake.name_len),
> -						inline_size);
> +					=
EXT4_DIR_NAME_LEN(fake.name_len),
> +					inline_size);
> 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
> 			de =3D &fake;
> 			pos =3D EXT4_INLINE_DOTDOT_OFFSET;
> @@ -1394,8 +1394,8 @@ int htree_inlinedir_to_tree(struct file =
*dir_file,
> 			fake.name_len =3D 2;
> 			strcpy(fake.name, "..");
> 			fake.rec_len =3D ext4_rec_len_to_disk(
> -						=
EXT4_DIR_REC_LEN(fake.name_len),
> -						inline_size);
> +					=
EXT4_DIR_NAME_LEN(fake.name_len),
> +					inline_size);
> 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
> 			de =3D &fake;
> 			pos =3D EXT4_INLINE_DOTDOT_SIZE;
> @@ -1492,8 +1492,8 @@ int ext4_read_inline_dir(struct file *file,
> 	 * So we will use extra_offset and extra_size to indicate them
> 	 * during the inline dir iteration.
> 	 */
> -	dotdot_offset =3D EXT4_DIR_REC_LEN(1);
> -	dotdot_size =3D dotdot_offset + EXT4_DIR_REC_LEN(2);
> +	dotdot_offset =3D EXT4_DIR_NAME_LEN(1);
> +	dotdot_size =3D dotdot_offset + EXT4_DIR_NAME_LEN(2);
> 	extra_offset =3D dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
> 	extra_size =3D extra_offset + inline_size;
>=20
> @@ -1528,7 +1528,7 @@ int ext4_read_inline_dir(struct file *file,
> 			 * failure will be detected in the
> 			 * dirent test below. */
> 			if (ext4_rec_len_from_disk(de->rec_len, =
extra_size)
> -				< EXT4_DIR_REC_LEN(1))
> +				< EXT4_DIR_NAME_LEN(1))
> 				break;
> 			i +=3D ext4_rec_len_from_disk(de->rec_len,
> 						    extra_size);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 7c649cf2b630..67edab5572d8 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -239,7 +239,8 @@ static unsigned dx_get_count(struct dx_entry =
*entries);
> static unsigned dx_get_limit(struct dx_entry *entries);
> static void dx_set_count(struct dx_entry *entries, unsigned value);
> static void dx_set_limit(struct dx_entry *entries, unsigned value);
> -static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
> +static inline unsigned int dx_root_limit(struct inode *dir,
> +		struct ext4_dir_entry_2 *dot_de, unsigned int infosize);
> static unsigned dx_node_limit(struct inode *dir);
> static struct dx_frame *dx_probe(struct ext4_filename *fname,
> 				 struct inode *dir,
> @@ -552,10 +553,15 @@ static inline void dx_set_limit(struct dx_entry =
*entries, unsigned value)
> 	((struct dx_countlimit *) entries)->limit =3D =
cpu_to_le16(value);
> }
>=20
> -static inline unsigned dx_root_limit(struct inode *dir, unsigned =
infosize)
> +static inline unsigned int dx_root_limit(struct inode *dir,
> +		struct ext4_dir_entry_2 *dot_de, unsigned int infosize)
> {
> -	unsigned entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(1) -
> -		EXT4_DIR_REC_LEN(2) - infosize;
> +	struct ext4_dir_entry_2 *dotdot_de;
> +	unsigned int entry_space;
> +
> +	dotdot_de =3D ext4_next_entry(dot_de, dir->i_sb->s_blocksize);
> +	entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(dot_de) -
> +			 EXT4_DIR_REC_LEN(dotdot_de) - infosize;
>=20
> 	if (ext4_has_metadata_csum(dir->i_sb))
> 		entry_space -=3D sizeof(struct dx_tail);
> @@ -564,7 +570,8 @@ static inline unsigned dx_root_limit(struct inode =
*dir, unsigned infosize)
>=20
> static inline unsigned dx_node_limit(struct inode *dir)
> {
> -	unsigned entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(0);
> +	unsigned int entry_space =3D dir->i_sb->s_blocksize -
> +					EXT4_DIR_NAME_LEN(0);
>=20
> 	if (ext4_has_metadata_csum(dir->i_sb))
> 		entry_space -=3D sizeof(struct dx_tail);
> @@ -676,7 +683,7 @@ static struct stats dx_show_leaf(struct inode =
*dir,
> 				       (unsigned) ((char *) de - base));
> #endif
> 			}
> -			space +=3D EXT4_DIR_REC_LEN(de->name_len);
> +			space +=3D EXT4_DIR_REC_LEN(de);
> 			names++;
> 		}
> 		de =3D ext4_next_entry(de, size);
> @@ -984,7 +991,7 @@ static int htree_dirblock_to_tree(struct file =
*dir_file,
> 	de =3D (struct ext4_dir_entry_2 *) bh->b_data;
> 	top =3D (struct ext4_dir_entry_2 *) ((char *) de +
> 					   dir->i_sb->s_blocksize -
> -					   EXT4_DIR_REC_LEN(0));
> +					   EXT4_DIR_NAME_LEN(0));
> #ifdef CONFIG_EXT4_FS_ENCRYPTION
> 	/* Check if the directory is encrypted */
> 	if (ext4_encrypted_inode(dir)) {
> @@ -1567,6 +1574,7 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 	inode =3D NULL;
> 	if (bh) {
> 		__u32 ino =3D le32_to_cpu(de->inode);
> +
> 		brelse(bh);
> 		if (!ext4_valid_inum(dir->i_sb, ino)) {
> 			EXT4_ERROR_INODE(dir, "bad inode number: %u", =
ino);
> @@ -1635,7 +1643,7 @@ dx_move_dirents(char *from, char *to, struct =
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
> @@ -1659,7 +1667,7 @@ static struct ext4_dir_entry_2* =
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
> @@ -1790,10 +1798,13 @@ int ext4_find_dest_de(struct inode *dir, =
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
> +	unsigned short reclen =3D EXT4_DIR_NAME_LEN(fname_len(fname));
> 	int nlen, rlen;
> 	unsigned int offset =3D 0;
> 	char *top;
> @@ -1806,10 +1817,28 @@ int ext4_find_dest_de(struct inode *dir, =
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
> +		 * required for just the entry, no FID
> +		 */
> +		if (is_dotdot) {
> +			if ((de->inode ? rlen - nlen : rlen) >=3D
> +			    dotdot_reclen) {
> +				*write_short_dotdot =3D true;
> +				break;
> +			}
> +			/* The new ".." entry mut be written over the
> +			 * previous ".." entry, which is the first
> +			 * entry traversed by this scan.  If it doesn't
> +			 * fit, something is badly wrong, so -EIO.
> +			 */
> +			return -EIO;
> +		}
> +
> 		de =3D (struct ext4_dir_entry_2 *)((char *)de + rlen);
> 		offset +=3D rlen;
> 	}
> @@ -1828,7 +1857,8 @@ void ext4_insert_dentry(struct inode *inode,
>=20
> 	int nlen, rlen;
>=20
> -	nlen =3D EXT4_DIR_REC_LEN(de->name_len);
> +	nlen =3D EXT4_DIR_REC_LEN(de);
> +
> 	rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
> 	if (de->inode) {
> 		struct ext4_dir_entry_2 *de1 =3D
> @@ -1852,21 +1882,46 @@ void ext4_insert_dentry(struct inode *inode,
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
> +	struct ext4_dirent_data_header *ddh;
> +	int namelen =3D dentry->d_name.len;
>=20
> 	if (ext4_has_metadata_csum(inode->i_sb))
> 		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>=20
> +	ddh =3D ext4_dentry_get_data(inode->i_sb, (struct =
ext4_dentry_param *)
> +						dentry->d_fsdata);
> +	if (ddh)
> +		dlen =3D ddh->ddh_length + 1 /* NUL separator */;
> +
> +	is_dotdot =3D (namelen =3D=3D 2 &&
> +		     memcmp(dentry->d_name.name, "..", 2) =3D=3D 0);
> +
> +	/* dotdot entries must be in the second place in a directory =
block,
> +	 * so calculate an alternate length without the dirdata so they =
can
> +	 * always be made to fit in the existing slot
> +	 */
> +	if (is_dotdot)
> +		dotdot_reclen =3D EXT4_DIR_NAME_LEN(namelen);
> +
> +	reclen =3D EXT4_DIR_NAME_LEN(namelen + dlen + 3);
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
> @@ -1880,6 +1935,24 @@ static int add_dirent_to_buf(handle_t *handle, =
struct ext4_filename *fname,
> 	/* By now the buffer is marked for journaling */
> 	ext4_insert_dentry(inode, de, blocksize, fname);
>=20
> +	/* If we're writing short form of "dotdot", don't add data =
section */
> +	if (ddh && !write_short_dotdot) {
> +		de->name[namelen] =3D 0;
> +		memcpy(&de->name[namelen + 1], ddh, ddh->ddh_length);
> +		de->file_type |=3D EXT4_DIRENT_LUFID;
> +		data_offset =3D ddh->ddh_length;

I don't see where "data_offset" is declared?  It looks like that is in =
the next
patch.

> +	}
> +
> +	if (inode) {


This whole part handling "i_ino_hi" should go into the next patch?

> +		__u32 *i_ino_hi;
> +
> +		de->name[namelen + 1 + data_offset] =3D 5;

> +		i_ino_hi =3D (__u32 *)&de->name[namelen + 1 + =
data_offset + 1];
> +		*i_ino_hi =3D cpu_to_le32((__u32)(inode->i_ino >> 32));


> @@ -1976,20 +2049,17 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,

> 	dotdot_de->rec_len =3D
> 		ext4_rec_len_to_disk(blocksize - =
le16_to_cpu(dot_de->rec_len),
> 				     blocksize);
> -
> 	/* initialize hashing info */
> 	dx_info =3D dx_get_dx_info(dot_de);
> 	memset(dx_info, 0, sizeof(*dx_info));
> 	dx_info->info_length =3D sizeof(*dx_info);
> 	dx_info->hash_version =3D =
EXT4_SB(dir->i_sb)->s_def_hash_version;
> -
> 	entries =3D (void *)dx_info + sizeof(*dx_info);
> -

Not sure why these blank lines are being removed?

> 	dx_set_block(entries, 1);
> 	dx_set_count(entries, 1);
> -	dx_set_limit(entries, dx_root_limit(dir, (struct =
ext4_dir_entry_2 *)
> -					    frame->bh->b_data,
> -					    sizeof(*dx_info)));
> +	dx_set_limit(entries, dx_root_limit(dir,
> +				(struct ext4_dir_entry_2 =
*)frame->bh->b_data,
> +				sizeof(*dx_info)));
>=20
> 	/* Initialize as for dx_probe */
> 	fname->hinfo.hash_version =3D dx_info->hash_version;
> @@ -2017,7 +2087,7 @@ static int make_indexed_dir(handle_t *handle, =
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
> @@ -2094,7 +2164,7 @@ static int ext4_add_entry(handle_t *handle, =
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
> @@ -2123,7 +2193,7 @@ static int ext4_add_entry(handle_t *handle, =
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
> @@ -2165,7 +2235,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
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
> @@ -2291,7 +2361,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
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
> @@ -2557,7 +2627,7 @@ struct ext4_dir_entry_2 =
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
> @@ -2567,11 +2637,11 @@ struct ext4_dir_entry_2 =
*ext4_init_dot_dotdot(struct inode *inode,
> 	de->name_len =3D 2;
> 	if (!dotdot_real_len)
> 		de->rec_len =3D ext4_rec_len_to_disk(blocksize -
> -					(csum_size + =
EXT4_DIR_REC_LEN(1)),
> +					(csum_size + =
EXT4_DIR_NAME_LEN(1)),
> 					blocksize);
> 	else
> 		de->rec_len =3D ext4_rec_len_to_disk(
> -				EXT4_DIR_REC_LEN(de->name_len), =
blocksize);
> +				EXT4_DIR_REC_LEN(de), blocksize);
> 	strcpy(de->name, "..");
> 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
>=20
> @@ -2700,7 +2770,7 @@ bool ext4_empty_dir(struct inode *inode)
> 	}
>=20
> 	sb =3D inode->i_sb;
> -	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)) {
> +	if (inode->i_size < EXT4_DIR_NAME_LEN(1) + EXT4_DIR_NAME_LEN(2)) =
{
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
> 2.13.6 (Apple Git-96)
>=20


Cheers, Andreas






--Apple-Mail=_66902FEE-33CD-4C85-AA5A-4A273A87D31C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaJfAYpIg59Q01vtYRAsjGAJ9+RNepPHHkRym/aepE5B4Y6lOI8QCg3wRy
ZMn50J9UotputC2zHoPlgww=
=kvBS
-----END PGP SIGNATURE-----

--Apple-Mail=_66902FEE-33CD-4C85-AA5A-4A273A87D31C--
