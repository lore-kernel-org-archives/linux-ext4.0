From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/4] ext4: add debug_want_extra_isize mount option
Date: Thu, 12 Jan 2017 12:19:37 -0700
Message-ID: <EBB78DF0-12A8-45DA-B61C-695E8DE358DB@dilger.ca>
References: <20170112034938.5934-1-tytso@mit.edu> <20170112034938.5934-2-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_86CA2D7D-8CCB-4C64-8EEB-B54FB85B2079"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36048 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbdALVUq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2017 16:20:46 -0500
Received: by mail-it0-f66.google.com with SMTP id o138so3169726ito.3
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2017 13:20:46 -0800 (PST)
In-Reply-To: <20170112034938.5934-2-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_86CA2D7D-8CCB-4C64-8EEB-B54FB85B2079
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 11, 2017, at 8:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> In order to test the inode extra isize expansion code, it is useful to
> be able to easily create file systems that have inodes with extra
> isize values smaller than the current desired value.

Rather than adding all of the debug hooks as mount options, wouldn't it
make more sense to add tunables via debugfs or as an attr_extra_isize or
similar?

Cheers, Andreas

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/super.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9d15a6293124..829e4a7b59e4 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1284,7 +1284,7 @@ enum {
> 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
> 	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version, =
Opt_dax,
> 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
> -	Opt_lazytime, Opt_nolazytime,
> +	Opt_lazytime, Opt_nolazytime, Opt_debug_want_extra_isize,
> 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
> 	Opt_inode_readahead_blks, Opt_journal_ioprio,
> 	Opt_dioread_nolock, Opt_dioread_lock,
> @@ -1352,6 +1352,7 @@ static const match_table_t tokens =3D {
> 	{Opt_delalloc, "delalloc"},
> 	{Opt_lazytime, "lazytime"},
> 	{Opt_nolazytime, "nolazytime"},
> +	{Opt_debug_want_extra_isize, "debug_want_extra_isize=3D%u"},
> 	{Opt_nodelalloc, "nodelalloc"},
> 	{Opt_removed, "mblk_io_submit"},
> 	{Opt_removed, "nomblk_io_submit"},
> @@ -1557,6 +1558,7 @@ static const struct mount_opts {
> #endif
> 	{Opt_nouid32, EXT4_MOUNT_NO_UID32, MOPT_SET},
> 	{Opt_debug, EXT4_MOUNT_DEBUG, MOPT_SET},
> +	{Opt_debug_want_extra_isize, 0, MOPT_GTE0},
> 	{Opt_quota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA, MOPT_SET | =
MOPT_Q},
> 	{Opt_usrquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA,
> 							MOPT_SET | =
MOPT_Q},
> @@ -1670,6 +1672,8 @@ static int handle_mount_opt(struct super_block =
*sb, char *opt, int token,
> 		if (arg =3D=3D 0)
> 			arg =3D JBD2_DEFAULT_MAX_COMMIT_AGE;
> 		sbi->s_commit_interval =3D HZ * arg;
> +	} else if (token =3D=3D Opt_debug_want_extra_isize) {
> +		sbi->s_want_extra_isize =3D arg;
> 	} else if (token =3D=3D Opt_max_batch_time) {
> 		sbi->s_max_batch_time =3D arg;
> 	} else if (token =3D=3D Opt_min_batch_time) {
> @@ -4081,7 +4085,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		sb->s_flags |=3D MS_RDONLY;
>=20
> 	/* determine the minimum size of new large inodes, if present */
> -	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
> +	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    sbi->s_want_extra_isize =3D=3D 0) {
> 		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
> 						     =
EXT4_GOOD_OLD_INODE_SIZE;
> 		if (ext4_has_feature_extra_isize(sb)) {
> --
> 2.11.0.rc0.7.gbe5a750

Cheers, Andreas






--Apple-Mail=_86CA2D7D-8CCB-4C64-8EEB-B54FB85B2079
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWHfzJ3Kl2rkXzB/gAQidPxAAotgeCItZ2h7Flx+t5DotD9PH8uc+MXcq
DMwKNteGZielwBNv8hGrNjk6+h/TPebylnEa6lOFTo5a3ZIOe7HdByLGxVj1pJeu
6IUl4cOXUGGq/8KBMhh+CPFWINakTd1AHejtxqdjq0pQkLelDlftOOcMrRtDaGKc
4cyWPrNk9IohyDVAqabltC7/DXIM1w1i1pOx60Zbz3hWqxNjCDUA8iC3bRg9ft2U
hkJx73JDqGznPoKo6O4OBzI1rS0CvyKzDInL8MEoSqJyJB16+JJxX8Umeperh3Oy
DU99f3sVma67qtK3xFpJPpYv1D+862I40+c5gHU4Y1l5hZGovGnb+MxWOffa+G/8
L3xW5aDLypHYhoxeeWkOfEAz8T5Iuglpe2uuaNEDYodDtq2SnBmg2PeEWUDWaPYi
ygNOMyUS1HGruhIuTXFmC1+abpeo2qSKxFfEvtfuL520YjGVz4FRxUUJqdctiGI1
RNK8sP6mxSY3ruirZiI8TSx8i5OHkfCxUPiSWXlm3Ei77B5uHqWY+Jc5u8naBIIo
qMwYEiJiA0M3Meu5NrgqXJvZl+iAfjP7KoyvQgwO6rEiQmWh9T7IIl/oSq6RfwJu
gsbxoXF46hOhBVeq15m5VqqdA965eRb9prT2RQHW2sh6p5dGNOBSu9sWS3lfc/S/
MzcMbUxwy4Y=
=MhEB
-----END PGP SIGNATURE-----

--Apple-Mail=_86CA2D7D-8CCB-4C64-8EEB-B54FB85B2079--
