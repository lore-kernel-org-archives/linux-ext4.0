From: Dave Chinner <david@fromorbit.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 16 Dec 2010 14:37:18 +1100
Message-ID: <20101216033718.GM9925@dastard>
References: <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com>
 <1291747731-sup-3099@think>
 <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
 <1291751698-sup-9297@think>
 <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com>
 <1291754340-sup-1631@think>
 <AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com>
 <1291755258-sup-8760@think>
 <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
 <1291810586-sup-8211@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:43847 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401Ab0LPDhg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Dec 2010 22:37:36 -0500
Content-Disposition: inline
In-Reply-To: <1291810586-sup-8211@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 08, 2010 at 07:20:24AM -0500, Chris Mason wrote:
> Excerpts from Jon Nelson's message of 2010-12-07 22:29:26 -0500:
> > On Tue, Dec 7, 2010 at 3:02 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
> > > Excerpts from Jon Nelson's message of 2010-12-07 15:48:58 -0500:
> > >> On Tue, Dec 7, 2010 at 2:41 PM, Chris Mason <chris.mason@oracle.=
com> wrote:
> > >> > Excerpts from Jon Nelson's message of 2010-12-07 15:25:47 -050=
0:
> > >> >> On Tue, Dec 7, 2010 at 2:02 PM, Chris Mason <chris.mason@orac=
le.com> wrote:
> > >> >> > Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -=
0500:
> > >> >> >> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@=
oracle.com> wrote:
> > >> >> >> >> postgresql errors. Typically, header corruption but fro=
m the limited
> > >> >> >> >> visibility I've had into this via strace, what I see is=
 zeroed pages
> > >> >> >> >> where there shouldn't be.
> > >> >> >> >
> > >> >> >> > This sounds a lot like a bug higher up than dm-crypt. =A0=
Zeros tend to
> > >> >> >> > come from some piece of code explicitly filling a page w=
ith zeros, and
> > >> >> >> > that often happens in the corner cases for O_DIRECT and =
a few other
> > >> >> >> > places in the filesystem.
> > >> >> >> >
> > >> >> >> > Have you tried triggering this with a regular block devi=
ce?
> > >> >> >>
> > >> >> >> I just tried the whole set of tests, but with /dev/sdb dir=
ectly (as
> > >> >> >> ext4) without any crypt-y bits.
> > >> >> >> It takes more iterations but out of 6 tests I had one fail=
ure: same
> > >> >> >> type of thing, 'invalid page header in block ....'.
> > >> >> >>
> > >> >> >> I can't guarantee that it is a full-page of zeroes, just w=
hat I saw
> > >> >> >> from the (limited) stracing I did.
> > >> >> >
> > >> >> > Fantastic. Now for our usual suspects:
> >=20
> > Maybe not so fantastic. I kept testing and had no more failures. At
> > all. After 40+ iterations I gave up.
> > I went back to trying ext4 on a LUKS volume. The 'hit' ratio went t=
o
> > something like 1 in 3, or better.
> >=20
> > I will continue to do testing with and without LUKS. I did /not/
> > reboot between tests, but I do start with a fresh postgres database=
=2E
> >=20
>=20
> Once we trigger once without dm-crypt, dm-crypt is off the hook.  Jus=
t
> to verify, when you say without luks, you mean without any crypto bit=
s
> in use at all on the filesystems postgres uses?
>=20
> Usually the trick to reproducing filesystem corruptions is adding mem=
ory
> pressure.  The corruption is probably a bad interaction between reads
> and writes, and we need to make sure the reads actually happen.
>=20
> http://oss.oracle.com/~mason/pin_ram.c
>=20
> gcc -Wall -o pin_ram pin_ram.c
>=20
> pin_ram -m 80%-of-your-ram-in-mb

Implemented in xfstests about 10 years ago:

http://git.kernel.org/?p=3Dfs/xfs/xfstests-dev.git;a=3Dblob;f=3Dsrc/use=
mem.c;h=3Db8794a6b209cebf8dbf312a8ef131e2e54b18d29;hb=3DHEAD

:P

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
