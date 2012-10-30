From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Wed, 31 Oct 2012 09:14:41 +1100
Message-ID: <20121031091441.5fc6b412@notabene.brown>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
	<yq1ehkg8us1.fsf@sermon.lab.mkp.net>
	<20121030154844.1898f068@notabene.brown>
	<yq1a9v4884i.fsf@sermon.lab.mkp.net>
	<20121030201424.GD19559@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gUQY4rUg_Wu6MAFc_2U.0fO"; protocol="application/pgp-signature"
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab2J3WOX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 18:14:23 -0400
In-Reply-To: <20121030201424.GD19559@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/gUQY4rUg_Wu6MAFc_2U.0fO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Oct 2012 13:14:24 -0700 "Darrick J. Wong"
<darrick.wong@oracle.com> wrote:

> On Tue, Oct 30, 2012 at 08:19:41AM -0400, Martin K. Petersen wrote:
> > >>>>> "Neil" =3D=3D NeilBrown  <neilb@suse.de> writes:
> >=20
> > Neil,
> >=20
> > >> Might be nice to make the sysfs knob tweakable. Also, don't forget to
> > >> add a suitable blurb to Documentation/ABI/.
> >=20
> > Neil>  It isn't at all clear to me that having the sysfs knob
> > Neil>  'tweakable' is a good idea.  From the md/raid5 perspective, I
> > Neil>  would want to know for certain whether the pages in a give bio
> > Neil>  are guaranteed not to change, or if they might.  I could set the
> > Neil>  BDI_CAP_STABLE_WRITES and believe they will never change, or test
> > Neil>  the BDI_CAP_STABLE_WRITES and let that tell me if they might
> > Neil>  change or not.  But if the bit can be changed at any moment, then
> > Neil>  it can never be trusted and so becomes worthless to me.
> >=20
> > I was mostly interested in being able to turn it on for devices that
> > haven't explicitly done so. I agree that turning it off can be
> > problematic.
>=20
> I'm ok with having a tunable that can turn it on, but atm I can't really =
think
> of a convincing reason to let people turn it /off/.  If people yell loud =
enough
> I'll add it, but I'd rather not have to distinguish between "on because u=
ser
> set it on" vs "on because hw needs it".
>=20
> It'd be nice if the presence BDI_CAP_STABLE_WRITES meant that all filesys=
tems
> would wait on page writes.  Hrm, guess I'll see about adding that to the =
patch
> set.  Though ISTR that at least the vfat and ext2 maintainers weren't
> interested the last time I asked.

I'm still a little foggy on the exact semantics and use-cases for this flag.
I'll try to piece together the bits that I know and ask you to tell me what
I've missed or what I've got wrong.

 Stable writes are valuable when the filesystem or device driver calculates
 some sort of 'redundancy' information based on the page in memory that is
 about to be written.
 This could be:
      integrity data that will be sent with the page to the storage device
      parity over a number of pages that will be written to a separate devi=
ce
       (i.e. RAID5/RAID6).
      MAC or similar checksum that will be sent with the data over the netw=
ork
        and will be validated by the receiving device, which can then ACK or
        NAK depending on correctness.

 These could be implemented  in the filesystem or in the device driver, so
 either should be able to request stable writes.  If neither request stable
 writes, then the cost of stable writes should be avoided.

 For the device driver (or network transport), not getting stable writes wh=
en
 requested might be a performance issue, or it might be a correctness issue.
 e.g. if an unstable write causes a MAC to be wrong, the network layer can
 simply arrange a re-transmit.  If an unstable write causes RAID5 parity to
 be wrong, that unstable write could cause data corruption.

 For the filesystem, the requirement to provide stable writes could just be=
 a
 performance cost (a few extra waits) or it could require significant
 re-working of the code (you say vfat and ext2 aren't really comfortable wi=
th
 supporting them).

 Finally there is the VFS/VM which needs to provide support for stable
 writes.  It already does - your flag seems to just allow clients of the
 VFS/VM to indicate whether stable writes are required.

 So there seem to be several cases:

 1/ The filesystem wants to always use stable writes.  It just sets the fla=
g,
    and the device will see stable writes whether it cares or not.  This wo=
uld
    happen if the filesystem is adding integrity data.
 2/ The device would prefer stable writes if possible.  This would apply to
    iscsi (??) as it needs to add some sort of checksum before putting the
    data on the network
 3/ The device absolutely requires stable writes, or needs to provide
    stability itself by taking a copy (md/RAID5 does this).  So it needs to
    know whether each write is stable, or it cannot take advantage of stable
    writes.


 So I see a need for 2 flags here.
 The first one is set by the device or transport to say "I would prefer
 stable writes if possible".
 The second is set by the filesystem, either because it has its own needs, =
or
 because it sees the first flag set on the device and chooses to honour it.
 The VFS/VM would act based on this second flag, and devices like md/RAID5
 would set the first flag, and assume writes are stable if the second flag =
is
 also set.

 This implies that setting that second flag must be handled synchronously by
 the filesystem, so that the device doesn't see the flag set until the
 filesystem has committed to honouring it.  That seems to make a mount (or
 remount) option the safest way to set it.

 Comments?

NeilBrown

--Sig_/gUQY4rUg_Wu6MAFc_2U.0fO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJBRUTnsnt1WYoG5AQJ4PhAAhcuZXGjHWdpsT8zy9KH7uXD1shHaIxX9
6MNTv90A0WDpGhNGZNeqGqQxQRFvBXDCbweBB53jPxCEOKVirzL0OCdPmygfY+aG
ynlnHm3ntrlAyZDo7tOKKb60JjBrr5hMmZdpzlAOZzuYMKaelwHThnic1p2Q+kmB
8h4nYTk7mEEKVVEEpYfwCKRNteOrs7Y3AKsv3vHcUq6lElE+CqWhj1gS3tP870SK
KOayAtvPIbPrWn44Bpm/DHKJmL5XhF4YMccEuElLTCvg6yzqd+SgNMqxyB3LGSEu
eHUmDSJ6iMjDerGetJmJURAfgKEjRGIXnmWFtq9QW7eaId/H6Oui281miKtuzfAf
YySPLbWMIOTa2BvFpBXjPHu64mZyf+kwaZbGucvVR4LB1bbIJYuWruGkIYwl+AJR
BbtgHqwpuIoasuK64MkdAFCH1v71vewA4CcxwOjHHweX2FKSIOVZs2rPOnElu36P
HZSdpKrGc6AL2z2H3Ho1v5hvfWlhRPcPr/DGo1yrIRrQe/22YUujqiDnL6Rz7gJ+
LanRtVyPKj+tfa4pS+LlyCaz+3hQ4ONiO7JgMrrGavErJKtKB76j+All4DjzEkyn
/GkIXhA94HSORS4ONSk0cda0OjPc8oQBLuhhSFx7z/pobKlxaYoPpL5xu1ADdUA0
YTGw7jRZUzM=
=zTRD
-----END PGP SIGNATURE-----

--Sig_/gUQY4rUg_Wu6MAFc_2U.0fO--
