From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] filefrag: accommodate holes when calculating expected values
Date: Fri, 4 Dec 2015 15:06:04 -0700
Message-ID: <8B852D41-28F6-4280-9DF0-7A370ADC5B2D@dilger.ca>
References: <20151203203726.GH10580@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C9975A66-E91F-4CB7-A150-A498B48C99D3"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34891 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbbLDWGK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 17:06:10 -0500
Received: by ioc74 with SMTP id 74so130261015ioc.2
        for <linux-ext4@vger.kernel.org>; Fri, 04 Dec 2015 14:06:10 -0800 (PST)
In-Reply-To: <20151203203726.GH10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C9975A66-E91F-4CB7-A150-A498B48C99D3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 3, 2015, at 1:37 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> Currently, filefrag's "expected physical block" column expects extent
> records to be physically adjacent regardless of the amount of logical
> block space between the two records.  This means that if we punch a
> hole in a file, we get reports like this:
>=20
> ext:   logical_offset:   physical_offset: length:  expected: flags:
> 4:     4096..    8343:   57376..  61623:   4248:
> 5:     8345..   10313:   61625..  63593:   1969:   61624:
>=20
> Notice how it expects 8345 to map to 61624, and scores this against
> the fragmentation of the file.  Flagging this as "unexpected" is
> incorrect because the gap in the logical mapping is exactly the same
> size as the gap in the physical extents.
>=20
> Furthermore, this particular mapping leaves the door open to the
> optimal mapping -- if a write to block 8344 causes it to be mapped to
> 61624, the entire range 4096-10313 can be mapped with a single extent.
> Until that happens, there's no way to combine extents 4 and 5 because
> of the gap in the logical mapping at block 8344.
>=20
> Therefore, tweak the extent report to account for holes.
>=20
> v2: Make it work for extents crossing FIEMAP calls, and clean up the
> FIBMAP version to report correct expected values.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> misc/filefrag.c |   74 =
+++++++++++++++++++++++++++++++++----------------------
> 1 file changed, 45 insertions(+), 29 deletions(-)
>=20
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 5bcde91..5ad6ee0 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -208,6 +208,7 @@ static int filefrag_fiemap(int fd, int blk_shift, =
int *num_extents,
> 	__u64 buf[2048];	/* __u64 for proper field alignment */
> 	struct fiemap *fiemap =3D (struct fiemap *)buf;
> 	struct fiemap_extent *fm_ext =3D &fiemap->fm_extents[0];
> +	struct fiemap_extent fm_last;
> 	int count =3D (sizeof(buf) - sizeof(*fiemap)) /
> 			sizeof(struct fiemap_extent);
> 	unsigned long long expected =3D 0;
> @@ -219,6 +220,7 @@ static int filefrag_fiemap(int fd, int blk_shift, =
int *num_extents,
> 	int rc;
>=20
> 	memset(fiemap, 0, sizeof(struct fiemap));
> +	memset(&fm_last, 0, sizeof(struct fiemap_extent));

This could just be an initializer at declaration time?

> 	if (sync_file)
> 		flags |=3D FIEMAP_FLAG_SYNC;
> @@ -254,6 +256,8 @@ static int filefrag_fiemap(int fd, int blk_shift, =
int *num_extents,
> 		}
>=20
> 		for (i =3D 0; i < fiemap->fm_mapped_extents; i++) {
> +			expected =3D fm_last.fe_physical +
> +				   fm_ext[i].fe_logical - =
fm_last.fe_logical;

Does it make sense to allow two "expected" values? Either the sparse one =
that
leaves a gap for the block, or the dense one that packs physical blocks =
adjacent
to each other seem acceptable, depending on the application.  It doesn't =
make
sense to preserve holes in files that are never going to be modified =
in-place
(e.g. core dump or something).  Something like:

			expected_dense =3D fm_last.fe_physical + =
fm_last.fe_length;
			expected_sparse =3D fm_last.fe_physical +
				   fm_ext[i].fe_logical - =
fm_last.fe_logical;

			if (fm_ext[i].fe_logical !=3D 0 &&
			    fm_ext[i].fe_physical !=3D expected_dense &&
			    fm_ext[i].fe_physical !=3D expected_sparse) =
{
				tot_extents++;

Cheers, Andreas

> @@ -265,10 +269,9 @@ static int filefrag_fiemap(int fd, int blk_shift, =
int *num_extents,
> 			if (verbose)
> 				print_extent_info(&fm_ext[i], n, =
expected,
> 						  blk_shift, st);
> -
> -			expected =3D fm_ext[i].fe_physical + =
fm_ext[i].fe_length;
> 			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
> 				last =3D 1;
> +			fm_last =3D fm_ext[i];
> 			n++;
> 		}
>=20
> @@ -287,14 +290,15 @@ static int filefrag_fibmap(int fd, int =
blk_shift, int *num_extents,
> 			   ext2fs_struct_stat *st,
> 			   unsigned long numblocks, int is_ext2)
> {
> -	struct fiemap_extent	fm_ext;
> +	struct fiemap_extent	fm_ext, fm_last;
> 	unsigned long		i, last_block;
> -	unsigned long long	logical;
> +	unsigned long long	logical, expected =3D 0;
> 				/* Blocks per indirect block */
> 	const long		bpib =3D st->st_blksize / 4;
> 	int			count;
>=20
> 	memset(&fm_ext, 0, sizeof(fm_ext));
> +	memset(&fm_last, 0, sizeof(fm_last));

These could be declaration initializers.

> 	if (force_extent) {
> 		fm_ext.fe_flags =3D FIEMAP_EXTENT_MERGED;
> 	}
> @@ -322,40 +326,52 @@ static int filefrag_fibmap(int fd, int =
blk_shift, int *num_extents,
> 			return rc;
> 		if (block =3D=3D 0)
> 			continue;
> -		if (*num_extents =3D=3D 0) {
> -			(*num_extents)++;
> -			if (force_extent) {
> +
> +		if (*num_extents =3D=3D 0 || block !=3D last_block + 1 =
||
> +		    fm_ext.fe_logical + fm_ext.fe_length !=3D logical) {
> +			/*
> +			 * This is the start of a new extent; figure out =
where
> +			 * we expected it to be and report the extent.
> +			 */
> +			if (*num_extents !=3D 0 && fm_last.fe_length) {
> +				expected =3D fm_last.fe_physical +
> +					(fm_ext.fe_logical - =
fm_last.fe_logical);
> +				if (expected =3D=3D fm_ext.fe_physical)
> +					expected =3D 0;
> +			}
> +			if (force_extent && *num_extents =3D=3D 0)
> 				print_extent_header();
> -				fm_ext.fe_physical =3D block * =
st->st_blksize;
> +			if (force_extent && *num_extents !=3D 0) {
> +				print_extent_info(&fm_ext, *num_extents =
- 1,
> +						  expected, blk_shift, =
st);
> 			}
> -		}
> -		count++;
> -		if (force_extent && last_block !=3D 0 &&
> -		    (block !=3D last_block + 1 ||
> -		     fm_ext.fe_logical + fm_ext.fe_length !=3D logical)) =
{
> -			print_extent_info(&fm_ext, *num_extents - 1,
> -					  (last_block + 1) * =
st->st_blksize,
> -					  blk_shift, st);
> -			fm_ext.fe_length =3D 0;
> +			if (verbose && expected !=3D 0) {
> +				printf("Discontinuity: Block %llu is at =
%llu "
> +				       "(was %llu)\n",
> +					fm_ext.fe_logical / =
st->st_blksize,
> +					fm_ext.fe_physical / =
st->st_blksize,
> +					expected / st->st_blksize);
> +			}
> +			/* create the new extent */
> +			fm_last =3D fm_ext;
> 			(*num_extents)++;
> -			fm_ext.fe_logical =3D logical;
> 			fm_ext.fe_physical =3D block * st->st_blksize;
> -		} else if (last_block && (block !=3D last_block + 1)) {
> -			if (verbose)
> -				printf("Discontinuity: Block %ld is at =
%lu (was "
> -				       "%lu)\n", i, block, last_block + =
1);
> -			fm_ext.fe_length =3D 0;
> -			(*num_extents)++;
> 			fm_ext.fe_logical =3D logical;
> -			fm_ext.fe_physical =3D block * st->st_blksize;
> +			fm_ext.fe_length =3D 0;
> 		}
> 		fm_ext.fe_length +=3D st->st_blksize;
> 		last_block =3D block;
> 	}
> -
> -	if (force_extent)
> -		print_extent_info(&fm_ext, *num_extents - 1,
> -				  last_block * st->st_blksize, =
blk_shift, st);
> +	if (force_extent && *num_extents !=3D 0) {
> +		if (fm_last.fe_length) {
> +			expected =3D fm_last.fe_physical +
> +				   (fm_ext.fe_logical - =
fm_last.fe_logical);
> +			if (expected =3D=3D fm_ext.fe_physical)
> +				expected =3D 0;
> +		}
> +		print_extent_info(&fm_ext, *num_extents - 1, expected,
> +				  blk_shift, st);
> +	}
>=20
> 	return count;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_C9975A66-E91F-4CB7-A150-A498B48C99D3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmIOTHKl2rkXzB/gAQj5FhAAt+MshCaxjJXKPKffAKUBk3dLUtmy+SJB
mxMSCe4KJGP9bRm5NhlEg6zXHC0zq+agjzJsXct4NBIqvshc/G6qHzuWV1aLUXC0
0LBkBIHeuz29LO7pATym0kAtNPb7iOJHPOhRTaz08fz0wp5MmAaVgq4wm7LvYzlM
KgQFdbL5x1UuVpNmlLArx6+G8JtfgGoLc+1ehDlYfqzY8gVaNvqK008N/+XOt+NC
4v6e8P1b1ha38UlrzbrVn4ziE+dKupr9e1oawN1BZ989AsDdIXHyKGvkv6t51xWB
4x1KiLZ46pGLwL7j4GUYWuCspX2+ePRq0OAiTyBDO+OzJB5L+9poMUseW55Id3+u
Auw/qvrEY8pg7rchcvdfqVsqyYFfAWUKjMztw0JEHFWxLWetzoh8vSfKJXRTQc0q
n9G1L5GlOHvJ9zY+ljJ9xH3sVmJGRwlwR43+7HcNO7Efgk9aF/URvZRCAs43XUtj
0NumHgdZ3qoh3KqJVuXREHKVZuGVHq17ReW2MBIzcp2SqTodqhjw2d19OpHmtFmH
V8cKOWBvzTuV4Y11xt+QjVtt+7n5LaKU/reEvHsjxK+F29jY6VEAW23ygI0ER14r
Wy0lQZF8lX4UBZIDFZU0Iz/bKwoSsdb3LpTw7EMWmR5X1ng5h/eph+S1awz5ViFZ
F9lqPJz5rJg=
=Sm4z
-----END PGP SIGNATURE-----

--Apple-Mail=_C9975A66-E91F-4CB7-A150-A498B48C99D3--
