From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: always pre-allocate max depth for path
Date: Thu, 16 Jun 2016 13:36:29 -0600
Message-ID: <C55AC620-92E2-47C6-B138-790B7508B2F5@dilger.ca>
References: <C214BF91-E916-4790-93AD-0849767A9F8E@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_10AC93AF-B17D-4D1C-8971-5A56E22D51B4"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: "Faccini, Bruno" <bruno.faccini@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36341 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbcFPTge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2016 15:36:34 -0400
Received: by mail-it0-f68.google.com with SMTP id h190so8311571ith.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2016 12:36:34 -0700 (PDT)
In-Reply-To: <C214BF91-E916-4790-93AD-0849767A9F8E@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_10AC93AF-B17D-4D1C-8971-5A56E22D51B4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 16, 2016, at 10:53 AM, Faccini, Bruno <bruno.faccini@intel.com> =
wrote:
>=20
> From: Bruno Faccini <bruno.faccini@intel.com>
>=20
> I have first found this way to fix holes in previous ext4 layers =
versions
> where an array of struct ext4_ext_path had been allocated with an =
arbitrary
> evaluated size and finally could overrun upon ext_depth() growth =
outside
> i_data_sem protection. But it seems it can still help with recent ext4
> version, to avoid re-allocation need and overhead when it can be =
allocated
> to max possible extent depth (ie, 5 presently) at first time and for a =
low
> cost regarding its memory foot-print, it should also avoid further =
invalid
> dereference by underlying callers sharing same ppath (with present
> inter-routines path re-use scheme), and also upon re-allocation error.
>=20
> Signed-off-by: Bruno Faccini <bruno.faccini@intel.com>
> ---
> fs/ext4/ext4.h        |    3 +
> fs/ext4/extents.c     |  113 ++++++++++++++++++++++++++--------------
> fs/ext4/move_extent.c |   10 +--
> fs/ext4/super.c       |    3 -
> 4 files changed, 85 insertions(+), 44 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1e20fa9..73d5866 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1340,6 +1340,9 @@ struct ext4_sb_info {
> 	unsigned long s_ext_extents;
> #endif
>=20
> +	/* maximum possible extents tree depth, to be computed at mount =
time */
> +	unsigned int s_max_ext_tree_depth;
> +
> 	/* for buddy allocator */
> 	struct ext4_group_info ***s_group_info;
> 	struct inode *s_buddy_cache;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b52fea3..aee676d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -871,19 +871,18 @@ ext4_find_extent(struct inode *inode, =
ext4_lblk_t block,
>=20
> 	if (path) {
> 		ext4_ext_drop_refs(path);
> -		if (depth > path[0].p_maxdepth) {
> -			kfree(path);
> -			*orig_path =3D path =3D NULL;
> -		}
> -	}
> -	if (!path) {
> +		/* path has been allocated for the max possible depth
> +		 * so we can simply reuse it */
> +		/* XXX need to clear/zero old path content? */
> +	} else {
> 		/* account possible depth increase */
> -		path =3D kzalloc(sizeof(struct ext4_ext_path) * (depth + =
2),
> +		path =3D kzalloc(sizeof(struct ext4_ext_path) *
> +				=
EXT4_SB(inode->i_sb)->s_max_ext_tree_depth,
> 				GFP_NOFS);
> 		if (unlikely(!path))
> 			return ERR_PTR(-ENOMEM);
> -		path[0].p_maxdepth =3D depth + 1;
> 	}
> +	path[0].p_maxdepth =3D depth + 1;
> 	path[0].p_hdr =3D eh;
> 	path[0].p_bh =3D NULL;
>=20
> @@ -934,9 +933,11 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t =
block,
>=20
> err:
> 	ext4_ext_drop_refs(path);
> -	kfree(path);
> -	if (orig_path)
> -		*orig_path =3D NULL;
> +
> +	/* do not free *orig_path, it is likely to be referenced by =
callers */
> +	if (!orig_path)
> +		kfree(path);
> +
> 	return ERR_PTR(ret);
> }
>=20
> @@ -2147,7 +2148,8 @@ static int ext4_fill_fiemap_extents(struct inode =
*inode,
> 				    ext4_lblk_t block, ext4_lblk_t num,
> 				    struct fiemap_extent_info *fieinfo)
> {
> -	struct ext4_ext_path *path =3D NULL;
> +	struct ext4_ext_path *path =3D NULL, *orig_path =3D NULL;
> +	struct ext4_ext_path **orig_ppath =3D &orig_path;
> 	struct ext4_extent *ex;
> 	struct extent_status es;
> 	ext4_lblk_t next, next_del, start =3D 0, end =3D 0;
> @@ -2161,13 +2163,16 @@ static int ext4_fill_fiemap_extents(struct =
inode *inode,
> 		/* find extent for this block */
> 		down_read(&EXT4_I(inode)->i_data_sem);
>=20
> -		path =3D ext4_find_extent(inode, block, &path, 0);
> +		path =3D ext4_find_extent(inode, block, orig_ppath, 0);
> 		if (IS_ERR(path)) {
> 			up_read(&EXT4_I(inode)->i_data_sem);
> 			err =3D PTR_ERR(path);
> 			path =3D NULL;
> 			break;
> 		}
> +		if (!orig_path)
> +			orig_path =3D path;
> +		/* XXX else BUG_ON(path !=3D orig_path); */
>=20
> 		depth =3D ext_depth(inode);
> 		if (unlikely(path[depth].p_hdr =3D=3D NULL)) {
> @@ -2287,8 +2292,8 @@ static int ext4_fill_fiemap_extents(struct inode =
*inode,
> 		block =3D es.es_lblk + es.es_len;
> 	}
>=20
> -	ext4_ext_drop_refs(path);
> -	kfree(path);
> +	ext4_ext_drop_refs(orig_path);
> +	kfree(orig_path);
> 	return err;
> }
>=20
> @@ -2910,7 +2915,8 @@ again:
> 			path[k].p_block =3D
> 				=
le16_to_cpu(path[k].p_hdr->eh_entries)+1;
> 	} else {
> -		path =3D kzalloc(sizeof(struct ext4_ext_path) * (depth + =
1),
> +		path =3D kzalloc(sizeof(struct ext4_ext_path) *
> +			       =
EXT4_SB(inode->i_sb)->s_max_ext_tree_depth,
> 			       GFP_NOFS);
> 		if (path =3D=3D NULL) {
> 			ext4_journal_stop(handle);
> @@ -3051,13 +3057,14 @@ out:
>  */
> void ext4_ext_init(struct super_block *sb)
> {
> +	ext4_fsblk_t maxblocks;
> +
> 	/*
> 	 * possible initialization would be here
> 	 */
>=20
> 	if (ext4_has_feature_extents(sb)) {
> -#if defined(AGGRESSIVE_TEST) || defined(CHECK_BINSEARCH) || =
defined(EXTENTS_STATS)

This debugging info shouldn't be printed for every mount.  This should =
be
kept under the original #ifdef:

#if defined(AGGRESSIVE_TEST) || defined(CHECK_BINSEARCH) || \
    defined(EXTENTS_STATS) || defined(EXT_DEBUG)


> -		printk(KERN_INFO "EXT4-fs: file extents enabled"
> +		printk(KERN_INFO "EXT4-fs (%s): file extents enabled"
> #ifdef AGGRESSIVE_TEST
> 		       ", aggressive tests"
> #endif
> @@ -3067,8 +3074,36 @@ void ext4_ext_init(struct super_block *sb)
> #ifdef EXTENTS_STATS
> 		       ", stats"
> #endif
> -		       "\n");
> +		       , sb->s_id);
> +
> +
> +		EXT4_SB(sb)->s_max_ext_tree_depth =3D 1;
> +
> +		maxblocks =3D sb->s_maxbytes / sb->s_blocksize;

To avoid the 64-bit divide on 32-bit platforms this can be:

		maxblocks =3D sb->s_maxbytes >> sb->s_blocksize_bits;

> +		/* 1st/root level/node of extents tree stands in i_data =
and
> +		 * entries stored in tree nodes can be of type =
ext4_extent
> +		 * (leaf node) or ext4_extent_idx (internal node) */
> +		maxblocks /=3D (sizeof(((struct ext4_inode_info =
*)0x0)->i_data) -
> +			      sizeof(struct ext4_extent_header)) /
> +			     max(sizeof(struct ext4_extent),
> +				 sizeof(struct ext4_extent_idx));
> +		/* compute maximum extents tree depth for a fully =
populated
> +		 * file of max size made of only minimal/1-block extents =
*/
> +		while (maxblocks > 0) {
> +			maxblocks /=3D (sb->s_blocksize -
> +				      sizeof(struct ext4_extent_header)) =
/
> +				     max(sizeof(struct ext4_extent),
> +					 sizeof(struct =
ext4_extent_idx));

These need to be changed to avoid a 64-bit divide, and possibly =
simplified:

		unsigned ext_size =3D max(sizeof(struct ext4_extent),
					sizeof(struct ext4_extent_idx));
		unsigned ext_per_leaf =3D (sb->s_blocksize -
					 sizeof(struct =
ext4_extent_header)) /
					ext_size);

		do_div(maxblocks,
                       (sizeof(((struct ext4_inode_info *)NULL)->i_data) =
-
			sizeof(struct ext4_extent_header)) / ext_size);

		while (maxblocks > 0) {
			do_div(maxblocks, ext_per_leaf);
			EXT4_SB(sb)->s_max_ext_tree_depth++;
		}

> +#ifdef EXT_DEBUG
> +		printk(", maximum tree depth=3D%u",
> +		       EXT4_SB(sb)->s_max_ext_tree_depth);
> #endif
> +		printk("\n");

It isn't great to "continue" printk() statements, since they can get =
mixed
up if there are multiple messages being printed to the console at once.
Better to calculate the s_max_ext_tree_depth first, then print out the
debugging info in a single printk() call.  Alternately, just make this a
completely separate printk() under EXT_DEBUG instead of trying to =
continue
the previous one.

Cheers, Andreas

> #ifdef EXTENTS_STATS
> 		spin_lock_init(&EXT4_SB(sb)->s_ext_stats_lock);
> 		EXT4_SB(sb)->s_ext_min =3D 1 << 30;
> @@ -5348,18 +5383,18 @@ ext4_ext_shift_extents(struct inode *inode, =
handle_t *handle,
> 		       ext4_lblk_t start, ext4_lblk_t shift,
> 		       enum SHIFT_DIRECTION SHIFT)
> {
> -	struct ext4_ext_path *path;
> +	struct ext4_ext_path *path, *orig_path;
> 	int ret =3D 0, depth;
> 	struct ext4_extent *extent;
> 	ext4_lblk_t stop, *iterator, ex_start, ex_end;
>=20
> 	/* Let path point to the last extent */
> -	path =3D ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
> -	if (IS_ERR(path))
> -		return PTR_ERR(path);
> +	orig_path =3D ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, =
0);
> +	if (IS_ERR(orig_path))
> +		return PTR_ERR(orig_path);
>=20
> -	depth =3D path->p_depth;
> -	extent =3D path[depth].p_ext;
> +	depth =3D orig_path->p_depth;
> +	extent =3D orig_path[depth].p_ext;
> 	if (!extent)
> 		goto out;
>=20
> @@ -5371,9 +5406,11 @@ ext4_ext_shift_extents(struct inode *inode, =
handle_t *handle,
> 	 * sure the hole is big enough to accommodate the shift.
> 	*/
> 	if (SHIFT =3D=3D SHIFT_LEFT) {
> -		path =3D ext4_find_extent(inode, start - 1, &path, 0);
> -		if (IS_ERR(path))
> -			return PTR_ERR(path);
> +		path =3D ext4_find_extent(inode, start - 1, &orig_path, =
0);
> +		if (IS_ERR(path)) {
> +			ret =3D PTR_ERR(path);
> +			goto out;
> +		}
> 		depth =3D path->p_depth;
> 		extent =3D  path[depth].p_ext;
> 		if (extent) {
> @@ -5387,9 +5424,8 @@ ext4_ext_shift_extents(struct inode *inode, =
handle_t *handle,
>=20
> 		if ((start =3D=3D ex_start && shift > ex_start) ||
> 		    (shift > start - ex_end)) {
> -			ext4_ext_drop_refs(path);
> -			kfree(path);
> -			return -EINVAL;
> +			ret =3D -EINVAL;
> +			goto out;
> 		}
> 	}
>=20
> @@ -5405,15 +5441,18 @@ ext4_ext_shift_extents(struct inode *inode, =
handle_t *handle,
>=20
> 	/* Its safe to start updating extents */
> 	while (start < stop) {
> -		path =3D ext4_find_extent(inode, *iterator, &path, 0);
> -		if (IS_ERR(path))
> -			return PTR_ERR(path);
> +		path =3D ext4_find_extent(inode, *iterator, &orig_path, =
0);
> +		if (IS_ERR(path)) {
> +			ret =3D PTR_ERR(path);
> +			goto out;
> +		}
> 		depth =3D path->p_depth;
> 		extent =3D path[depth].p_ext;
> 		if (!extent) {
> 			EXT4_ERROR_INODE(inode, "unexpected hole at =
%lu",
> 					 (unsigned long) *iterator);
> -			return -EFSCORRUPTED;
> +			ret =3D  -EFSCORRUPTED;
> +			goto out;
> 		}
> 		if (SHIFT =3D=3D SHIFT_LEFT && *iterator >
> 		    le32_to_cpu(extent->ee_block)) {
> @@ -5445,8 +5484,8 @@ ext4_ext_shift_extents(struct inode *inode, =
handle_t *handle,
> 			break;
> 	}
> out:
> -	ext4_ext_drop_refs(path);
> -	kfree(path);
> +	ext4_ext_drop_refs(orig_path);
> +	kfree(orig_path);
> 	return ret;
> }
>=20
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index fb6f117..7c319c5 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -39,13 +39,11 @@ get_ext_path(struct inode *inode, ext4_lblk_t =
lblock,
> 	path =3D ext4_find_extent(inode, lblock, ppath, =
EXT4_EX_NOCACHE);
> 	if (IS_ERR(path))
> 		return PTR_ERR(path);
> -	if (path[ext_depth(inode)].p_ext =3D=3D NULL) {
> -		ext4_ext_drop_refs(path);
> -		kfree(path);
> -		*ppath =3D NULL;
> +	if (path[ext_depth(inode)].p_ext =3D=3D NULL)
> 		return -ENODATA;
> -	}
> -	*ppath =3D path;
> +	if (*ppath =3D=3D NULL)
> +		*ppath =3D path;
> +	/* XXX else BUG_ON(path !=3D *ppath); */
> 	return 0;
> }
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 486e869..199157a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3701,6 +3701,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		if (ext4_multi_mount_protect(sb, =
le64_to_cpu(es->s_mmp_block)))
> 			goto failed_mount3a;
>=20
> +	ext4_ext_init(sb); /* needed before using extent-mapped journal =
*/
> +
> 	/*
> 	 * The first inode we look at is the journal inode.  Don't try
> 	 * root first: it may be modified in the journal!
> @@ -3894,7 +3896,6 @@ no_journal:
> 		goto failed_mount4a;
> 	}
>=20
> -	ext4_ext_init(sb);
> 	err =3D ext4_mb_init(sb);
> 	if (err) {
> 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc =
(%d)",
> --


Cheers, Andreas






--Apple-Mail=_10AC93AF-B17D-4D1C-8971-5A56E22D51B4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV2L/vXKl2rkXzB/gAQgi7g/9Fk81ya5tBx194aKgyg1UyJlzVaOlGWyr
fOEy5dwkkakUFKVq2H4ejJ4s8U98soR8YDv9d4PaLwI4RMfCZA5QN0VgANoJeBZQ
J15HM8QWAutvOtOoCJ5C/Yh0M+gEIku0l4eNgUqGRYaxrRF4IZS6qb1dGNuTPYSe
J173gqCcB2jOPdSJU/VdyjDl0n4Dgo/Th/xGcmtMj/clHde7glBCDmyIoDYiIbyM
skzTImQN6mhhLJkZN2YoyB/lwPstvgybJgdRUdfkC0vNeboc1MmNvED1Pzo3BDQZ
Ctr8BHSLLcfLv4CjxThBND7vJxs9eNnA5GBq6cEugzGSoAf6fX7xxLCDXkuu9wr4
hQcz2cU59Jf3Ex0IsysGZiAkJGqdjv+CbKfcW6yYKSO25dnsHni0vSao//Ox8GNv
WW0wTUg9wA3iAwydQS3xcX785fYvTeyHpM6TG0xSzHTOF9IjIXmA8HriO5v95SZw
VNeHUYd7r/Zd12JysDm37pc+QqP3Yl69eZ+xS0JU+zu9ufptKdkZOf04/+Bjlb45
UjiO4NJY0DJyo2gB6m9pxBAjvLej8bACrsIQqlhP1VmrDED5q/cbIdCHf/dCR93Z
WfWkOzIJ3lPcV8KUoHISttFHNtqRaZ8TH3wO2XAo0ck7sQkzIz2X3F4PjoqPci/D
Tz5W+EzwhVc=
=J0UE
-----END PGP SIGNATURE-----

--Apple-Mail=_10AC93AF-B17D-4D1C-8971-5A56E22D51B4--
