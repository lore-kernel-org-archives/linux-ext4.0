From: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems	larger
 than 32-bit blocks (take 2).
Date: Tue, 05 Jun 2007 15:26:53 +0200
Message-ID: <4665649D.8010302@bull.net>
References: <20070601105234.4be40028@rx8>	 <20070601225441.GF5181@schatzie.adilger.int> <20070604113210.1a76934b@gara>	 <20070604175728.GT5181@schatzie.adilger.int>	 <1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>	 <20070605064109.2cb6bad7@gara> <1181049283.18452.0.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4F631CF721AB0DB29AD953F3"
Cc: "Jose R. Santos" <jrs@us.ibm.com>, cmm@us.ibm.com,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46518 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761428AbXFEN1E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 09:27:04 -0400
In-Reply-To: <1181049283.18452.0.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4F631CF721AB0DB29AD953F3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dave Kleikamp wrote:
> On Tue, 2007-06-05 at 06:41 -0500, Jose R. Santos wrote:
>> On Mon, 04 Jun 2007 16:01:45 -0700
>> Mingming Cao <cmm@us.ibm.com> wrote:
>>
>>> On Mon, 2007-06-04 at 11:57 -0600, Andreas Dilger wrote:
>>>> On Jun 04, 2007  11:32 -0500, Jose R. Santos wrote:
>>>>> Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
>>>>> than 32bit block sizes during mount time.  This ensure proper recor=
d
>>>>> lenth when writing to the journal.
>>>>>
>>>>> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
>>>>> ---
>>>>>  fs/ext4/super.c |   11 +++++++++++
>>>>>  1 file changed, 11 insertions(+)
>>>>>
>>>>> Index: linux-2.6.22-rc3/fs/ext4/super.c
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> --- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.02836=
0650 -0500
>>>>> +++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-04 11:05:11.389126418 =
-0500
>>>>> @@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
>>>>>  		goto failed_mount3;
>>>>>  	}
>>>>> =20
>>>>> +        /*
>>>>> +	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
>>>>> +	 * with more that 32-bit block counts
>>>>> +	 */
>>>>> +	if(es->s_blocks_count_hi &&
>>> This need to be le32_to_cpu(es->s_blocks_count_hi)
>> I'm curious,
>>
>> Why do we need to do an endian conversion to check for a non-zero valu=
e
>> in s_blocks_count_hi?  Seems unnecessary here.
>=20
> Jose is right.  The endian conversion is unnecessary.
>=20
> Shaggy

But by using le32_to_cpu(es->s_blocks_count_hi) you explicitly mark the v=
ariable
as a little-endian.
So if someone reads the code, he knows this is a little-endian value and =
this
allows to avoid errors if later variable must be tested for other value t=
han 0.

For instance, you have :

if(es->s_blocks_count_hi)

and later the value should be compared to 10, how do you know easily you =
should use:

if (le32_to_cpu(es->s_blocks_count_hi) =3D=3D 10)

instead of

if(es->s_blocks_count_hi =3D=3D 10)

I think writing like Mingming asks should allow to avoid errors later.

(and code becomes really self-explicit...)

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
       "Any sufficiently advanced technology is
  indistinguishable from magic." - Arthur C. Clarke


--------------enig4F631CF721AB0DB29AD953F3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGZWSi9Kffa9pFVzwRAnluAKDScH0G1e0dGLKb6UMYhkBAEWisMQCfdwI0
omEc0JicDooSw1jxGgsp9m4=
=xlqA
-----END PGP SIGNATURE-----

--------------enig4F631CF721AB0DB29AD953F3--
