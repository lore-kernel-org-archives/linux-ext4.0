From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add largedir feature
Date: Thu, 16 Mar 2017 15:44:03 -0600
Message-ID: <CE3A3FB1-8DE6-476A-8386-94D590B17A23@dilger.ca>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9139B15C-689A-4740-B37E-9ED24BEED16A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33075 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbdCPVoP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Mar 2017 17:44:15 -0400
Received: by mail-it0-f67.google.com with SMTP id g138so678651itb.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Mar 2017 14:44:14 -0700 (PDT)
In-Reply-To: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9139B15C-689A-4740-B37E-9ED24BEED16A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 16, 2017, at 3:51 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> This INCOMPAT_LARGEDIR feature allows larger directories to be created
> in ldiskfs, both with directory sizes over 2GB and and a maximum htree
> depth of 3 instead of the current limit of 2. These features are =
needed
> in order to exceed the current limit of approximately 10M entries in a
> single directory.

Artem,
many thanks for updating and submitting this, and creating the e2fsck =
patches.

Ted,
can you please add the original author for the largedir ext4 patch when
landing this patch: Liang Zhen <liang.zhen@intel.com>

and these tags which contain more background information on this =
feature:

Lustre-change: https://review.hpdd.intel.com/375
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-50

> Signed-off-by: Yang Sheng <yang.sheng@intel.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

