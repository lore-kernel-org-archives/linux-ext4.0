From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 06/12] e2fsck: update i_blocks accounting for ea_inode
 feature
Date: Mon, 26 Jun 2017 15:36:15 -0600
Message-ID: <866E2967-833B-4CC9-A990-835F5DB291B6@dilger.ca>
References: <20170626134348.1240-1-tahsin@google.com>
 <20170626134348.1240-6-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_661F1AF8-6F99-41D5-97E1-F26A67DCB895";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33103 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdFZVgU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 17:36:20 -0400
Received: by mail-it0-f66.google.com with SMTP id x12so1248000itb.0
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 14:36:20 -0700 (PDT)
In-Reply-To: <20170626134348.1240-6-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_661F1AF8-6F99-41D5-97E1-F26A67DCB895
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 26, 2017, at 7:43 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> With ea_inode feature, i_blocks include the disk space used by
> referenced xattr inodes. Make e2fsck aware of that.

This makes it all the more important that the "fast symlink" checking be
divorced from i_blocks, and instead depend on i_size.  Otherwise, we =
will
have yet another bunch of problems as large xattrs on a fast symlink =
will
incorrectly result in problems with the symlink.

This was most recently discussed in the thread:
[PATCH] libext2fs: correctly subtract xattr blocks on bigalloc =
filesystems
https://www.spinics.net/lists/linux-ext4/msg56601.html

All indications are that using i_size to distinguish fast symlinks is =
safe,
while using i_blocks has repeatedly caused breakage as new blocks are
allocated to the inode.

Cheers, Andreas

> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> e2fsck/e2fsck.c |   4 ++
> e2fsck/e2fsck.h |   5 +++
> e2fsck/pass1.c  | 124 =
+++++++++++++++++++++++++++++++++++++++++---------------
> 3 files changed, 100 insertions(+), 33 deletions(-)
>=20
> diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
> index 0f9da46a5a12..e0f449ee2047 100644
> --- a/e2fsck/e2fsck.c
> +++ b/e2fsck/e2fsck.c
> @@ -98,6 +98,10 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
> 		ea_refcount_free(ctx->refcount_extra);
> 		ctx->refcount_extra =3D 0;
> 	}
> +	if (ctx->ea_block_quota) {
> +		ea_refcount_free(ctx->ea_block_quota);
> +		ctx->ea_block_quota =3D 0;
> +	}
> 	if (ctx->block_dup_map) {
> 		ext2fs_free_block_bitmap(ctx->block_dup_map);
> 		ctx->block_dup_map =3D 0;
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index f9285d01978c..79eeda9fbafb 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -269,6 +269,11 @@ struct e2fsck_struct {
> 	ext2_refcount_t	refcount;
> 	ext2_refcount_t refcount_extra;
>=20
> +	/*
> +	 * Quota blocks to be charged for each ea block.
> +	 */
> +	ext2_refcount_t ea_block_quota;
> +
> 	/*
> 	 * Array of flags indicating whether an inode bitmap, block
> 	 * bitmap, or inode table is invalid
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 9ee2c5e89a61..cc88a7d05cef 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -66,7 +66,7 @@ static int process_bad_block(ext2_filsys fs, blk64_t =
*block_nr,
> 			     e2_blkcnt_t blockcnt, blk64_t ref_blk,
> 			     int ref_offset, void *priv_data);
> static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
> -			 char *block_buf);
> +			 char *block_buf, blk64_t =
ea_ibody_quota_blocks);
> static void mark_table_blocks(e2fsck_t ctx);
> static void alloc_bb_map(e2fsck_t ctx);
> static void alloc_imagic_map(e2fsck_t ctx);
> @@ -103,6 +103,7 @@ struct process_block_struct {
>=20
> struct process_inode_block {
> 	ext2_ino_t ino;
> +	blk64_t ea_ibody_quota_blocks;
> 	struct ext2_inode_large inode;
> };
>=20
> @@ -351,13 +352,25 @@ static void mark_inode_ea_map(e2fsck_t ctx, =
struct problem_context *pctx,
> 	ext2fs_mark_inode_bitmap2(ctx->inode_ea_map, ino);
> }
>=20
> +/*
> + * For a given size, calculate how many blocks would be charged =
towards quota.
> + */
> +static blk64_t size_to_quota_blocks(ext2_filsys fs, size_t size)
> +{
> +	blk64_t clusters;
> +
> +	clusters =3D DIV_ROUND_UP(size, fs->blocksize << =
fs->cluster_ratio_bits);
> +	return EXT2FS_C2B(fs, clusters);
> +}
> +
> /*
>  * Check validity of EA inode. Return 0 if EA inode is valid, =
otherwise return
>  * the problem code.
>  */
> static problem_t check_large_ea_inode(e2fsck_t ctx,
> 				      struct ext2_ext_attr_entry *entry,
> -				      struct problem_context *pctx)
> +				      struct problem_context *pctx,
> +				      blk64_t *quota_blocks)
> {
> 	struct ext2_inode inode;
> 	__u32 hash;
> @@ -380,11 +393,15 @@ static problem_t check_large_ea_inode(e2fsck_t =
ctx,
> 		fatal_error(ctx, 0);
> 	}
>=20
> -	if (hash !=3D entry->e_hash) {
> +	if (hash =3D=3D entry->e_hash) {
> +		*quota_blocks =3D size_to_quota_blocks(ctx->fs,
> +						     =
entry->e_value_size);
> +	} else {
> 		/* This might be an old Lustre-style ea_inode reference. =
*/
> -		if (inode.i_mtime !=3D pctx->ino ||
> -		    inode.i_generation !=3D pctx->inode->i_generation) {
> -
> +		if (inode.i_mtime =3D=3D pctx->ino &&
> +		    inode.i_generation =3D=3D pctx->inode->i_generation) =
{
> +			*quota_blocks =3D 0;
> +		} else {
> 			/* If target inode is also missing EA_INODE =
flag,
> 			 * this is likely to be a bad reference.
> 			 */
> @@ -411,7 +428,8 @@ static problem_t check_large_ea_inode(e2fsck_t =
ctx,
> 	return 0;
> }
>=20
> -static void check_ea_in_inode(e2fsck_t ctx, struct problem_context =
*pctx)
> +static void check_ea_in_inode(e2fsck_t ctx, struct problem_context =
*pctx,
> +			      blk64_t *ea_ibody_quota_blocks)
> {
> 	struct ext2_super_block *sb =3D ctx->fs->super;
> 	struct ext2_inode_large *inode;
> @@ -420,6 +438,9 @@ static void check_ea_in_inode(e2fsck_t ctx, struct =
problem_context *pctx)
> 	unsigned int storage_size, remain;
> 	problem_t problem =3D 0;
> 	region_t region =3D 0;
> +	blk64_t quota_blocks =3D 0;
> +
> +	*ea_ibody_quota_blocks =3D 0;
>=20
> 	inode =3D (struct ext2_inode_large *) pctx->inode;
> 	storage_size =3D EXT2_INODE_SIZE(ctx->fs->super) - =
EXT2_GOOD_OLD_INODE_SIZE -
> @@ -496,11 +517,15 @@ static void check_ea_in_inode(e2fsck_t ctx, =
struct problem_context *pctx)
> 				goto fix;
> 			}
> 		} else {
> -			problem =3D check_large_ea_inode(ctx, entry, =
pctx);
> +			blk64_t entry_quota_blocks;
> +
> +			problem =3D check_large_ea_inode(ctx, entry, =
pctx,
> +						       =
&entry_quota_blocks);
> 			if (problem !=3D 0)
> 				goto fix;
>=20
> 			mark_inode_ea_map(ctx, pctx, =
entry->e_value_inum);
> +			quota_blocks +=3D entry_quota_blocks;
> 		}
>=20
> 		/* If EA value is stored in external inode then it does =
not
> @@ -523,8 +548,10 @@ fix:
> 	 * it seems like a corruption. it's very unlikely we could =
repair
> 	 * EA(s) in automatic fashion -bzzz
> 	 */
> -	if (problem =3D=3D 0 || !fix_problem(ctx, problem, pctx))
> +	if (problem =3D=3D 0 || !fix_problem(ctx, problem, pctx)) {
> +		*ea_ibody_quota_blocks =3D quota_blocks;
> 		return;
> +	}
>=20
> 	/* simply remove all possible EA(s) */
> 	*((__u32 *)header) =3D 0UL;
> @@ -547,13 +574,16 @@ static int =
check_inode_extra_negative_epoch(__u32 xtime, __u32 extra) {
>  */
> #define EXT4_EXTRA_NEGATIVE_DATE_CUTOFF 2 * (1LL << 32)
>=20
> -static void check_inode_extra_space(e2fsck_t ctx, struct =
problem_context *pctx)
> +static void check_inode_extra_space(e2fsck_t ctx, struct =
problem_context *pctx,
> +				    blk64_t *ea_ibody_quota_blocks)
> {
> 	struct ext2_super_block *sb =3D ctx->fs->super;
> 	struct ext2_inode_large *inode;
> 	__u32 *eamagic;
> 	int min, max;
>=20
> +	*ea_ibody_quota_blocks =3D 0;
> +
> 	inode =3D (struct ext2_inode_large *) pctx->inode;
> 	if (EXT2_INODE_SIZE(sb) =3D=3D EXT2_GOOD_OLD_INODE_SIZE) {
> 		/* this isn't large inode. so, nothing to check */
> @@ -592,7 +622,7 @@ static void check_inode_extra_space(e2fsck_t ctx, =
struct problem_context *pctx)
> 			inode->i_extra_isize);
> 	if (*eamagic =3D=3D EXT2_EXT_ATTR_MAGIC) {
> 		/* it seems inode has an extended attribute(s) in body =
*/
> -		check_ea_in_inode(ctx, pctx);
> +		check_ea_in_inode(ctx, pctx, ea_ibody_quota_blocks);
> 	}
>=20
> 	/*
> @@ -1150,6 +1180,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 	int		failed_csum =3D 0;
> 	ext2_ino_t	ino_threshold =3D 0;
> 	dgrp_t		ra_group =3D 0;
> +	blk64_t		ea_ibody_quota_blocks;
>=20
> 	init_resource_track(&rtrack, ctx->fs->io);
> 	clear_problem_context(&pctx);
> @@ -1695,7 +1726,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 							   "pass1");
> 					failed_csum =3D 0;
> 				}
> -				check_blocks(ctx, &pctx, block_buf);
> +				check_blocks(ctx, &pctx, block_buf, 0);
> 				FINISH_INODE_LOOP(ctx, ino, &pctx, =
failed_csum);
> 				continue;
> 			}
> @@ -1722,7 +1753,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 							"pass1");
> 					failed_csum =3D 0;
> 				}
> -				check_blocks(ctx, &pctx, block_buf);
> +				check_blocks(ctx, &pctx, block_buf, 0);
> 				FINISH_INODE_LOOP(ctx, ino, &pctx, =
failed_csum);
> 				continue;
> 			}
> @@ -1760,7 +1791,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 					failed_csum =3D 0;
> 				}
> 			}
> -			check_blocks(ctx, &pctx, block_buf);
> +			check_blocks(ctx, &pctx, block_buf, 0);
> 			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
> 			continue;
> 		}
> @@ -1825,7 +1856,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 			}
> 		}
>=20
> -		check_inode_extra_space(ctx, &pctx);
> +		check_inode_extra_space(ctx, &pctx, =
&ea_ibody_quota_blocks);
> 		check_is_really_dir(ctx, &pctx, block_buf);
>=20
> 		/*
> @@ -1872,7 +1903,8 @@ void e2fsck_pass1(e2fsck_t ctx)
> 				continue;
> 			} else if (ext2fs_inode_data_blocks(fs, inode) =
=3D=3D 0) {
> 				ctx->fs_fast_symlinks_count++;
> -				check_blocks(ctx, &pctx, block_buf);
> +				check_blocks(ctx, &pctx, block_buf,
> +					     ea_ibody_quota_blocks);
> 				FINISH_INODE_LOOP(ctx, ino, &pctx, =
failed_csum);
> 				continue;
> 			}
> @@ -1906,17 +1938,19 @@ void e2fsck_pass1(e2fsck_t ctx)
> 		     inode->i_block[EXT2_DIND_BLOCK] ||
> 		     inode->i_block[EXT2_TIND_BLOCK] ||
> 		     ext2fs_file_acl_block(fs, inode))) {
> -			struct ext2_inode_large *ip;
> +			struct process_inode_block *itp;
>=20
> -			inodes_to_process[process_inode_count].ino =3D =
ino;
> -			ip =3D =
&inodes_to_process[process_inode_count].inode;
> +			itp =3D &inodes_to_process[process_inode_count];
> +			itp->ino =3D ino;
> +			itp->ea_ibody_quota_blocks =3D =
ea_ibody_quota_blocks;
> 			if (inode_size < sizeof(struct =
ext2_inode_large))
> -				memcpy(ip, inode, inode_size);
> +				memcpy(&itp->inode, inode, inode_size);
> 			else
> -				memcpy(ip, inode, sizeof(*ip));
> +				memcpy(&itp->inode, inode, =
sizeof(itp->inode));
> 			process_inode_count++;
> 		} else
> -			check_blocks(ctx, &pctx, block_buf);
> +			check_blocks(ctx, &pctx, block_buf,
> +				     ea_ibody_quota_blocks);
>=20
> 		FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
>=20
> @@ -2086,7 +2120,8 @@ static void process_inodes(e2fsck_t ctx, char =
*block_buf)
> 		sprintf(buf, _("reading indirect blocks of inode %u"),
> 			pctx.ino);
> 		ehandler_operation(buf);
> -		check_blocks(ctx, &pctx, block_buf);
> +		check_blocks(ctx, &pctx, block_buf,
> +			     =
inodes_to_process[i].ea_ibody_quota_blocks);
> 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
> 			break;
> 	}
> @@ -2306,7 +2341,7 @@ static void adjust_extattr_refcount(e2fsck_t =
ctx, ext2_refcount_t refcount,
>  * Handle processing the extended attribute blocks
>  */
> static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
> -			   char *block_buf)
> +			   char *block_buf, blk64_t =
*ea_block_quota_blocks)
> {
> 	ext2_filsys fs =3D ctx->fs;
> 	ext2_ino_t	ino =3D pctx->ino;
> @@ -2315,7 +2350,7 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
> 	char *		end;
> 	struct ext2_ext_attr_header *header;
> 	struct ext2_ext_attr_entry *entry;
> -	int		count;
> +	blk64_t		quota_blocks =3D EXT2FS_C2B(fs, 1);
> 	region_t	region =3D 0;
> 	int		failed_csum =3D 0;
>=20
> @@ -2369,6 +2404,12 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
>=20
> 	/* Have we seen this EA block before? */
> 	if (ext2fs_fast_test_block_bitmap2(ctx->block_ea_map, blk)) {
> +		if (ctx->ea_block_quota)
> +			ea_refcount_fetch(ctx->ea_block_quota, blk,
> +					  ea_block_quota_blocks);
> +		else
> +			*ea_block_quota_blocks =3D 0;
> +
> 		if (ea_refcount_decrement(ctx->refcount, blk, 0) =3D=3D =
0)
> 			return 1;
> 		/* Ooops, this EA was referenced more than it stated */
> @@ -2477,13 +2518,17 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
> 			}
> 		} else {
> 			problem_t problem;
> +			blk64_t entry_quota_blocks;
>=20
> -			problem =3D check_large_ea_inode(ctx, entry, =
pctx);
> +			problem =3D check_large_ea_inode(ctx, entry, =
pctx,
> +						       =
&entry_quota_blocks);
> 			if (problem =3D=3D 0)
> 				mark_inode_ea_map(ctx, pctx,
> 						  entry->e_value_inum);
> 			else if (fix_problem(ctx, problem, pctx))
> 				goto clear_extattr;
> +
> +			quota_blocks +=3D entry_quota_blocks;
> 		}
>=20
> 		entry =3D EXT2_EXT_ATTR_NEXT(entry);
> @@ -2506,9 +2551,21 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
> 			return 0;
> 	}
>=20
> -	count =3D header->h_refcount - 1;
> -	if (count)
> -		ea_refcount_store(ctx->refcount, blk, count);
> +	*ea_block_quota_blocks =3D quota_blocks;
> +	if (quota_blocks) {
> +		if (!ctx->ea_block_quota) {
> +			pctx->errcode =3D ea_refcount_create(0,
> +							=
&ctx->ea_block_quota);
> +			if (pctx->errcode) {
> +				pctx->num =3D 3;
> +				fix_problem(ctx, PR_1_ALLOCATE_REFCOUNT, =
pctx);
> +				ctx->flags |=3D E2F_FLAG_ABORT;
> +				return 0;
> +			}
> +		}
> +		ea_refcount_store(ctx->ea_block_quota, blk, =
quota_blocks);
> +	}
> +	ea_refcount_store(ctx->refcount, blk, header->h_refcount - 1);
> 	mark_block_used(ctx, blk);
> 	ext2fs_fast_mark_block_bitmap2(ctx->block_ea_map, blk);
> 	return 1;
> @@ -3162,7 +3219,7 @@ err:
>  * blocks used by that inode.
>  */
> static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
> -			 char *block_buf)
> +			 char *block_buf, blk64_t ea_ibody_quota_blocks)
> {
> 	ext2_filsys fs =3D ctx->fs;
> 	struct process_block_struct pb;
> @@ -3173,9 +3230,10 @@ static void check_blocks(e2fsck_t ctx, struct =
problem_context *pctx,
> 	int		extent_fs;
> 	int		inlinedata_fs;
> 	__u64		size;
> +	blk64_t		ea_block_quota_blocks =3D 0;
>=20
> 	pb.ino =3D ino;
> -	pb.num_blocks =3D 0;
> +	pb.num_blocks =3D EXT2FS_B2C(ctx->fs, ea_ibody_quota_blocks);
> 	pb.last_block =3D ~0;
> 	pb.last_init_lblock =3D -1;
> 	pb.last_db_block =3D -1;
> @@ -3198,10 +3256,10 @@ static void check_blocks(e2fsck_t ctx, struct =
problem_context *pctx,
> 	extent_fs =3D ext2fs_has_feature_extents(ctx->fs->super);
> 	inlinedata_fs =3D =
ext2fs_has_feature_inline_data(ctx->fs->super);
>=20
> -	if (check_ext_attr(ctx, pctx, block_buf)) {
> +	if (check_ext_attr(ctx, pctx, block_buf, =
&ea_block_quota_blocks)) {
> 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
> 			goto out;
> -		pb.num_blocks++;
> +		pb.num_blocks +=3D EXT2FS_B2C(ctx->fs, =
ea_block_quota_blocks);
> 	}
>=20
> 	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
> --
> 2.13.1.611.g7e3b11ae1-goog
>=20


Cheers, Andreas






--Apple-Mail=_661F1AF8-6F99-41D5-97E1-F26A67DCB895
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZUX5PpIg59Q01vtYRAhxUAJ0ZvzwMWxhVTz+zPQihWHl767tqcQCeMZwo
0kR5qxpRXexA4KB8IVNb91M=
=JBKR
-----END PGP SIGNATURE-----

--Apple-Mail=_661F1AF8-6F99-41D5-97E1-F26A67DCB895--
