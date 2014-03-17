From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 36/49] libext2fs: allow clients to read-ahead metadata
Date: Mon, 17 Mar 2014 17:11:09 -0600
Message-ID: <609A6301-38DD-4794-B707-A4E5A7A84B5F@dilger.ca>
References: <20140311065356.30585.47192.stgit@birch.djwong.org> <20140311065750.30585.71404.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_72EBF968-282B-4164-9892-1F0308B67038"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39206 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaCQXMR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2014 19:12:17 -0400
Received: by mail-pd0-f180.google.com with SMTP id v10so6221582pde.39
        for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2014 16:12:17 -0700 (PDT)
In-Reply-To: <20140311065750.30585.71404.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_72EBF968-282B-4164-9892-1F0308B67038
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Mar 11, 2014, at 12:57 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> This patch adds to libext2fs the ability to pre-fetch metadata
> into the page cache in the hopes of speeding up libext2fs' clients.
> There are two new library functions -- the first allows a client to
> readahead a list of blocks, and the second is a helper function that
> uses that first mechanism to load group data (bitmaps, inode tables).
>=20
> e2fsck will employ both of these methods to speed itself up.

You can also add a Reviewed-by: Andreas Dilger <adilger@dilger.ca> on =
this.

> diff --git a/lib/ext2fs/readahead.c b/lib/ext2fs/readahead.c
> new file mode 100644
> index 0000000..ed6e555
> --- /dev/null
> +++ b/lib/ext2fs/readahead.c
> @@ -0,0 +1,188 @@
> +struct read_dblist {
> +	errcode_t err;
> +	blk64_t run_start;
> +	blk64_t run_len;
> +};
> +
> +static EXT2_QSORT_TYPE readahead_dir_block_cmp(const void *a, const =
void *b)
> +{
> +	const struct ext2_db_entry2 *db_a =3D
> +		(const struct ext2_db_entry2 *) a;
> +	const struct ext2_db_entry2 *db_b =3D
> +		(const struct ext2_db_entry2 *) b;

> +
> +	return (int) (db_a->blk - db_b->blk);
> +}
> +
> +static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 =
*db,
> +			       void *priv_data)
> +{
> +	errcode_t err =3D 0;
> +	struct read_dblist *pr =3D priv_data;
> +
> +	if (!pr->run_len || db->blk !=3D pr->run_start + pr->run_len) {


It probably isn't necessary to check "!pr->run_len", since the only
case where this isn't entered on a new look is db->blk =3D=3D 0, which =
is
always loaded when the filesystem is mounted anyway.

Cheers, Andreas

> +		if (pr->run_len) {
> +			pr->err =3D io_channel_cache_readahead(fs->io,
> +							     =
pr->run_start,
> +							     =
pr->run_len);
> +			dbg_printf("readahead start=3D%llu len=3D%llu =
err=3D%d\n",
> +				   pr->run_start, pr->run_len,
> +				   (int)pr->err);
> +		}
> +		pr->run_start =3D db->blk;
> +		pr->run_len =3D 0;

> +	}
> +	pr->run_len +=3D db->blockcnt;
> +
> +	return pr->err ? DBLIST_ABORT : 0;
> +}
> +
> +errcode_t ext2fs_readahead_dblist(ext2_filsys fs, int flags,
> +				  ext2_dblist dblist)
> +{
> +	errcode_t err;
> +	struct read_dblist pr;
> +
> +	dbg_printf("%s: flags=3D0x%x\n", __func__, flags);
> +	if (flags)
> +		return EXT2_ET_INVALID_ARGUMENT;
> +
> +	ext2fs_dblist_sort2(dblist, readahead_dir_block_cmp);
> +
> +	memset(&pr, 0, sizeof(pr));
> +	err =3D ext2fs_dblist_iterate2(dblist, readahead_dir_block, =
&pr);
> +	if (pr.err)
> +		return pr.err;
> +	if (err)
> +		return err;
> +
> +	if (pr.run_len)
> +		err =3D io_channel_cache_readahead(fs->io, pr.run_start,
> +						 pr.run_len);
> +
> +	return err;
> +}
> +
> +errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
> +			   dgrp_t ngroups)
> +{
> +	blk64_t		super, old_gdt, new_gdt;
> +	blk_t		blocks;
> +	dgrp_t		i;
> +	ext2_dblist	dblist;
> +	dgrp_t		end =3D start + ngroups;
> +	errcode_t	err =3D 0;
> +
> +	dbg_printf("%s: flags=3D0x%x start=3D%d groups=3D%d\n", =
__func__, flags,
> +		   start, ngroups);
> +	if (flags & ~EXT2_READA_ALL_FLAGS)
> +		return EXT2_ET_INVALID_ARGUMENT;
> +
> +	if (end > fs->group_desc_count)
> +		end =3D fs->group_desc_count;
> +
> +	if (flags =3D=3D 0)
> +		return 0;
> +
> +	err =3D ext2fs_init_dblist(fs, &dblist);
> +	if (err)
> +		return err;
> +
> +	for (i =3D start; i < end; i++) {
> +		err =3D ext2fs_super_and_bgd_loc2(fs, i, &super, =
&old_gdt,
> +						&new_gdt, &blocks);
> +		if (err)
> +			break;
> +
> +		if (flags & EXT2_READA_SUPER) {
> +			err =3D ext2fs_add_dir_block2(dblist, 0, super, =
0);
> +			if (err)
> +				break;
> +		}
> +
> +		if (flags & EXT2_READA_GDT) {
> +			if (old_gdt)
> +				err =3D ext2fs_add_dir_block2(dblist, 0, =
old_gdt,
> +							    blocks);
> +			else if (new_gdt)
> +				err =3D ext2fs_add_dir_block2(dblist, 0, =
new_gdt,
> +							    blocks);
> +			else
> +				err =3D 0;
> +			if (err)
> +				break;
> +		}
> +
> +		if ((flags & EXT2_READA_BBITMAP) &&
> +		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) =
&&
> +		    ext2fs_bg_free_blocks_count(fs, i) <
> +				fs->super->s_blocks_per_group) {
> +			super =3D ext2fs_block_bitmap_loc(fs, i);
> +			err =3D ext2fs_add_dir_block2(dblist, 0, super, =
1);
> +			if (err)
> +				break;
> +		}
> +
> +		if ((flags & EXT2_READA_IBITMAP) &&
> +		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) =
&&
> +		    ext2fs_bg_free_inodes_count(fs, i) <
> +				fs->super->s_inodes_per_group) {
> +			super =3D ext2fs_inode_bitmap_loc(fs, i);
> +			err =3D ext2fs_add_dir_block2(dblist, 0, super, =
1);
> +			if (err)
> +				break;
> +		}
> +
> +		if ((flags & EXT2_READA_ITABLE) &&
> +		    ext2fs_bg_free_inodes_count(fs, i) <
> +				fs->super->s_inodes_per_group) {
> +			super =3D ext2fs_inode_table_loc(fs, i);
> +			blocks =3D fs->inode_blocks_per_group -
> +				 (ext2fs_bg_itable_unused(fs, i) *
> +				  EXT2_INODE_SIZE(fs->super) / =
fs->blocksize);
> +			err =3D ext2fs_add_dir_block2(dblist, 0, super, =
blocks);
> +			if (err)
> +				break;
> +		}
> +	}
> +
> +	if (!err)
> +		err =3D ext2fs_readahead_dblist(fs, 0, dblist);
> +
> +	ext2fs_free_dblist(dblist);
> +	return err;
> +}
> +
> +int ext2fs_can_readahead(ext2_filsys fs)
> +{
> +	errcode_t err;
> +
> +	err =3D io_channel_cache_readahead(fs->io, 0, 1);
> +	dbg_printf("%s: supp=3D%d\n", __func__, err !=3D =
EXT2_ET_OP_NOT_SUPPORTED);
> +	return err !=3D EXT2_ET_OP_NOT_SUPPORTED;
> +}
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_72EBF968-282B-4164-9892-1F0308B67038
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUyeBDnKl2rkXzB/gAQKeOw//QgjNbQe0HOz+QOavjVXTxyDzalbcR8T5
qhmKYQ7Ngcp3gDZa2oIxV1Kxv8qFpS78jzPrF5on1nl0GBO62AysjzdmR88o2g2O
xrhhfaOxixnPH4ArGWT882fkTZeDn1KDPHkqIdWKB2UiYh/2XCmZG2yHa7VAhY00
hzdb/NJ/a2jt4p30FzdYps0jhLq9uCq6GoA9JfBqYD2q0TvYaCe4yHtfWLBzEAX1
EccKaBAY94cJSiY8HLaBICon9FiCDiy0O/AMhu9SpEd3TU0R8J9SnLZME4Js23Sz
7PyU2DrUkIlVgs4Y0Z3Fz0sSNOH0xg1wQqWm3WjctuNLw1X0nWjvNrFrr8oVXRJe
9kB1sZ6GYtBfEkexDTL7rXwo3QgPMiIswFCMCxXxpQbyQXwrE5dzn1c/NM+Fu/ay
AmWt9CtEyAvM4mMLZU86nRVunv8YUyYQC0rDkS+o2nwtZm+kCafCcXbAAnuu79QA
ou+/Rg4N0pDO3bmnJTtGM3iYx7/jjtMOCMuZQfFQ2+cjyyGQibkT7weLCv67d3o+
lW6xZqfwngGFNSL8jbjeiRb1nrzvEqCFKoPqXSZy8M2BNxLMQe8m04RwseEF8Wpa
jMYr+m4HIckUapt2NuoPqRSBZWlFLZFimXCIJZWmPOoe5RupTnu9fGb+BikeLb9R
F4HCHZDbe3I=
=lcc8
-----END PGP SIGNATURE-----

--Apple-Mail=_72EBF968-282B-4164-9892-1F0308B67038--
