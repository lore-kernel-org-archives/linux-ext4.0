From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: [PATCH] make ext4_valid_block_bitmap() more verbose
Date: Mon, 15 Nov 2010 20:22:58 +0100
Message-ID: <4CE18892.9020908@ddn.com>
References: <201011130026.51268.bs_lists@aakef.fastmail.fm> <4CE15DF8.4030600@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC3C33BF9C36ABC1BB0064DF2"
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <andreas.dilger@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:30378 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab0KOTXC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Nov 2010 14:23:02 -0500
In-Reply-To: <4CE15DF8.4030600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enigC3C33BF9C36ABC1BB0064DF2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/15/2010 05:21 PM, Eric Sandeen wrote:
> On 11/12/10 5:26 PM, Bernd Schubert wrote:
>> The real issue we want to debug with the patch below actually came up =
while=20
>> stress testing Lustre using the RHEL5.5 kernel (so 2.6.32'ish ext4), b=
ut a=20
>> more verbose error function should not hurt for vanilla ext4 either.
>>
>> make ext4_valid_block_bitmap() more verbose
>>
>> While running our stress test suite, ext4_valid_block_bitmap()=20
>> frequently complains about an invalid block bitmap.
>> However, e2fsck does not find anything. So in oder to be able
>> to better debug this issue, make the function more verbose and=20
>> let it complain about the two possible invalid bitmaps.
>=20
> Making a raw e2image of the problematic filesystem would let us take a
> look at why e2fsck isn't finding problems; unless you plan to fix that
> yourself as well, which is just fine of course.  :)
>=20

I already captured an e2image and will do again on Wednesday, now that I
could reproduce it again with the updated code. Unfortunately no time
before. Will try to check out myself with debugfs first, if there is
really something wrong. It might be a race in the code as well...

Cheers,
Bernd


--------------enigC3C33BF9C36ABC1BB0064DF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzhiJIACgkQqh74FqyuOzRa1gCgveZvUIjiSikatw07BLrbnm/7
1gMAn14TFfgCLA3oAwyWQY96+EP/vzsp
=Hn8h
-----END PGP SIGNATURE-----

--------------enigC3C33BF9C36ABC1BB0064DF2--
