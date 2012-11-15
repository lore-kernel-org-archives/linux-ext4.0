From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: ext4 settings in an embedded system
Date: Thu, 15 Nov 2012 12:38:47 +0200
Message-ID: <1352975927.2221.23.camel@sauron.fi.intel.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
	 <1352968933.2221.16.camel@sauron.fi.intel.com>
	 <CAA0+VHyODd+hsSL6FBqcLGb_r3ViHmL78ay=8k5CJeP0=Z2k7A@mail.gmail.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DNJ2HylXlMreOVyaHHdd"
Cc: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>, linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992967Ab2KOKiI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 05:38:08 -0500
In-Reply-To: <CAA0+VHyODd+hsSL6FBqcLGb_r3ViHmL78ay=8k5CJeP0=Z2k7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-DNJ2HylXlMreOVyaHHdd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-15 at 13:01 +0300, Andrey Sidorov wrote:
> On Thu, Nov 15, 2012 at 12:42 PM, Artem Bityutskiy <dedekind1@gmail.com> =
wrote:
>=20
> > We conducted some 3 years ago. Results were quite good for ext4 - in
> > many cases it could recover without a need to run ckfs.ext4, sometimes
> > it was not mountable, but ckfs.ext4 helped.
> >
> > On the opposite, ext3 constantly required ckfs.ext3, and sometimes died
> > so badly that even ckfs.ext3 could not recover it.
>=20
> We ran about 6000 cycles of power resets with linux 2.6.37. The test
> was to run 3 tar processes unpacking linux kernel archive and power
> off after about 15 seconds. There were only 3 failures when file
> system couldn't be mounted, but that was due to HDD failure
> (unreadable sector in journal area). e2fsck successfully recovered
> those corruptions. As for software itself, there was no single issue
> and we never needed to run fsck after power loss. So I'd say that ext4
> is very tolerant to power losses at least in 2.6.37 assuming barriers
> and ordered data mode. I however understand this test is quite basic
> and any way results can be different for different kernels.

Very different experience indeed, shoes that everyone has to conduct own
power-cut tests in own system. I did not say that we were running on
eMMC.

--=20
Best Regards,
Artem Bityutskiy

--=-DNJ2HylXlMreOVyaHHdd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQpMY3AAoJECmIfjd9wqK0GmcQAIz4z+mRYXGHtVanvXbQlRjV
d7tW2amFQ02BX08aNndWhvvN22CayPYcyxZuH1tTkbgBivhq6G2TSobXkCrW72yL
BraSaAIcCK/GK9mW3jNKKzhnutkbqHhPkDucYsq2l4Za5SrrYn2ukPgdo8vCNr1d
3vVRm3fUDgDi8hubYXWr6ylrFLPusJc9sW/VitBbp5Az2zv8/wU3Ljpb+Hp0omqn
Y1x42sDGLA8/UPlnPK3C0FydfDNAdvZ8cXGw1SA7htGCPzOQFZiDA4ZYQEttKJ+g
YTvSTDdBVtGPn4N0sUKlrnjV3aDl1AZAVl3DgmBc1+9SXftP0PVeI42F7wrFLhAT
AxovFfAXWyDq600qjyDIbvaCCwjEB0+dDOf7lq/CNb3AQGJ8RxnL1nbiXJ5JfFTm
ykoeyuWnmvKe8bO3VmA83v52IXk9Lzuvqc2+SCBZvMuSlA8sKzjjJY8Lqo1z67DD
y7cJtXwmXtbK3pzi1vBH+84LxFlh3eFTcrFm/iqQ97iIXV/fwQuFn/FdFTB7C24Z
ynkoRq3AeY1qWG9WIOXUvpODFYJRulQ3jXCJ/rDMD3kexJC0z8CoRbVl8Fdmbbh1
ur/vKTDm4F79lV2UBVsLyymtEF7K8TqbHBake/+3/xyaTdP4p93R6f0kYNecvhRe
V10vrkDmcPVGjezToDUK
=Vsjn
-----END PGP SIGNATURE-----

--=-DNJ2HylXlMreOVyaHHdd--

