From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 3/3] ext4: Add 64-bit inode number support
Date: Tue, 5 Dec 2017 14:26:58 -0700
Message-ID: <FECC22CA-3112-4C4F-ABE6-9609753559B7@dilger.ca>
References: <20171130151753.24986-1-artem.blagodarenko@gmail.com>
 <20171130151753.24986-4-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0605D243-1F7E-4F10-9D14-A9ACFC67555B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@google.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:41296 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdLEV1G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Dec 2017 16:27:06 -0500
Received: by mail-it0-f66.google.com with SMTP id x28so4800570ita.0
        for <linux-ext4@vger.kernel.org>; Tue, 05 Dec 2017 13:27:06 -0800 (PST)
In-Reply-To: <20171130151753.24986-4-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0605D243-1F7E-4F10-9D14-A9ACFC67555B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 30, 2017, at 8:17 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Use dirdata to store high bits of 64bit inode
> number.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@google.com>
> ---
> fs/ext4/dir.c    |  4 +--
> fs/ext4/ext4.h   | 85 =
++++++++++++++++++++++++++++++++++++++++++++++----------
> fs/ext4/ialloc.c | 19 ++++++++-----
> fs/ext4/inode.c  |  5 ++++
> fs/ext4/namei.c  | 53 ++++++++++++++++++++++++++++-------
> fs/ext4/resize.c |  8 +++---
> fs/ext4/super.c  | 14 +++++++---
> 7 files changed, 147 insertions(+), 41 deletions(-)
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 0c4dddb0f07a..d971bc68903c 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -76,7 +76,7 @@ int __ext4_check_dir_entry(const char *function, =
unsigned int line,
> 	else if (unlikely(((char *) de - buf) + rlen > size))
> 		error_msg =3D "directory entry across range";
> 	else if (unlikely(le32_to_cpu(de->inode) >
> -			=
le32_to_cpu(EXT4_SB(dir->i_sb)->s_es->s_inodes_count)))
> +		 ext4_get_inodes_count(dir->i_sb)))
> @@ -382,7 +382,7 @@ struct fname {
> 	__u32		minor_hash;
> 	struct rb_node	rb_hash;
> 	struct fname	*next;
> -	__u32		inode;
> +	__u64		inode;
> 	__u8		name_len;
> 	__u8		file_type;
> 	char		name[0];
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3678657d8e47..18e30589b704 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1331,7 +1331,10 @@ struct ext4_super_block {
> 	__le32	s_lpf_ino;		/* Location of the lost+found =
inode */
> 	__le32	s_prj_quota_inum;	/* inode for tracking project =
quota */
> 	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set =
*/
> -	__le32	s_reserved[98];		/* Padding to the end of the =
block */
> +	__le32	s_inodes_count_hi;	/* higth part of inode count */
> +	__le32	s_free_inodes_count_hi;	/* Free inodes count */
> +	__le32	s_prj_quota_inum_hi;	/* high part of project quota =
inode */
> +	__le32	s_reserved[95];		/* Padding to the end of the =
block */

What about s_last_orphan, s_first_error_ino, and s_last_error_ino?

> 	__le32	s_checksum;		/* crc32c(superblock) */
> };
>=20
> @@ -1539,18 +1542,6 @@ static inline struct ext4_inode_info =
*EXT4_I(struct inode *inode)
> 	return container_of(inode, struct ext4_inode_info, vfs_inode);
> }
>=20
> -static inline int ext4_valid_inum(struct super_block *sb, unsigned =
long ino)
> -{
> -	return ino =3D=3D EXT4_ROOT_INO ||
> -		ino =3D=3D EXT4_USR_QUOTA_INO ||
> -		ino =3D=3D EXT4_GRP_QUOTA_INO ||
> -		ino =3D=3D EXT4_BOOT_LOADER_INO ||
> -		ino =3D=3D EXT4_JOURNAL_INO ||
> -		ino =3D=3D EXT4_RESIZE_INO ||
> -		(ino >=3D EXT4_FIRST_INO(sb) &&
> -		 ino <=3D =
le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
> -}
> -
> /*
>  * Inode dynamic state flags
>  */
> @@ -1689,6 +1680,7 @@ static inline void ext4_clear_state_flags(struct =
ext4_inode_info *ei)
> #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB =
or 3-lvl htree */
> #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode =
*/
> #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
> +#define EXT4_FEATURE_INCOMPAT_INODE64		0x20000
>=20
> #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
> static inline bool ext4_has_feature_##name(struct super_block *sb) \
> @@ -1777,6 +1769,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		=
CSUM_SEED)
> EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		LARGEDIR)
> EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	INLINE_DATA)
> EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
> +EXT4_FEATURE_INCOMPAT_FUNCS(inode64,		INODE64)
> +
>=20
> #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
> #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| =
\
> @@ -1805,6 +1799,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		=
ENCRYPT)
> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
> 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED =
| \
> +					 EXT4_FEATURE_INCOMPAT_INODE64 | =
\
> 					 EXT4_FEATURE_INCOMPAT_LARGEDIR =
| \
> 					 EXT4_FEATURE_INCOMPAT_DIRDATA)
> #define EXT4_FEATURE_RO_COMPAT_SUPP	=
(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> @@ -2000,6 +1995,11 @@ struct ext4_dirent_lufid {
> 	__u8				dl_data[0];
> } __packed;
>=20
> +struct ext4_dirent_inohi {
> +	struct ext4_dirent_data_header	di_header; /* 1 + 4 */
> +	__le32				di_inohi;
> +} __packed;

It would be better to keep the struct name "ext4_dirent_inode64" to =
match
the feature name?

I also notice that you need to update "s_inode_goal" to be "unsigned =
long",
so that you can easily test inode allocations beyond 2^32.  You also =
need
to fix the ext4_ext_migrate() function to have a __u64 goal.

There is an interaction with the xattr_inode feature that needs to be =
fixed.
The e_value_inum field is only a __u32, and there doesn't appear to be =
any
space to hold the high 32 bits of the inode number therein.  One option =
(not
sure what you think of this) is to always use the same __u32 i_ino_hi =
for the
xattr inode as for the regular inode that references it?  That is OK for
unshared xattrs, and for shared inodes it would mean one shared inode =
per 2^32
inodes by changing ext4_xattr_inode_cache_find() to only find an =
existing cached
entry if they have the same high 32 bits in the inode number.

There also looks to be some interaction with =
inline.c::htree_inlinedir_to_tree()
storing the inode number into the "fake" dirent, but it isn't handling =
64-bit
inodes.  Similarly, ext4_try_create_inline_dir() and =
ext4_add_dirent_to_inline()
need some attention.

> @@ -2476,7 +2476,7 @@ extern int ext4fs_dirhash(const char *name, int =
len, struct
>=20
> /* ialloc.c */
> extern struct inode *__ext4_new_inode(handle_t *, struct inode *, =
umode_t,
> -				      const struct qstr *qstr, __u32 =
goal,
> +				      const struct qstr *qstr, __u64 =
goal,
> 				      uid_t *owner, __u32 i_flags,
> 				      int handle_type, unsigned int =
line_no,
> 				      int nblocks);
> @@ -2903,6 +2903,63 @@ static inline unsigned int =
ext4_flex_bg_size(struct ext4_sb_info *sbi)
> 	return 1 << sbi->s_log_groups_per_flex;
> }
>=20
> +static inline unsigned long ext4_get_inodes_count(struct super_block =
*sb)
> +{
> +	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> +	unsigned long inodes_count =3D le32_to_cpu(es->s_inodes_count);
> +
> +	if (ext4_has_feature_inode64(sb))
> +		inodes_count |=3D
> +			(unsigned =
long)le32_to_cpu(es->s_inodes_count_hi)
> +			<< 32;
> +	return inodes_count;
> +}
> +
> +static inline void ext4_set_inodes_count(struct super_block *sb,
> +					 unsigned long val)
> +{
> +	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> +
> +	if (ext4_has_feature_inode64(sb))
> +		es->s_inodes_count_hi =3D  cpu_to_le32(val >> 32);
> +
> +	es->s_inodes_count =3D cpu_to_le32(val);
> +}
> +
> +static inline unsigned long ext4_get_free_inodes_count(struct =
super_block *sb)
> +{
> +	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> +	unsigned long inodes_count =3D =
le32_to_cpu(es->s_free_inodes_count);
> +
> +	if (ext4_has_feature_inode64(sb))
> +		inodes_count |=3D
> +			(unsigned =
long)le32_to_cpu(es->s_free_inodes_count_hi)
> +			<< 32;
> +	return inodes_count;
> +}
> +
> +static inline void ext4_set_free_inodes_count(struct super_block *sb,
> +					      unsigned long val)
> +{
> +	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> +
> +	if (ext4_has_feature_inode64(sb))
> +		es->s_free_inodes_count_hi =3D cpu_to_le32(val >> 32);
> +
> +	es->s_free_inodes_count =3D cpu_to_le32(val);
> +}
> +
> +static inline int ext4_valid_inum(struct super_block *sb, unsigned =
long ino)
> +{
> +	return ino =3D=3D EXT4_ROOT_INO ||
> +		ino =3D=3D EXT4_USR_QUOTA_INO ||
> +		ino =3D=3D EXT4_GRP_QUOTA_INO ||
> +		ino =3D=3D EXT4_JOURNAL_INO ||
> +		ino =3D=3D EXT4_RESIZE_INO ||
> +		(ino >=3D EXT4_FIRST_INO(sb) &&
> +		 ino <=3D ext4_get_inodes_count(sb));
> +}
> +
> #define ext4_std_error(sb, errno)				\
> do {								\
> 	if ((errno))						\
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index ee823022aa34..e23dc4133e84 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -303,7 +303,7 @@ void ext4_free_inode(handle_t *handle, struct =
inode *inode)
> 	ext4_clear_inode(inode);
>=20
> 	es =3D EXT4_SB(sb)->s_es;
> -	if (ino < EXT4_FIRST_INO(sb) || ino > =
le32_to_cpu(es->s_inodes_count)) {
> +	if (ino < EXT4_FIRST_INO(sb) || ino > ext4_get_inodes_count(sb)) =
{
> 		ext4_error(sb, "reserved or nonexistent inode %lu", =
ino);
> 		goto error_return;
> 	}
> @@ -770,7 +770,7 @@ static int find_inode_bit(struct super_block *sb, =
ext4_group_t group,
>  */
> struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
> 			       umode_t mode, const struct qstr *qstr,
> -			       __u32 goal, uid_t *owner, __u32 i_flags,
> +			       __u64 goal, uid_t *owner, __u32 i_flags,
> 			       int handle_type, unsigned int line_no,
> 			       int nblocks)
> {
> @@ -887,7 +887,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> 	if (!goal)
> 		goal =3D sbi->s_inode_goal;
>=20
> -	if (goal && goal <=3D le32_to_cpu(sbi->s_es->s_inodes_count)) {
> +	if (goal && goal <=3D ext4_get_inodes_count(sb)) {
> 		group =3D (goal - 1) / EXT4_INODES_PER_GROUP(sb);
> 		ino =3D (goal - 1) % EXT4_INODES_PER_GROUP(sb);
> 		ret2 =3D 0;
> @@ -1149,6 +1149,11 @@ struct inode *__ext4_new_inode(handle_t =
*handle, struct inode *dir,
> 		__le32 gen =3D cpu_to_le32(inode->i_generation);
> 		csum =3D ext4_chksum(sbi, sbi->s_csum_seed, (__u8 =
*)&inum,
> 				   sizeof(inum));
> +		if (inode->i_ino >> 32) {
> +			inum =3D cpu_to_le32(inode->i_ino >> 32);
> +			csum =3D ext4_chksum(sbi, sbi->s_csum_seed,
> +					(__u8 *)&inum, sizeof(inum));
> +		}
> 		ei->i_csum_seed =3D ext4_chksum(sbi, csum, (__u8 *)&gen,
> 					      sizeof(gen));
> 	}
> @@ -1226,7 +1231,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> /* Verify that we are loading a valid orphan from disk */
> struct inode *ext4_orphan_get(struct super_block *sb, unsigned long =
ino)
> {
> -	unsigned long max_ino =3D =
le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
> +	unsigned long max_ino =3D ext4_get_inodes_count(sb);
> 	ext4_group_t block_group;
> 	int bit;
> 	struct buffer_head *bitmap_bh =3D NULL;
> @@ -1330,9 +1335,9 @@ unsigned long ext4_count_free_inodes(struct =
super_block *sb)
> 		bitmap_count +=3D x;
> 	}
> 	brelse(bitmap_bh);
> -	printk(KERN_DEBUG "ext4_count_free_inodes: "
> -	       "stored =3D %u, computed =3D %lu, %lu\n",
> -	       le32_to_cpu(es->s_free_inodes_count), desc_count, =
bitmap_count);
> +	printk(KERN_DEBUG "ext4_count_free_inodes:\n"

This should be kept on a single line.

> +	       "stored =3D %lu, computed =3D %lu, %lu\n",

> +	       ext4_get_inodes_count(sb), desc_count, bitmap_count);
> 	return desc_count;
> #else
> 	desc_count =3D 0;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 31db875bc7a1..9caefee1bce9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4691,6 +4691,11 @@ struct inode *ext4_iget(struct super_block *sb, =
unsigned long ino)
> 		__le32 gen =3D raw_inode->i_generation;
> 		csum =3D ext4_chksum(sbi, sbi->s_csum_seed, (__u8 =
*)&inum,
> 				   sizeof(inum));
> +		if (inode->i_ino >> 32) {
> +			inum =3D cpu_to_le32(inode->i_ino >> 32);
> +			csum =3D ext4_chksum(sbi, sbi->s_csum_seed,
> +					(__u8 *)&inum, sizeof(inum));
> +		}
> 		ei->i_csum_seed =3D ext4_chksum(sbi, csum, (__u8 *)&gen,
> 					      sizeof(gen));
> 	}
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 67edab5572d8..0ef33556c51d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1573,11 +1573,45 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 		return (struct dentry *) bh;
> 	inode =3D NULL;
> 	if (bh) {
> -		__u32 ino =3D le32_to_cpu(de->inode);
> +		unsigned long ino;
> +
> +		ino =3D le32_to_cpu(de->inode);
> +		if (ext4_has_feature_inode64(dir->i_sb) &&
> +		    (de->file_type & EXT4_DIRENT_INODE)) {
> +			struct ext4_dirent_data_header *ddh =3D
> +				(struct ext4_dirent_data_header *)
> +				&de->name[de->name_len];

This should always skip the NUL separator after the name, and not make =
it
part of EXT4_DIRENT_LUFID:

			struct ext4_dirent_data_header *ddh =3D
				(struct ext4_dirent_data_header *)
				(&de->name[de->name_len] + 1);

Otherwise, it isn't clear whether EXT4_DIRENT_INODE64 handling should
skip the NUL byte if there is no EXT4_DIRENT_LUFID record.

Should we also be checking "if ((char *)ddh > &de->name[de->rec_len])" =
here?

> +
> +			if (de->file_type & EXT4_DIRENT_LUFID) {
> +				/* skip LUFID record if present */
> +				ddh =3D (struct ext4_dirent_data_header =
*)
> +					&de->name[de->name_len + 1 +
> +							=
ddh->ddh_length];

Having a "ext4_dirdata_next()" helper would be convenient here, or at =
least
avoid recomputing the offset:

				ddh =3D (struct ext4_dirent_data_header =
*)
					((char *)ddh + ddh->ddh_length);

> +			}
> +
> +			if ((char *)ddh > &de->name[de->rec_len]) {
> +				EXT4_ERROR_INODE(dir,
> +					"corrupted dirdata entry\n");
> +				return ERR_PTR(-EFSCORRUPTED);
> +			}

> +
> +			if (ddh->ddh_length =3D=3D (sizeof(__u32) + 1)) =
{

(defect) this should check for EXT4_DIRENT_INODE64 before checking the =
size,
otherwise this would accidentally catch 1/256 inodes that happen to have =
"05"
in the low byte.

> +				__le32 ino_hi;
> +				struct ext4_dirent_lufid *dlf =3D
> +					(struct ext4_dirent_lufid *)ddh;

(defect) this should be struct ext4_dirent_inohi *di?

> +
> +				memcpy(&ino_hi, dlf->dl_data, =
sizeof(__u32));

Then here it would be:
				memcpy(&ino_hi, di->di_inohi, =
sizeof(ino_hi));

> +				ino |=3D (__u64)le32_to_cpu(ino_hi) << =
32;
> +			} else {
> +				EXT4_ERROR_INODE(dir,
> +					"corrupted dirdata inode =
number\n");
> +				return ERR_PTR(-EFSCORRUPTED);
> +			}
> +		}

I also saw that ext4_rename_dir_prepare(), ext4_rename_dir_finish(),
ext4_rename_delete(), ext4_cross_rename(), ext4_empty_dir(), =
ext4_rmdir(),
ext4_rename(), ext4_unlink(), and ext4_setent() need to be updated to
handle 64-bit inodes, since they are comparing i_ino to de->inode when
handling the directory entry.  It looks like it would be useful to have
a helper function like ext4_dirent_ino(de) that extracts the 64-bit =
inode
from the dirent, which could be used in ext4_lookup() (it would be the =
whole
block of code added above that is checking for =
ext4_has_feature_inode64()).

It makes sense to add the ext4_dirent_ino() and =
ext4_{get,set}_inodes_count()
helper functions in a preliminary patch (with only 32-bit inodes) and =
then
add the code handling 64-bit inodes in a second patch?  That would move =
all
the boring changes out of this patch, so it can focus on the important =
changes.


> @@ -1588,7 +1622,7 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 		inode =3D ext4_iget_normal(dir->i_sb, ino);
> 		if (inode =3D=3D ERR_PTR(-ESTALE)) {
> 			EXT4_ERROR_INODE(dir,
> -					 "deleted inode referenced: %u",
> +					 "deleted inode referenced: =
%lu",
> 					 ino);
> 			return ERR_PTR(-EFSCORRUPTED);
> 		}
> @@ -1892,7 +1926,7 @@ static int add_dirent_to_buf(handle_t *handle,
> 	unsigned int	blocksize =3D dir->i_sb->s_blocksize;
> 	int		csum_size =3D 0;
> 	unsigned short	reclen, dotdot_reclen =3D 0;
> -	int		 err, dlen =3D 0;
> +	int		 err, dlen =3D 0, data_offset =3D 0;
> 	bool		is_dotdot =3D false, write_short_dotdot =3D =
false;
> 	struct ext4_dirent_data_header *ddh;
> 	int namelen =3D dentry->d_name.len;
> @@ -1944,13 +1978,12 @@ static int add_dirent_to_buf(handle_t *handle,
> 	}
>=20
> 	if (inode) {
> -		__u32 *i_ino_hi;
> -
> -		de->name[namelen + 1 + data_offset] =3D 5;
> -		i_ino_hi =3D (__u32 *)&de->name[namelen + 1 + =
data_offset + 1];
> -		*i_ino_hi =3D cpu_to_le32((__u32)(inode->i_ino >> 32));
> -		de->file_type |=3D EXT4_DIRENT_INODE;
> +		struct ext4_dirent_inohi *di =3D (struct =
ext4_dirent_inohi *)
> +			&de->name[namelen + 1 + data_offset];
> +		di->di_header.ddh_length =3D sizeof(*di);
> +		di->di_inohi =3D cpu_to_le32(inode->i_ino >> 32);
> 		de->inode =3D cpu_to_le32(inode->i_ino & 0xFFFFFFFF);
> +		de->file_type |=3D EXT4_DIRENT_INODE;
> 	}

Since "i_ino_hi" may not be 4-byte aligned, using it directly as a =
pointer
may cause problems on some architectures.  This should instead use =
memcpy()
like above:

struct ext4_dirent_inohi {
	struct ext4_dirent_data_header	di_header; /* 1 + 4 */
	__le32				di_inohi;
} __packed;

	if (inode) {
		struct ext4_dirent_inohi *di;
		__u32 i_ino_hi;

		i_ino_hi =3D cpu_to_le32((__u32)(inode->i_ino >> 32));
		di =3D (void *)&de->name[namelen + 1 + data_offset];

		di->di_header.ddh_length =3D sizeof(*di);
		memcpy(di->di_inohi, &i_ino_hi, sizeof(i_ino_hi));

> +		de->file_type |=3D EXT4_DIRENT_INODE;
> +		de->inode =3D cpu_to_le32(inode->i_ino & 0xFFFFFFFF);

Setting "de->inode" isn't needed, it was set in ext4_insert_dentry() =
above.

For consistency, this should also increment data_offset so it will be
correct if/when the next dirdata field is added.

		data_offset +=3D di->di_header.ddh_length;
	}

> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 035cd3f4785e..d0d5acd1a70d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1337,10 +1337,10 @@ static void ext4_update_super(struct =
super_block *sb,
>=20
> 	ext4_blocks_count_set(es, ext4_blocks_count(es) + blocks_count);
> 	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + =
free_blocks);
> -	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb) *
> -		     flex_gd->count);
> -	le32_add_cpu(&es->s_free_inodes_count, EXT4_INODES_PER_GROUP(sb) =
*
> -		     flex_gd->count);
> +	ext4_set_inodes_count(sb, ext4_get_inodes_count(sb) +
> +			      EXT4_INODES_PER_GROUP(sb) * =
flex_gd->count);
> +	ext4_set_free_inodes_count(sb, ext4_get_free_inodes_count(sb) +
> +			EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
>=20
> 	ext4_debug("free blocks count %llu", =
ext4_free_blocks_count(es));
> 	/*
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ead9406d9cff..a06252f9aada 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3489,6 +3489,12 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		goto cantfind_ext4;
> 	}
>=20
> +	if (ext4_has_feature_inode64(sb) &&
> +	    (sizeof(u64) !=3D sizeof(unsigned long))) {
> +		ext4_msg(sb, KERN_ERR, "64 bit inodes need 64 bit =
kernel.");

"64-bit"

> +		goto failed_mount;
> +	}
> +
> 	/* Load the checksum driver */
> 	if (ext4_has_feature_metadata_csum(sb) ||
> 	    ext4_has_feature_ea_inode(sb)) {
> @@ -4248,7 +4254,7 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 				  GFP_KERNEL);
> 	if (!err) {
> 		unsigned long freei =3D ext4_count_free_inodes(sb);
> -		sbi->s_es->s_free_inodes_count =3D cpu_to_le32(freei);
> +		ext4_set_free_inodes_count(sb, freei);
> 		err =3D percpu_counter_init(&sbi->s_freeinodes_counter, =
freei,
> 					  GFP_KERNEL);
> 	}
> @@ -4705,9 +4711,9 @@ static int ext4_commit_super(struct super_block =
*sb, int sync)
> 			EXT4_C2B(EXT4_SB(sb), =
percpu_counter_sum_positive(
> 				&EXT4_SB(sb)->s_freeclusters_counter)));
> 	if =
(percpu_counter_initialized(&EXT4_SB(sb)->s_freeinodes_counter))
> -		es->s_free_inodes_count =3D
> -			cpu_to_le32(percpu_counter_sum_positive(
> -				&EXT4_SB(sb)->s_freeinodes_counter));
> +		ext4_set_free_inodes_count(sb,
> +				cpu_to_le32(percpu_counter_sum_positive(
> +				&EXT4_SB(sb)->s_freeinodes_counter)));
> 	BUFFER_TRACE(sbh, "marking dirty");
> 	ext4_superblock_csum_set(sb);
> 	if (sync)
> --
> 2.13.6 (Apple Git-96)
>=20


Cheers, Andreas






--Apple-Mail=_0605D243-1F7E-4F10-9D14-A9ACFC67555B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaJw8lpIg59Q01vtYRAnVfAJ9rc2vlo2whAO2iQOHN8F6W3qz1bwCgwQ2P
/Sy7LKdcONKxsJ04RI9BTc8=
=f+BX
-----END PGP SIGNATURE-----

--Apple-Mail=_0605D243-1F7E-4F10-9D14-A9ACFC67555B--
