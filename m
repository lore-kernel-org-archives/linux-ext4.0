From: Markus <M4rkusXXL@web.de>
Subject: Re: Dirty ext4 blocks system startup
Date: Mon, 07 Apr 2014 12:58:40 +0200
Message-ID: <7488414.mDGKOZ8cSK@web.de>
References: <1459400.cqhC1n3S74@f209> <20140404182020.GA8888@birch.djwong.org> <5060780.kj9pBZIMgD@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:54007 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbaDGK6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 06:58:43 -0400
In-Reply-To: <5060780.kj9pBZIMgD@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

=46inally e2image finished successfully. But the produced file is way t=
oo big for a mail.

Any other possibility?
(e2image does dump everything except file data and free space. But the =
problem seems to be just in the bitmap and/or journal.)

Actually, when I look at the code around e2fsck/recovery.c:594
The error is detected and continue is called.
But tagp/tag is never changed, but the checksum is always compared to t=
he one from tag. Intended?


Thanks,
Markus


Markus wrote on 05.04.2014:
> Hi!
>=20
> Its a md-raid6 of about 10 TiB.
> The disks have no bad sectors, long smart-test completetd without err=
ors and=20
> raid check does not have any mismatched blocks.
>=20
> The e2image is still running. Dont know how it big it will grow.
>=20
> The e2fsck messages:
> > e2fsck 1.43-WIP (4-Feb-2014)
> > /dev/md5: recovering journal
> > JBD: Invalid checksum recovering block 1152 in log
> > JBD: Invalid checksum recovering block 1152 in log
> > =E2=80=A6
> > JBD: Invalid checksum recovering block 1152 in log
> > Killed
>=20
> (needed to kill -9 the process)
> =3D> e2fsck/recovery.c:594
>=20
> > debugfs 1.43-WIP (4-Feb-2014)
> > /dev/md5: Block bitmap checksum does not match bitmap while reading=
 block
> > bitmap
>=20
> The filesystem was not loaded. Catastrophic mode does work.
>=20
> Or what "exact error messages" do you mean?
>=20
> metadata_csum is enabled, correct.
>=20
>=20
> Thanks,
> Markus
>=20
>=20
> PS: Yes that is the correct lkml message.
>=20
>=20
> Darrick J. Wong wroteat 04.04.2014:
> > On Fri, Apr 04, 2014 at 12:35:45PM +0200, Markus wrote:
> > > Hi!
> > >=20
> > > I have a dirty ext4 volume. The system just hangs at startup. Aft=
er=20
> removing that volume from fstab the system starts.
> > >=20
> > > Mount and e2fsck just flood with "Invalid checksum recovering blo=
ck 1152=20
> in log" messages.
> > >=20
> > > (Mounting with ro,noload let me access most files.)
> > >=20
> > > I also tried the e2fsck from current git.
> > >=20
> > > debugfs just fails with "Block bitmap checksum does not match bit=
map while=20
> reading block bitmap". (catastrophic mode does work)
> > >=20
> > > Three points:
> > > - e2fsck should not get into an endless loop, blocking the system=
=2E
> > > - mount should not get into an endless loop, blocking the system =
and=20
> flooding the system log.
> > > - At least e2fsck should fix the filesystem.
> > >=20
> > >=20
> > > Any help or hints?
> >=20
> > Hmm, that's probably a bug in the journal replay code. :(
> >=20
> > Can you send me the output of "e2image -r /dev/sdXX - | bzip2 > hd.=
e2i.bz2"=20
> if
> > it's not too huge?  The exact error messages (if you can capture/ph=
otograph
> > them) would also be useful.
> >=20
> > I'm guessing you have metadata_csum enabled...
> >=20
> > PS: lkml.org is dead; I'm assuming the URL referenced the discussio=
n "Ext4
> > Recovery: Invalid checksum recovering block # in log" but it's hard=
 to tell
> > since there was no subject line provided with that URL.
> >=20
> > --D
> > >=20
> > >=20
> > > Thanks,
> > > Markus
> > >=20
> > >=20
> > > PS: Original lkml-mail:
> > > https://lkml.org/lkml/2014/4/1/467
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
