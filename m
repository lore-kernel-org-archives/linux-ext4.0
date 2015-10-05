From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix potential use after free in __ext4_journal_stop
Date: Mon, 5 Oct 2015 13:20:52 -0600
Message-ID: <D351F62D-C7F5-4B8F-8D7C-246DC6BB52CC@dilger.ca>
References: <1441205154-16501-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1510051618030.4946@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A093F2CD-5876-4CB3-B319-3BAD035B1F0B"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33477 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbJETVH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Oct 2015 15:21:07 -0400
Received: by pacex6 with SMTP id ex6so185185728pac.0
        for <linux-ext4@vger.kernel.org>; Mon, 05 Oct 2015 12:21:06 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1510051618030.4946@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A093F2CD-5876-4CB3-B319-3BAD035B1F0B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Oct 5, 2015, at 8:18 AM, Luk=C3=A1=C5=A1 Czerner =
<lczerner@redhat.com> wrote:
>=20
> On Wed, 2 Sep 2015, Lukas Czerner wrote:
>=20
>> Date: Wed,  2 Sep 2015 16:45:54 +0200
>> From: Lukas Czerner <lczerner@redhat.com>
>> To: linux-ext4@vger.kernel.org
>> Cc: Lukas Czerner <lczerner@redhat.com>
>> Subject: [PATCH] ext4: fix potential use after free in =
__ext4_journal_stop
>>=20
>> There is a use-after-free possibility in __ext4_journal_stop() in the
>> case that we free the handle in the first jbd2_journal_stop() because
>> we're referencing handle->h_err afterwards. This was introduced in
>> 9705acd63b125dee8b15c705216d7186daea4625 and it is wrong. Fix it by
>> storing the handle->h_err value beforehand and avoid referencing
>> potentially freed handle.
>=20
> ping
>>=20
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

>> ---
>> fs/ext4/ext4_jbd2.c | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
>> index d418431..e770c1ee 100644
>> --- a/fs/ext4/ext4_jbd2.c
>> +++ b/fs/ext4/ext4_jbd2.c
>> @@ -88,13 +88,13 @@ int __ext4_journal_stop(const char *where, =
unsigned int line, handle_t *handle)
>> 		return 0;
>> 	}
>>=20
>> +	err =3D handle->h_err;
>> 	if (!handle->h_transaction) {
>> -		err =3D jbd2_journal_stop(handle);
>> -		return handle->h_err ? handle->h_err : err;
>> +		rc =3D jbd2_journal_stop(handle);
>> +		return err ? err : rc;
>> 	}
>>=20
>> 	sb =3D handle->h_transaction->t_journal->j_private;
>> -	err =3D handle->h_err;
>> 	rc =3D jbd2_journal_stop(handle);
>>=20
>> 	if (!err)
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_A093F2CD-5876-4CB3-B319-3BAD035B1F0B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVhLNlnKl2rkXzB/gAQj+pQ/9GurtZDjk7V9CX0VlGSq88+HS55AubIOx
sb6nTIMPv7Idw5p6ZAqhwI30dHlj8CbSwUKs1U0Xgl7fD1iRApBMywtqZLZzaZ6I
Y3aUasXHKFFaP6WoPS7pB0JM4TpknoEt0ZGbB6KpC3JwZttcYJcReOmU84guJL0O
C14eslCm41o0qagLIH4wYUDsCBaCpLDHZ8FHBxgJpenm+p6Kt7Qpeytdu1XNttPB
SC/pm2aTjXfJv18pZwaiBd27e4JvMLbwZaV/WESt3s6ZHRQiwFz+09pXSKQIa5ZW
zjTP0uqcV1dfbhZePLl153PK12PcnIt/qgTkA1kEipPzR/bAeOwOT3kc/i2ftnMn
oBlGO6SbYWgGJaI0jdYbE8K5XF6OtkIyDaFp+fYTseBqNseciudMAchLqYAm9mKX
/jxI+hxiKF+e5zCTjQ6I/sgX5bzDemwIua+Oe3iFfM/VNy4c3SPYJP912pSuIEKV
ihokNUcDyPFyC9vzPTUxoyo3pqlNBEhV70ri0f9+lYbRybhN/PoGb38CKgP2IvlF
FKGzdszZ3zmgslgk+T7a1R8hH6PamJi+iqdpVjK427+jdCIVUbhBKh57WNtnVbP5
h0Qx9OtEHevTPIHcAWQBibeAUn1thPLXSpi/+85OpTmA1hXYckDkQMBjWPRXu3yK
GndpAqNIrF4=
=wfGg
-----END PGP SIGNATURE-----

--Apple-Mail=_A093F2CD-5876-4CB3-B319-3BAD035B1F0B--
