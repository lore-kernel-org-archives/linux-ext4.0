From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 3/4] e2fsck: 3 level hash tree directory optimization
Date: Thu, 16 Feb 2017 20:57:36 -0700
Message-ID: <C0659690-8625-42C8-ADA2-8505E6E80571@dilger.ca>
References: <33754C3A-4131-4061-86D0-6D58B2550F06@dilger.ca>
 <1487180700-930-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_469E1106-B999-4B79-BE7B-998ABD890205";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33673 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754965AbdBQD5l (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2017 22:57:41 -0500
Received: by mail-it0-f67.google.com with SMTP id e137so839953itc.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2017 19:57:40 -0800 (PST)
In-Reply-To: <1487180700-930-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_469E1106-B999-4B79-BE7B-998ABD890205
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Feb 15, 2017, at 10:45 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> e2fsck fix for partitions with 3 level hash directries.
> Additional level is added to e2fsck -D codepath.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> debugfs/htree.c     |    3 +-
> e2fsck/e2fsck.h     |    1 +
> e2fsck/pass2.c      |   68 ++++++++++++++++++++++--------
> e2fsck/rehash.c     |  115 =
++++++++++++++++++++++++++++++++++++++++-----------
> lib/ext2fs/ext2fs.h |    5 ++
> 5 files changed, 148 insertions(+), 44 deletions(-)
>=20
> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index 54e55e2..8c18666 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -287,7 +287,8 @@ void do_htree_dump(int argc, char *argv[])
> 	fprintf(pager, "\t Indirect levels: %d\n", =
rootnode->indirect_levels);
> 	fprintf(pager, "\t Flags: %d\n", rootnode->unused_flags);
>=20
> -	ent =3D (struct ext2_dx_entry *) (buf + 24 + =
rootnode->info_length);
> +	ent =3D (struct ext2_dx_entry *)
> +		((char *)rootnode + rootnode->info_length);
>=20
> 	htree_dump_int_node(current_fs, ino, &inode, rootnode, ent,
> 			    buf + current_fs->blocksize,
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index f356810..a4efbdf 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -122,6 +122,7 @@ struct dx_dirblock_info {
> 	blk64_t		phys;
> 	int		flags;
> 	blk64_t		parent;
> +	blk64_t		previous;
> 	ext2_dirhash_t	min_hash;
> 	ext2_dirhash_t	max_hash;
> 	ext2_dirhash_t	node_min_hash;
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 2f41fc4..c1c4e48 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -85,6 +85,39 @@ struct check_dir_struct {
> 	unsigned long long next_ra_off;
> };
>=20
> +static void update_parents(struct dx_dir_info *dx_dir, int type)
> +{
> +	struct dx_dirblock_info *dx_db, *dx_parent, *dx_previous;
> +	int b;
> +
> +	for (b =3D 0, dx_db =3D dx_dir->dx_block;
> +	     b < dx_dir->numblocks;
> +	     b++, dx_db++) {
> +		dx_parent =3D &dx_dir->dx_block[dx_db->parent];
> +		if (dx_db->type !=3D type)
> +			continue;
> +
> +		/*
> +		 * XXX Make sure dx_parent->min_hash > dx_db->min_hash
> +		*/
> +		if (dx_db->flags & DX_FLAG_FIRST) {
> +			dx_parent->min_hash =3D dx_db->min_hash;
> +			if (dx_parent->previous) {
> +				dx_previous =3D
> +					=
&dx_dir->dx_block[dx_parent->previous];
> +				dx_previous->node_max_hash =3D
> +					dx_parent->min_hash;
> +			}
> +		}
> +		/*
> +		 * XXX Make sure dx_parent->max_hash < dx_db->max_hash
> +		 */
> +		if (dx_db->flags & DX_FLAG_LAST) {
> +			dx_parent->max_hash =3D dx_db->max_hash;
> +		}
> +	}
> +}
> +
> void e2fsck_pass2(e2fsck_t ctx)
> {
> 	struct ext2_super_block *sb =3D ctx->fs->super;
> @@ -182,24 +215,11 @@ void e2fsck_pass2(e2fsck_t ctx)
> 		 * Find all of the first and last leaf blocks, and
> 		 * update their parent's min and max hash values
> 		 */
> -		for (b=3D0, dx_db =3D dx_dir->dx_block;
> -		     b < dx_dir->numblocks;
> -		     b++, dx_db++) {
> -			if ((dx_db->type !=3D DX_DIRBLOCK_LEAF) ||
> -			    !(dx_db->flags & (DX_FLAG_FIRST | =
DX_FLAG_LAST)))
> -				continue;
> -			dx_parent =3D &dx_dir->dx_block[dx_db->parent];
> -			/*
> -			 * XXX Make sure dx_parent->min_hash > =
dx_db->min_hash
> -			 */
> -			if (dx_db->flags & DX_FLAG_FIRST)
> -				dx_parent->min_hash =3D dx_db->min_hash;
> -			/*
> -			 * XXX Make sure dx_parent->max_hash < =
dx_db->max_hash
> -			 */
> -			if (dx_db->flags & DX_FLAG_LAST)
> -				dx_parent->max_hash =3D dx_db->max_hash;
> -		}
> +		update_parents(dx_dir, DX_DIRBLOCK_LEAF);
> +
> +		/* for 3 level htree: update 2 level parent's min
> +		 * and max hash values */
> +		update_parents(dx_dir, DX_DIRBLOCK_NODE);
>=20
> 		for (b=3D0, dx_db =3D dx_dir->dx_block;
> 		     b < dx_dir->numblocks;
> @@ -642,6 +662,10 @@ static void parse_int_node(ext2_filsys fs,
> 			dx_db->flags |=3D DX_FLAG_REFERENCED;
> 			dx_db->parent =3D db->blockcnt;
> 		}
> +
> +		dx_db->previous =3D
> +			i ? ext2fs_le32_to_cpu(ent[i-1].block & =
0x0ffffff) : 0;
> +
> 		if (hash < min_hash)
> 			min_hash =3D hash;
> 		if (hash > max_hash)
> @@ -949,6 +973,14 @@ static int check_dir_block(ext2_filsys fs,
> 			return DIRENT_ABORT;
> 	}
>=20
> +	/* This will allow (at some point in the future) to punch out =
empty
> +	 * directory blocks and reduce the space used by a directory =
that grows
> +	 * very large and then the files are deleted. For now, all that =
is
> +	 * needed is to avoid e2fsck filling in these holes as part of
> +	 * feature flag. */
> +	if (db->blk =3D=3D 0 && ext2fs_has_feature_largedir(fs))
> +		return 0;
> +
> 	if (db->blk =3D=3D 0 && !inline_data_size) {
> 		if (allocate_dir_block(ctx, db, buf, &cd->pctx))
> 			return 0;
> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 22a58f3..7dcb386 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
> @@ -603,6 +603,43 @@ static struct ext2_dx_entry =
*set_int_node(ext2_filsys fs, char *buf)
> 	return (struct ext2_dx_entry *) limits;
> }
>=20
> +static int alloc_blocks(ext2_filsys fs,
> +			struct ext2_dx_countlimit **limit,
> +			struct ext2_dx_entry **prev_ent,
> +			struct ext2_dx_entry **next_ent,
> +			int *prev_offset, int *next_offset,
> +			struct out_dir *outdir, int i,
> +			int *prev_count, int *next_count)
> +{
> +	errcode_t	retval;
> +	char		*block_start;
> +
> +	if (*limit)
> +		(*limit)->limit =3D (*limit)->count =3D
> +			ext2fs_cpu_to_le16((*limit)->limit);
> +	*prev_ent =3D (struct ext2_dx_entry *) (outdir->buf + =
*prev_offset);
> +	(*prev_ent)->block =3D ext2fs_cpu_to_le32(outdir->num);
> +
> +	if (i !=3D 1)
> +		(*prev_ent)->hash =3D
> +			ext2fs_cpu_to_le32(outdir->hashes[i]);
> +
> +	retval =3D get_next_block(fs, outdir, &block_start);
> +	if (retval)
> +		return retval;
> +
> +	*next_ent =3D set_int_node(fs, block_start);
> +	*limit =3D (struct ext2_dx_countlimit *)(*next_ent);
> +	if (next_offset)
> +		*next_offset =3D ((char *) *next_ent - outdir->buf);
> +
> +	*next_count =3D (*limit)->limit;
> +	(*prev_offset) +=3D sizeof(struct ext2_dx_entry);
> +	(*prev_count)--;
> +
> +	return 0;
> +}
> +
> /*
>  * This function takes the leaf nodes which have been written in
>  * outdir, and populates the root node and any necessary interior =
nodes.
> @@ -612,13 +649,13 @@ static errcode_t calculate_tree(ext2_filsys fs,
> 				ext2_ino_t ino,
> 				ext2_ino_t parent)
> {
> -	struct ext2_dx_root_info  	*root_info;
> -	struct ext2_dx_entry 		*root, *dx_ent =3D 0;
> -	struct ext2_dx_countlimit	*root_limit, *limit;
> +	struct ext2_dx_root_info	*root_info;
> +	struct ext2_dx_entry		*root, *int_ent, *dx_ent =3D 0;
> +	struct ext2_dx_countlimit	*root_limit, *int_limit, *limit;
> 	errcode_t			retval;
> 	char				* block_start;
> -	int				i, c1, c2, nblks;
> -	int				limit_offset, root_offset;
> +	int				i, c1, c2, c3, nblks;
> +	int				limit_offset, int_offset, =
root_offset;
>=20
> 	root_info =3D set_root_node(fs, outdir->buf, ino, parent);
> 	root_offset =3D limit_offset =3D ((char *) root_info - =
outdir->buf) +
> @@ -628,7 +665,7 @@ static errcode_t calculate_tree(ext2_filsys fs,
> 	nblks =3D outdir->num;
>=20
> 	/* Write out the pointer blocks */
> -	if (nblks-1 <=3D c1) {
> +	if (nblks - 1 <=3D c1) {
> 		/* Just write out the root block, and we're done */
> 		root =3D (struct ext2_dx_entry *) (outdir->buf + =
root_offset);
> 		for (i=3D1; i < nblks; i++) {
> @@ -639,31 +676,20 @@ static errcode_t calculate_tree(ext2_filsys fs,
> 			root++;
> 			c1--;
> 		}
> -	} else {
> +	} else if (nblks - 1 <=3D ext2fs_htree_intnode_maxrecs(fs, c1)) =
{
> 		c2 =3D 0;
> -		limit =3D 0;
> +		limit =3D NULL;
> 		root_info->indirect_levels =3D 1;
> 		for (i=3D1; i < nblks; i++) {
> -			if (c1 =3D=3D 0)
> +			if (c2 =3D=3D 0 && c1 =3D=3D 0)
> 				return ENOSPC;
> 			if (c2 =3D=3D 0) {
> -				if (limit)
> -					limit->limit =3D limit->count =3D
> -		ext2fs_cpu_to_le16(limit->limit);
> -				root =3D (struct ext2_dx_entry *)
> -					(outdir->buf + root_offset);
> -				root->block =3D =
ext2fs_cpu_to_le32(outdir->num);
> -				if (i !=3D 1)
> -					root->hash =3D
> -			ext2fs_cpu_to_le32(outdir->hashes[i]);
> -				if ((retval =3D  get_next_block(fs, =
outdir,
> -							      =
&block_start)))
> +				retval =3D alloc_blocks(fs, &limit, =
&root,
> +						      &dx_ent, =
&root_offset,
> +						      NULL, outdir, i, =
&c1,
> +						      &c2);
> +				if (retval)
> 					return retval;
> -				dx_ent =3D set_int_node(fs, =
block_start);
> -				limit =3D (struct ext2_dx_countlimit *) =
dx_ent;
> -				c2 =3D limit->limit;
> -				root_offset +=3D sizeof(struct =
ext2_dx_entry);
> -				c1--;
> 			}
> 			dx_ent->block =3D ext2fs_cpu_to_le32(i);
> 			if (c2 !=3D limit->limit)
> @@ -674,6 +700,45 @@ static errcode_t calculate_tree(ext2_filsys fs,
> 		}
> 		limit->count =3D ext2fs_cpu_to_le16(limit->limit - c2);
> 		limit->limit =3D ext2fs_cpu_to_le16(limit->limit);
> +	} else {
> +		c2 =3D 0;
> +		c3 =3D 0;
> +		limit =3D NULL;
> +		int_limit =3D 0;
> +		root_info->indirect_levels =3D 2;
> +		for (i =3D 1; i < nblks; i++) {
> +			if (c3 =3D=3D 0 && c2 =3D=3D 0 && c1 =3D=3D 0)
> +				return ENOSPC;
> +			if (c3 =3D=3D 0 && c2 =3D=3D 0) {
> +				retval =3D alloc_blocks(fs, &int_limit, =
&root,
> +						      &int_ent, =
&root_offset,
> +						      &int_offset, =
outdir, i,
> +						      &c1, &c2);
> +				if (retval)
> +					return retval;
> +			}
> +			if (c3 =3D=3D 0) {
> +				retval =3D alloc_blocks(fs, &limit, =
&int_ent,
> +						      &dx_ent, =
&int_offset,
> +						      NULL, outdir, i, =
&c2,
> +						      &c3);
> +				if (retval)
> +					return retval;
> +
> +			}
> +			dx_ent->block =3D ext2fs_cpu_to_le32(i);
> +			if (c3 !=3D limit->limit)
> +				dx_ent->hash =3D
> +					=
ext2fs_cpu_to_le32(outdir->hashes[i]);
> +			dx_ent++;
> +			c3--;
> +		}
> +		int_limit->count =3D ext2fs_cpu_to_le16(limit->limit - =
c2);
> +		int_limit->limit =3D ext2fs_cpu_to_le16(limit->limit);
> +
> +		limit->count =3D ext2fs_cpu_to_le16(limit->limit - c3);
> +		limit->limit =3D ext2fs_cpu_to_le16(limit->limit);
> +
> 	}
> 	root_limit =3D (struct ext2_dx_countlimit *) (outdir->buf + =
limit_offset);
> 	root_limit->count =3D ext2fs_cpu_to_le16(root_limit->limit - =
c1);
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index c68be50..baa422c 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1937,6 +1937,11 @@ static inline unsigned int =
ext2_dir_htree_level(ext2_filsys fs)
> 	return EXT4_HTREE_LEVEL_COMPAT;
> }
>=20
> +_INLINE_ int ext2fs_htree_intnode_maxrecs(ext2_filsys fs, int blocks)
> +{
> +	return blocks * ((fs->blocksize - 8) / sizeof(struct =
ext2_dx_entry));
> +}
> +
> /*
>  * This is an efficient, overflow safe way of calculating ceil((1.0 * =
a) / b)
>  */
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_469E1106-B999-4B79-BE7B-998ABD890205
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYpnSwpIg59Q01vtYRAmuwAKCer7L/SRKESxtRKUR1LLsZ75u5nwCffbHv
gzzovzkIFZVaJg75uqWuybc=
=+Af6
-----END PGP SIGNATURE-----

--Apple-Mail=_469E1106-B999-4B79-BE7B-998ABD890205--
