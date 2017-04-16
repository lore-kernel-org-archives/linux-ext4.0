From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH] ext4: xattr-in-inode support
Date: Sun, 16 Apr 2017 22:09:34 +0300
Message-ID: <45DBE249-1CDD-421A-903E-7021BD1426C7@gmail.com>
References: <86611BEE-5695-4047-9404-D2D3E232318A@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Ts'o Theodore <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        James Simmons <jsimmons@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36034 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756597AbdDPTJo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Apr 2017 15:09:44 -0400
Received: by mail-lf0-f68.google.com with SMTP id 75so14166818lfs.3
        for <linux-ext4@vger.kernel.org>; Sun, 16 Apr 2017 12:09:42 -0700 (PDT)
In-Reply-To: <86611BEE-5695-4047-9404-D2D3E232318A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas,

I don=E2=80=99t sure it=E2=80=99s good idea to allocate one more inode =
to store a large EA.
It dramatically decrease a speed with accessing a EA data in this case.
And now we have already a hit a limit of inode count with large disks.
I think it code need to be rewritten to use an special extents to store =
a large EA, as it avoid so much problems related to bad credits while =
unlinking a parent inode,
some kind problems with integer overflow as backlink stored on mdata =
field, and other.

I know we don=E2=80=99t hit a problems in this area for last year, but =
anyway - i prefer a different solution.

