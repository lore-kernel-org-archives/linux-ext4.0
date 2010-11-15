From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: [PATCH] make ext4_valid_block_bitmap() more verbose
Date: Mon, 15 Nov 2010 20:15:59 +0100
Message-ID: <4CE186EF.2090508@ddn.com>
References: <201011130026.51268.bs_lists@aakef.fastmail.fm> <E2A9104D-764C-42AD-B479-51333960AF19@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB52A10B275B799502A1A99CB"
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:30156 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab0KOTQI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Nov 2010 14:16:08 -0500
In-Reply-To: <E2A9104D-764C-42AD-B479-51333960AF19@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enigB52A10B275B799502A1A99CB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/13/2010 12:56 AM, Andreas Dilger wrote:
> On 2010-11-12, at 16:26, Bernd Schubert wrote:
>> The real issue we want to debug with the patch below actually came
>> up while stress testing Lustre using the RHEL5.5 kernel (so
>> 2.6.32'ish ext4), but a more verbose error function should not hurt
>> for vanilla ext4 either.
>>=20
>> make ext4_valid_block_bitmap() more verbose
>>=20
>> While running our stress test suite, ext4_valid_block_bitmap()=20
>> frequently complains about an invalid block bitmap. However, e2fsck
>> does not find anything. So in oder to be able to better debug this
>> issue, make the function more verbose and let it complain about the
>> two possible invalid bitmaps.
>=20
> Bernd, thanks for sending this in.  I like the idea of making these
> messages more verbose, since they should rarely be hit and when they
> are it would be good to know why these checks failed.

Andreas, thanks for your helpful review, I will send an updated patch on
Wednesday.

>> +	if (!valid) +		ext4_error(sb, "Invalid block bitmap - block_group
>> =3D %d", +			   block_group);
>=20
> It would probably be worthwhile to also print the block number of the
> bitmap itself.

I guess you mean bitmap_blk here? But that changes for every of the
possible checks, so I already printed it above. Is it worth to print it
again? And what if more than one problem is found, might become a bit
confusing then?


Thanks,
Bernd


--------------enigB52A10B275B799502A1A99CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzhhvQACgkQqh74FqyuOzSbcgCfUUG6g3nlyDTy/yTzamnWQZOh
eqMAoKTUEtnBZQFZCYn+Q8qrLgjUYx7H
=Cvwo
-----END PGP SIGNATURE-----

--------------enigB52A10B275B799502A1A99CB--
