From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH v2 1/2] ext4: dirdata feature
Date: Tue, 7 Nov 2017 22:40:43 -0700
Message-ID: <369F06E8-6C5B-4AE8-81DD-8F45041E622C@dilger.ca>
References: <20171101212455.47964-1-artem.blagodarenko@gmail.com>
 <20171101212455.47964-2-artem.blagodarenko@gmail.com>
 <20171107185333.GA6233@magnolia>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6F29F37C-B69E-4915-B478-DF6769EAF04E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:43819 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753211AbdKHFku (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Nov 2017 00:40:50 -0500
Received: by mail-it0-f67.google.com with SMTP id k70so8159702itk.0
        for <linux-ext4@vger.kernel.org>; Tue, 07 Nov 2017 21:40:50 -0800 (PST)
In-Reply-To: <20171107185333.GA6233@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6F29F37C-B69E-4915-B478-DF6769EAF04E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 7, 2017, at 11:53 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Thu, Nov 02, 2017 at 12:24:54AM +0300, Artem Blagodarenko wrote:
>> From: Andreas Dilger <andreas.dilger@intel.com>
>>=20
>> This patch implements feature which allows ext4 fs users (e.g. =
Lustre)
>> to store data in ext4 dirent. Data is stored in ext4 dirent after
>> file-name, this space is accounted in de->rec_len.
>> Flag EXT4_DIRENT_LUFID added to d_type if extra data
>> is present.
>>=20
>> Make use of dentry->d_fsdata to pass fid to ext4. so no
>> changes in ext4_add_entry() interface required.

Darrick,
thanks for the review.  Comments inline.

>> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
>> index b04e882179c6..46fcb8ec47a6 100644
>> --- a/fs/ext4/dir.c
>> +++ b/fs/ext4/dir.c
>> @@ -67,11 +67,11 @@ int __ext4_check_dir_entry(const char *function, =
unsigned int line,
>> 	const int rlen =3D ext4_rec_len_from_disk(de->rec_len,
>> 						dir->i_sb->s_blocksize);
>>=20
>> -	if (unlikely(rlen < EXT4_DIR_REC_LEN(1)))
>> +	if (unlikely(rlen < __EXT4_DIR_REC_LEN(1)))
>> 		error_msg =3D "rec_len is smaller than minimal";
>> 	else if (unlikely(rlen % 4 !=3D 0))
>> 		error_msg =3D "rec_len % 4 !=3D 0";
>> -	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de->name_len)))
>> +	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de)))
>> 		error_msg =3D "rec_len is too small for name_len";
>> 	else if (unlikely(((char *) de - buf) + rlen > size))
>> 		error_msg =3D "directory entry across range";
>> @@ -218,7 +218,8 @@ static int ext4_readdir(struct file *file, struct =
dir_context *ctx)
>> 				 * failure will be detected in the
>> 				 * dirent test below. */
>> 				if (ext4_rec_len_from_disk(de->rec_len,
>> -					sb->s_blocksize) < =
EXT4_DIR_REC_LEN(1))
>> +						sb->s_blocksize) <
>> +						__EXT4_DIR_REC_LEN(1))
>> 					break;
>> 				i +=3D =
ext4_rec_len_from_disk(de->rec_len,
>> 							    =
sb->s_blocksize);
>> @@ -441,12 +442,18 @@ int ext4_htree_store_dirent(struct file =
*dir_file, __u32 hash,
>> 	struct fname *fname, *new_fn;
>> 	struct dir_private_info *info;
>> 	int len;
>> +	int extra_data =3D 0;
>>=20
>> 	info =3D dir_file->private_data;
>> 	p =3D &info->root.rb_node;
>>=20
>> 	/* Create and allocate the fname structure */
>> -	len =3D sizeof(struct fname) + ent_name->len + 1;
>> +	if (dirent->file_type & ~EXT4_FT_MASK)
>> +		extra_data =3D ext4_get_dirent_data_len(dirent);
>> +
>> +	len =3D sizeof(struct fname) + dirent->name_len + extra_data + =
1;
>> +
>> +
>> 	new_fn =3D kzalloc(len, GFP_KERNEL);
>> 	if (!new_fn)
>> 		return -ENOMEM;
>> @@ -455,7 +462,7 @@ int ext4_htree_store_dirent(struct file =
*dir_file, __u32 hash,
>> 	new_fn->inode =3D le32_to_cpu(dirent->inode);
>> 	new_fn->name_len =3D ent_name->len;
>> 	new_fn->file_type =3D dirent->file_type;
>> -	memcpy(new_fn->name, ent_name->name, ent_name->len);
>> +	memcpy(new_fn->name, ent_name->name, ent_name->len + =
extra_data);
>> 	new_fn->name[ent_name->len] =3D 0;
>>=20
>> 	while (*p) {
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index e2abe01c8c6b..9a9b01b0956a 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1111,6 +1111,7 @@ struct ext4_inode_info {
>>  * Mount flags set via mount options or defaults
>>  */
>> #define EXT4_MOUNT_NO_MBCACHE		0x00001 /* Do not use =
mbcache */
>> +#define EXT4_MOUNT_DIRDATA		0x00002 /* Data in directory =
entries*/
>> #define EXT4_MOUNT_GRPID		0x00004	/* Create files with =
directory's group */
>> #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging =
messages */
>> #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on =
errors */
>> @@ -1804,7 +1805,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		=
ENCRYPT)
>> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
>> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
>> 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED =
| \
>> -					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
>> +					 EXT4_FEATURE_INCOMPAT_LARGEDIR =
| \
>> +					 EXT4_FEATURE_INCOMPAT_DIRDATA)
>> #define EXT4_FEATURE_RO_COMPAT_SUPP	=
(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>> 					 =
EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
>> 					 =
EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
>> @@ -1965,6 +1967,45 @@ struct ext4_dir_entry_tail {
>>=20
>> #define EXT4_FT_DIR_CSUM	0xDE
>>=20
>> +#define EXT4_FT_MASK		0xf
>> +
>> +#if EXT4_FT_MAX > EXT4_FT_MASK
>> +#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
>> +#endif
>> +
>> +/*
>> + * d_type has 4 unused bits, so it can hold four types data. these =
different
>> + * type of data (e.g. lustre data, high 32 bits of 64-bit inode =
number) can be
>> + * stored, in flag order, after file-name in ext4 dirent.
>> + */
>> +/*
>> + * this flag is added to d_type if ext4 dirent has extra data after
>> + * filename. this data length is variable and length is stored in =
first byte
>> + * of data. data start after filename NUL byte.
>> + * This is used by Lustre FS.
>> + */
>> +#define EXT4_DIRENT_LUFID		0x10
>> +#define EXT4_DIRENT_INODE		0x20
>> +#define DIRENT_INODE_LEN		2
>=20
> Unrelated addition, since large inodes are the next patch?

Sure, I thought the same, as this is not in the original dirdata patch, =
but
I figured Artem wanted to reserve this flag in case this first patch =
landed
and the inode64 feature took a while to land.

>> +#define EXT4_LUFID_MAGIC    0xAD200907UL
>> +struct ext4_dentry_param {
>> +	__u32  edp_magic;	/* EXT4_LUFID_MAGIC */
>=20
> If this is an on-disk data structure, this field type should be =
__le32.

This one is in-memory only.

>> +	char   edp_len;		/* size of edp_data in bytes */
>=20
> Don't we already have a length byte preceeding edp_magic that tells us
> the length of the data?  I guess it's necessary for the incore buffer =
to
> track the length of edp_data, but since this gets memcpy'd into the
> dirent that means we store redundant size information.

It doesn't actually store the size redundantly.  I verified this using
debugfs on a Lustre system, and the entries are 0x11 bytes in size.  The
same 1-byte size field is used in both cases - see below the pointer to
"edp_len" is returned to the caller.

>> +	char   edp_data[0];	/* packed array of data */
>=20
> (and these should be __u8, not char)

Sure.

>> +} __packed;
>> +
>> +static inline unsigned char *ext4_dentry_get_data(struct super_block =
*sb,
>> +		struct ext4_dentry_param *p)
>> +{
>> +	if (!ext4_has_feature_dirdata(sb))
>> +		return NULL;
>> +	if (p && p->edp_magic =3D=3D EXT4_LUFID_MAGIC)
>> +		return &p->edp_len;
>> +	else
>> +		return NULL;
>> +}
>> +
>> /*
>>  * EXT4_DIR_PAD defines the directory entries boundaries
>>  *
>> @@ -1972,8 +2013,11 @@ struct ext4_dir_entry_tail {
>>  */
>> #define EXT4_DIR_PAD			4
>> #define EXT4_DIR_ROUND			(EXT4_DIR_PAD - 1)
>> -#define EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + =
EXT4_DIR_ROUND) & \
>> +#define __EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + =
EXT4_DIR_ROUND) & \
>> 					 ~EXT4_DIR_ROUND)
>> +#define EXT4_DIR_REC_LEN(de)		=
(__EXT4_DIR_REC_LEN(de->name_len +\
>> +					ext4_get_dirent_data_len(de)))
>=20
> Now that we have __EXT4_DIR_REC_LEN and EXT4_DIR_REC_LEN, how about a
> comment to describe how they differ from each other?

Agreed...  EXT4_DIR_REC_LEN() is the total size of the dirent including =
any
extra data, while __EXT4_DIR_REC_LEN() is just the name + inode data =
without
any extra dirdata.  I wouldn't object to better naming, maybe something =
like
EXT4_DIR_REC_LEN() and EXT4_DIR_NAME_LEN() or EXT4_DIR_ENTRY_LEN() or =
similar?

>> @@ -2376,7 +2420,10 @@ extern int ext4_find_dest_de(struct inode =
*dir, struct inode *inode,
>> 			     struct buffer_head *bh,
>> 			     void *buf, int buf_size,
>> 			     struct ext4_filename *fname,
>> -			     struct ext4_dir_entry_2 **dest_de);
>> +			     struct ext4_dir_entry_2 **dest_de,
>> +			     bool is_dotdot,
>> +			     bool *write_short_dotdot,
>> +			     unsigned short dotdot_reclen);
>> void ext4_insert_dentry(struct inode *inode,
>> 			struct ext4_dir_entry_2 *de,
>> 			int buf_size,
>> @@ -2392,10 +2439,16 @@ static const unsigned char =
ext4_filetype_table[] =3D {
>>=20
>> static inline  unsigned char get_dtype(struct super_block *sb, int =
filetype)
>> {
>> -	if (!ext4_has_feature_filetype(sb) || filetype >=3D EXT4_FT_MAX)
>> +	int fl_index =3D filetype & EXT4_FT_MASK;
>> +
>> +	if (!ext4_has_feature_filetype(sb) || fl_index >=3D EXT4_FT_MAX)
>> 		return DT_UNKNOWN;
>>=20
>> -	return ext4_filetype_table[filetype];
>> +	if (!test_opt(sb, DIRDATA))
>> +		return (ext4_filetype_table[fl_index]);
>=20
> What's the use case for having the incompat feature flag set on disk =
but
> no mount option?

Mounting with the DIRDATA option will return the full filetype to the =
caller,
but by default only the masked EXT4_FT_* filetype (converted into DT_*) =
is
returned to the caller.

>> +	return (ext4_filetype_table[fl_index]) |
>> +		(filetype & ~EXT4_FT_MASK);
>=20
> So I guess this just overrides DT_*?  Is the high nibble of =
de->filetype
> (the new EXT4_DIRENT_* flags) exposed to userspace?  It would seem to
> be, since the return value is passed to dir_emit(), in which case
> userland readdir callers are in for a surprise.

No, it is masked out before returning it to the caller, unless the =
filesystem
is mounted with "-o dirdata".  It isn't expected that users will do this
unless they have some need (e.g. Lustre, or some other extension using =
dirdata
in the future).

>> @@ -3271,6 +3324,28 @@ static inline void =
ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>>=20
>> extern const struct iomap_ops ext4_iomap_ops;
>>=20
>> +/*
>> + * Compute the total directory entry data length.
>> + * This includes the filename and an implicit NUL terminator (always =
present),
>> + * and optional extensions.  Each extension has a bit set in the =
high 4 bits of
>> + * de->file_type, and the extension length is the first byte in each =
entry.
>> + */
>> +static inline int ext4_get_dirent_data_len(struct ext4_dir_entry_2 =
*de)
>> +{
>> +	char *len =3D de->name + de->name_len + 1 /* NUL terminator */;
>> +	int dlen =3D 0;
>> +	__u8 extra_data_flags =3D (de->file_type & ~EXT4_FT_MASK) >> 4;
>> +
>> +	while (extra_data_flags) {
>> +		if (extra_data_flags & 1) {
>> +			dlen +=3D *len + (dlen =3D=3D 0);
>> +			len +=3D *len;
>=20
> Ugh, dereferencing an char pointer to get the length.  See later rant
> about adding struct ext4_dirent_data_header to avoid this raw byte
> interpretation stuff.

I'm not against changing the mechanics here, but the actual data =
structure
shouldn't be changed.

>> +		}
>> +		extra_data_flags >>=3D 1;
>> +	}
>> +	return dlen;
>> +}
>> +
>> #endif	/* __KERNEL__ */
>>=20
>> #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index 28c5c3abddb3..ea46735e18c6 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
>> @@ -1026,7 +1026,7 @@ static int ext4_add_dirent_to_inline(handle_t =
*handle,
>> 	struct ext4_dir_entry_2 *de;
>>=20
>> 	err =3D ext4_find_dest_de(dir, inode, iloc->bh, inline_start,
>> -				inline_size, fname, &de);
>> +				inline_size, fname, &de, 0, NULL, 0);
>> 	if (err)
>> 		return err;
>>=20
>> @@ -1103,7 +1103,7 @@ static int ext4_update_inline_dir(handle_t =
*handle, struct inode *dir,
>> 	int old_size =3D EXT4_I(dir)->i_inline_size - =
EXT4_MIN_INLINE_DATA_SIZE;
>> 	int new_size =3D get_max_inline_xattr_value_size(dir, iloc);
>>=20
>> -	if (new_size - old_size <=3D EXT4_DIR_REC_LEN(1))
>> +	if (new_size - old_size <=3D __EXT4_DIR_REC_LEN(1))
>> 		return -ENOSPC;
>>=20
>> 	ret =3D ext4_update_inline_data(handle, dir,
>> @@ -1384,8 +1384,8 @@ int htree_inlinedir_to_tree(struct file =
*dir_file,
>> 			fake.name_len =3D 1;
>> 			strcpy(fake.name, ".");
>> 			fake.rec_len =3D ext4_rec_len_to_disk(
>> -						=
EXT4_DIR_REC_LEN(fake.name_len),
>> -						inline_size);
>> +					=
__EXT4_DIR_REC_LEN(fake.name_len),
>> +					inline_size);
>> 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
>> 			de =3D &fake;
>> 			pos =3D EXT4_INLINE_DOTDOT_OFFSET;
>> @@ -1394,8 +1394,8 @@ int htree_inlinedir_to_tree(struct file =
*dir_file,
>> 			fake.name_len =3D 2;
>> 			strcpy(fake.name, "..");
>> 			fake.rec_len =3D ext4_rec_len_to_disk(
>> -						=
EXT4_DIR_REC_LEN(fake.name_len),
>> -						inline_size);
>> +					=
__EXT4_DIR_REC_LEN(fake.name_len),
>> +					inline_size);
>=20
> Unrelated indenting changes...

Hmm, this exposes a problem with this patch that I didn't notice before.
It seems the precursor patch "ext4-kill-dx-root.patch" is missing.  That
patch separates the handling of "struct dx_root_info" from "struct =
dx_root"
with fixed-size "fake_dirent" structures that are at the start of an =
htree
directory.  Otherwise, if "." or ".." have a dirdata field, the overlay
of "struct dx_root" on top of the dirdata will result in garbage.

Artem, is there a reason you dropped the ext4-kill-dx-root.patch part?
I can send an RFC version of that patch for review, it is mostly just
a code reorg, and IMHO an improvement over the existing dx_root =
handling.

Also, looking into this more closely, I see that this patch also needs =
to
be updated to fix get_dx_countlimit() to handle "." and ".." entries =
with
dirdata and metacsum enabled at the same time.

>> 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
>> 			de =3D &fake;
>> 			pos =3D EXT4_INLINE_DOTDOT_SIZE;
>> @@ -1492,8 +1492,8 @@ int ext4_read_inline_dir(struct file *file,
>> 	 * So we will use extra_offset and extra_size to indicate them
>> 	 * during the inline dir iteration.
>> 	 */
>> -	dotdot_offset =3D EXT4_DIR_REC_LEN(1);
>> -	dotdot_size =3D dotdot_offset + EXT4_DIR_REC_LEN(2);
>> +	dotdot_offset =3D __EXT4_DIR_REC_LEN(1);
>> +	dotdot_size =3D dotdot_offset + __EXT4_DIR_REC_LEN(2);
>> 	extra_offset =3D dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
>> 	extra_size =3D extra_offset + inline_size;
>>=20
>> @@ -1528,7 +1528,7 @@ int ext4_read_inline_dir(struct file *file,
>> 			 * failure will be detected in the
>> 			 * dirent test below. */
>> 			if (ext4_rec_len_from_disk(de->rec_len, =
extra_size)
>> -				< EXT4_DIR_REC_LEN(1))
>> +				< __EXT4_DIR_REC_LEN(1))
>> 				break;
>> 			i +=3D ext4_rec_len_from_disk(de->rec_len,
>> 						    extra_size);
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index c1cf020d1889..b09e73100e14 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -249,7 +249,8 @@ static unsigned dx_get_count(struct dx_entry =
*entries);
>> static unsigned dx_get_limit(struct dx_entry *entries);
>> static void dx_set_count(struct dx_entry *entries, unsigned value);
>> static void dx_set_limit(struct dx_entry *entries, unsigned value);
>> -static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
>> +static inline unsigned int dx_root_limit(struct inode *dir,
>> +		struct ext4_dir_entry_2 *dot_de, unsigned int infosize);
>> static unsigned dx_node_limit(struct inode *dir);
>> static struct dx_frame *dx_probe(struct ext4_filename *fname,
>> 				 struct inode *dir,
>> @@ -551,10 +552,16 @@ static inline void dx_set_limit(struct dx_entry =
*entries, unsigned value)
>> 	((struct dx_countlimit *) entries)->limit =3D =
cpu_to_le16(value);
>> }
>>=20
>> -static inline unsigned dx_root_limit(struct inode *dir, unsigned =
infosize)
>> +static inline unsigned int dx_root_limit(struct inode *dir,
>> +		struct ext4_dir_entry_2 *dot_de, unsigned int infosize)
>> {
>> -	unsigned entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(1) -
>> -		EXT4_DIR_REC_LEN(2) - infosize;
>> +	struct ext4_dir_entry_2 *dotdot_de;
>> +	unsigned int entry_space;
>> +
>> +	BUG_ON(dot_de->name_len !=3D 1);
>=20
> Yikes, this will crash the kernel when someone feeds us malicious
> metadata!

I thought that the directory buffers are always verified at read time?
However, I was trying to find the code that is doing this, but it looks
like the entries are verified at readdir() time, but only the metadata
checksum is being verified in this code path, not the dirents.

In any case, this code predates the patch and previously just assumed =
the
fake "." and ".." records in struct dx_root were valid without even =
checking.
I agree that this should be fixed (if we don't find any code path that
validates the entries before this BUG_ON()), but IMHO I'd rather hit the
BUG_ON() than corrupt the directory.

>> +	dotdot_de =3D ext4_next_entry(dot_de, dir->i_sb->s_blocksize);
>> +	entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(dot_de) -
>> +			 EXT4_DIR_REC_LEN(dotdot_de) - infosize;
>>=20
>> 	if (ext4_has_metadata_csum(dir->i_sb))
>> 		entry_space -=3D sizeof(struct dx_tail);
>> @@ -563,7 +570,8 @@ static inline unsigned dx_root_limit(struct inode =
*dir, unsigned infosize)
>>=20
>> static inline unsigned dx_node_limit(struct inode *dir)
>> {
>> -	unsigned entry_space =3D dir->i_sb->s_blocksize - =
EXT4_DIR_REC_LEN(0);
>> +	unsigned int entry_space =3D dir->i_sb->s_blocksize -
>> +					__EXT4_DIR_REC_LEN(0);
>>=20
>> 	if (ext4_has_metadata_csum(dir->i_sb))
>> 		entry_space -=3D sizeof(struct dx_tail);
>> @@ -675,7 +683,7 @@ static struct stats dx_show_leaf(struct inode =
*dir,
>> 				       (unsigned) ((char *) de - base));
>> #endif
>> 			}
>> -			space +=3D EXT4_DIR_REC_LEN(de->name_len);
>> +			space +=3D EXT4_DIR_REC_LEN(de);
>> 			names++;
>> 		}
>> 		de =3D ext4_next_entry(de, size);
>> @@ -785,10 +793,14 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
>> 				      root->info.info_length);
>>=20
>> 	if (dx_get_limit(entries) !=3D dx_root_limit(dir,
>> -						   =
root->info.info_length)) {
>> +				(struct ext4_dir_entry_2 *) =
frame->bh->b_data,
>> +				root->info.info_length)) {
>> 		ext4_warning_inode(dir, "dx entry: limit %u !=3D root =
limit %u",
>> 				   dx_get_limit(entries),
>> -				   dx_root_limit(dir, =
root->info.info_length));
>> +				   dx_root_limit(dir,
>> +						 (struct =
ext4_dir_entry_2 *)
>> +						 frame->bh->b_data,
>> +						 =
root->info.info_length));
>> 		goto fail;
>> 	}
>>=20
>> @@ -980,7 +992,7 @@ static int htree_dirblock_to_tree(struct file =
*dir_file,
>> 	de =3D (struct ext4_dir_entry_2 *) bh->b_data;
>> 	top =3D (struct ext4_dir_entry_2 *) ((char *) de +
>> 					   dir->i_sb->s_blocksize -
>> -					   EXT4_DIR_REC_LEN(0));
>> +					   __EXT4_DIR_REC_LEN(0));
>> #ifdef CONFIG_EXT4_FS_ENCRYPTION
>> 	/* Check if the directory is encrypted */
>> 	if (ext4_encrypted_inode(dir)) {
>> @@ -1563,6 +1575,7 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
>> 	inode =3D NULL;
>> 	if (bh) {
>> 		__u32 ino =3D le32_to_cpu(de->inode);
>> +
>> 		brelse(bh);
>> 		if (!ext4_valid_inum(dir->i_sb, ino)) {
>> 			EXT4_ERROR_INODE(dir, "bad inode number: %u", =
ino);
>> @@ -1631,7 +1644,7 @@ dx_move_dirents(char *from, char *to, struct =
dx_map_entry *map, int count,
>> 	while (count--) {
>> 		struct ext4_dir_entry_2 *de =3D (struct ext4_dir_entry_2 =
*)
>> 						(from + (map->offs<<2));
>> -		rec_len =3D EXT4_DIR_REC_LEN(de->name_len);
>> +		rec_len =3D EXT4_DIR_REC_LEN(de);
>> 		memcpy (to, de, rec_len);
>> 		((struct ext4_dir_entry_2 *) to)->rec_len =3D
>> 				ext4_rec_len_to_disk(rec_len, =
blocksize);
>> @@ -1655,7 +1668,7 @@ static struct ext4_dir_entry_2* =
dx_pack_dirents(char *base, unsigned blocksize)
>> 	while ((char*)de < base + blocksize) {
>> 		next =3D ext4_next_entry(de, blocksize);
>> 		if (de->inode && de->name_len) {
>> -			rec_len =3D EXT4_DIR_REC_LEN(de->name_len);
>> +			rec_len =3D EXT4_DIR_REC_LEN(de);
>> 			if (de > to)
>> 				memmove(to, de, rec_len);
>> 			to->rec_len =3D ext4_rec_len_to_disk(rec_len, =
blocksize);
>> @@ -1786,10 +1799,13 @@ int ext4_find_dest_de(struct inode *dir, =
struct inode *inode,
>> 		      struct buffer_head *bh,
>> 		      void *buf, int buf_size,
>> 		      struct ext4_filename *fname,
>> -		      struct ext4_dir_entry_2 **dest_de)
>> +		      struct ext4_dir_entry_2 **dest_de,
>> +		      bool is_dotdot,
>> +		      bool *write_short_dotdot,
>> +		      unsigned short dotdot_reclen)
>> {
>> 	struct ext4_dir_entry_2 *de;
>> -	unsigned short reclen =3D EXT4_DIR_REC_LEN(fname_len(fname));
>> +	unsigned short reclen =3D __EXT4_DIR_REC_LEN(fname_len(fname));
>> 	int nlen, rlen;
>> 	unsigned int offset =3D 0;
>> 	char *top;
>> @@ -1802,10 +1818,28 @@ int ext4_find_dest_de(struct inode *dir, =
struct inode *inode,
>> 			return -EFSCORRUPTED;
>> 		if (ext4_match(fname, de))
>> 			return -EEXIST;
>> -		nlen =3D EXT4_DIR_REC_LEN(de->name_len);
>> +		nlen =3D EXT4_DIR_REC_LEN(de);
>> 		rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
>> +		/* Check first for enough space for the full entry */
>> 		if ((de->inode ? rlen - nlen : rlen) >=3D reclen)
>> 			break;
>> +		/* Then for dotdot entries, check for the smaller space
>> +		 * required for just the entry, no FID
>> +		 */
>> +		if (is_dotdot) {
>> +			if ((de->inode ? rlen - nlen : rlen) >=3D
>> +			    dotdot_reclen) {
>> +				*write_short_dotdot =3D true;
>> +				break;
>> +			}
>> +			/* The new ".." entry mut be written over the
>> +			 * previous ".." entry, which is the first
>> +			 * entry traversed by this scan.  If it doesn't
>> +			 * fit, something is badly wrong, so -EIO.
>> +			 */
>> +			return -EIO;
>> +		}
>> +
>> 		de =3D (struct ext4_dir_entry_2 *)((char *)de + rlen);
>> 		offset +=3D rlen;
>> 	}
>> @@ -1824,7 +1858,8 @@ void ext4_insert_dentry(struct inode *inode,
>>=20
>> 	int nlen, rlen;
>>=20
>> -	nlen =3D EXT4_DIR_REC_LEN(de->name_len);
>> +	nlen =3D EXT4_DIR_REC_LEN(de);
>> +
>> 	rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
>> 	if (de->inode) {
>> 		struct ext4_dir_entry_2 *de1 =3D
>> @@ -1848,21 +1883,46 @@ void ext4_insert_dentry(struct inode *inode,
>>  * space.  It will return -ENOSPC if no space is available, and -EIO
>>  * and -EEXIST if directory entry already exists.
>>  */
>> -static int add_dirent_to_buf(handle_t *handle, struct ext4_filename =
*fname,
>> +static int add_dirent_to_buf(handle_t *handle,
>> +			     struct dentry *dentry,
>> +			     struct ext4_filename *fname,
>> 			     struct inode *dir,
>> 			     struct inode *inode, struct =
ext4_dir_entry_2 *de,
>> 			     struct buffer_head *bh)
>> {
>> 	unsigned int	blocksize =3D dir->i_sb->s_blocksize;
>> 	int		csum_size =3D 0;
>> -	int		err;
>> +	unsigned short	reclen, dotdot_reclen =3D 0;
>> +	int		 err, dlen =3D 0;
>> +	bool		is_dotdot =3D false, write_short_dotdot =3D =
false;
>> +	unsigned char	*data;
>> +	int namelen =3D dentry->d_name.len;
>>=20
>> 	if (ext4_has_metadata_csum(inode->i_sb))
>> 		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20
>> +	data =3D ext4_dentry_get_data(inode->i_sb, (struct =
ext4_dentry_param *)
>> +						dentry->d_fsdata);
>> +	if (data)
>> +		dlen =3D (*data) + 1;
>=20
> Ok, now I /really/ want this to be some kind of data structure instead
> of raw dereferencing of an unsigned char pointer to find the length.
>=20
> struct ext4_dirent_data_header {
> 	/* length of this header + the whole data blob */
> 	__u8				ddh_length;
> } __packed;
>=20
> struct ext4_dirent_lufid {
> 	struct ext4_dirent_data_header	dl_header; /* 6+ */
> 	__le32				dl_magic; /* 0xAD200907 */
> 	__u8				dl_datalen;
> 	__u8				dl_data[0];
> } __packed;

This is adding extra complexity, which IMHO isn't necessarily better =
than
just dereferencing a pointer to the size directly.  The buffer returned
by ext4_dentry_get_data() is already stripping off the magic (which is =
the
first field, but is not written to disk) and then returns only the =
dirdata.

If we are going down this road, it should instead be:

struct ext4_dirent_lufid {
	struct ext4_dirent_data_header	dl_header;	/* 1 + 16n */
	__u8				dl_data[0];
} __packed;

struct ext4_dentry_param {
	__u32  				edp_magic;	/* =
EXT4_LUFID_MAGIC */
	struct ext4_dirent_lufid	edp_lufid;
} __packed;

struct ext4_dirent_inohi {
	struct ext4_dirent_data_header	di_header;	/* 1 + 4 */
	__le32				di_inohi;
} __packed;

> ...and then:

I think actually:

	struct ext4_dirent_data_header *ddh =3D =
ext4_dentry_get_data(...);

	if (ddh)
		dlen =3D ddh->ddh_length + 1 /* NUL separator */;

>> +	is_dotdot =3D (namelen =3D=3D 2 &&
>> +		     memcmp(dentry->d_name.name, "..", 2) =3D=3D 0);
>> +
>> +	/* dotdot entries must be in the second place in a directory =
block,
>> +	 * so calculate an alternate length without the dirdata so they =
can
>> +	 * always be made to fit in the existing slot
>> +	 */
>> +	if (is_dotdot)
>> +		dotdot_reclen =3D __EXT4_DIR_REC_LEN(namelen);
>> +
>> +	reclen =3D __EXT4_DIR_REC_LEN(namelen + dlen + 3);
>> +
>> 	if (!de) {
>> 		err =3D ext4_find_dest_de(dir, inode, bh, bh->b_data,
>> -					blocksize - csum_size, fname, =
&de);
>> +					blocksize - csum_size, fname, =
&de,
>> +					is_dotdot,
>> +					&write_short_dotdot, =
dotdot_reclen);
>> 		if (err)
>> 			return err;
>> 	}
>> @@ -1876,6 +1936,13 @@ static int add_dirent_to_buf(handle_t *handle, =
struct ext4_filename *fname,
>> 	/* By now the buffer is marked for journaling */
>> 	ext4_insert_dentry(inode, de, blocksize, fname);
>>=20
>> +	/* If we're writing short form of "dotdot", don't add data =
section */
>> +	if (data && !write_short_dotdot) {
>=20
> What if we're writing a long dotdot entry and write_short_dotdot is =
true?
> We're not just dropping the LUFID on the floor, are we?

Correct.  For Lustre, the LUFID in the directory entry is somewhat =
equivalent
to the file type in the dirent.  Having it available for readdir() =
improves
performance significantly, but if it isn't available we can extract it =
from
an xattr stored on the inode at the expense of reading every inode in =
the
directory from disk, which hurts "find" and "ls" performance =
significantly.

In any case, I mentioned this issue in the context of the inode64 patch,
where it is NOT OK to drop the high 32 bits of the inode number, but for
Lustre FID it is OK to drop the FID on the floor.  That only happens if =
an
old (8+ years without dirdata) filesystem is upgraded to a new version =
with
dirdata enabled, but the directory block is too full to add the FID into
the ".." entry.

>> +		de->name[namelen] =3D 0;
>=20
> Not sure why we suddenly need this extra null byte in the name; we've
> gotten along just fine without it.

To separate the name from the rest of the dirdata fields...  If reading
the dirents with "-o dirdata" then the names will be NUL terminated for
the caller, and if they don't care about the dirdata they won't explode.
In any case, this is part of the on-disk format for hundreds of PB
(maybe EB at this point) of ext4 filesystems, so it is hard to change at
this point. Since it is only added when dirdata is used, and increases
the space usage in a fraction of cases (dirents are 4-byte aligned =
anyway)
it isn't a huge deal IMHO.

>> +		memcpy(&de->name[namelen + 1], data, *(char *)data);
>=20
> 		memcpy(&de->name[namelen + 1], dl, =
dl->dl_header.ddh_length);
>=20
> (Endian conversions?)

You don't need endian conversion for a one-byte field...

>=20
> --D
>=20
>> +		de->file_type |=3D EXT4_DIRENT_LUFID;
>> +	}
>> +
>> 	/*
>> 	 * XXX shouldn't update any times until successful
>> 	 * completion of syscall, but too many callers depend
>> @@ -1970,7 +2037,7 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
>>=20
>> 	/* Initialize the root; the dot dirents already exist */
>> 	de =3D (struct ext4_dir_entry_2 *) (&root->dotdot);
>> -	de->rec_len =3D ext4_rec_len_to_disk(blocksize - =
EXT4_DIR_REC_LEN(2),
>> +	de->rec_len =3D ext4_rec_len_to_disk(blocksize - =
__EXT4_DIR_REC_LEN(2),
>> 					   blocksize);
>> 	memset (&root->info, 0, sizeof(root->info));
>> 	root->info.info_length =3D sizeof(root->info);
>> @@ -1978,7 +2045,8 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
>> 	entries =3D root->entries;
>> 	dx_set_block(entries, 1);
>> 	dx_set_count(entries, 1);
>> -	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
>> +	dx_set_limit(entries, dx_root_limit(dir,
>> +					 fde, sizeof(root->info)));
>>=20
>> 	/* Initialize as for dx_probe */
>> 	fname->hinfo.hash_version =3D root->info.hash_version;
>> @@ -2006,7 +2074,7 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
>> 		goto out_frames;
>> 	}
>>=20
>> -	retval =3D add_dirent_to_buf(handle, fname, dir, inode, de, =
bh2);
>> +	retval =3D add_dirent_to_buf(handle, NULL, fname, dir, inode, =
de, bh2);
>> out_frames:
>> 	/*
>> 	 * Even if the block split failed, we have to properly write
>> @@ -2083,7 +2151,7 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
>> 			bh =3D NULL;
>> 			goto out;
>> 		}
>> -		retval =3D add_dirent_to_buf(handle, &fname, dir, inode,
>> +		retval =3D add_dirent_to_buf(handle, dentry, &fname, =
dir, inode,
>> 					   NULL, bh);
>> 		if (retval !=3D -ENOSPC)
>> 			goto out;
>> @@ -2112,7 +2180,7 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
>> 		initialize_dirent_tail(t, blocksize);
>> 	}
>>=20
>> -	retval =3D add_dirent_to_buf(handle, &fname, dir, inode, de, =
bh);
>> +	retval =3D add_dirent_to_buf(handle, dentry, &fname, dir, inode, =
de, bh);
>> out:
>> 	ext4_fname_free_filename(&fname);
>> 	brelse(bh);
>> @@ -2154,7 +2222,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
>> 	if (err)
>> 		goto journal_error;
>>=20
>> -	err =3D add_dirent_to_buf(handle, fname, dir, inode, NULL, bh);
>> +	err =3D add_dirent_to_buf(handle, NULL, fname, dir, inode, NULL, =
bh);
>> 	if (err !=3D -ENOSPC)
>> 		goto cleanup;
>>=20
>> @@ -2279,7 +2347,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
>> 		err =3D PTR_ERR(de);
>> 		goto cleanup;
>> 	}
>> -	err =3D add_dirent_to_buf(handle, fname, dir, inode, de, bh);
>> +	err =3D add_dirent_to_buf(handle, NULL, fname, dir, inode, de, =
bh);
>> 	goto cleanup;
>>=20
>> journal_error:
>> @@ -2545,7 +2613,7 @@ struct ext4_dir_entry_2 =
*ext4_init_dot_dotdot(struct inode *inode,
>> {
>> 	de->inode =3D cpu_to_le32(inode->i_ino);
>> 	de->name_len =3D 1;
>> -	de->rec_len =3D =
ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
>> +	de->rec_len =3D ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de),
>> 					   blocksize);
>> 	strcpy(de->name, ".");
>> 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
>> @@ -2555,11 +2623,11 @@ struct ext4_dir_entry_2 =
*ext4_init_dot_dotdot(struct inode *inode,
>> 	de->name_len =3D 2;
>> 	if (!dotdot_real_len)
>> 		de->rec_len =3D ext4_rec_len_to_disk(blocksize -
>> -					(csum_size + =
EXT4_DIR_REC_LEN(1)),
>> +					(csum_size + =
__EXT4_DIR_REC_LEN(1)),
>> 					blocksize);
>> 	else
>> 		de->rec_len =3D ext4_rec_len_to_disk(
>> -				EXT4_DIR_REC_LEN(de->name_len), =
blocksize);
>> +				EXT4_DIR_REC_LEN(de), blocksize);
>> 	strcpy(de->name, "..");
>> 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
>>=20
>> @@ -2688,7 +2756,7 @@ bool ext4_empty_dir(struct inode *inode)
>> 	}
>>=20
>> 	sb =3D inode->i_sb;
>> -	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)) {
>> +	if (inode->i_size < __EXT4_DIR_REC_LEN(1) + =
__EXT4_DIR_REC_LEN(2)) {
>> 		EXT4_ERROR_INODE(inode, "invalid size");
>> 		return true;
>> 	}
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index b0915b734a38..ead9406d9cff 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1339,7 +1339,7 @@ enum {
>> 	Opt_data_err_abort, Opt_data_err_ignore, =
Opt_test_dummy_encryption,
>> 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, =
Opt_offgrpjquota,
>> 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
>> -	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
>> +	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err, Opt_dirdata,
>> 	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version, =
Opt_dax,
>> 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
>> 	Opt_lazytime, Opt_nolazytime, Opt_debug_want_extra_isize,
>> @@ -1400,6 +1400,7 @@ static const match_table_t tokens =3D {
>> 	{Opt_noquota, "noquota"},
>> 	{Opt_quota, "quota"},
>> 	{Opt_usrquota, "usrquota"},
>> +	{Opt_dirdata, "dirdata"},
>> 	{Opt_prjquota, "prjquota"},
>> 	{Opt_barrier, "barrier=3D%u"},
>> 	{Opt_barrier, "barrier"},
>> --
>> 2.13.5 (Apple Git-94)


Cheers, Andreas






--Apple-Mail=_6F29F37C-B69E-4915-B478-DF6769EAF04E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaApjcpIg59Q01vtYRAnijAKCaT7xSMQEH097+s3j1w0WNd8HoMACeIk8k
X5hpAfhfAiTMPv3QyRjmf7M=
=McZ7
-----END PGP SIGNATURE-----

--Apple-Mail=_6F29F37C-B69E-4915-B478-DF6769EAF04E--
