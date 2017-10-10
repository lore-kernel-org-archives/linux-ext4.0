From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] misc: quiet llvm build warnings
Date: Tue, 10 Oct 2017 16:44:38 -0600
Message-ID: <9EE2BF96-AAC7-4FCC-A08F-C95D2FDB4030@dilger.ca>
References: <1507675283-70118-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_14519D95-4BD4-466E-B9EC-3829277D264B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:55836 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755549AbdJJWoo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 18:44:44 -0400
Received: by mail-it0-f65.google.com with SMTP id l196so576829itl.4
        for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2017 15:44:44 -0700 (PDT)
In-Reply-To: <1507675283-70118-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_14519D95-4BD4-466E-B9EC-3829277D264B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 10, 2017, at 4:41 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> Quiet some relatively harmless build warnings:
>=20
> mkquota.c:527:15: warning: format specifies type 'long' but the
> 	argument has type 'qsize_t' (aka 'long long') [-Wformat]
> 		dq->dq_id, dq->dq_dqb.dqb_curspace,
> 			   ^~~~~~~~~~~~~~~~~~~~~~~
>=20
> tune2fs.c:928:18: warning: '&&' within '||' [-Wlogical-op-parentheses]
> 	if (pass =3D=3D 1 && (inode->i_flags & EXT4_EA_INODE_FL) ||
> 	    ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~
> tune2fs.c:928:18: place parentheses around '&&' to silence warning

Sorry, please ignore this one, it was sent from an old branch and has
already been merged.

Cheers, Andreas

> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
> lib/support/mkquota.c | 2 +-
> misc/tune2fs.c        | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
> index 11a878e..4251e46 100644
> --- a/lib/support/mkquota.c
> +++ b/lib/support/mkquota.c
> @@ -523,7 +523,7 @@ static int scan_dquots_callback(struct dquot =
*dquot, void *cb_data)
> 	    dq->dq_dqb.dqb_curinodes !=3D dquot->dq_dqb.dqb_curinodes) {
> 		scan_data->usage_is_inconsistent =3D 1;
> 		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for =
ID %u:"
> -			"actual (%ld, %ld) !=3D expected (%ld, %ld)\n",
> +			"actual (%lld, %lld) !=3D expected (%lld, =
%lld)\n",
> 			dq->dq_id, dq->dq_dqb.dqb_curspace,
> 			dq->dq_dqb.dqb_curinodes,
> 			dquot->dq_dqb.dqb_curspace,
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 9b53dc2..c7c1d6d 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -925,8 +925,8 @@ static void rewrite_inodes(ext2_filsys fs)
> 			if (!ino)
> 				break;
>=20
> -			if (pass =3D=3D 1 && (inode->i_flags & =
EXT4_EA_INODE_FL) ||
> -			    pass =3D=3D 2 && !(inode->i_flags & =
EXT4_EA_INODE_FL))
> +			if ((pass =3D=3D 1 && (inode->i_flags & =
EXT4_EA_INODE_FL))||
> +			    (pass =3D=3D 2 && !(inode->i_flags & =
EXT4_EA_INODE_FL)))
> 				rewrite_one_inode(&ctx, ino, inode);
> 		} while (ino);
>=20
> --
> 1.8.0
>=20


Cheers, Andreas






--Apple-Mail=_14519D95-4BD4-466E-B9EC-3829277D264B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ3U1WpIg59Q01vtYRArBsAKDfhpLdWPm0we4v6JKUgM6NTQ3k0gCcC+Ws
Mz3sz0o6nST0F/kqLl6DmiY=
=tPre
-----END PGP SIGNATURE-----

--Apple-Mail=_14519D95-4BD4-466E-B9EC-3829277D264B--