> 13 =D0=B0=D0=BF=D1=80. 2017 =D0=B3., =D0=B2 22:58, Andreas Dilger =
<adilger@dilger.ca> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> Large xattr support is implemented for EXT4_FEATURE_INCOMPAT_EA_INODE.
>=20
> If the size of an xattr value is larger than will fit in a single
> external block, then the xattr value will be saved into the body
> of an external xattr inode.
>=20
> The also helps support a larger number of xattr, since only the =
headers
> will be stored in the in-inode space or the single external block.
>=20
> The inode is referenced from the xattr header via "e_value_inum",
> which was formerly "e_value_block", but that field was never used.
> The e_value_size still contains the xattr size so that listing
> xattrs does not need to look up the inode if the data is not accessed.
>=20
> struct ext4_xattr_entry {
> 	__u8	e_name_len;	/* length of name */
> 	__u8	e_name_index;	/* attribute name index */
> 	__le16	e_value_offs;	/* offset in disk block of value */
> 	__le32	e_value_inum;	/* inode in which value is stored */
> 	__le32	e_value_size;	/* size of attribute value */
> 	__le32	e_hash;		/* hash value of name and value */
> 	char	e_name[0];	/* attribute name */
> };
>=20
> The xattr inode is marked with the EXT4_EA_INODE_FL flag and also
> holds a back-reference to the owning inode in its i_mtime field,
> allowing the ext4/e2fsck to verify the correct inode is accessed.
>=20
> Lustre-Jira: https://jira.hpdd.intel.com/browse/LU-80
> Lustre-bugzilla: https://bugzilla.lustre.org/show_bug.cgi?id=3D4424
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
> Signed-off-by: James Simmons <uja.ornl@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>=20
> Per recent discussion, here is the latest version of the =
xattr-in-inode
> patch.  This has just been freshly updated to the current kernel (from
> 4.4) and has not even been compiled, so it is unlikely to work =
properly.
> The functional parts of the feature and on-disk format are unchanged,
> and is really what Ted is interested in.
>=20
> Cheers, Andreas
> --
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index fb69ee2..afe830b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1797,6 +1797,7 @@ static inline void ext4_clear_state_flags(struct =
ext4_inode_info *ei)
> 					 EXT4_FEATURE_INCOMPAT_EXTENTS| =
\
> 					 EXT4_FEATURE_INCOMPAT_64BIT| \
> 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| =
\
> +					 EXT4_FEATURE_INCOMPAT_EA_INODE| =
\
> 					 EXT4_FEATURE_INCOMPAT_MMP | \
> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
> @@ -2220,6 +2221,12 @@ struct mmpd_data {
> #define EXT4_MMP_MAX_CHECK_INTERVAL	300UL
>=20
> /*
> + * Maximum size of xattr attributes for FEATURE_INCOMPAT_EA_INODE 1Mb
> + * This limit is arbitrary, but is reasonable for the xattr API.
> + */
> +#define EXT4_XATTR_MAX_LARGE_EA_SIZE    (1024 * 1024)
> +
> +/*
>  * Function prototypes
>  */
>=20
> @@ -2231,6 +2238,10 @@ struct mmpd_data {
> # define ATTRIB_NORET	__attribute__((noreturn))
> # define NORET_AND	noreturn,
>=20
> +struct ext4_xattr_ino_array {
> +	unsigned int xia_count;		/* # of used item in the array =
*/
> +	unsigned int xia_inodes[0];
> +};
> /* bitmap.c */
> extern unsigned int ext4_count_free(char *bitmap, unsigned numchars);
> void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t =
group,
> @@ -2480,6 +2491,7 @@ int do_journal_get_write_access(handle_t =
*handle,
> extern void ext4_get_inode_flags(struct ext4_inode_info *);
> extern int ext4_alloc_da_blocks(struct inode *inode);
> extern void ext4_set_aops(struct inode *inode);
> +extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int =
chunk);
> extern int ext4_writepage_trans_blocks(struct inode *);
> extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
> extern int ext4_zero_partial_blocks(handle_t *handle, struct inode =
*inode,
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 17bc043..01eaad6 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -294,7 +294,6 @@ void ext4_free_inode(handle_t *handle, struct =
inode *inode)
> 	 * as writing the quota to disk may need the lock as well.
> 	 */
> 	dquot_initialize(inode);
> -	ext4_xattr_delete_inode(handle, inode);
> 	dquot_free_inode(inode);
> 	dquot_drop(inode);
>=20
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 375fb1c..9601496 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -61,7 +61,7 @@ static int get_max_inline_xattr_value_size(struct =
inode *inode,
>=20
> 	/* Compute min_offs. */
> 	for (; !IS_LAST_ENTRY(entry); entry =3D EXT4_XATTR_NEXT(entry)) =
{
> -		if (!entry->e_value_block && entry->e_value_size) {
> +		if (!entry->e_value_inum && entry->e_value_size) {
> 			size_t offs =3D =
le16_to_cpu(entry->e_value_offs);
> 			if (offs < min_offs)
> 				min_offs =3D offs;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b9ffa9f..70069e0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -139,8 +139,6 @@ static void ext4_invalidatepage(struct page *page, =
unsigned int offset,
> 				unsigned int length);
> static int __ext4_journalled_writepage(struct page *page, unsigned int =
len);
> static int ext4_bh_delay_or_unwritten(handle_t *handle, struct =
buffer_head *bh);
> -static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> -				  int pextents);
>=20
> /*
>  * Test whether an inode is a fast symlink.
> @@ -189,6 +187,8 @@ void ext4_evict_inode(struct inode *inode)
> {
> 	handle_t *handle;
> 	int err;
> +	int extra_credits =3D 3;
> +	struct ext4_xattr_ino_array *lea_ino_array =3D NULL;
>=20
> 	trace_ext4_evict_inode(inode);
>=20
> @@ -238,8 +238,8 @@ void ext4_evict_inode(struct inode *inode)
> 	 * protection against it
> 	 */
> 	sb_start_intwrite(inode->i_sb);
> -	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE,
> -				    ext4_blocks_for_truncate(inode)+3);
> +
> +	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE, =
extra_credits);
> 	if (IS_ERR(handle)) {
> 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
> 		/*
> @@ -251,9 +251,36 @@ void ext4_evict_inode(struct inode *inode)
> 		sb_end_intwrite(inode->i_sb);
> 		goto no_delete;
> 	}
> -
> 	if (IS_SYNC(inode))
> 		ext4_handle_sync(handle);
> +
> +	/*
> +	 * Delete xattr inode before deleting the main inode.
> +	 */
> +	err =3D ext4_xattr_delete_inode(handle, inode, &lea_ino_array);
> +	if (err) {
> +		ext4_warning(inode->i_sb,
> +			     "couldn't delete inode's xattr (err %d)", =
err);
> +		goto stop_handle;
> +	}
> +
> +	if (!IS_NOQUOTA(inode))
> +		extra_credits +=3D 2 * =
EXT4_QUOTA_DEL_BLOCKS(inode->i_sb);
> +
> +	if (!ext4_handle_has_enough_credits(handle,
> +			ext4_blocks_for_truncate(inode) + =
extra_credits)) {
> +		err =3D ext4_journal_extend(handle,
> +			ext4_blocks_for_truncate(inode) + =
extra_credits);
> +		if (err > 0)
> +			err =3D ext4_journal_restart(handle,
> +			ext4_blocks_for_truncate(inode) + =
extra_credits);
> +		if (err !=3D 0) {
> +			ext4_warning(inode->i_sb,
> +				     "couldn't extend journal (err %d)", =
err);
> +			goto stop_handle;
> +		}
> +	}
> +
> 	inode->i_size =3D 0;
> 	err =3D ext4_mark_inode_dirty(handle, inode);
> 	if (err) {
> @@ -277,10 +304,10 @@ void ext4_evict_inode(struct inode *inode)
> 	 * enough credits left in the handle to remove the inode from
> 	 * the orphan list and set the dtime field.
> 	 */
> -	if (!ext4_handle_has_enough_credits(handle, 3)) {
> -		err =3D ext4_journal_extend(handle, 3);
> +	if (!ext4_handle_has_enough_credits(handle, extra_credits)) {
> +		err =3D ext4_journal_extend(handle, extra_credits);
> 		if (err > 0)
> -			err =3D ext4_journal_restart(handle, 3);
> +			err =3D ext4_journal_restart(handle, =
extra_credits);
> 		if (err !=3D 0) {
> 			ext4_warning(inode->i_sb,
> 				     "couldn't extend journal (err %d)", =
err);
> @@ -315,8 +342,12 @@ void ext4_evict_inode(struct inode *inode)
> 		ext4_clear_inode(inode);
> 	else
> 		ext4_free_inode(handle, inode);
> +
> 	ext4_journal_stop(handle);
> 	sb_end_intwrite(inode->i_sb);
> +
> +	if (lea_ino_array !=3D NULL)
> +		ext4_xattr_inode_array_free(inode, lea_ino_array);
> 	return;
> no_delete:
> 	ext4_clear_inode(inode);	/* We must guarantee clearing of =
inode... */
> @@ -5475,7 +5506,7 @@ static int ext4_index_trans_blocks(struct inode =
*inode, int lblocks,
>  *
>  * Also account for superblock, inode, quota and xattr blocks
>  */
> -static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> +int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> 				  int pextents)
> {
> 	ext4_group_t groups, ngroups =3D =
ext4_get_groups_count(inode->i_sb);
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 996e790..f158798 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -190,9 +190,8 @@ static void ext4_xattr_block_csum_set(struct inode =
*inode,
>=20
> 	/* Check the values */
> 	while (!IS_LAST_ENTRY(entry)) {
> -		if (entry->e_value_block !=3D 0)
> -			return -EFSCORRUPTED;
> -		if (entry->e_value_size !=3D 0) {
> +		if (entry->e_value_size !=3D 0 &&
> +		    entry->e_value_inum =3D=3D 0) {
> 			u16 offs =3D le16_to_cpu(entry->e_value_offs);
> 			u32 size =3D le32_to_cpu(entry->e_value_size);
> 			void *value;
> @@ -258,19 +257,26 @@ static void ext4_xattr_block_csum_set(struct =
inode *inode,
> 	__xattr_check_inode((inode), (header), (end), __func__, =
__LINE__)
>=20
> static inline int
> -ext4_xattr_check_entry(struct ext4_xattr_entry *entry, size_t size)
> +ext4_xattr_check_entry(struct ext4_xattr_entry *entry, size_t size,
> +		       struct inode *inode)
> {
> 	size_t value_size =3D le32_to_cpu(entry->e_value_size);
>=20
> -	if (entry->e_value_block !=3D 0 || value_size > size ||
> +	if (!entry->e_value_inum &&
> 	    le16_to_cpu(entry->e_value_offs) + value_size > size)
> 		return -EFSCORRUPTED;
> +	if (entry->e_value_inum &&
> +	    (le32_to_cpu(entry->e_value_inum) < =
EXT4_FIRST_INO(inode->i_sb) ||
> +	     le32_to_cpu(entry->e_value_inum) >
> +	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_inodes_count)))
> +		return -EFSCORRUPTED;
> 	return 0;
> }
>=20
> static int
> ext4_xattr_find_entry(struct ext4_xattr_entry **pentry, int =
name_index,
> -		      const char *name, size_t size, int sorted)
> +		      const char *name, size_t size, int sorted,
> +		      struct inode *inode)
> {
> 	struct ext4_xattr_entry *entry;
> 	size_t name_len;
> @@ -290,11 +296,104 @@ static void ext4_xattr_block_csum_set(struct =
inode *inode,
> 			break;
> 	}
> 	*pentry =3D entry;
> -	if (!cmp && ext4_xattr_check_entry(entry, size))
> +	if (!cmp && ext4_xattr_check_entry(entry, size, inode))
> 		return -EFSCORRUPTED;
> 	return cmp ? -ENODATA : 0;
> }
>=20
> +/*
> + * Read the EA value from an inode.
> + */
> +static int
> +ext4_xattr_inode_read(struct inode *ea_inode, void *buf, size_t =
*size)
> +{
> +	unsigned long block =3D 0;
> +	struct buffer_head *bh =3D NULL;
> +	int blocksize;
> +	size_t csize, ret_size =3D 0;
> +
> +	if (*size =3D=3D 0)
> +		return 0;
> +
> +	blocksize =3D ea_inode->i_sb->s_blocksize;
> +
> +	while (ret_size < *size) {
> +		csize =3D (*size - ret_size) > blocksize ? blocksize :
> +							*size - =
ret_size;
> +		bh =3D ext4_bread(NULL, ea_inode, block, 0);
> +		if (IS_ERR(bh)) {
> +			*size =3D ret_size;
> +			return PTR_ERR(bh);
> +		}
> +		memcpy(buf, bh->b_data, csize);
> +		brelse(bh);
> +
> +		buf +=3D csize;
> +		block +=3D 1;
> +		ret_size +=3D csize;
> +	}
> +
> +	*size =3D ret_size;
> +
> +	return 0;
> +}
> +
> +struct inode *ext4_xattr_inode_iget(struct inode *parent, unsigned =
long ea_ino, int *err)
> +{
> +	struct inode *ea_inode =3D NULL;
> +
> +	ea_inode =3D ext4_iget(parent->i_sb, ea_ino);
> +	if (IS_ERR(ea_inode) || is_bad_inode(ea_inode)) {
> +		int rc =3D IS_ERR(ea_inode) ? PTR_ERR(ea_inode) : 0;
> +		ext4_error(parent->i_sb, "error while reading EA inode =
%lu "
> +			   "/ %d %d", ea_ino, rc, =
is_bad_inode(ea_inode));
> +		*err =3D rc !=3D 0 ? rc : -EIO;
> +		return NULL;
> +	}
> +
> +	if (EXT4_XATTR_INODE_GET_PARENT(ea_inode) !=3D parent->i_ino ||
> +	    ea_inode->i_generation !=3D parent->i_generation) {
> +		ext4_error(parent->i_sb, "Backpointer from EA inode %lu =
"
> +			   "to parent invalid.", ea_ino);
> +		*err =3D -EINVAL;
> +		goto error;
> +	}
> +
> +	if (!(EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL)) {
> +		ext4_error(parent->i_sb, "EA inode %lu does not have "
> +			   "EXT4_EA_INODE_FL flag set.\n", ea_ino);
> +		*err =3D -EINVAL;
> +		goto error;
> +	}
> +
> +	*err =3D 0;
> +	return ea_inode;
> +
> +error:
> +	iput(ea_inode);
> +	return NULL;
> +}
> +
> +/*
> + * Read the value from the EA inode.
> + */
> +static int
> +ext4_xattr_inode_get(struct inode *inode, unsigned long ea_ino, void =
*buffer,
> +		     size_t *size)
> +{
> +	struct inode *ea_inode =3D NULL;
> +	int err;
> +
> +	ea_inode =3D ext4_xattr_inode_iget(inode, ea_ino, &err);
> +	if (err)
> +		return err;
> +
> +	err =3D ext4_xattr_inode_read(ea_inode, buffer, size);
> +	iput(ea_inode);
> +
> +	return err;
> +}
> +
> static int
> ext4_xattr_block_get(struct inode *inode, int name_index, const char =
*name,
> 		     void *buffer, size_t buffer_size)
> @@ -327,7 +426,8 @@ static void ext4_xattr_block_csum_set(struct inode =
*inode,
> 	}
> 	ext4_xattr_cache_insert(ext4_mb_cache, bh);
> 	entry =3D BFIRST(bh);
> -	error =3D ext4_xattr_find_entry(&entry, name_index, name, =
bh->b_size, 1);
> +	error =3D ext4_xattr_find_entry(&entry, name_index, name, =
bh->b_size, 1,
> +				      inode);
> 	if (error =3D=3D -EFSCORRUPTED)
> 		goto bad_block;
> 	if (error)
> @@ -337,8 +437,16 @@ static void ext4_xattr_block_csum_set(struct =
inode *inode,
> 		error =3D -ERANGE;
> 		if (size > buffer_size)
> 			goto cleanup;
> -		memcpy(buffer, bh->b_data + =
le16_to_cpu(entry->e_value_offs),
> -		       size);
> +		if (entry->e_value_inum) {
> +			error =3D ext4_xattr_inode_get(inode,
> +					     =
le32_to_cpu(entry->e_value_inum),
> +					     buffer, &size);
> +			if (error)
> +				goto cleanup;
> +		} else {
> +			memcpy(buffer, bh->b_data +
> +			       le16_to_cpu(entry->e_value_offs), size);
> +		}
> 	}
> 	error =3D size;
>=20
> @@ -372,7 +480,7 @@ static void ext4_xattr_block_csum_set(struct inode =
*inode,
> 	if (error)
> 		goto cleanup;
> 	error =3D ext4_xattr_find_entry(&entry, name_index, name,
> -				      end - (void *)entry, 0);
> +				      end - (void *)entry, 0, inode);
> 	if (error)
> 		goto cleanup;
> 	size =3D le32_to_cpu(entry->e_value_size);
> @@ -380,8 +488,16 @@ static void ext4_xattr_block_csum_set(struct =
inode *inode,
> 		error =3D -ERANGE;
> 		if (size > buffer_size)
> 			goto cleanup;
> -		memcpy(buffer, (void *)IFIRST(header) +
> -		       le16_to_cpu(entry->e_value_offs), size);
> +		if (entry->e_value_inum) {
> +			error =3D ext4_xattr_inode_get(inode,
> +					     =
le32_to_cpu(entry->e_value_inum),
> +					     buffer, &size);
> +			if (error)
> +				goto cleanup;
> +		} else {
> +			memcpy(buffer, (void *)IFIRST(header) +
> +			       le16_to_cpu(entry->e_value_offs), size);
> +		}
> 	}
> 	error =3D size;
>=20
> @@ -648,7 +764,7 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
> 				    size_t *min_offs, void *base, int =
*total)
> {
> 	for (; !IS_LAST_ENTRY(last); last =3D EXT4_XATTR_NEXT(last)) {
> -		if (last->e_value_size) {
> +		if (!last->e_value_inum && last->e_value_size) {
> 			size_t offs =3D le16_to_cpu(last->e_value_offs);
> 			if (offs < *min_offs)
> 				*min_offs =3D offs;
> @@ -659,16 +775,172 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
> 	return (*min_offs - ((void *)last - base) - sizeof(__u32));
> }
>=20
> -static int
> -ext4_xattr_set_entry(struct ext4_xattr_info *i, struct =
ext4_xattr_search *s)
> +/*
> + * Write the value of the EA in an inode.
> + */
> +static int ext4_xattr_inode_write(handle_t *handle, struct inode =
*ea_inode,
> +				  const void *buf, int bufsize)
> +{
> +	struct buffer_head *bh =3D NULL;
> +	unsigned long block =3D 0;
> +	unsigned blocksize =3D ea_inode->i_sb->s_blocksize;
> +	unsigned max_blocks =3D (bufsize + blocksize - 1) >> =
ea_inode->i_blkbits;
> +	int csize, wsize =3D 0;
> +	int ret =3D 0;
> +	int retries =3D 0;
> +
> +retry:
> +	while (ret >=3D 0 && ret < max_blocks) {
> +		struct ext4_map_blocks map;
> +		map.m_lblk =3D block +=3D ret;
> +		map.m_len =3D max_blocks -=3D ret;
> +
> +		ret =3D ext4_map_blocks(handle, ea_inode, &map,
> +				      EXT4_GET_BLOCKS_CREATE);
> +		if (ret <=3D 0) {
> +			ext4_mark_inode_dirty(handle, ea_inode);
> +			if (ret =3D=3D -ENOSPC &&
> +			    ext4_should_retry_alloc(ea_inode->i_sb, =
&retries)) {
> +				ret =3D 0;
> +				goto retry;
> +			}
> +			break;
> +		}
> +	}
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	block =3D 0;
> +	while (wsize < bufsize) {
> +		if (bh !=3D NULL)
> +			brelse(bh);
> +		csize =3D (bufsize - wsize) > blocksize ? blocksize :
> +								bufsize =
- wsize;
> +		bh =3D ext4_getblk(handle, ea_inode, block, 0);
> +		if (IS_ERR(bh)) {
> +			ret =3D PTR_ERR(bh);
> +			goto out;
> +		}
> +		ret =3D ext4_journal_get_write_access(handle, bh);
> +		if (ret)
> +			goto out;
> +
> +		memcpy(bh->b_data, buf, csize);
> +		set_buffer_uptodate(bh);
> +		ext4_handle_dirty_metadata(handle, ea_inode, bh);
> +
> +		buf +=3D csize;
> +		wsize +=3D csize;
> +		block +=3D 1;
> +	}
> +
> +	mutex_lock(&ea_inode->i_mutex);
> +	i_size_write(ea_inode, wsize);
> +	ext4_update_i_disksize(ea_inode, wsize);
> +	mutex_unlock(&ea_inode->i_mutex);
> +
> +	ext4_mark_inode_dirty(handle, ea_inode);
> +
> +out:
> +	brelse(bh);
> +
> +	return ret;
> +}
> +
> +/*
> + * Create an inode to store the value of a large EA.
> + */
> +static struct inode *ext4_xattr_inode_create(handle_t *handle,
> +					     struct inode *inode)
> +{
> +	struct inode *ea_inode =3D NULL;
> +
> +	/*
> +	 * Let the next inode be the goal, so we try and allocate the EA =
inode
> +	 * in the same group, or nearby one.
> +	 */
> +	ea_inode =3D ext4_new_inode(handle, =
inode->i_sb->s_root->d_inode,
> +				  S_IFREG | 0600, NULL, inode->i_ino + =
1, NULL);
> +	if (!IS_ERR(ea_inode)) {
> +		ea_inode->i_op =3D &ext4_file_inode_operations;
> +		ea_inode->i_fop =3D &ext4_file_operations;
> +		ext4_set_aops(ea_inode);
> +		ea_inode->i_generation =3D inode->i_generation;
> +		EXT4_I(ea_inode)->i_flags |=3D EXT4_EA_INODE_FL;
> +
> +		/*
> +		 * A back-pointer from EA inode to parent inode will be =
useful
> +		 * for e2fsck.
> +		 */
> +		EXT4_XATTR_INODE_SET_PARENT(ea_inode, inode->i_ino);
> +		unlock_new_inode(ea_inode);
> +	}
> +
> +	return ea_inode;
> +}
> +
> +/*
> + * Unlink the inode storing the value of the EA.
> + */
> +int ext4_xattr_inode_unlink(struct inode *inode, unsigned long =
ea_ino)
> +{
> +	struct inode *ea_inode =3D NULL;
> +	int err;
> +
> +	ea_inode =3D ext4_xattr_inode_iget(inode, ea_ino, &err);
> +	if (err)
> +		return err;
> +
> +	clear_nlink(ea_inode);
> +	iput(ea_inode);
> +
> +	return 0;
> +}
> +
> +/*
> + * Add value of the EA in an inode.
> + */
> +static int ext4_xattr_inode_set(handle_t *handle, struct inode =
*inode,
> +				unsigned long *ea_ino, const void =
*value,
> +				size_t value_len)
> +{
> +	struct inode *ea_inode;
> +	int err;
> +
> +	/* Create an inode for the EA value */
> +	ea_inode =3D ext4_xattr_inode_create(handle, inode);
> +	if (IS_ERR(ea_inode))
> +		return PTR_ERR(ea_inode);
> +
> +	err =3D ext4_xattr_inode_write(handle, ea_inode, value, =
value_len);
> +	if (err)
> +		clear_nlink(ea_inode);
> +	else
> +		*ea_ino =3D ea_inode->i_ino;
> +
> +	iput(ea_inode);
> +
> +	return err;
> +}
> +
> +static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
> +				struct ext4_xattr_search *s,
> +				handle_t *handle, struct inode *inode)
> {
> 	struct ext4_xattr_entry *last;
> 	size_t free, min_offs =3D s->end - s->base, name_len =3D =
strlen(i->name);
> +	int in_inode =3D i->in_inode;
> +
> +	if (ext4_feature_incompat(inode->i_sb, EA_INODE) &&
> +	    (EXT4_XATTR_SIZE(i->value_len) >
> +	     EXT4_XATTR_MIN_LARGE_EA_SIZE(inode->i_sb->s_blocksize)))
> +		in_inode =3D 1;
>=20
> 	/* Compute min_offs and last. */
> 	last =3D s->first;
> 	for (; !IS_LAST_ENTRY(last); last =3D EXT4_XATTR_NEXT(last)) {
> -		if (last->e_value_size) {
> +		if (!last->e_value_inum && last->e_value_size) {
> 			size_t offs =3D le16_to_cpu(last->e_value_offs);
> 			if (offs < min_offs)
> 				min_offs =3D offs;
> @@ -676,15 +948,20 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
> 	}
> 	free =3D min_offs - ((void *)last - s->base) - sizeof(__u32);
> 	if (!s->not_found) {
> -		if (s->here->e_value_size) {
> +		if (!in_inode &&
> +		    !s->here->e_value_inum && s->here->e_value_size) {
> 			size_t size =3D =
le32_to_cpu(s->here->e_value_size);
> 			free +=3D EXT4_XATTR_SIZE(size);
> 		}
> 		free +=3D EXT4_XATTR_LEN(name_len);
> 	}
> 	if (i->value) {
> -		if (free < EXT4_XATTR_LEN(name_len) +
> -			   EXT4_XATTR_SIZE(i->value_len))
> +		size_t value_len =3D EXT4_XATTR_SIZE(i->value_len);
> +
> +		if (in_inode)
> +			value_len =3D 0;
> +
> +		if (free < EXT4_XATTR_LEN(name_len) + value_len)
> 			return -ENOSPC;
> 	}
>=20
> @@ -698,7 +975,8 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
> 		s->here->e_name_len =3D name_len;
> 		memcpy(s->here->e_name, i->name, name_len);
> 	} else {
> -		if (s->here->e_value_size) {
> +		if (!s->here->e_value_inum && s->here->e_value_size &&
> +		    s->here->e_value_offs > 0) {
> 			void *first_val =3D s->base + min_offs;
> 			size_t offs =3D =
le16_to_cpu(s->here->e_value_offs);
> 			void *val =3D s->base + offs;
> @@ -732,12 +1010,18 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
> 			last =3D s->first;
> 			while (!IS_LAST_ENTRY(last)) {
> 				size_t o =3D =
le16_to_cpu(last->e_value_offs);
> -				if (last->e_value_size && o < offs)
> +				if (!last->e_value_inum &&
> +				    last->e_value_size && o < offs)
> 					last->e_value_offs =3D
> 						cpu_to_le16(o + size);
> 				last =3D EXT4_XATTR_NEXT(last);
> 			}
> 		}
> +		if (s->here->e_value_inum) {
> +			ext4_xattr_inode_unlink(inode,
> +					    =
le32_to_cpu(s->here->e_value_inum);
> +			s->here->e_value_inum =3D 0;
> +		}
> 		if (!i->value) {
> 			/* Remove the old name. */
> 			size_t size =3D EXT4_XATTR_LEN(name_len);
> @@ -750,11 +1034,20 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
>=20
> 	if (i->value) {
> 		/* Insert the new value. */
> -		s->here->e_value_size =3D cpu_to_le32(i->value_len);
> -		if (i->value_len) {
> +		if (in_inode) {
> +			unsigned long ea_ino =3D
> +				le32_to_cpu(s->here->e_value_inum);
> +			rc =3D ext4_xattr_inode_set(handle, inode, =
&ea_ino,
> +						  i->value, =
i->value_len);
> +			if (rc)
> +				goto out;
> +			s->here->e_value_inum =3D cpu_to_le32(ea_ino);
> +			s->here->e_value_offs =3D 0;
> +		} else if (i->value_len) {
> 			size_t size =3D EXT4_XATTR_SIZE(i->value_len);
> 			void *val =3D s->base + min_offs - size;
> 			s->here->e_value_offs =3D cpu_to_le16(min_offs - =
size);
> +			s->here->e_value_inum =3D 0;
> 			if (i->value =3D=3D EXT4_ZERO_XATTR_VALUE) {
> 				memset(val, 0, size);
> 			} else {
> @@ -764,8 +1057,11 @@ static size_t ext4_xattr_free_space(struct =
ext4_xattr_entry *last,
> 				memcpy(val, i->value, i->value_len);
> 			}
> 		}
> +		s->here->e_value_size =3D cpu_to_le32(i->value_len);
> 	}
> -	return 0;
> +
> +out:
> +	return rc;
> }
>=20
> struct ext4_xattr_block_find {
> @@ -804,7 +1100,7 @@ struct ext4_xattr_block_find {
> 		bs->s.end =3D bs->bh->b_data + bs->bh->b_size;
> 		bs->s.here =3D bs->s.first;
> 		error =3D ext4_xattr_find_entry(&bs->s.here, =
i->name_index,
> -					      i->name, bs->bh->b_size, =
1);
> +					     i->name, bs->bh->b_size, 1, =
inode);
> 		if (error && error !=3D -ENODATA)
> 			goto cleanup;
> 		bs->s.not_found =3D error;
> @@ -829,8 +1125,6 @@ struct ext4_xattr_block_find {
>=20
> #define header(x) ((struct ext4_xattr_header *)(x))
>=20
> -	if (i->value && i->value_len > sb->s_blocksize)
> -		return -ENOSPC;
> 	if (s->base) {
> 		BUFFER_TRACE(bs->bh, "get_write_access");
> 		error =3D ext4_journal_get_write_access(handle, bs->bh);
> @@ -849,7 +1143,7 @@ struct ext4_xattr_block_find {
> 			mb_cache_entry_delete_block(ext4_mb_cache, hash,
> 						    bs->bh->b_blocknr);
> 			ea_bdebug(bs->bh, "modifying in-place");
> -			error =3D ext4_xattr_set_entry(i, s);
> +			error =3D ext4_xattr_set_entry(i, s, handle, =
inode);
> 			if (!error) {
> 				if (!IS_LAST_ENTRY(s->first))
> 					=
ext4_xattr_rehash(header(s->base),
> @@ -898,7 +1192,7 @@ struct ext4_xattr_block_find {
> 		s->end =3D s->base + sb->s_blocksize;
> 	}
>=20
> -	error =3D ext4_xattr_set_entry(i, s);
> +	error =3D ext4_xattr_set_entry(i, s, handle, inode);
> 	if (error =3D=3D -EFSCORRUPTED)
> 		goto bad_block;
> 	if (error)
> @@ -1077,7 +1371,7 @@ int ext4_xattr_ibody_find(struct inode *inode, =
struct ext4_xattr_info *i,
> 		/* Find the named attribute. */
> 		error =3D ext4_xattr_find_entry(&is->s.here, =
i->name_index,
> 					      i->name, is->s.end -
> -					      (void *)is->s.base, 0);
> +					      (void *)is->s.base, 0, =
inode);
> 		if (error && error !=3D -ENODATA)
> 			return error;
> 		is->s.not_found =3D error;
> @@ -1095,7 +1389,7 @@ int ext4_xattr_ibody_inline_set(handle_t =
*handle, struct inode *inode,
>=20
> 	if (EXT4_I(inode)->i_extra_isize =3D=3D 0)
> 		return -ENOSPC;
> -	error =3D ext4_xattr_set_entry(i, s);
> +	error =3D ext4_xattr_set_entry(i, s, handle, inode);
> 	if (error) {
> 		if (error =3D=3D -ENOSPC &&
> 		    ext4_has_inline_data(inode)) {
> @@ -1107,7 +1401,7 @@ int ext4_xattr_ibody_inline_set(handle_t =
*handle, struct inode *inode,
> 			error =3D ext4_xattr_ibody_find(inode, i, is);
> 			if (error)
> 				return error;
> -			error =3D ext4_xattr_set_entry(i, s);
> +			error =3D ext4_xattr_set_entry(i, s, handle, =
inode);
> 		}
> 		if (error)
> 			return error;
> @@ -1133,7 +1427,7 @@ static int ext4_xattr_ibody_set(struct inode =
*inode,
>=20
> 	if (EXT4_I(inode)->i_extra_isize =3D=3D 0)
> 		return -ENOSPC;
> -	error =3D ext4_xattr_set_entry(i, s);
> +	error =3D ext4_xattr_set_entry(i, s, handle, inode);
> 	if (error)
> 		return error;
> 	header =3D IHDR(inode, ext4_raw_inode(&is->iloc));
> @@ -1180,7 +1474,7 @@ static int ext4_xattr_value_same(struct =
ext4_xattr_search *s,
> 		.name =3D name,
> 		.value =3D value,
> 		.value_len =3D value_len,
> -
> +		.in_inode =3D 0,
> 	};
> 	struct ext4_xattr_ibody_find is =3D {
> 		.s =3D { .not_found =3D -ENODATA, },
> @@ -1250,6 +1544,15 @@ static int ext4_xattr_value_same(struct =
ext4_xattr_search *s,
> 					goto cleanup;
> 			}
> 			error =3D ext4_xattr_block_set(handle, inode, =
&i, &bs);
> +			if (EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
> +					EXT4_FEATURE_INCOMPAT_EA_INODE) =
&&
> +			    error =3D=3D -ENOSPC) {
> +				/* xattr not fit to block, store at =
external
> +				 * inode */
> +				i.in_inode =3D 1;
> +				error =3D ext4_xattr_ibody_set(handle, =
inode,
> +							     &i, &is);
> +			}
> 			if (error)
> 				goto cleanup;
> 			if (!is.s.not_found) {
> @@ -1293,9 +1596,22 @@ static int ext4_xattr_value_same(struct =
ext4_xattr_search *s,
> 	       const void *value, size_t value_len, int flags)
> {
> 	handle_t *handle;
> +	struct super_block *sb =3D inode->i_sb;
> 	int error, retries =3D 0;
> 	int credits =3D ext4_jbd2_credits_xattr(inode);
>=20
> +	if ((value_len >=3D =
EXT4_XATTR_MIN_LARGE_EA_SIZE(sb->s_blocksize)) &&
> +	    EXT4_HAS_INCOMPAT_FEATURE(sb, =
EXT4_FEATURE_INCOMPAT_EA_INODE)) {
> +		int nrblocks =3D (value_len + sb->s_blocksize - 1) >>
> +					sb->s_blocksize_bits;
> +
> +		/* For new inode */
> +		credits +=3D EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + 3;
> +
> +		/* For data blocks of EA inode */
> +		credits +=3D ext4_meta_trans_blocks(inode, nrblocks, 0);
> +	}
> +
> retry:
> 	handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, credits);
> 	if (IS_ERR(handle)) {
> @@ -1307,7 +1623,7 @@ static int ext4_xattr_value_same(struct =
ext4_xattr_search *s,
> 					      value, value_len, flags);
> 		error2 =3D ext4_journal_stop(handle);
> 		if (error =3D=3D -ENOSPC &&
> -		    ext4_should_retry_alloc(inode->i_sb, &retries))
> +		    ext4_should_retry_alloc(sb, &retries))
> 			goto retry;
> 		if (error =3D=3D 0)
> 			error =3D error2;
> @@ -1332,7 +1648,7 @@ static void ext4_xattr_shift_entries(struct =
ext4_xattr_entry *entry,
>=20
> 	/* Adjust the value offsets of the entries */
> 	for (; !IS_LAST_ENTRY(last); last =3D EXT4_XATTR_NEXT(last)) {
> -		if (last->e_value_size) {
> +		if (!last->e_value_inum && last->e_value_size) {
> 			new_offs =3D le16_to_cpu(last->e_value_offs) +
> 							=
value_offs_shift;
> 			last->e_value_offs =3D cpu_to_le16(new_offs);
> @@ -1593,21 +1909,135 @@ int ext4_expand_extra_isize_ea(struct inode =
*inode, int new_extra_isize,
> }
>=20
>=20
> +#define EIA_INCR 16 /* must be 2^n */
> +#define EIA_MASK (EIA_INCR - 1)
> +/* Add the large xattr @ino into @lea_ino_array for later deletion.
> + * If @lea_ino_array is new or full it will be grown and the old
> + * contents copied over.
> + */
> +static int
> +ext4_expand_ino_array(struct ext4_xattr_ino_array **lea_ino_array, =
__u32 ino)
> +{
> +	if (*lea_ino_array =3D=3D NULL) {
> +		/*
> +		 * Start with 15 inodes, so it fits into a power-of-two =
size.
> +		 * If *lea_ino_array is NULL, this is essentially =
offsetof()
> +		 */
> +		(*lea_ino_array) =3D
> +			kmalloc(offsetof(struct ext4_xattr_ino_array,
> +					 xia_inodes[EIA_MASK]),
> +				GFP_NOFS);
> +		if (*lea_ino_array =3D=3D NULL)
> +			return -ENOMEM;
> +		(*lea_ino_array)->xia_count =3D 0;
> +	} else if (((*lea_ino_array)->xia_count & EIA_MASK) =3D=3D =
EIA_MASK) {
> +		/* expand the array once all 15 + n * 16 slots are full =
*/
> +		struct ext4_xattr_ino_array *new_array =3D NULL;
> +		int count =3D (*lea_ino_array)->xia_count;
> +
> +		/* if new_array is NULL, this is essentially offsetof() =
*/
> +		new_array =3D kmalloc(
> +				offsetof(struct ext4_xattr_ino_array,
> +					 xia_inodes[count + EIA_INCR]),
> +				GFP_NOFS);
> +		if (new_array =3D=3D NULL)
> +			return -ENOMEM;
> +		memcpy(new_array, *lea_ino_array,
> +		       offsetof(struct ext4_xattr_ino_array,
> +				xia_inodes[count]));
> +		kfree(*lea_ino_array);
> +		*lea_ino_array =3D new_array;
> +	}
> +	(*lea_ino_array)->xia_inodes[(*lea_ino_array)->xia_count++] =3D =
ino;
> +	return 0;
> +}
> +
> +/**
> + * Add xattr inode to orphan list
> + */
> +static int
> +ext4_xattr_inode_orphan_add(handle_t *handle, struct inode *inode,
> +			int credits, struct ext4_xattr_ino_array =
*lea_ino_array)
> +{
> +	struct inode *ea_inode =3D NULL;
> +	int idx =3D 0, error =3D 0;
> +
> +	if (lea_ino_array =3D=3D NULL)
> +		return 0;
> +
> +	for (; idx < lea_ino_array->xia_count; ++idx) {
> +		if (!ext4_handle_has_enough_credits(handle, credits)) {
> +			error =3D ext4_journal_extend(handle, credits);
> +			if (error > 0)
> +				error =3D ext4_journal_restart(handle, =
credits);
> +
> +			if (error !=3D 0) {
> +				ext4_warning(inode->i_sb,
> +					"couldn't extend journal "
> +					"(err %d)", error);
> +				return error;
> +			}
> +		}
> +		ea_inode =3D ext4_xattr_inode_iget(inode,
> +				lea_ino_array->xia_inodes[idx], &error);
> +		if (error)
> +			continue;
> +		ext4_orphan_add(handle, ea_inode);
> +		/* the inode's i_count will be released by caller */
> +	}
> +
> +	return 0;
> +}
>=20
> /*
>  * ext4_xattr_delete_inode()
>  *
> - * Free extended attribute resources associated with this inode. This
> + * Free extended attribute resources associated with this inode. =
Traverse
> + * all entries and unlink any xattr inodes associated with this =
inode. This
>  * is called immediately before an inode is freed. We have exclusive
> - * access to the inode.
> + * access to the inode. If an orphan inode is deleted it will also =
delete any
> + * xattr block and all xattr inodes. They are checked by =
ext4_xattr_inode_iget()
> + * to ensure they belong to the parent inode and were not deleted =
already.
>  */
> -void
> -ext4_xattr_delete_inode(handle_t *handle, struct inode *inode)
> +int
> +ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
> +			struct ext4_xattr_ino_array **lea_ino_array)
> {
> 	struct buffer_head *bh =3D NULL;
> +	struct ext4_xattr_ibody_header *header;
> +	struct ext4_inode *raw_inode;
> +	struct ext4_iloc iloc;
> +	struct ext4_xattr_entry *entry;
> +	int credits =3D 3, error =3D 0;
>=20
> -	if (!EXT4_I(inode)->i_file_acl)
> +	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> +		goto delete_external_ea;
> +
> +	error =3D ext4_get_inode_loc(inode, &iloc);
> +	if (error)
> +		goto cleanup;
> +	raw_inode =3D ext4_raw_inode(&iloc);
> +	header =3D IHDR(inode, raw_inode);
> +	for (entry =3D IFIRST(header); !IS_LAST_ENTRY(entry);
> +	     entry =3D EXT4_XATTR_NEXT(entry)) {
> +		if (!entry->e_value_inum)
> +			continue;
> +		if (ext4_expand_ino_array(lea_ino_array,
> +					  entry->e_value_inum) !=3D 0) {
> +			brelse(iloc.bh);
> +			goto cleanup;
> +		}
> +		entry->e_value_inum =3D 0;
> +	}
> +	brelse(iloc.bh);
> +
> +delete_external_ea:
> +	if (!EXT4_I(inode)->i_file_acl) {
> +		/* add xattr inode to orphan list */
> +		ext4_xattr_inode_orphan_add(handle, inode, credits,
> +						*lea_ino_array);
> 		goto cleanup;
> +	}
> 	bh =3D sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> 	if (!bh) {
> 		EXT4_ERROR_INODE(inode, "block %llu read error",
> @@ -1620,11 +2050,69 @@ int ext4_expand_extra_isize_ea(struct inode =
*inode, int new_extra_isize,
> 				 EXT4_I(inode)->i_file_acl);
> 		goto cleanup;
> 	}
> +
> +	for (entry =3D BFIRST(bh); !IS_LAST_ENTRY(entry);
> +	     entry =3D EXT4_XATTR_NEXT(entry)) {
> +		if (!entry->e_value_inum)
> +			continue;
> +		if (ext4_expand_ino_array(lea_ino_array,
> +					  entry->e_value_inum) !=3D 0)
> +			goto cleanup;
> +		entry->e_value_inum =3D 0;
> +	}
> +
> +	/* add xattr inode to orphan list */
> +	error =3D ext4_xattr_inode_orphan_add(handle, inode, credits,
> +					*lea_ino_array);
> +	if (error !=3D 0)
> +		goto cleanup;
> +
> +	if (!IS_NOQUOTA(inode))
> +		credits +=3D 2 * EXT4_QUOTA_DEL_BLOCKS(inode->i_sb);
> +
> +	if (!ext4_handle_has_enough_credits(handle, credits)) {
> +		error =3D ext4_journal_extend(handle, credits);
> +		if (error > 0)
> +			error =3D ext4_journal_restart(handle, credits);
> +		if (error !=3D 0) {
> +			ext4_warning(inode->i_sb,
> +				"couldn't extend journal (err %d)", =
error);
> +			goto cleanup;
> +		}
> +	}
> +
> 	ext4_xattr_release_block(handle, inode, bh);
> 	EXT4_I(inode)->i_file_acl =3D 0;
>=20
> cleanup:
> 	brelse(bh);
> +
> +	return error;
> +}
> +
> +void
> +ext4_xattr_inode_array_free(struct inode *inode,
> +			    struct ext4_xattr_ino_array *lea_ino_array)
> +{
> +	struct inode	*ea_inode =3D NULL;
> +	int		idx =3D 0;
> +	int		err;
> +
> +	if (lea_ino_array =3D=3D NULL)
> +		return;
> +
> +	for (; idx < lea_ino_array->xia_count; ++idx) {
> +		ea_inode =3D ext4_xattr_inode_iget(inode,
> +				lea_ino_array->xia_inodes[idx], &err);
> +		if (err)
> +			continue;
> +		/* for inode's i_count get from ext4_xattr_delete_inode =
*/
> +		if (!list_empty(&EXT4_I(ea_inode)->i_orphan))
> +			iput(ea_inode);
> +		clear_nlink(ea_inode);
> +		iput(ea_inode);
> +	}
> +	kfree(lea_ino_array);
> }
>=20
> /*
> @@ -1676,10 +2164,9 @@ int ext4_expand_extra_isize_ea(struct inode =
*inode, int new_extra_isize,
> 		    entry1->e_name_index !=3D entry2->e_name_index ||
> 		    entry1->e_name_len !=3D entry2->e_name_len ||
> 		    entry1->e_value_size !=3D entry2->e_value_size ||
> +		    entry1->e_value_inum !=3D entry2->e_value_inum ||
> 		    memcmp(entry1->e_name, entry2->e_name, =
entry1->e_name_len))
> 			return 1;
> -		if (entry1->e_value_block !=3D 0 || =
entry2->e_value_block !=3D 0)
> -			return -EFSCORRUPTED;
> 		if (memcmp((char *)header1 + =
le16_to_cpu(entry1->e_value_offs),
> 			   (char *)header2 + =
le16_to_cpu(entry2->e_value_offs),
> 			   le32_to_cpu(entry1->e_value_size)))
> @@ -1751,7 +2238,7 @@ static inline void ext4_xattr_hash_entry(struct =
ext4_xattr_header *header,
> 		       *name++;
> 	}
>=20
> -	if (entry->e_value_size !=3D 0) {
> +	if (!entry->e_value_inum && entry->e_value_size) {
> 		__le32 *value =3D (__le32 *)((char *)header +
> 			le16_to_cpu(entry->e_value_offs));
> 		for (n =3D (le32_to_cpu(entry->e_value_size) +
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 099c8b6..6e10ff9 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -44,7 +44,7 @@ struct ext4_xattr_entry {
> 	__u8	e_name_len;	/* length of name */
> 	__u8	e_name_index;	/* attribute name index */
> 	__le16	e_value_offs;	/* offset in disk block of value */
> -	__le32	e_value_block;	/* disk block attribute is stored on =
(n/i) */
> +	__le32	e_value_inum;	/* inode in which the value is stored */
> 	__le32	e_value_size;	/* size of attribute value */
> 	__le32	e_hash;		/* hash value of name and value */
> 	char	e_name[0];	/* attribute name */
> @@ -69,6 +69,26 @@ struct ext4_xattr_entry {
> 		EXT4_I(inode)->i_extra_isize))
> #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
>=20
> +/*
> + * Link EA inode back to parent one using i_mtime field.
> + * Extra integer type conversion added to ignore higher
> + * bits in i_mtime.tv_sec which might be set by ext4_get()
> + */
> +#define EXT4_XATTR_INODE_SET_PARENT(inode, inum)      \
> +do {                                                  \
> +      (inode)->i_mtime.tv_sec =3D inum;                 \
> +} while(0)
> +
> +#define EXT4_XATTR_INODE_GET_PARENT(inode)            \
> +((__u32)(inode)->i_mtime.tv_sec)
> +
> +/*
> + * The minimum size of EA value when you start storing it in an =
external inode
> + * size of block - size of header - size of 1 entry - 4 null bytes
> +*/
> +#define EXT4_XATTR_MIN_LARGE_EA_SIZE(b)					=
\
> +	((b) - EXT4_XATTR_LEN(3) - sizeof(struct ext4_xattr_header) - 4)
> +
> #define BHDR(bh) ((struct ext4_xattr_header *)((bh)->b_data))
> #define ENTRY(ptr) ((struct ext4_xattr_entry *)(ptr))
> #define BFIRST(bh) ENTRY(BHDR(bh)+1)
> @@ -77,10 +97,11 @@ struct ext4_xattr_entry {
> #define EXT4_ZERO_XATTR_VALUE ((void *)-1)
>=20
> struct ext4_xattr_info {
> -	int name_index;
> 	const char *name;
> 	const void *value;
> 	size_t value_len;
> +	int name_index;
> +	int in_inode;
> };
>=20
> struct ext4_xattr_search {
> @@ -140,7 +161,13 @@ static inline void ext4_write_unlock_xattr(struct =
inode *inode, int *save)
> extern int ext4_xattr_set(struct inode *, int, const char *, const =
void *, size_t, int);
> extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, =
const char *, const void *, size_t, int);
>=20
> -extern void ext4_xattr_delete_inode(handle_t *, struct inode *);
> +extern struct inode *ext4_xattr_inode_iget(struct inode *parent, =
unsigned long ea_ino,
> +					   int *err);
> +extern int ext4_xattr_inode_unlink(struct inode *inode, unsigned long =
ea_ino);
> +extern int ext4_xattr_delete_inode(handle_t *handle, struct inode =
*inode,
> +				   struct ext4_xattr_ino_array **array);
> +extern void ext4_xattr_inode_array_free(struct inode *inode,
> +					struct ext4_xattr_ino_array =
*array);
>=20
> extern int ext4_expand_extra_isize_ea(struct inode *inode, int =
new_extra_isize,
> 			    struct ext4_inode *raw_inode, handle_t =
*handle);
> diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h =
b/include/uapi/linux/netfilter/xt_CONNMARK.h
> index 2f2e48e..efc17a8 100644
> --- a/include/uapi/linux/netfilter/xt_CONNMARK.h
> +++ b/include/uapi/linux/netfilter/xt_CONNMARK.h
> @@ -1,6 +1,31 @@
> -#ifndef _XT_CONNMARK_H_target
> -#define _XT_CONNMARK_H_target
> +#ifndef _XT_CONNMARK_H
> +#define _XT_CONNMARK_H
>=20
> -#include <linux/netfilter/xt_connmark.h>
> +#include <linux/types.h>
>=20
> -#endif /*_XT_CONNMARK_H_target*/
> +/* Copyright (C) 2002,2004 MARA Systems AB =
<http://www.marasystems.com>
> + * by Henrik Nordstrom <hno@marasystems.com>
> + *
> + * This program is free software; you can redistribute it and/or =
modify
> + * it under the terms of the GNU General Public License as published =
by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +enum {
> +	XT_CONNMARK_SET =3D 0,
> +	XT_CONNMARK_SAVE,
> +	XT_CONNMARK_RESTORE
> +};
> +
> +struct xt_connmark_tginfo1 {
> +	__u32 ctmark, ctmask, nfmask;
> +	__u8 mode;
> +};
> +
> +struct xt_connmark_mtinfo1 {
> +	__u32 mark, mask;
> +	__u8 invert;
> +};
> +
> +#endif /*_XT_CONNMARK_H*/
> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h =
b/include/uapi/linux/netfilter/xt_DSCP.h
> index 648e0b3..15f8932 100644
> --- a/include/uapi/linux/netfilter/xt_DSCP.h
> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
> @@ -1,26 +1,31 @@
> -/* x_tables module for setting the IPv4/IPv6 DSCP field
> +/* x_tables module for matching the IPv4/IPv6 DSCP field
>  *
>  * (C) 2002 Harald Welte <laforge@gnumonks.org>
> - * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh =
<mgm@paktronix.com>
>  * This software is distributed under GNU GPL v2, 1991
>  *
>  * See RFC2474 for a description of the DSCP field within the IP =
Header.
>  *
> - * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
> + * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
> */
> -#ifndef _XT_DSCP_TARGET_H
> -#define _XT_DSCP_TARGET_H
> -#include <linux/netfilter/xt_dscp.h>
> +#ifndef _XT_DSCP_H
> +#define _XT_DSCP_H
> +
> #include <linux/types.h>
>=20
> -/* target info */
> -struct xt_DSCP_info {
> +#define XT_DSCP_MASK	0xfc	/* 11111100 */
> +#define XT_DSCP_SHIFT	2
> +#define XT_DSCP_MAX	0x3f	/* 00111111 */
> +
> +/* match info */
> +struct xt_dscp_info {
> 	__u8 dscp;
> +	__u8 invert;
> };
>=20
> -struct xt_tos_target_info {
> -	__u8 tos_value;
> +struct xt_tos_match_info {
> 	__u8 tos_mask;
> +	__u8 tos_value;
> +	__u8 invert;
> };
>=20
> -#endif /* _XT_DSCP_TARGET_H */
> +#endif /* _XT_DSCP_H */
> diff --git a/include/uapi/linux/netfilter/xt_MARK.h =
b/include/uapi/linux/netfilter/xt_MARK.h
> index 41c456d..ecadc40 100644
> --- a/include/uapi/linux/netfilter/xt_MARK.h
> +++ b/include/uapi/linux/netfilter/xt_MARK.h
> @@ -1,6 +1,15 @@
> -#ifndef _XT_MARK_H_target
> -#define _XT_MARK_H_target
> +#ifndef _XT_MARK_H
> +#define _XT_MARK_H
>=20
> -#include <linux/netfilter/xt_mark.h>
> +#include <linux/types.h>
>=20
> -#endif /*_XT_MARK_H_target */
> +struct xt_mark_tginfo2 {
> +	__u32 mark, mask;
> +};
> +
> +struct xt_mark_mtinfo1 {
> +	__u32 mark, mask;
> +	__u8 invert;
> +};
> +
> +#endif /*_XT_MARK_H*/
> diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h =
b/include/uapi/linux/netfilter/xt_TCPMSS.h
> index 9a6960a..fbac56b 100644
> --- a/include/uapi/linux/netfilter/xt_TCPMSS.h
> +++ b/include/uapi/linux/netfilter/xt_TCPMSS.h
> @@ -1,12 +1,11 @@
> -#ifndef _XT_TCPMSS_H
> -#define _XT_TCPMSS_H
> +#ifndef _XT_TCPMSS_MATCH_H
> +#define _XT_TCPMSS_MATCH_H
>=20
> #include <linux/types.h>
>=20
> -struct xt_tcpmss_info {
> -	__u16 mss;
> +struct xt_tcpmss_match_info {
> +    __u16 mss_min, mss_max;
> +    __u8 invert;
> };
>=20
> -#define XT_TCPMSS_CLAMP_PMTU 0xffff
> -
> -#endif /* _XT_TCPMSS_H */
> +#endif /*_XT_TCPMSS_MATCH_H*/
> diff --git a/include/uapi/linux/netfilter/xt_rateest.h =
b/include/uapi/linux/netfilter/xt_rateest.h
> index 13fe50d..ec1b570 100644
> --- a/include/uapi/linux/netfilter/xt_rateest.h
> +++ b/include/uapi/linux/netfilter/xt_rateest.h
> @@ -1,38 +1,16 @@
> -#ifndef _XT_RATEEST_MATCH_H
> -#define _XT_RATEEST_MATCH_H
> +#ifndef _XT_RATEEST_TARGET_H
> +#define _XT_RATEEST_TARGET_H
>=20
> #include <linux/types.h>
> #include <linux/if.h>
>=20
> -enum xt_rateest_match_flags {
> -	XT_RATEEST_MATCH_INVERT	=3D 1<<0,
> -	XT_RATEEST_MATCH_ABS	=3D 1<<1,
> -	XT_RATEEST_MATCH_REL	=3D 1<<2,
> -	XT_RATEEST_MATCH_DELTA	=3D 1<<3,
> -	XT_RATEEST_MATCH_BPS	=3D 1<<4,
> -	XT_RATEEST_MATCH_PPS	=3D 1<<5,
> -};
> -
> -enum xt_rateest_match_mode {
> -	XT_RATEEST_MATCH_NONE,
> -	XT_RATEEST_MATCH_EQ,
> -	XT_RATEEST_MATCH_LT,
> -	XT_RATEEST_MATCH_GT,
> -};
> -
> -struct xt_rateest_match_info {
> -	char			name1[IFNAMSIZ];
> -	char			name2[IFNAMSIZ];
> -	__u16		flags;
> -	__u16		mode;
> -	__u32		bps1;
> -	__u32		pps1;
> -	__u32		bps2;
> -	__u32		pps2;
> +struct xt_rateest_target_info {
> +	char			name[IFNAMSIZ];
> +	__s8			interval;
> +	__u8		ewma_log;
>=20
> 	/* Used internally by the kernel */
> -	struct xt_rateest	*est1 __attribute__((aligned(8)));
> -	struct xt_rateest	*est2 __attribute__((aligned(8)));
> +	struct xt_rateest	*est __attribute__((aligned(8)));
> };
>=20
> -#endif /* _XT_RATEEST_MATCH_H */
> +#endif /* _XT_RATEEST_TARGET_H */
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h =
b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> index bb88d53..0e0c063 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> @@ -1,33 +1,15 @@
> -/* Header file for iptables ipt_ECN target
> - *
> - * (C) 2002 by Harald Welte <laforge@gnumonks.org>
> - *
> - * This software is distributed under GNU GPL v2, 1991
> - *
> - * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
> -*/
> -#ifndef _IPT_ECN_TARGET_H
> -#define _IPT_ECN_TARGET_H
> -
> -#include <linux/types.h>
> -#include <linux/netfilter/xt_DSCP.h>
> -
> -#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
> -
> -#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header =
*/
> -#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
> -#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
> -
> -#define IPT_ECN_OP_MASK		0xce
> -
> -struct ipt_ECN_info {
> -	__u8 operation;	/* bitset of operations */
> -	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
> -	union {
> -		struct {
> -			__u8 ece:1, cwr:1; /* TCP ECT bits */
> -		} tcp;
> -	} proto;
> +#ifndef _IPT_ECN_H
> +#define _IPT_ECN_H
> +
> +#include <linux/netfilter/xt_ecn.h>
> +#define ipt_ecn_info xt_ecn_info
> +
> +enum {
> +	IPT_ECN_IP_MASK       =3D XT_ECN_IP_MASK,
> +	IPT_ECN_OP_MATCH_IP   =3D XT_ECN_OP_MATCH_IP,
> +	IPT_ECN_OP_MATCH_ECE  =3D XT_ECN_OP_MATCH_ECE,
> +	IPT_ECN_OP_MATCH_CWR  =3D XT_ECN_OP_MATCH_CWR,
> +	IPT_ECN_OP_MATCH_MASK =3D XT_ECN_OP_MATCH_MASK,
> };
>=20
> -#endif /* _IPT_ECN_TARGET_H */
> +#endif /* IPT_ECN_H */
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h =
b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> index f6ac169..37bee44 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> @@ -1,5 +1,5 @@
> -/* TTL modification module for IP tables
> - * (C) 2000 by Harald Welte <laforge@netfilter.org> */
> +/* IP tables module for matching the value of the TTL
> + * (C) 2000 by Harald Welte <laforge@gnumonks.org> */
>=20
> #ifndef _IPT_TTL_H
> #define _IPT_TTL_H
> @@ -7,14 +7,14 @@
> #include <linux/types.h>
>=20
> enum {
> -	IPT_TTL_SET =3D 0,
> -	IPT_TTL_INC,
> -	IPT_TTL_DEC
> +	IPT_TTL_EQ =3D 0,		/* equals */
> +	IPT_TTL_NE,		/* not equals */
> +	IPT_TTL_LT,		/* less than */
> +	IPT_TTL_GT,		/* greater than */
> };
>=20
> -#define IPT_TTL_MAXMODE	IPT_TTL_DEC
>=20
> -struct ipt_TTL_info {
> +struct ipt_ttl_info {
> 	__u8	mode;
> 	__u8	ttl;
> };
> diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h =
b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> index ebd8ead..6e76dbc 100644
> --- a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> +++ b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> @@ -1,6 +1,6 @@
> -/* Hop Limit modification module for ip6tables
> +/* ip6tables module for matching the Hop Limit value
>  * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> - * Based on HW's TTL module */
> + * Based on HW's ttl module */
>=20
> #ifndef _IP6T_HL_H
> #define _IP6T_HL_H
> @@ -8,14 +8,14 @@
> #include <linux/types.h>
>=20
> enum {
> -	IP6T_HL_SET =3D 0,
> -	IP6T_HL_INC,
> -	IP6T_HL_DEC
> +	IP6T_HL_EQ =3D 0,		/* equals */
> +	IP6T_HL_NE,		/* not equals */
> +	IP6T_HL_LT,		/* less than */
> +	IP6T_HL_GT,		/* greater than */
> };
>=20
> -#define IP6T_HL_MAXMODE	IP6T_HL_DEC
>=20
> -struct ip6t_HL_info {
> +struct ip6t_hl_info {
> 	__u8	mode;
> 	__u8	hop_limit;
> };
> diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
> index 498b54f..755d2f6 100644
> --- a/net/netfilter/xt_RATEEST.c
> +++ b/net/netfilter/xt_RATEEST.c
> @@ -8,184 +8,149 @@
> #include <linux/module.h>
> #include <linux/skbuff.h>
> #include <linux/gen_stats.h>
> -#include <linux/jhash.h>
> -#include <linux/rtnetlink.h>
> -#include <linux/random.h>
> -#include <linux/slab.h>
> -#include <net/gen_stats.h>
> -#include <net/netlink.h>
>=20
> #include <linux/netfilter/x_tables.h>
> -#include <linux/netfilter/xt_RATEEST.h>
> +#include <linux/netfilter/xt_rateest.h>
> #include <net/netfilter/xt_rateest.h>
>=20
> -static DEFINE_MUTEX(xt_rateest_mutex);
>=20
> -#define RATEEST_HSIZE	16
> -static struct hlist_head rateest_hash[RATEEST_HSIZE] __read_mostly;
> -static unsigned int jhash_rnd __read_mostly;
> -
> -static unsigned int xt_rateest_hash(const char *name)
> -{
> -	return jhash(name, FIELD_SIZEOF(struct xt_rateest, name), =
jhash_rnd) &
> -	       (RATEEST_HSIZE - 1);
> -}
> -
> -static void xt_rateest_hash_insert(struct xt_rateest *est)
> +static bool
> +xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
> {
> -	unsigned int h;
> -
> -	h =3D xt_rateest_hash(est->name);
> -	hlist_add_head(&est->list, &rateest_hash[h]);
> -}
> +	const struct xt_rateest_match_info *info =3D par->matchinfo;
> +	struct gnet_stats_rate_est64 sample =3D {0};
> +	u_int32_t bps1, bps2, pps1, pps2;
> +	bool ret =3D true;
> +
> +	gen_estimator_read(&info->est1->rate_est, &sample);
> +
> +	if (info->flags & XT_RATEEST_MATCH_DELTA) {
> +		bps1 =3D info->bps1 >=3D sample.bps ? info->bps1 - =
sample.bps : 0;
> +		pps1 =3D info->pps1 >=3D sample.pps ? info->pps1 - =
sample.pps : 0;
> +	} else {
> +		bps1 =3D sample.bps;
> +		pps1 =3D sample.pps;
> +	}
>=20
> -struct xt_rateest *xt_rateest_lookup(const char *name)
> -{
> -	struct xt_rateest *est;
> -	unsigned int h;
> -
> -	h =3D xt_rateest_hash(name);
> -	mutex_lock(&xt_rateest_mutex);
> -	hlist_for_each_entry(est, &rateest_hash[h], list) {
> -		if (strcmp(est->name, name) =3D=3D 0) {
> -			est->refcnt++;
> -			mutex_unlock(&xt_rateest_mutex);
> -			return est;
> +	if (info->flags & XT_RATEEST_MATCH_ABS) {
> +		bps2 =3D info->bps2;
> +		pps2 =3D info->pps2;
> +	} else {
> +		gen_estimator_read(&info->est2->rate_est, &sample);
> +
> +		if (info->flags & XT_RATEEST_MATCH_DELTA) {
> +			bps2 =3D info->bps2 >=3D sample.bps ? info->bps2 =
- sample.bps : 0;
> +			pps2 =3D info->pps2 >=3D sample.pps ? info->pps2 =
- sample.pps : 0;
> +		} else {
> +			bps2 =3D sample.bps;
> +			pps2 =3D sample.pps;
> 		}
> 	}
> -	mutex_unlock(&xt_rateest_mutex);
> -	return NULL;
> -}
> -EXPORT_SYMBOL_GPL(xt_rateest_lookup);
>=20
> -void xt_rateest_put(struct xt_rateest *est)
> -{
> -	mutex_lock(&xt_rateest_mutex);
> -	if (--est->refcnt =3D=3D 0) {
> -		hlist_del(&est->list);
> -		gen_kill_estimator(&est->rate_est);
> -		/*
> -		 * gen_estimator est_timer() might access est->lock or =
bstats,
> -		 * wait a RCU grace period before freeing 'est'
> -		 */
> -		kfree_rcu(est, rcu);
> +	switch (info->mode) {
> +	case XT_RATEEST_MATCH_LT:
> +		if (info->flags & XT_RATEEST_MATCH_BPS)
> +			ret &=3D bps1 < bps2;
> +		if (info->flags & XT_RATEEST_MATCH_PPS)
> +			ret &=3D pps1 < pps2;
> +		break;
> +	case XT_RATEEST_MATCH_GT:
> +		if (info->flags & XT_RATEEST_MATCH_BPS)
> +			ret &=3D bps1 > bps2;
> +		if (info->flags & XT_RATEEST_MATCH_PPS)
> +			ret &=3D pps1 > pps2;
> +		break;
> +	case XT_RATEEST_MATCH_EQ:
> +		if (info->flags & XT_RATEEST_MATCH_BPS)
> +			ret &=3D bps1 =3D=3D bps2;
> +		if (info->flags & XT_RATEEST_MATCH_PPS)
> +			ret &=3D pps1 =3D=3D pps2;
> +		break;
> 	}
> -	mutex_unlock(&xt_rateest_mutex);
> +
> +	ret ^=3D info->flags & XT_RATEEST_MATCH_INVERT ? true : false;
> +	return ret;
> }
> -EXPORT_SYMBOL_GPL(xt_rateest_put);
>=20
> -static unsigned int
> -xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
> +static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
> {
> -	const struct xt_rateest_target_info *info =3D par->targinfo;
> -	struct gnet_stats_basic_packed *stats =3D &info->est->bstats;
> +	struct xt_rateest_match_info *info =3D par->matchinfo;
> +	struct xt_rateest *est1, *est2;
> +	int ret =3D -EINVAL;
>=20
> -	spin_lock_bh(&info->est->lock);
> -	stats->bytes +=3D skb->len;
> -	stats->packets++;
> -	spin_unlock_bh(&info->est->lock);
> +	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
> +				     XT_RATEEST_MATCH_REL)) !=3D 1)
> +		goto err1;
>=20
> -	return XT_CONTINUE;
> -}
> +	if (!(info->flags & (XT_RATEEST_MATCH_BPS | =
XT_RATEEST_MATCH_PPS)))
> +		goto err1;
>=20
> -static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
> -{
> -	struct xt_rateest_target_info *info =3D par->targinfo;
> -	struct xt_rateest *est;
> -	struct {
> -		struct nlattr		opt;
> -		struct gnet_estimator	est;
> -	} cfg;
> -	int ret;
> -
> -	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
> -
> -	est =3D xt_rateest_lookup(info->name);
> -	if (est) {
> -		/*
> -		 * If estimator parameters are specified, they must =
match the
> -		 * existing estimator.
> -		 */
> -		if ((!info->interval && !info->ewma_log) ||
> -		    (info->interval !=3D est->params.interval ||
> -		     info->ewma_log !=3D est->params.ewma_log)) {
> -			xt_rateest_put(est);
> -			return -EINVAL;
> -		}
> -		info->est =3D est;
> -		return 0;
> +	switch (info->mode) {
> +	case XT_RATEEST_MATCH_EQ:
> +	case XT_RATEEST_MATCH_LT:
> +	case XT_RATEEST_MATCH_GT:
> +		break;
> +	default:
> +		goto err1;
> 	}
>=20
> -	ret =3D -ENOMEM;
> -	est =3D kzalloc(sizeof(*est), GFP_KERNEL);
> -	if (!est)
> +	ret  =3D -ENOENT;
> +	est1 =3D xt_rateest_lookup(info->name1);
> +	if (!est1)
> 		goto err1;
>=20
> -	strlcpy(est->name, info->name, sizeof(est->name));
> -	spin_lock_init(&est->lock);
> -	est->refcnt		=3D 1;
> -	est->params.interval	=3D info->interval;
> -	est->params.ewma_log	=3D info->ewma_log;
> -
> -	cfg.opt.nla_len		=3D nla_attr_size(sizeof(cfg.est));
> -	cfg.opt.nla_type	=3D TCA_STATS_RATE_EST;
> -	cfg.est.interval	=3D info->interval;
> -	cfg.est.ewma_log	=3D info->ewma_log;
> -
> -	ret =3D gen_new_estimator(&est->bstats, NULL, &est->rate_est,
> -				&est->lock, NULL, &cfg.opt);
> -	if (ret < 0)
> -		goto err2;
> +	est2 =3D NULL;
> +	if (info->flags & XT_RATEEST_MATCH_REL) {
> +		est2 =3D xt_rateest_lookup(info->name2);
> +		if (!est2)
> +			goto err2;
> +	}
>=20
> -	info->est =3D est;
> -	xt_rateest_hash_insert(est);
> +	info->est1 =3D est1;
> +	info->est2 =3D est2;
> 	return 0;
>=20
> err2:
> -	kfree(est);
> +	xt_rateest_put(est1);
> err1:
> 	return ret;
> }
>=20
> -static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
> +static void xt_rateest_mt_destroy(const struct xt_mtdtor_param *par)
> {
> -	struct xt_rateest_target_info *info =3D par->targinfo;
> +	struct xt_rateest_match_info *info =3D par->matchinfo;
>=20
> -	xt_rateest_put(info->est);
> +	xt_rateest_put(info->est1);
> +	if (info->est2)
> +		xt_rateest_put(info->est2);
> }
>=20
> -static struct xt_target xt_rateest_tg_reg __read_mostly =3D {
> -	.name       =3D "RATEEST",
> +static struct xt_match xt_rateest_mt_reg __read_mostly =3D {
> +	.name       =3D "rateest",
> 	.revision   =3D 0,
> 	.family     =3D NFPROTO_UNSPEC,
> -	.target     =3D xt_rateest_tg,
> -	.checkentry =3D xt_rateest_tg_checkentry,
> -	.destroy    =3D xt_rateest_tg_destroy,
> -	.targetsize =3D sizeof(struct xt_rateest_target_info),
> -	.usersize   =3D offsetof(struct xt_rateest_target_info, est),
> +	.match      =3D xt_rateest_mt,
> +	.checkentry =3D xt_rateest_mt_checkentry,
> +	.destroy    =3D xt_rateest_mt_destroy,
> +	.matchsize  =3D sizeof(struct xt_rateest_match_info),
> +	.usersize   =3D offsetof(struct xt_rateest_match_info, est1),
> 	.me         =3D THIS_MODULE,
> };
>=20
> -static int __init xt_rateest_tg_init(void)
> +static int __init xt_rateest_mt_init(void)
> {
> -	unsigned int i;
> -
> -	for (i =3D 0; i < ARRAY_SIZE(rateest_hash); i++)
> -		INIT_HLIST_HEAD(&rateest_hash[i]);
> -
> -	return xt_register_target(&xt_rateest_tg_reg);
> +	return xt_register_match(&xt_rateest_mt_reg);
> }
>=20
> -static void __exit xt_rateest_tg_fini(void)
> +static void __exit xt_rateest_mt_fini(void)
> {
> -	xt_unregister_target(&xt_rateest_tg_reg);
> +	xt_unregister_match(&xt_rateest_mt_reg);
> }
>=20
> -
> MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
> MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("Xtables: packet rate estimator");
> -MODULE_ALIAS("ipt_RATEEST");
> -MODULE_ALIAS("ip6t_RATEEST");
> -module_init(xt_rateest_tg_init);
> -module_exit(xt_rateest_tg_fini);
> +MODULE_DESCRIPTION("xtables rate estimator match");
> +MODULE_ALIAS("ipt_rateest");
> +MODULE_ALIAS("ip6t_rateest");
> +module_init(xt_rateest_mt_init);
> +module_exit(xt_rateest_mt_fini);
> diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> index 27241a7..c53d4d1 100644
> --- a/net/netfilter/xt_TCPMSS.c
> +++ b/net/netfilter/xt_TCPMSS.c
> @@ -1,351 +1,110 @@
> -/*
> - * This is a module which is used for setting the MSS option in TCP =
packets.
> - *
> - * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
> - * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
> +/* Kernel module to match TCP MSS values. */
> +
> +/* Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
> + * Portions (C) 2005 by Harald Welte <laforge@netfilter.org>
>  *
>  * This program is free software; you can redistribute it and/or =
modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> #include <linux/module.h>
> #include <linux/skbuff.h>
> -#include <linux/ip.h>
> -#include <linux/gfp.h>
> -#include <linux/ipv6.h>
> -#include <linux/tcp.h>
> -#include <net/dst.h>
> -#include <net/flow.h>
> -#include <net/ipv6.h>
> -#include <net/route.h>
> #include <net/tcp.h>
>=20
> +#include <linux/netfilter/xt_tcpmss.h>
> +#include <linux/netfilter/x_tables.h>
> +
> #include <linux/netfilter_ipv4/ip_tables.h>
> #include <linux/netfilter_ipv6/ip6_tables.h>
> -#include <linux/netfilter/x_tables.h>
> -#include <linux/netfilter/xt_tcpudp.h>
> -#include <linux/netfilter/xt_TCPMSS.h>
>=20
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
> -MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) =
adjustment");
> -MODULE_ALIAS("ipt_TCPMSS");
> -MODULE_ALIAS("ip6t_TCPMSS");
> -
> -static inline unsigned int
> -optlen(const u_int8_t *opt, unsigned int offset)
> -{
> -	/* Beware zero-length options: make finite progress */
> -	if (opt[offset] <=3D TCPOPT_NOP || opt[offset+1] =3D=3D 0)
> -		return 1;
> -	else
> -		return opt[offset+1];
> -}
> -
> -static u_int32_t tcpmss_reverse_mtu(struct net *net,
> -				    const struct sk_buff *skb,
> -				    unsigned int family)
> -{
> -	struct flowi fl;
> -	const struct nf_afinfo *ai;
> -	struct rtable *rt =3D NULL;
> -	u_int32_t mtu     =3D ~0U;
> -
> -	if (family =3D=3D PF_INET) {
> -		struct flowi4 *fl4 =3D &fl.u.ip4;
> -		memset(fl4, 0, sizeof(*fl4));
> -		fl4->daddr =3D ip_hdr(skb)->saddr;
> -	} else {
> -		struct flowi6 *fl6 =3D &fl.u.ip6;
> -
> -		memset(fl6, 0, sizeof(*fl6));
> -		fl6->daddr =3D ipv6_hdr(skb)->saddr;
> -	}
> -	rcu_read_lock();
> -	ai =3D nf_get_afinfo(family);
> -	if (ai !=3D NULL)
> -		ai->route(net, (struct dst_entry **)&rt, &fl, false);
> -	rcu_read_unlock();
> -
> -	if (rt !=3D NULL) {
> -		mtu =3D dst_mtu(&rt->dst);
> -		dst_release(&rt->dst);
> -	}
> -	return mtu;
> -}
> +MODULE_DESCRIPTION("Xtables: TCP MSS match");
> +MODULE_ALIAS("ipt_tcpmss");
> +MODULE_ALIAS("ip6t_tcpmss");
>=20
> -static int
> -tcpmss_mangle_packet(struct sk_buff *skb,
> -		     const struct xt_action_param *par,
> -		     unsigned int family,
> -		     unsigned int tcphoff,
> -		     unsigned int minlen)
> +static bool
> +tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
> {
> -	const struct xt_tcpmss_info *info =3D par->targinfo;
> -	struct tcphdr *tcph;
> -	int len, tcp_hdrlen;
> -	unsigned int i;
> -	__be16 oldval;
> -	u16 newmss;
> -	u8 *opt;
> -
> -	/* This is a fragment, no TCP header is available */
> -	if (par->fragoff !=3D 0)
> -		return 0;
> -
> -	if (!skb_make_writable(skb, skb->len))
> -		return -1;
> -
> -	len =3D skb->len - tcphoff;
> -	if (len < (int)sizeof(struct tcphdr))
> -		return -1;
> -
> -	tcph =3D (struct tcphdr *)(skb_network_header(skb) + tcphoff);
> -	tcp_hdrlen =3D tcph->doff * 4;
> -
> -	if (len < tcp_hdrlen)
> -		return -1;
> -
> -	if (info->mss =3D=3D XT_TCPMSS_CLAMP_PMTU) {
> -		struct net *net =3D xt_net(par);
> -		unsigned int in_mtu =3D tcpmss_reverse_mtu(net, skb, =
family);
> -		unsigned int min_mtu =3D min(dst_mtu(skb_dst(skb)), =
in_mtu);
> -
> -		if (min_mtu <=3D minlen) {
> -			net_err_ratelimited("unknown or invalid path-MTU =
(%u)\n",
> -					    min_mtu);
> -			return -1;
> -		}
> -		newmss =3D min_mtu - minlen;
> -	} else
> -		newmss =3D info->mss;
> -
> -	opt =3D (u_int8_t *)tcph;
> -	for (i =3D sizeof(struct tcphdr); i <=3D tcp_hdrlen - =
TCPOLEN_MSS; i +=3D optlen(opt, i)) {
> -		if (opt[i] =3D=3D TCPOPT_MSS && opt[i+1] =3D=3D =
TCPOLEN_MSS) {
> -			u_int16_t oldmss;
> -
> -			oldmss =3D (opt[i+2] << 8) | opt[i+3];
> -
> -			/* Never increase MSS, even when setting it, as
> -			 * doing so results in problems for hosts that =
rely
> -			 * on MSS being set correctly.
> -			 */
> -			if (oldmss <=3D newmss)
> -				return 0;
> -
> -			opt[i+2] =3D (newmss & 0xff00) >> 8;
> -			opt[i+3] =3D newmss & 0x00ff;
> -
> -			inet_proto_csum_replace2(&tcph->check, skb,
> -						 htons(oldmss), =
htons(newmss),
> -						 false);
> -			return 0;
> +	const struct xt_tcpmss_match_info *info =3D par->matchinfo;
> +	const struct tcphdr *th;
> +	struct tcphdr _tcph;
> +	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
> +	const u_int8_t *op;
> +	u8 _opt[15 * 4 - sizeof(_tcph)];
> +	unsigned int i, optlen;
> +
> +	/* If we don't have the whole header, drop packet. */
> +	th =3D skb_header_pointer(skb, par->thoff, sizeof(_tcph), =
&_tcph);
> +	if (th =3D=3D NULL)
> +		goto dropit;
> +
> +	/* Malformed. */
> +	if (th->doff*4 < sizeof(*th))
> +		goto dropit;
> +
> +	optlen =3D th->doff*4 - sizeof(*th);
> +	if (!optlen)
> +		goto out;
> +
> +	/* Truncated options. */
> +	op =3D skb_header_pointer(skb, par->thoff + sizeof(*th), optlen, =
_opt);
> +	if (op =3D=3D NULL)
> +		goto dropit;
> +
> +	for (i =3D 0; i < optlen; ) {
> +		if (op[i] =3D=3D TCPOPT_MSS
> +		    && (optlen - i) >=3D TCPOLEN_MSS
> +		    && op[i+1] =3D=3D TCPOLEN_MSS) {
> +			u_int16_t mssval;
> +
> +			mssval =3D (op[i+2] << 8) | op[i+3];
> +
> +			return (mssval >=3D info->mss_min &&
> +				mssval <=3D info->mss_max) ^ =
info->invert;
> 		}
> +		if (op[i] < 2)
> +			i++;
> +		else
> +			i +=3D op[i+1] ? : 1;
> 	}
> +out:
> +	return info->invert;
>=20
> -	/* There is data after the header so the option can't be added
> -	 * without moving it, and doing so may make the SYN packet
> -	 * itself too large. Accept the packet unmodified instead.
> -	 */
> -	if (len > tcp_hdrlen)
> -		return 0;
> -
> -	/*
> -	 * MSS Option not found ?! add it..
> -	 */
> -	if (skb_tailroom(skb) < TCPOLEN_MSS) {
> -		if (pskb_expand_head(skb, 0,
> -				     TCPOLEN_MSS - skb_tailroom(skb),
> -				     GFP_ATOMIC))
> -			return -1;
> -		tcph =3D (struct tcphdr *)(skb_network_header(skb) + =
tcphoff);
> -	}
> -
> -	skb_put(skb, TCPOLEN_MSS);
> -
> -	/*
> -	 * IPv4: RFC 1122 states "If an MSS option is not received at
> -	 * connection setup, TCP MUST assume a default send MSS of 536".
> -	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a =
minimum
> -	 * length IPv6 header of 60, ergo the default MSS value is 1220
> -	 * Since no MSS was provided, we must use the default values
> -	 */
> -	if (xt_family(par) =3D=3D NFPROTO_IPV4)
> -		newmss =3D min(newmss, (u16)536);
> -	else
> -		newmss =3D min(newmss, (u16)1220);
> -
> -	opt =3D (u_int8_t *)tcph + sizeof(struct tcphdr);
> -	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
> -
> -	inet_proto_csum_replace2(&tcph->check, skb,
> -				 htons(len), htons(len + TCPOLEN_MSS), =
true);
> -	opt[0] =3D TCPOPT_MSS;
> -	opt[1] =3D TCPOLEN_MSS;
> -	opt[2] =3D (newmss & 0xff00) >> 8;
> -	opt[3] =3D newmss & 0x00ff;
> -
> -	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), =
false);
> -
> -	oldval =3D ((__be16 *)tcph)[6];
> -	tcph->doff +=3D TCPOLEN_MSS/4;
> -	inet_proto_csum_replace2(&tcph->check, skb,
> -				 oldval, ((__be16 *)tcph)[6], false);
> -	return TCPOLEN_MSS;
> -}
> -
> -static unsigned int
> -tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
> -{
> -	struct iphdr *iph =3D ip_hdr(skb);
> -	__be16 newlen;
> -	int ret;
> -
> -	ret =3D tcpmss_mangle_packet(skb, par,
> -				   PF_INET,
> -				   iph->ihl * 4,
> -				   sizeof(*iph) + sizeof(struct =
tcphdr));
> -	if (ret < 0)
> -		return NF_DROP;
> -	if (ret > 0) {
> -		iph =3D ip_hdr(skb);
> -		newlen =3D htons(ntohs(iph->tot_len) + ret);
> -		csum_replace2(&iph->check, iph->tot_len, newlen);
> -		iph->tot_len =3D newlen;
> -	}
> -	return XT_CONTINUE;
> -}
> -
> -#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> -static unsigned int
> -tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
> -{
> -	struct ipv6hdr *ipv6h =3D ipv6_hdr(skb);
> -	u8 nexthdr;
> -	__be16 frag_off, oldlen, newlen;
> -	int tcphoff;
> -	int ret;
> -
> -	nexthdr =3D ipv6h->nexthdr;
> -	tcphoff =3D ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, =
&frag_off);
> -	if (tcphoff < 0)
> -		return NF_DROP;
> -	ret =3D tcpmss_mangle_packet(skb, par,
> -				   PF_INET6,
> -				   tcphoff,
> -				   sizeof(*ipv6h) + sizeof(struct =
tcphdr));
> -	if (ret < 0)
> -		return NF_DROP;
> -	if (ret > 0) {
> -		ipv6h =3D ipv6_hdr(skb);
> -		oldlen =3D ipv6h->payload_len;
> -		newlen =3D htons(ntohs(oldlen) + ret);
> -		if (skb->ip_summed =3D=3D CHECKSUM_COMPLETE)
> -			skb->csum =3D csum_add(csum_sub(skb->csum, =
oldlen),
> -					     newlen);
> -		ipv6h->payload_len =3D newlen;
> -	}
> -	return XT_CONTINUE;
> -}
> -#endif
> -
> -/* Must specify -p tcp --syn */
> -static inline bool find_syn_match(const struct xt_entry_match *m)
> -{
> -	const struct xt_tcp *tcpinfo =3D (const struct xt_tcp *)m->data;
> -
> -	if (strcmp(m->u.kernel.match->name, "tcp") =3D=3D 0 &&
> -	    tcpinfo->flg_cmp & TCPHDR_SYN &&
> -	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
> -		return true;
> -
> +dropit:
> +	par->hotdrop =3D true;
> 	return false;
> }
>=20
> -static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
> -{
> -	const struct xt_tcpmss_info *info =3D par->targinfo;
> -	const struct ipt_entry *e =3D par->entryinfo;
> -	const struct xt_entry_match *ematch;
> -
> -	if (info->mss =3D=3D XT_TCPMSS_CLAMP_PMTU &&
> -	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
> -			   (1 << NF_INET_LOCAL_OUT) |
> -			   (1 << NF_INET_POST_ROUTING))) !=3D 0) {
> -		pr_info("path-MTU clamping only supported in "
> -			"FORWARD, OUTPUT and POSTROUTING hooks\n");
> -		return -EINVAL;
> -	}
> -	if (par->nft_compat)
> -		return 0;
> -
> -	xt_ematch_foreach(ematch, e)
> -		if (find_syn_match(ematch))
> -			return 0;
> -	pr_info("Only works on TCP SYN packets\n");
> -	return -EINVAL;
> -}
> -
> -#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> -static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
> -{
> -	const struct xt_tcpmss_info *info =3D par->targinfo;
> -	const struct ip6t_entry *e =3D par->entryinfo;
> -	const struct xt_entry_match *ematch;
> -
> -	if (info->mss =3D=3D XT_TCPMSS_CLAMP_PMTU &&
> -	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
> -			   (1 << NF_INET_LOCAL_OUT) |
> -			   (1 << NF_INET_POST_ROUTING))) !=3D 0) {
> -		pr_info("path-MTU clamping only supported in "
> -			"FORWARD, OUTPUT and POSTROUTING hooks\n");
> -		return -EINVAL;
> -	}
> -	if (par->nft_compat)
> -		return 0;
> -
> -	xt_ematch_foreach(ematch, e)
> -		if (find_syn_match(ematch))
> -			return 0;
> -	pr_info("Only works on TCP SYN packets\n");
> -	return -EINVAL;
> -}
> -#endif
> -
> -static struct xt_target tcpmss_tg_reg[] __read_mostly =3D {
> +static struct xt_match tcpmss_mt_reg[] __read_mostly =3D {
> 	{
> +		.name		=3D "tcpmss",
> 		.family		=3D NFPROTO_IPV4,
> -		.name		=3D "TCPMSS",
> -		.checkentry	=3D tcpmss_tg4_check,
> -		.target		=3D tcpmss_tg4,
> -		.targetsize	=3D sizeof(struct xt_tcpmss_info),
> +		.match		=3D tcpmss_mt,
> +		.matchsize	=3D sizeof(struct xt_tcpmss_match_info),
> 		.proto		=3D IPPROTO_TCP,
> 		.me		=3D THIS_MODULE,
> 	},
> -#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> 	{
> +		.name		=3D "tcpmss",
> 		.family		=3D NFPROTO_IPV6,
> -		.name		=3D "TCPMSS",
> -		.checkentry	=3D tcpmss_tg6_check,
> -		.target		=3D tcpmss_tg6,
> -		.targetsize	=3D sizeof(struct xt_tcpmss_info),
> +		.match		=3D tcpmss_mt,
> +		.matchsize	=3D sizeof(struct xt_tcpmss_match_info),
> 		.proto		=3D IPPROTO_TCP,
> 		.me		=3D THIS_MODULE,
> 	},
> -#endif
> };
>=20
> -static int __init tcpmss_tg_init(void)
> +static int __init tcpmss_mt_init(void)
> {
> -	return xt_register_targets(tcpmss_tg_reg, =
ARRAY_SIZE(tcpmss_tg_reg));
> +	return xt_register_matches(tcpmss_mt_reg, =
ARRAY_SIZE(tcpmss_mt_reg));
> }
>=20
> -static void __exit tcpmss_tg_exit(void)
> +static void __exit tcpmss_mt_exit(void)
> {
> -	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
> +	xt_unregister_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
> }
>=20
> -module_init(tcpmss_tg_init);
> -module_exit(tcpmss_tg_exit);
> +module_init(tcpmss_mt_init);
> +module_exit(tcpmss_mt_exit);
> diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
> index 236ac80..3f83d38 100644
> --- a/net/netfilter/xt_dscp.c
> +++ b/net/netfilter/xt_dscp.c
> @@ -1,11 +1,14 @@
> -/* IP tables module for matching the value of the IPv4/IPv6 DSCP =
field
> +/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
>  *
>  * (C) 2002 by Harald Welte <laforge@netfilter.org>
> + * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh =
<mgm@paktronix.com>
>  *
>  * This program is free software; you can redistribute it and/or =
modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
> - */
> + *
> + * See RFC2474 for a description of the DSCP field within the IP =
Header.
> +*/
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> #include <linux/module.h>
> #include <linux/skbuff.h>
> @@ -14,102 +17,150 @@
> #include <net/dsfield.h>
>=20
> #include <linux/netfilter/x_tables.h>
> -#include <linux/netfilter/xt_dscp.h>
> +#include <linux/netfilter/xt_DSCP.h>
>=20
> MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
> -MODULE_DESCRIPTION("Xtables: DSCP/TOS field match");
> +MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
> MODULE_LICENSE("GPL");
> -MODULE_ALIAS("ipt_dscp");
> -MODULE_ALIAS("ip6t_dscp");
> -MODULE_ALIAS("ipt_tos");
> -MODULE_ALIAS("ip6t_tos");
> +MODULE_ALIAS("ipt_DSCP");
> +MODULE_ALIAS("ip6t_DSCP");
> +MODULE_ALIAS("ipt_TOS");
> +MODULE_ALIAS("ip6t_TOS");
>=20
> -static bool
> -dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
> +static unsigned int
> +dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
> {
> -	const struct xt_dscp_info *info =3D par->matchinfo;
> +	const struct xt_DSCP_info *dinfo =3D par->targinfo;
> 	u_int8_t dscp =3D ipv4_get_dsfield(ip_hdr(skb)) >> =
XT_DSCP_SHIFT;
>=20
> -	return (dscp =3D=3D info->dscp) ^ !!info->invert;
> +	if (dscp !=3D dinfo->dscp) {
> +		if (!skb_make_writable(skb, sizeof(struct iphdr)))
> +			return NF_DROP;
> +
> +		ipv4_change_dsfield(ip_hdr(skb),
> +				    (__force __u8)(~XT_DSCP_MASK),
> +				    dinfo->dscp << XT_DSCP_SHIFT);
> +
> +	}
> +	return XT_CONTINUE;
> }
>=20
> -static bool
> -dscp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
> +static unsigned int
> +dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
> {
> -	const struct xt_dscp_info *info =3D par->matchinfo;
> +	const struct xt_DSCP_info *dinfo =3D par->targinfo;
> 	u_int8_t dscp =3D ipv6_get_dsfield(ipv6_hdr(skb)) >> =
XT_DSCP_SHIFT;
>=20
> -	return (dscp =3D=3D info->dscp) ^ !!info->invert;
> +	if (dscp !=3D dinfo->dscp) {
> +		if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
> +			return NF_DROP;
> +
> +		ipv6_change_dsfield(ipv6_hdr(skb),
> +				    (__force __u8)(~XT_DSCP_MASK),
> +				    dinfo->dscp << XT_DSCP_SHIFT);
> +	}
> +	return XT_CONTINUE;
> }
>=20
> -static int dscp_mt_check(const struct xt_mtchk_param *par)
> +static int dscp_tg_check(const struct xt_tgchk_param *par)
> {
> -	const struct xt_dscp_info *info =3D par->matchinfo;
> +	const struct xt_DSCP_info *info =3D par->targinfo;
>=20
> 	if (info->dscp > XT_DSCP_MAX) {
> 		pr_info("dscp %x out of range\n", info->dscp);
> 		return -EDOM;
> 	}
> -
> 	return 0;
> }
>=20
> -static bool tos_mt(const struct sk_buff *skb, struct xt_action_param =
*par)
> +static unsigned int
> +tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
> +{
> +	const struct xt_tos_target_info *info =3D par->targinfo;
> +	struct iphdr *iph =3D ip_hdr(skb);
> +	u_int8_t orig, nv;
> +
> +	orig =3D ipv4_get_dsfield(iph);
> +	nv   =3D (orig & ~info->tos_mask) ^ info->tos_value;
> +
> +	if (orig !=3D nv) {
> +		if (!skb_make_writable(skb, sizeof(struct iphdr)))
> +			return NF_DROP;
> +		iph =3D ip_hdr(skb);
> +		ipv4_change_dsfield(iph, 0, nv);
> +	}
> +
> +	return XT_CONTINUE;
> +}
> +
> +static unsigned int
> +tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
> {
> -	const struct xt_tos_match_info *info =3D par->matchinfo;
> -
> -	if (xt_family(par) =3D=3D NFPROTO_IPV4)
> -		return ((ip_hdr(skb)->tos & info->tos_mask) =3D=3D
> -		       info->tos_value) ^ !!info->invert;
> -	else
> -		return ((ipv6_get_dsfield(ipv6_hdr(skb)) & =
info->tos_mask) =3D=3D
> -		       info->tos_value) ^ !!info->invert;
> +	const struct xt_tos_target_info *info =3D par->targinfo;
> +	struct ipv6hdr *iph =3D ipv6_hdr(skb);
> +	u_int8_t orig, nv;
> +
> +	orig =3D ipv6_get_dsfield(iph);
> +	nv   =3D (orig & ~info->tos_mask) ^ info->tos_value;
> +
> +	if (orig !=3D nv) {
> +		if (!skb_make_writable(skb, sizeof(struct iphdr)))
> +			return NF_DROP;
> +		iph =3D ipv6_hdr(skb);
> +		ipv6_change_dsfield(iph, 0, nv);
> +	}
> +
> +	return XT_CONTINUE;
> }
>=20
> -static struct xt_match dscp_mt_reg[] __read_mostly =3D {
> +static struct xt_target dscp_tg_reg[] __read_mostly =3D {
> 	{
> -		.name		=3D "dscp",
> +		.name		=3D "DSCP",
> 		.family		=3D NFPROTO_IPV4,
> -		.checkentry	=3D dscp_mt_check,
> -		.match		=3D dscp_mt,
> -		.matchsize	=3D sizeof(struct xt_dscp_info),
> +		.checkentry	=3D dscp_tg_check,
> +		.target		=3D dscp_tg,
> +		.targetsize	=3D sizeof(struct xt_DSCP_info),
> +		.table		=3D "mangle",
> 		.me		=3D THIS_MODULE,
> 	},
> 	{
> -		.name		=3D "dscp",
> +		.name		=3D "DSCP",
> 		.family		=3D NFPROTO_IPV6,
> -		.checkentry	=3D dscp_mt_check,
> -		.match		=3D dscp_mt6,
> -		.matchsize	=3D sizeof(struct xt_dscp_info),
> +		.checkentry	=3D dscp_tg_check,
> +		.target		=3D dscp_tg6,
> +		.targetsize	=3D sizeof(struct xt_DSCP_info),
> +		.table		=3D "mangle",
> 		.me		=3D THIS_MODULE,
> 	},
> 	{
> -		.name		=3D "tos",
> +		.name		=3D "TOS",
> 		.revision	=3D 1,
> 		.family		=3D NFPROTO_IPV4,
> -		.match		=3D tos_mt,
> -		.matchsize	=3D sizeof(struct xt_tos_match_info),
> +		.table		=3D "mangle",
> +		.target		=3D tos_tg,
> +		.targetsize	=3D sizeof(struct xt_tos_target_info),
> 		.me		=3D THIS_MODULE,
> 	},
> 	{
> -		.name		=3D "tos",
> +		.name		=3D "TOS",
> 		.revision	=3D 1,
> 		.family		=3D NFPROTO_IPV6,
> -		.match		=3D tos_mt,
> -		.matchsize	=3D sizeof(struct xt_tos_match_info),
> +		.table		=3D "mangle",
> +		.target		=3D tos_tg6,
> +		.targetsize	=3D sizeof(struct xt_tos_target_info),
> 		.me		=3D THIS_MODULE,
> 	},
> };
>=20
> -static int __init dscp_mt_init(void)
> +static int __init dscp_tg_init(void)
> {
> -	return xt_register_matches(dscp_mt_reg, =
ARRAY_SIZE(dscp_mt_reg));
> +	return xt_register_targets(dscp_tg_reg, =
ARRAY_SIZE(dscp_tg_reg));
> }
>=20
> -static void __exit dscp_mt_exit(void)
> +static void __exit dscp_tg_exit(void)
> {
> -	xt_unregister_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
> +	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
> }
>=20
> -module_init(dscp_mt_init);
> -module_exit(dscp_mt_exit);
> +module_init(dscp_tg_init);
> +module_exit(dscp_tg_exit);
> diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
> index 0039511..1535e87 100644
> --- a/net/netfilter/xt_hl.c
> +++ b/net/netfilter/xt_hl.c
> @@ -1,96 +1,169 @@
> /*
> - * IP tables module for matching the value of the TTL
> - * (C) 2000,2001 by Harald Welte <laforge@netfilter.org>
> + * TTL modification target for IP tables
> + * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
>  *
> - * Hop Limit matching module
> - * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
> + * Hop Limit modification target for ip6tables
> + * Maciej Soltysiak <solt@dns.toxicfilms.tv>
>  *
>  * This program is free software; you can redistribute it and/or =
modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -
> -#include <linux/ip.h>
> -#include <linux/ipv6.h>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> #include <linux/module.h>
> #include <linux/skbuff.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <net/checksum.h>
>=20
> #include <linux/netfilter/x_tables.h>
> -#include <linux/netfilter_ipv4/ipt_ttl.h>
> -#include <linux/netfilter_ipv6/ip6t_hl.h>
> +#include <linux/netfilter_ipv4/ipt_TTL.h>
> +#include <linux/netfilter_ipv6/ip6t_HL.h>
>=20
> +MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
> MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
> -MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match");
> +MODULE_DESCRIPTION("Xtables: Hoplimit/TTL Limit field modification =
target");
> MODULE_LICENSE("GPL");
> -MODULE_ALIAS("ipt_ttl");
> -MODULE_ALIAS("ip6t_hl");
>=20
> -static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param =
*par)
> +static unsigned int
> +ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
> {
> -	const struct ipt_ttl_info *info =3D par->matchinfo;
> -	const u8 ttl =3D ip_hdr(skb)->ttl;
> +	struct iphdr *iph;
> +	const struct ipt_TTL_info *info =3D par->targinfo;
> +	int new_ttl;
> +
> +	if (!skb_make_writable(skb, skb->len))
> +		return NF_DROP;
> +
> +	iph =3D ip_hdr(skb);
>=20
> 	switch (info->mode) {
> -	case IPT_TTL_EQ:
> -		return ttl =3D=3D info->ttl;
> -	case IPT_TTL_NE:
> -		return ttl !=3D info->ttl;
> -	case IPT_TTL_LT:
> -		return ttl < info->ttl;
> -	case IPT_TTL_GT:
> -		return ttl > info->ttl;
> +	case IPT_TTL_SET:
> +		new_ttl =3D info->ttl;
> +		break;
> +	case IPT_TTL_INC:
> +		new_ttl =3D iph->ttl + info->ttl;
> +		if (new_ttl > 255)
> +			new_ttl =3D 255;
> +		break;
> +	case IPT_TTL_DEC:
> +		new_ttl =3D iph->ttl - info->ttl;
> +		if (new_ttl < 0)
> +			new_ttl =3D 0;
> +		break;
> +	default:
> +		new_ttl =3D iph->ttl;
> +		break;
> +	}
> +
> +	if (new_ttl !=3D iph->ttl) {
> +		csum_replace2(&iph->check, htons(iph->ttl << 8),
> +					   htons(new_ttl << 8));
> +		iph->ttl =3D new_ttl;
> 	}
>=20
> -	return false;
> +	return XT_CONTINUE;
> }
>=20
> -static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param =
*par)
> +static unsigned int
> +hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
> {
> -	const struct ip6t_hl_info *info =3D par->matchinfo;
> -	const struct ipv6hdr *ip6h =3D ipv6_hdr(skb);
> +	struct ipv6hdr *ip6h;
> +	const struct ip6t_HL_info *info =3D par->targinfo;
> +	int new_hl;
> +
> +	if (!skb_make_writable(skb, skb->len))
> +		return NF_DROP;
> +
> +	ip6h =3D ipv6_hdr(skb);
>=20
> 	switch (info->mode) {
> -	case IP6T_HL_EQ:
> -		return ip6h->hop_limit =3D=3D info->hop_limit;
> -	case IP6T_HL_NE:
> -		return ip6h->hop_limit !=3D info->hop_limit;
> -	case IP6T_HL_LT:
> -		return ip6h->hop_limit < info->hop_limit;
> -	case IP6T_HL_GT:
> -		return ip6h->hop_limit > info->hop_limit;
> +	case IP6T_HL_SET:
> +		new_hl =3D info->hop_limit;
> +		break;
> +	case IP6T_HL_INC:
> +		new_hl =3D ip6h->hop_limit + info->hop_limit;
> +		if (new_hl > 255)
> +			new_hl =3D 255;
> +		break;
> +	case IP6T_HL_DEC:
> +		new_hl =3D ip6h->hop_limit - info->hop_limit;
> +		if (new_hl < 0)
> +			new_hl =3D 0;
> +		break;
> +	default:
> +		new_hl =3D ip6h->hop_limit;
> +		break;
> 	}
>=20
> -	return false;
> +	ip6h->hop_limit =3D new_hl;
> +
> +	return XT_CONTINUE;
> +}
> +
> +static int ttl_tg_check(const struct xt_tgchk_param *par)
> +{
> +	const struct ipt_TTL_info *info =3D par->targinfo;
> +
> +	if (info->mode > IPT_TTL_MAXMODE) {
> +		pr_info("TTL: invalid or unknown mode %u\n", =
info->mode);
> +		return -EINVAL;
> +	}
> +	if (info->mode !=3D IPT_TTL_SET && info->ttl =3D=3D 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int hl_tg6_check(const struct xt_tgchk_param *par)
> +{
> +	const struct ip6t_HL_info *info =3D par->targinfo;
> +
> +	if (info->mode > IP6T_HL_MAXMODE) {
> +		pr_info("invalid or unknown mode %u\n", info->mode);
> +		return -EINVAL;
> +	}
> +	if (info->mode !=3D IP6T_HL_SET && info->hop_limit =3D=3D 0) {
> +		pr_info("increment/decrement does not "
> +			"make sense with value 0\n");
> +		return -EINVAL;
> +	}
> +	return 0;
> }
>=20
> -static struct xt_match hl_mt_reg[] __read_mostly =3D {
> +static struct xt_target hl_tg_reg[] __read_mostly =3D {
> 	{
> -		.name       =3D "ttl",
> +		.name       =3D "TTL",
> 		.revision   =3D 0,
> 		.family     =3D NFPROTO_IPV4,
> -		.match      =3D ttl_mt,
> -		.matchsize  =3D sizeof(struct ipt_ttl_info),
> +		.target     =3D ttl_tg,
> +		.targetsize =3D sizeof(struct ipt_TTL_info),
> +		.table      =3D "mangle",
> +		.checkentry =3D ttl_tg_check,
> 		.me         =3D THIS_MODULE,
> 	},
> 	{
> -		.name       =3D "hl",
> +		.name       =3D "HL",
> 		.revision   =3D 0,
> 		.family     =3D NFPROTO_IPV6,
> -		.match      =3D hl_mt6,
> -		.matchsize  =3D sizeof(struct ip6t_hl_info),
> +		.target     =3D hl_tg6,
> +		.targetsize =3D sizeof(struct ip6t_HL_info),
> +		.table      =3D "mangle",
> +		.checkentry =3D hl_tg6_check,
> 		.me         =3D THIS_MODULE,
> 	},
> };
>=20
> -static int __init hl_mt_init(void)
> +static int __init hl_tg_init(void)
> {
> -	return xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
> +	return xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
> }
>=20
> -static void __exit hl_mt_exit(void)
> +static void __exit hl_tg_exit(void)
> {
> -	xt_unregister_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
> +	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
> }
>=20
> -module_init(hl_mt_init);
> -module_exit(hl_mt_exit);
> +module_init(hl_tg_init);
> +module_exit(hl_tg_exit);
> +MODULE_ALIAS("ipt_TTL");
> +MODULE_ALIAS("ip6t_HL");
>=20
>=20
>=20
>=20
