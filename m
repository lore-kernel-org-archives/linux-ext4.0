From: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger
 than 32-bit blocks (take 2).
Date: Tue, 05 Jun 2007 16:03:44 +0200
Message-ID: <46656D40.4050505@bull.net>
References: <20070601105234.4be40028@rx8>	<20070601225441.GF5181@schatzie.adilger.int>	<20070604113210.1a76934b@gara>	<20070604175728.GT5181@schatzie.adilger.int>	<1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>	<20070605064109.2cb6bad7@gara>	<1181049283.18452.0.camel@kleikamp.austin.ibm.com>	<4665649D.8010302@bull.net> <20070605084937.7622258a@gara>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig01BF48BFC541AC051CE67D94"
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, cmm@us.ibm.com,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60912 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024AbXFEODx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 10:03:53 -0400
In-Reply-To: <20070605084937.7622258a@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig01BF48BFC541AC051CE67D94
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jose R. Santos wrote:
> On Tue, 05 Jun 2007 15:26:53 +0200 Laurent Vivier <Laurent.Vivier@bull.=
net>
> wrote:
>=20
>> Dave Kleikamp wrote:
>>> Jose is right.  The endian conversion is unnecessary.
>>>=20
>>> Shaggy
>> But by using le32_to_cpu(es->s_blocks_count_hi) you explicitly mark th=
e
>> variable as a little-endian. So if someone reads the code, he knows th=
is is
>> a little-endian value and this allows to avoid errors if later variabl=
e
>> must be tested for other value than 0.
>>=20
>> For instance, you have :
>>=20
>> if(es->s_blocks_count_hi)
>>=20
>> and later the value should be compared to 10, how do you know easily y=
ou
>> should use:
>>=20
>> if (le32_to_cpu(es->s_blocks_count_hi) =3D=3D 10)
>>=20
>> instead of
>>=20
>> if(es->s_blocks_count_hi =3D=3D 10)
>>=20
>> I think writing like Mingming asks should allow to avoid errors later.=

>>=20
>> (and code becomes really self-explicit...)
>>=20
>> Regards, Laurent
>=20
> Hi Laurent,
>=20
> In this particular case though, the value of s_blocks_count_hi should n=
ot be
> uses on its own.  The correct way would be to use ext4_blocks_count() w=
hich
> already does the endian conversion.  If you think the code could confus=
e
> people as to how to access the data in s_blocks_count_hi, wouldn't hidi=
ng it
> through the use of a macro make more sense than doing an unnecessary en=
dian
> conversion?
>=20

Yes, I think the code could confuse people, but I don't think defining "Y=
et
Another Macro" is a good choice (IMHO).

I think we can resolve this (non-)issue by two ways:
- using le32_to_cpu() (but I agree it does an unnecessary endian conversi=
on on
big-endian systems)
- put a comment on the line (but are we allowed to put comments in kernel=
 source
code... ;-) )

Regards
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
       "Any sufficiently advanced technology is
  indistinguishable from magic." - Arthur C. Clarke


--------------enig01BF48BFC541AC051CE67D94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGZW1G9Kffa9pFVzwRAkxuAJ0WOJcGiAlDU8iXDDy2sQ0WOv3rTQCg0+nZ
ujHR67nxz3vmIDZnM/wKNYc=
=2p2o
-----END PGP SIGNATURE-----

--------------enig01BF48BFC541AC051CE67D94--
