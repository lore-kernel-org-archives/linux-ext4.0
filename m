From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 2/8]  e2fsck: add support for dirdata feature
Date: Fri, 27 Oct 2017 17:13:09 -0600
Message-ID: <E5C7221F-6A40-4FF4-9CC2-476B035BB037@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
 <20171027172254.14137-3-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_936413CE-59DD-4021-AD46-3E0894E3BF4C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:53281 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbdJ0XNQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 19:13:16 -0400
Received: by mail-io0-f194.google.com with SMTP id 189so15900538iow.10
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 16:13:16 -0700 (PDT)
In-Reply-To: <20171027172254.14137-3-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_936413CE-59DD-4021-AD46-3E0894E3BF4C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
> From: Andreas Dilger <andreas.dilger@intel.com>
>=20
>    Add support for the INCOMPAT_DIRDATA feature, which allows
>    storing extra data in the directory entry beyond the name.
>    This allows the Lustre File IDentifier to be accessed in
>    an efficient manner, and would be useful for expanding a
>    filesystem to allow more than 2^32 inodes in the future.
>=20
>      LU-1774 e2fsck: e2fsck -D does not change dirdata content
>=20
>      Fix dir optimization to preserver dirdata content for dot
>      and dotdot entries.

(typo) s/preserver/preserve/

> +int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry *de,
> +			     unsigned int offset, struct problem_context =
*pctx)
> +{
> +	if (!(ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_DIRDATA)) {
> +		if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
> +			/* clear dirent extra data flags. */
> +			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) =
{
> +				de->name_len &=3D (EXT2_FT_MASK << 8) |
> +						EXT2_NAME_LEN;
> +				return 2;
> +			}
> +		}
> +		return 1;
> +	}
> +	if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
> +		if (de->rec_len >=3D EXT2_DIR_REC_LEN(de) ||
> +		    de->rec_len + offset =3D=3D =
EXT2_BLOCK_SIZE(ctx->fs->super)) {
> +			if (ext2_get_dirent_dirdata_size(de,
> +							 =
EXT2_DIRENT_LUFID) =3D=3D
> +			    EXT2_DIRENT_LUFID_SIZE)
> +				return 0;

One thing that we've been thinking about recently is to store multiple =
FIDs
in the dirent to allow metadata replication (i.e. the dirent refers to =
inodes
on two different servers).  It would be better to change this check to =
be:

			if (ext2_get_dirent_dirdata_size(de, =
EXT2_DIRENT_LUFID)%
			    EXT2_DIRENT_LUFID_SIZE =3D=3D 1 /* size */ + =
1 /* NUL */)

and change

#define EXT2_DIRENT_LUFID_SIZE 16

so that the dirdata size can be a multiple of 16, with 1 byte for the =
record
size. The current EXT2_DIRENT_LUFID_SIZE is defined as 17 + 1, which I =
think
is misleading.  The actual size stored on disk is 17 (16 + =
sizeof(lu_fid))
and the extra "+ 1" is added by ext2_get_dirent_dirdata_size(), but I =
don't
think the NUL after the name should be included in LUFID_SIZE.  That =
wasn't
important when there was only a single FID and a single dirdata entry, =
but
it makes sense to fix this when landing this patch upstream.

> +		}
> +		/* just clear dirent data flags for now, we should fix =
FID data
> +		 * in lustre specific pass.
> +		 */
> +		if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
> +			ext2_fix_dirent_dirdata(de);
> +			if (ext2_get_dirent_dirdata_size(de,
> +							 =
EXT2_DIRENT_LUFID) !=3D
> +			    EXT2_DIRENT_LUFID_SIZE)

> +				de->name_len &=3D ~(EXT2_DIRENT_LUFID << =
8);
> +
> +			return 2;
> +		}
> +	}
> +	return 1;
> +}
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 2bb8d4e2..1891756b 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1671,6 +1671,11 @@ static struct e2fsck_problem problem_table[] =3D =
{
> 	  N_("Encrypted @E is too short.\n"),
> 	  PROMPT_CLEAR, 0 },
>=20
> +	/* Directory entry dirdata length set incorrectly */
> +	{ PR_2_CLEAR_DIRDATA,
> +	  N_("@E dirdata length set incorrectly.\n"),
> +	  PROMPT_CLEAR, PR_PREEN_OK },
> +
> 	/* Pass 3 errors */
>=20
> 	/* Pass 3: Checking directory connectivity */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 49a8c3ad..96862522 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -1004,6 +1004,9 @@ struct problem_context {
> /* Encrypted directory entry is too short */
> #define PR_2_BAD_ENCRYPTED_NAME		0x020050
>=20
> +/* Directory dirdata flag set */

Please make this comment match the error message in problem.c:

/* Entry dirdata length set incorrectly */

> +#define PR_2_CLEAR_DIRDATA		0x02f000

This should use the next (or at least close) problem number,
otherwise it is prone to getting the entries in the wrong
numerical order, which will fail.  We only had such a large
value in the Lustre e2fsprogs tree to avoid conflicts from
other patches landing upstream.


Cheers, Andreas






--Apple-Mail=_936413CE-59DD-4021-AD46-3E0894E3BF4C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ872GpIg59Q01vtYRAlNfAJ9NVLguAyKnhrryBXo9Xsag5JO2egCg56pv
ajqJ07lS3JP5QvMeGbXfO+c=
=hQ4E
-----END PGP SIGNATURE-----

--Apple-Mail=_936413CE-59DD-4021-AD46-3E0894E3BF4C--
