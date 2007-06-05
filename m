From: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger
 than 32-bit blocks (take 2).
Date: Tue, 05 Jun 2007 18:07:30 +0200
Message-ID: <46658A42.7040105@bull.net>
References: <20070601105234.4be40028@rx8>	<20070601225441.GF5181@schatzie.adilger.int>	<20070604113210.1a76934b@gara>	<20070604175728.GT5181@schatzie.adilger.int>	<1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>	<20070605064109.2cb6bad7@gara>	<1181049283.18452.0.camel@kleikamp.austin.ibm.com>	<4665649D.8010302@bull.net>	<20070605084937.7622258a@gara>	<46656D40.4050505@bull.net> <20070605104657.13d60531@gara>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig00612149DF5FDA1C63AC066B"
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, cmm@us.ibm.com,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47961 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764415AbXFEQHh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 12:07:37 -0400
In-Reply-To: <20070605104657.13d60531@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig00612149DF5FDA1C63AC066B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jose R. Santos wrote:
> On Tue, 05 Jun 2007 16:03:44 +0200
> Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>> Jose R. Santos wrote:
>>> Hi Laurent,
>>>
>>> In this particular case though, the value of s_blocks_count_hi should=
 not be
>>> uses on its own.  The correct way would be to use ext4_blocks_count()=
 which
>>> already does the endian conversion.  If you think the code could conf=
use
>>> people as to how to access the data in s_blocks_count_hi, wouldn't hi=
ding it
>>> through the use of a macro make more sense than doing an unnecessary =
endian
>>> conversion?
>>>
>> Yes, I think the code could confuse people, but I don't think defining=
 "Yet
>> Another Macro" is a good choice (IMHO).
>>
>> I think we can resolve this (non-)issue by two ways:
>> - using le32_to_cpu() (but I agree it does an unnecessary endian conve=
rsion on
>> big-endian systems)
>=20
> I just think that adding extra instructions for the sake of slightly
> better code readability is wrong, especially when the value
> s_blocks_count_hi should not be used on its own.
>=20
>> - put a comment on the line (but are we allowed to put comments in ker=
nel source
>> code... ;-) )
>=20
> One advantage of a macro here is that we would make the code more
> explicit and should be able to eliminate the need for those 4 lines of
> comments that this patch adds.

IMHO, you should do as _you_ think it is better... but as Mingming did th=
e first
comment perhaps she can explain what she thought.

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
       "Any sufficiently advanced technology is
  indistinguishable from magic." - Arthur C. Clarke


--------------enig00612149DF5FDA1C63AC066B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGZYpG9Kffa9pFVzwRAmczAJ9tlyDCoeWUfpGlmxSY3rjbBrQxCwCdHoxt
Vq2MuLaasM5bcvh3MnFdCDw=
=sxYw
-----END PGP SIGNATURE-----

--------------enig00612149DF5FDA1C63AC066B--
