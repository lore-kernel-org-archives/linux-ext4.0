From: Chris Mason <chris.mason@oracle.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt barrier support is effective)
Date: Wed, 08 Dec 2010 07:20:24 -0500
Message-ID: <1291810586-sup-8211@think>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com> <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com> <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com> <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com> <1291751698-sup-9297@think> <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com> <1291754340-sup-1631@think> <
 AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com> <1291755258-sup-8760@think> <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:16980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0LHMVc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Dec 2010 07:21:32 -0500
In-reply-to: <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Jon Nelson's message of 2010-12-07 22:29:26 -0500:
> On Tue, Dec 7, 2010 at 3:02 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > Excerpts from Jon Nelson's message of 2010-12-07 15:48:58 -0500:
> >> On Tue, Dec 7, 2010 at 2:41 PM, Chris Mason <chris.mason@oracle.co=
m> wrote:
> >> > Excerpts from Jon Nelson's message of 2010-12-07 15:25:47 -0500:
> >> >> On Tue, Dec 7, 2010 at 2:02 PM, Chris Mason <chris.mason@oracle=
=2Ecom> wrote:
> >> >> > Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -05=
00:
> >> >> >> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@or=
acle.com> wrote:
> >> >> >> >> postgresql errors. Typically, header corruption but from =
the limited
> >> >> >> >> visibility I've had into this via strace, what I see is z=
eroed pages
> >> >> >> >> where there shouldn't be.
> >> >> >> >
> >> >> >> > This sounds a lot like a bug higher up than dm-crypt. =C2=A0=
Zeros tend to
> >> >> >> > come from some piece of code explicitly filling a page wit=
h zeros, and
> >> >> >> > that often happens in the corner cases for O_DIRECT and a =
few other
> >> >> >> > places in the filesystem.
> >> >> >> >
> >> >> >> > Have you tried triggering this with a regular block device=
?
> >> >> >>
> >> >> >> I just tried the whole set of tests, but with /dev/sdb direc=
tly (as
> >> >> >> ext4) without any crypt-y bits.
> >> >> >> It takes more iterations but out of 6 tests I had one failur=
e: same
> >> >> >> type of thing, 'invalid page header in block ....'.
> >> >> >>
> >> >> >> I can't guarantee that it is a full-page of zeroes, just wha=
t I saw
> >> >> >> from the (limited) stracing I did.
> >> >> >
> >> >> > Fantastic. Now for our usual suspects:
>=20
> Maybe not so fantastic. I kept testing and had no more failures. At
> all. After 40+ iterations I gave up.
> I went back to trying ext4 on a LUKS volume. The 'hit' ratio went to
> something like 1 in 3, or better.
>=20
> I will continue to do testing with and without LUKS. I did /not/
> reboot between tests, but I do start with a fresh postgres database.
>=20

Once we trigger once without dm-crypt, dm-crypt is off the hook.  Just
to verify, when you say without luks, you mean without any crypto bits
in use at all on the filesystems postgres uses?

Usually the trick to reproducing filesystem corruptions is adding memor=
y
pressure.  The corruption is probably a bad interaction between reads
and writes, and we need to make sure the reads actually happen.

http://oss.oracle.com/~mason/pin_ram.c

gcc -Wall -o pin_ram pin_ram.c

pin_ram -m 80%-of-your-ram-in-mb

The idea is to trigger constant reads without having to swap heavily.
80% might be too much.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
