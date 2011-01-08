From: Jens Kasten <igraltist@rsbac.org>
Subject: Re: trim support on 2.6.37
Date: Sat, 08 Jan 2011 02:11:47 +0100
Message-ID: <1294449107.8289.1.camel@jaschtschik-malo>
References: <1294440738.15738.12.camel@jaschtschik-pc>
	 <AANLkTimkf4n8Oyf0c17SCZFbNrpdV9mbcHeTQpkMxbMJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.rsbac.org ([81.169.183.215]:47115 "EHLO www.rsbac.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1AHBJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 20:09:50 -0500
In-Reply-To: <AANLkTimkf4n8Oyf0c17SCZFbNrpdV9mbcHeTQpkMxbMJ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Freitag, den 07.01.2011, 18:29 -0500 schrieb Greg Freemyer:
> On Fri, Jan 7, 2011 at 5:52 PM, Jens Kasten <igraltist@rsbac.org> wro=
te:
> > Hi list,
> >
> > It is the first time the i write to this list.
> > I am not sure if it the right place.
> >
> > I use the kernel 2.6.37 with cryptsetup and lvm on a intel ssd.
> > In the logfile after booting i see this entry:
> > EXT4-fs (dm-1): re-mounted. Opts: discard,errors=3Dremount-ro
> > EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: di=
scard
> > EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: di=
scard
> > EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: di=
scard
> > EXT4-fs warning (device dm-1): ext4_issue_discard:2619: discard not
> > supported, disabling
> > EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
> > supported, disabling
> > EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
> > supported, disabling
> > EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
> > supported, disabling
> > EXT4-fs (sda1): re-mounted. Opts: discard,commit=3D0
> > EXT4-fs (dm-3): re-mounted. Opts: discard,commit=3D0
> > EXT4-fs (dm-2): re-mounted. Opts: discard,commit=3D0
> >
> > The mount command shows:
> > /dev/mapper/System2-root_ssd on / type ext2
> > (rw,noatime,errors=3Dremount-ro,barrier=3D1,stripe=3D32,data=3Dorde=
red,discard)
> > and the corresponding entry from fstab:
> > UUID=3D"635a1ad9-9ebb-4d1e-b8c3-30e11148bd92"     /                =
   ext4
> > noatime,discard,errors=3Dremount-ro               0       1
> >
> > My question is now, I don't have trim support now?
> >
> > Viele Gr=C3=BCsse
> > Jens Kasten
>=20
> Jens,
>=20
> I don't believe DM supports discard / trim passthru.  For
> clarification, you should ask on the Device Mapper list.
> <dm-devel@redhat.com>
>=20
> Alternatively, you may find that the wiper.sh script packaged with
> hdparm may work.  wiper.sh bypasses the DM layer and talks directly t=
o
> the drives, but it too has limitations.  The wiper.sh script is meant
> to be called on a routine basis via cron, etc.
>=20
> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Greg,

ok i will ask on this list.

Jens

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
