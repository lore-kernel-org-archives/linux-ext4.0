From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 04/12] e2fsck: do not early terminate extra space check
Date: Mon, 26 Jun 2017 15:23:52 -0600
Message-ID: <CF22DC39-678F-420D-BD6D-28C90CB7D6E3@dilger.ca>
References: <20170626134348.1240-1-tahsin@google.com>
 <20170626134348.1240-4-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BA81CACC-27EF-4FE5-8984-E2D2CC6BEDCA";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35733 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdFZVX5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 17:23:57 -0400
Received: by mail-io0-f196.google.com with SMTP id 84so1168414iop.2
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 14:23:56 -0700 (PDT)
In-Reply-To: <20170626134348.1240-4-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_BA81CACC-27EF-4FE5-8984-E2D2CC6BEDCA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jun 26, 2017, at 7:43 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> When check_inode_extra_space() detects a problem with the value of
> i_extra_isize, it adjusts it and then returns without further =
validation
> of contents in the inode body. Change this so that it will proceed to
> check inline extended attributes.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> e2fsck/pass1.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 32152f3ec926..1532fd2067f2 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -582,7 +582,6 @@ static void check_inode_extra_space(e2fsck_t ctx, =
struct problem_context *pctx)
> 			inode->i_extra_isize =3D (inode->i_extra_isize + =
3) & ~3;
> 		e2fsck_write_inode_full(ctx, pctx->ino, pctx->inode,
> 					EXT2_INODE_SIZE(sb), "pass1");
> -		return;
> 	}
>=20
> 	/* check if there is no place for an EA header */

The problem is that if i_extra_isize is changed, then the EA magic and =
data
will no longer be aligned properly, so there isn't anything to check?


Cheers, Andreas






--Apple-Mail=_BA81CACC-27EF-4FE5-8984-E2D2CC6BEDCA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZUXtppIg59Q01vtYRAtNSAKCX13+PKMzvpU6ShTnYMiLMtHPrIgCgkMTU
5Y8IRBjnoc0Llq/hKJM2ISs=
=sGCp
-----END PGP SIGNATURE-----

--Apple-Mail=_BA81CACC-27EF-4FE5-8984-E2D2CC6BEDCA--
