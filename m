Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:62247 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbeLELnj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 06:43:39 -0500
Subject: Re: [PATCH] inode_has_no_xattr() does not use proper sync
To: Jan Kara <jack@suse.cz>
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        linux-ext4@vger.kernel.org
References: <ce8c29d7-7f5e-5c78-dbd9-15364a384138@tu-dortmund.de>
 <20181205090117.GA22304@quack2.suse.cz>
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Message-ID: <8921ec9e-7c4c-71e2-0397-9e564824d9a4@tu-dortmund.de>
Date: Wed, 5 Dec 2018 12:43:18 +0100
MIME-Version: 1.0
In-Reply-To: <20181205090117.GA22304@quack2.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3Wlr7ToBPlZFzv5YWVsfEthhGBOAiqujP"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3Wlr7ToBPlZFzv5YWVsfEthhGBOAiqujP
Content-Type: multipart/mixed; boundary="axQDTtgTlONbSZRRvSMgZkt387FnQoXFe";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: Jan Kara <jack@suse.cz>
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
 linux-ext4@vger.kernel.org
Message-ID: <8921ec9e-7c4c-71e2-0397-9e564824d9a4@tu-dortmund.de>
Subject: Re: [PATCH] inode_has_no_xattr() does not use proper sync
References: <ce8c29d7-7f5e-5c78-dbd9-15364a384138@tu-dortmund.de>
 <20181205090117.GA22304@quack2.suse.cz>
In-Reply-To: <20181205090117.GA22304@quack2.suse.cz>

--axQDTtgTlONbSZRRvSMgZkt387FnQoXFe
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable



Am 05.12.18 um 10:01 schrieb Jan Kara:
> On Tue 27-11-18 15:54:28, Alexander Lochmann wrote:
>>
>> inode.i_flags is modified without any proper
>> synchronisation used. inode_set_flags() is now used.
>>
>> Found by LockDoc (Alexander Lochmann, Horst Schirmeier and Olaf
>> Spinczyk)
>>
>> Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
>> Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
>=20
> Thanks for the patch! Couple notes to this patch:
>=20
> 1) This is a generic VFS helper as such, linux-fsdevel mailing list and=
 VFS
> maintainer Al Viro is the right forum to post this patch to. We do have=

> scripts/get_maintainer.pl script you can use on a patch / file to get i=
dea
> who's the best to post the change to. It is not perfect but usually wor=
ks
> fine.
Oh, that's my fault. I thought this ml was the right place.
>=20
> 2) It would be good to include stacktrace showing where the unlocked ac=
cess
> happens in the changelog. It is non-trivial to find it by brief inspect=
ion
> as all standard filesystems call inode_has_no_xattr() under i_rwsem. Th=
is
> problem is really specific to blkdev_write_iter() AFAICT.
>=20
> 3) Also can you please add comment into inode_has_no_xattr() like:
> 	/*
> 	 * blkdev_write_iter() can call this without i_rwsem, need to be
> 	 * careful with i_flags update.
> 	 */
2) + 3) Done. Will post the patch asap.

- Alex
>=20
> 								Honza
>> ---
>>  include/linux/fs.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index c95c0807471f..54f3a21668a6 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -3446,7 +3446,7 @@ static inline int check_sticky(struct inode *dir=
,
>> struct inode *inode)
>>  static inline void inode_has_no_xattr(struct inode *inode)
>>  {
>>  	if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & SB_NOSEC))
>> -		inode->i_flags |=3D S_NOSEC;
>> +		inode_set_flags(inode, S_NOSEC, S_NOSEC);
>>  }
>>
>>  static inline bool is_root_inode(struct inode *inode)
>> --=20
>> 2.19.1
>>
>=20
>=20
>=20

--=20
Technische Universit=C3=A4t Dortmund
Alexander Lochmann                PGP key: 0xBC3EF6FD
Otto-Hahn-Str. 16                 phone:  +49.231.7556141
D-44227 Dortmund                  fax:    +49.231.7556116
http://ess.cs.tu-dortmund.de/Staff/al


--axQDTtgTlONbSZRRvSMgZkt387FnQoXFe--

--3Wlr7ToBPlZFzv5YWVsfEthhGBOAiqujP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElhZsUHzVP0dbkjCRWT7tBbw+9v0FAlwHudcACgkQWT7tBbw+
9v1ZIA//ZP7WUv+yD8Vn6RBHvOmKyg8uo1mjnlviHJ4GHyNQaRKxqvPqs6C4Q7av
Zzz+K+8UZGt7NjoY+Kx43Re6MrJn+Ep1ix5kfyflK7YdQWpcw4CoGX/IXmxFCKXP
XC5aH3m3ofCOy7lKbS/ZnX76u+edEGQtA2SgQmhJALLQbpo7M1DDhnnob/en9Auh
GgcUeTj/YrXVS2ZgjoIj2HWaF430sinzZ7Hw0G+XxWbc7Q7vsmcYOlMYZINB2NCI
F+/yuPMRTWNS8q6xN0OhkKaPFKI3/7FVXOFWfdHwces3GKfCjWImq4e+k851kmlW
6c7IMbP6KfAjjfUtvtnMgVtF7ZrQubUybRdUaMo1gWc99tfqtHHPDnMkPCCiRHmp
PsxUo9T+6A2L6OD1Owk7Q/w1gbGn3Xg/B2y0uBXQC+UiowQFTskREV4vB6pfXn7X
hsxP9MWMfAwZCFrxdd6lPkweibGxs7TFdYB5O1ShtAmQJwUCDhRepRICbc+x2IC2
+ScovMzKd7z4HX8pZjDlnSYa36hQUan3vFSUVQs837fuKlknKeJueWp9LOFKodxJ
J56iaoWBk9WywvP3ipAM8BfH90kspSXtqdvWgt2oCNRkVlOqcxDh3gbQR2Xh5ADT
JDttFCwkrQH1c4i7TFyTm+U5npV64lykTYbhyhYu/pt9zxm384U=
=rQNA
-----END PGP SIGNATURE-----

--3Wlr7ToBPlZFzv5YWVsfEthhGBOAiqujP--