> ---
> fs/ext4/ext4.h  |  23 ++++++++---
> fs/ext4/inode.c |   4 +-
> fs/ext4/namei.c | 118 =
+++++++++++++++++++++++++++++++++++++++-----------------
> 3 files changed, 102 insertions(+), 43 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 01d52b9..0bbbd9b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1799,7 +1799,8 @@ static inline void ext4_clear_state_flags(struct =
ext4_inode_info *ei)
> 					 EXT4_FEATURE_INCOMPAT_MMP | \
> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
> -					 =
EXT4_FEATURE_INCOMPAT_CSUM_SEED)
> +					 EXT4_FEATURE_INCOMPAT_CSUM_SEED =
| \
> +					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
> #define EXT4_FEATURE_RO_COMPAT_SUPP	=
(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> 					 =
EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
> 					 =
EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
> @@ -2125,6 +2126,16 @@ struct dir_private_info {
>  */
> #define ERR_BAD_DX_DIR	(-(MAX_ERRNO - 1))
>=20
> +/* htree levels for ext4 */
> +#define	EXT4_HTREE_LEVEL_COMPAT	2
> +#define	EXT4_HTREE_LEVEL	3
> +
> +static inline int ext4_dir_htree_level(struct super_block *sb)
> +{
> +	return ext4_has_feature_largedir(sb) ?
> +		EXT4_HTREE_LEVEL : EXT4_HTREE_LEVEL_COMPAT;
> +}
> +
> /*
>  * Timeout and state flag for lazy initialization inode thread.
>  */
> @@ -2758,13 +2769,15 @@ static inline void =
ext4_r_blocks_count_set(struct ext4_super_block *es,
> 	es->s_r_blocks_count_hi =3D cpu_to_le32(blk >> 32);
> }
>=20
> -static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
> +static inline loff_t ext4_isize(struct super_block *sb,
> +				struct ext4_inode *raw_inode)
> {
> -	if (S_ISREG(le16_to_cpu(raw_inode->i_mode)))
> +	if (ext4_has_feature_largedir(sb) ||
> +	    S_ISREG(le16_to_cpu(raw_inode->i_mode)))
> 		return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << =
32) |
> 			le32_to_cpu(raw_inode->i_size_lo);
> -	else
> -		return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
> +
> +	return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
> }
>=20
> static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t =
i_size)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f622d4a..5787f3d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4682,7 +4682,7 @@ struct inode *ext4_iget(struct super_block *sb, =
unsigned long ino)
> 	if (ext4_has_feature_64bit(sb))
> 		ei->i_file_acl |=3D
> 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) =
<< 32;
> -	inode->i_size =3D ext4_isize(raw_inode);
> +	inode->i_size =3D ext4_isize(sb, raw_inode);
> 	if ((size =3D i_size_read(inode)) < 0) {
> 		EXT4_ERROR_INODE(inode, "bad i_size value: %lld", size);
> 		ret =3D -EFSCORRUPTED;
> @@ -5008,7 +5008,7 @@ static int ext4_do_update_inode(handle_t =
*handle,
> 		raw_inode->i_file_acl_high =3D
> 			cpu_to_le16(ei->i_file_acl >> 32);
> 	raw_inode->i_file_acl_lo =3D cpu_to_le32(ei->i_file_acl);
> -	if (ei->i_disksize !=3D ext4_isize(raw_inode)) {
> +	if (ei->i_disksize !=3D ext4_isize(inode->i_sb, raw_inode)) {
> 		ext4_isize_set(raw_inode, ei->i_disksize);
> 		need_datasync =3D 1;
> 	}
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6ad612c..3298fe3 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -513,7 +513,7 @@ static inline int =
ext4_handle_dirty_dx_node(handle_t *handle,
>=20
> static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
> {
> -	return le32_to_cpu(entry->block) & 0x00ffffff;
> +	return le32_to_cpu(entry->block) & 0x0fffffff;
> }

It wouldn't be terrible to add a comment to this function explaining why
the block numbers are masked off, which is to allow the high bits of the
logical block number to hold a "fullness" fraction so that the kernel
could start shrinking directories if many files are deleted.  That said,
this isn't a shortcoming of this patch, but a suggestion if the patch is
being resubmitted for some other reason.

> static inline void dx_set_block(struct dx_entry *entry, ext4_lblk_t =
value)
> @@ -739,6 +739,7 @@ struct stats dx_show_entries(struct dx_hash_info =
*hinfo, struct inode *dir,
> 	struct dx_frame *ret_err =3D ERR_PTR(ERR_BAD_DX_DIR);
> 	u32 hash;
>=20
> +	memset(frame_in, 0, EXT4_HTREE_LEVEL * sizeof(frame_in[0]));
> 	frame->bh =3D ext4_read_dirblock(dir, 0, INDEX);
> 	if (IS_ERR(frame->bh))
> 		return (struct dx_frame *) frame->bh;
> @@ -768,9 +769,15 @@ struct stats dx_show_entries(struct dx_hash_info =
*hinfo, struct inode *dir,
> 	}
>=20
> 	indirect =3D root->info.indirect_levels;
> -	if (indirect > 1) {
> -		ext4_warning_inode(dir, "Unimplemented hash depth: =
%#06x",
> -				   root->info.indirect_levels);
> +	if (indirect >=3D ext4_dir_htree_level(dir->i_sb)) {
> +		ext4_warning(dir->i_sb,
> +			     "Directory (ino: %lu) htree depth %#06x =
exceed"
> +			     "supported value", dir->i_ino,
> +			     ext4_dir_htree_level(dir->i_sb));
> +		if (ext4_dir_htree_level(dir->i_sb) < EXT4_HTREE_LEVEL) =
{
> +			ext4_warning(dir->i_sb, "Enable large directory =
"
> +						"feature to access it");
> +		}
> 		goto fail;
> 	}
>=20
> @@ -859,12 +866,19 @@ struct stats dx_show_entries(struct dx_hash_info =
*hinfo, struct inode *dir,
>=20
> static void dx_release(struct dx_frame *frames)
> {
> +	struct dx_root_info *info;
> +	int i;
> +
> 	if (frames[0].bh =3D=3D NULL)
> 		return;
>=20
> -	if (((struct dx_root =
*)frames[0].bh->b_data)->info.indirect_levels)
> -		brelse(frames[1].bh);
> -	brelse(frames[0].bh);
> +	info =3D &((struct dx_root *)frames[0].bh->b_data)->info;
> +	for (i =3D 0; i <=3D info->indirect_levels; i++) {
> +		if (frames[i].bh =3D=3D NULL)
> +			break;
> +		brelse(frames[i].bh);
> +		frames[i].bh =3D NULL;
> +	}
> }
>=20
> /*
> @@ -1050,7 +1064,7 @@ int ext4_htree_fill_tree(struct file *dir_file, =
__u32 start_hash,
> {
> 	struct dx_hash_info hinfo;
> 	struct ext4_dir_entry_2 *de;
> -	struct dx_frame frames[2], *frame;
> +	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
> 	struct inode *dir;
> 	ext4_lblk_t block;
> 	int count =3D 0;
> @@ -1517,7 +1531,7 @@ static struct buffer_head * =
ext4_dx_find_entry(struct inode *dir,
> 			struct ext4_dir_entry_2 **res_dir)
> {
> 	struct super_block * sb =3D dir->i_sb;
> -	struct dx_frame frames[2], *frame;
> +	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
> 	const struct qstr *d_name =3D fname->usr_fname;
> 	struct buffer_head *bh;
> 	ext4_lblk_t block;
> @@ -1947,7 +1961,7 @@ static int add_dirent_to_buf(handle_t *handle, =
struct ext4_filename *fname,
> 	 */
> 	dir->i_mtime =3D dir->i_ctime =3D current_time(dir);
> 	ext4_update_dx_flag(dir);
> -	dir->i_version++;
> +	inode_inc_iversion(dir);
> 	ext4_mark_inode_dirty(handle, dir);
> 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> 	err =3D ext4_handle_dirty_dirent_node(handle, dir, bh);
> @@ -1966,7 +1980,7 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
> {
> 	struct buffer_head *bh2;
> 	struct dx_root	*root;
> -	struct dx_frame	frames[2], *frame;
> +	struct dx_frame	frames[EXT4_HTREE_LEVEL], *frame;
> 	struct dx_entry *entries;
> 	struct ext4_dir_entry_2	*de, *de2;
> 	struct ext4_dir_entry_tail *t;
> @@ -2185,13 +2199,16 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
> static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename =
*fname,
> 			     struct inode *dir, struct inode *inode)
> {
> -	struct dx_frame frames[2], *frame;
> +	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
> 	struct dx_entry *entries, *at;
> 	struct buffer_head *bh;
> 	struct super_block *sb =3D dir->i_sb;
> 	struct ext4_dir_entry_2 *de;
> +	int restart;
> 	int err;
>=20
> +again:
> +	restart =3D 0;
> 	frame =3D dx_probe(fname, dir, NULL, frames);
> 	if (IS_ERR(frame))
> 		return PTR_ERR(frame);
> @@ -2213,24 +2230,44 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> 	if (err !=3D -ENOSPC)
> 		goto cleanup;
>=20
> +	err =3D 0;
> 	/* Block full, should compress but for now just split */
> 	dxtrace(printk(KERN_DEBUG "using %u of %u node entries\n",
> 		       dx_get_count(entries), dx_get_limit(entries)));
> 	/* Need to split index? */
> 	if (dx_get_count(entries) =3D=3D dx_get_limit(entries)) {
> 		ext4_lblk_t newblock;
> -		unsigned icount =3D dx_get_count(entries);
> -		int levels =3D frame - frames;
> +		int levels =3D frame - frames + 1;
> +		unsigned int icount;
> +		int add_level =3D 1;
> 		struct dx_entry *entries2;
> 		struct dx_node *node2;
> 		struct buffer_head *bh2;
>=20
> -		if (levels && (dx_get_count(frames->entries) =3D=3D
> -			       dx_get_limit(frames->entries))) {
> -			ext4_warning_inode(dir, "Directory index =
full!");
> +		while (frame > frames) {
> +			if (dx_get_count((frame - 1)->entries) <
> +			    dx_get_limit((frame - 1)->entries)) {
> +				add_level =3D 0;
> +				break;
> +			}
> +			frame--; /* split higher index block */
> +			at =3D frame->at;
> +			entries =3D frame->entries;
> +			restart =3D 1;
> +		}
> +		if (add_level && levels =3D=3D ext4_dir_htree_level(sb)) =
{
> +			ext4_warning(sb, "Directory (ino: %lu) index =
full, "
> +					 "reach max htree level :%d",
> +					 dir->i_ino, levels);
> +			if (ext4_dir_htree_level(sb) < EXT4_HTREE_LEVEL) =
{
> +				ext4_warning(sb, "Large directory =
feature is "
> +						 "not enabled on this "
> +						 "filesystem");
> +			}
> 			err =3D -ENOSPC;
> 			goto cleanup;
> 		}
> +		icount =3D dx_get_count(entries);
> 		bh2 =3D ext4_append(handle, dir, &newblock);
> 		if (IS_ERR(bh2)) {
> 			err =3D PTR_ERR(bh2);
> @@ -2245,7 +2282,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> 		err =3D ext4_journal_get_write_access(handle, =
frame->bh);
> 		if (err)
> 			goto journal_error;
> -		if (levels) {
> +		if (!add_level) {
> 			unsigned icount1 =3D icount/2, icount2 =3D =
icount - icount1;
> 			unsigned hash2 =3D dx_get_hash(entries + =
icount1);
> 			dxtrace(printk(KERN_DEBUG "Split index %i/%i\n",
> @@ -2253,7 +2290,7 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
>=20
> 			BUFFER_TRACE(frame->bh, "get_write_access"); /* =
index root */
> 			err =3D ext4_journal_get_write_access(handle,
> -							     =
frames[0].bh);
> +							     (frame - =
1)->bh);
> 			if (err)
> 				goto journal_error;
>=20
> @@ -2269,17 +2306,23 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> 				frame->entries =3D entries =3D entries2;
> 				swap(frame->bh, bh2);
> 			}
> -			dx_insert_block(frames + 0, hash2, newblock);
> -			dxtrace(dx_show_index("node", =
frames[1].entries));
> +			dx_insert_block((frame - 1), hash2, newblock);
> +			dxtrace(dx_show_index("node", frame->entries));
> 			dxtrace(dx_show_index("node",
> 			       ((struct dx_node *) =
bh2->b_data)->entries));
> 			err =3D ext4_handle_dirty_dx_node(handle, dir, =
bh2);
> 			if (err)
> 				goto journal_error;
> 			brelse (bh2);
> +			ext4_handle_dirty_metadata(handle, dir,
> +						   (frame - 1)->bh);
> +			if (restart) {
> +				ext4_handle_dirty_metadata(handle, dir,
> +							   frame->bh);
> +				goto cleanup;
> +			}
> 		} else {
> -			dxtrace(printk(KERN_DEBUG
> -				       "Creating second level =
index...\n"));
> +			struct dx_root *dxroot;
> 			memcpy((char *) entries2, (char *) entries,
> 			       icount * sizeof(struct dx_entry));
> 			dx_set_limit(entries2, dx_node_limit(dir));
> @@ -2287,19 +2330,17 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> 			/* Set up root */
> 			dx_set_count(entries, 1);
> 			dx_set_block(entries + 0, newblock);
> -			((struct dx_root *) =
frames[0].bh->b_data)->info.indirect_levels =3D 1;
> -
> -			/* Add new access path frame */
> -			frame =3D frames + 1;
> -			frame->at =3D at =3D at - entries + entries2;
> -			frame->entries =3D entries =3D entries2;
> -			frame->bh =3D bh2;
> -			err =3D ext4_journal_get_write_access(handle,
> -							     frame->bh);
> -			if (err)
> -				goto journal_error;
> +			dxroot =3D (struct dx_root =
*)frames[0].bh->b_data;
> +			dxroot->info.indirect_levels +=3D 1;
> +			dxtrace(printk(KERN_DEBUG
> +				       "Creating %d level index...\n",
> +				       info->indirect_levels));
> +			ext4_handle_dirty_metadata(handle, dir, =
frame->bh);
> +			ext4_handle_dirty_metadata(handle, dir, bh2);
> +			brelse(bh2);
> +			restart =3D 1;
> +			goto cleanup;
> 		}
> -		err =3D ext4_handle_dirty_dx_node(handle, dir, =
frames[0].bh);
> 		if (err) {
> 			ext4_std_error(inode->i_sb, err);
> 			goto cleanup;
> @@ -2318,6 +2359,11 @@ static int ext4_dx_add_entry(handle_t *handle, =
struct ext4_filename *fname,
> cleanup:
> 	brelse(bh);
> 	dx_release(frames);
> +	/* @restart is true means htree-path has been changed, we need =
to
> +	 * repeat dx_probe() to find out valid htree-path
> +	 */
> +	if (restart && err =3D=3D 0)
> +		goto again;
> 	return err;
> }
>=20
> @@ -2354,7 +2400,7 @@ int ext4_generic_delete_entry(handle_t *handle,
> 					blocksize);
> 			else
> 				de->inode =3D 0;
> -			dir->i_version++;
> +			inode_inc_iversion(dir);
> 			return 0;
> 		}
> 		i +=3D ext4_rec_len_from_disk(de->rec_len, blocksize);
> --
> 1.8.3.1
>=20


Cheers, Andreas






--Apple-Mail=_9139B15C-689A-4740-B37E-9ED24BEED16A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYywcmpIg59Q01vtYRAnOOAJ9G+nDZbFcxMcDFw5VDsdEDOjyXngCeL17m
Dw7t4LPRaFzsghKTSQn2Ot8=
=is+Y
-----END PGP SIGNATURE-----

--Apple-Mail=_9139B15C-689A-4740-B37E-9ED24BEED16A--
