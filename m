From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 07/12] e2fsck: track ea_inode references
Date: Mon, 26 Jun 2017 15:45:50 -0600
Message-ID: <2822BB00-1A19-4DE4-8532-63FC307E5D7B@dilger.ca>
References: <20170626134348.1240-1-tahsin@google.com>
 <20170626134348.1240-7-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D47E0369-4FD2-4471-B444-DFD63E72FB0F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35442 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdFZVp4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 17:45:56 -0400
Received: by mail-it0-f67.google.com with SMTP id v193so520170itc.2
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 14:45:56 -0700 (PDT)
In-Reply-To: <20170626134348.1240-7-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D47E0369-4FD2-4471-B444-DFD63E72FB0F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 26, 2017, at 7:43 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> An extended attribute inode has a ref count to track how many entries
> point to it. Update e2fsck to verify that the stored ref count is
> correct.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> diff --git a/e2fsck/message.c b/e2fsck/message.c
> index 34201a37fd4b..525f4a1e7628 100644
> --- a/e2fsck/message.c
> +++ b/e2fsck/message.c
> @@ -466,6 +466,13 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		fprintf(f, "%*u", width, ctx->num);
> #else
> 		fprintf(f, "%*llu", width, (long long)ctx->num);
> +#endif
> +		break;
> +	case 'n':
> +#ifdef EXT2_NO_64_TYPE
> +		fprintf(f, "%*u", width, ctx->num2);
> +#else
> +		fprintf(f, "%*llu", width, (long long)ctx->num2);
> #endif

Rather than a series of "#ifdef EXT2_NO_64_TYPE" checks, it would be =
cleaner
to have a single #define to set the printf type, like:

#ifdef EXT2_NO_64_TYPE
#define EXT2_64U "%*u"
#define EXT2_64D "%*d"
#define EXT2_64X "%*x"
#else
#define EXT2_64U "%*llu"
#define EXT2_64D "%*lld"
#define EXT2_64X "%*llx"
#endif

and then use "EXT2_64D" or "EXT2_64U" in all of these fprintf() =
statements.

Cheers, Andreas






--Apple-Mail=_D47E0369-4FD2-4471-B444-DFD63E72FB0F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZUYCPpIg59Q01vtYRAj3kAJ9biOsDcMMAcuYr3og7y77B4L37DACfX/U7
td8sM3to4jxJUhTDNVDIcq8=
=qGSJ
-----END PGP SIGNATURE-----

--Apple-Mail=_D47E0369-4FD2-4471-B444-DFD63E72FB0F--
