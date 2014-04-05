From: Markus <M4rkusXXL@web.de>
Subject: Re: Dirty ext4 blocks system startup
Date: Sat, 05 Apr 2014 15:10:07 +0200
Message-ID: <5060780.kj9pBZIMgD@web.de>
References: <1459400.cqhC1n3S74@f209> <4785109.JJCKTTZWOe@f209> <20140404182020.GA8888@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61969 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbaDENKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Apr 2014 09:10:09 -0400
In-Reply-To: <20140404182020.GA8888@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

Its a md-raid6 of about 10 TiB.
The disks have no bad sectors, long smart-test completetd without error=
s and=20
raid check does not have any mismatched blocks.

The e2image is still running. Dont know how it big it will grow.

The e2fsck messages:
> e2fsck 1.43-WIP (4-Feb-2014)
> /dev/md5: recovering journal
> JBD: Invalid checksum recovering block 1152 in log
> JBD: Invalid checksum recovering block 1152 in log
> =E2=80=A6
> JBD: Invalid checksum recovering block 1152 in log
> Killed

(needed to kill -9 the process)
=3D> e2fsck/recovery.c:594

> debugfs 1.43-WIP (4-Feb-2014)
> /dev/md5: Block bitmap checksum does not match bitmap while reading b=
lock
> bitmap

The filesystem was not loaded. Catastrophic mode does work.

Or what "exact error messages" do you mean?

metadata_csum is enabled, correct.


Thanks,
Markus


PS: Yes that is the correct lkml message.


Darrick J. Wong wroteat 04.04.2014:
> On Fri, Apr 04, 2014 at 12:35:45PM +0200, Markus wrote:
> > Hi!
> >=20
> > I have a dirty ext4 volume. The system just hangs at startup. After=
=20
removing that volume from fstab the system starts.
> >=20
> > Mount and e2fsck just flood with "Invalid checksum recovering block=
 1152=20
in log" messages.
> >=20
> > (Mounting with ro,noload let me access most files.)
> >=20
> > I also tried the e2fsck from current git.
> >=20
> > debugfs just fails with "Block bitmap checksum does not match bitma=
p while=20
reading block bitmap". (catastrophic mode does work)
> >=20
> > Three points:
> > - e2fsck should not get into an endless loop, blocking the system.
> > - mount should not get into an endless loop, blocking the system an=
d=20
flooding the system log.
> > - At least e2fsck should fix the filesystem.
> >=20
> >=20
> > Any help or hints?
>=20
> Hmm, that's probably a bug in the journal replay code. :(
>=20
> Can you send me the output of "e2image -r /dev/sdXX - | bzip2 > hd.e2=
i.bz2"=20
if
> it's not too huge?  The exact error messages (if you can capture/phot=
ograph
> them) would also be useful.
>=20
> I'm guessing you have metadata_csum enabled...
>=20
> PS: lkml.org is dead; I'm assuming the URL referenced the discussion =
"Ext4
> Recovery: Invalid checksum recovering block # in log" but it's hard t=
o tell
> since there was no subject line provided with that URL.
>=20
> --D
> >=20
> >=20
> > Thanks,
> > Markus
> >=20
> >=20
> > PS: Original lkml-mail:
> > https://lkml.org/lkml/2014/4/1/467
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
