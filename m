From: Chris Mason <chris.mason@oracle.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt barrier support is effective)
Date: Tue, 07 Dec 2010 16:02:30 -0500
Message-ID: <1291755258-sup-8760@think>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com> <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com> <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com> <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com> <1291751698-sup-9297@think> <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com> <1291754340-sup-1631@think> <
 AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Jon Nelson's message of 2010-12-07 15:48:58 -0500:
> On Tue, Dec 7, 2010 at 2:41 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > Excerpts from Jon Nelson's message of 2010-12-07 15:25:47 -0500:
> >> On Tue, Dec 7, 2010 at 2:02 PM, Chris Mason <chris.mason@oracle.co=
m> wrote:
> >> > Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -0500:
> >> >> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@oracl=
e.com> wrote:
> >> >> >> postgresql errors. Typically, header corruption but from the=
 limited
> >> >> >> visibility I've had into this via strace, what I see is zero=
ed pages
> >> >> >> where there shouldn't be.
> >> >> >
> >> >> > This sounds a lot like a bug higher up than dm-crypt. =C2=A0Z=
eros tend to
> >> >> > come from some piece of code explicitly filling a page with z=
eros, and
> >> >> > that often happens in the corner cases for O_DIRECT and a few=
 other
> >> >> > places in the filesystem.
> >> >> >
> >> >> > Have you tried triggering this with a regular block device?
> >> >>
> >> >> I just tried the whole set of tests, but with /dev/sdb directly=
 (as
> >> >> ext4) without any crypt-y bits.
> >> >> It takes more iterations but out of 6 tests I had one failure: =
same
> >> >> type of thing, 'invalid page header in block ....'.
> >> >>
> >> >> I can't guarantee that it is a full-page of zeroes, just what I=
 saw
> >> >> from the (limited) stracing I did.
> >> >
> >> > Fantastic. Now for our usual suspects:
> >> >
> >> > 1) Is postgres using O_DIRECT? =C2=A0If yes, please turn it off
> >>
> >> According to strace, O_DIRECT didn't show up once during the test.
> >>
> >> > 2) Is postgres allocating sparse files? =C2=A0If yes, please hav=
e it fully
> >> > allocate the file instead.
> >>
> >> That's a tough one. I don't think postgresql does that, but I'm no=
t an
> >> expert here.
> >
> > Ok, please compare du -k and du -k --apparent-size for each of the
> > files involved in the postgres run.
>=20
> Because this is all done in a transaction (which fails), and because
> the table is a TEMPORARY table, there *are* no files once the
> transaction fails because postgresql unlinks them.
>=20
> I can modify the test to use real tables and do things outside of a
> transaction, however.

That would really help.

>=20
> I was using fdatasync[1] and now I'm using sync. I'm on 9 iterations
> without a failure (on ext4 - no crypt). Theoretically, these settings
> only make a difference in the event of a crash. However, could they
> make a difference in terms of the paths taken in the kernel?

Yes, the paths are different but similar.  If ext4 is causing zeros to
get stuffed somewhere, it should happen for both O_SYNC and fdatasync.

-chris
