From: Marc MERLIN <marc@merlins.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Wed, 25 Jul 2012 23:54:12 -0700
Message-ID: <20120726065412.GB20315@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60178 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2GZGyR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2012 02:54:17 -0400
Content-Disposition: inline
In-Reply-To: <20120726033223.GA5884@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 25, 2012 at 11:32:23PM -0400, Ted Ts'o wrote:
> On Wed, Jul 25, 2012 at 08:40:28PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > > First, I had he problem with btrfs (details below), and then I no=
ticed that
> > > while ext4 is actually twice as fast as btrfs, it's still a lot s=
lower at
> > > stat on my fast Samsung 830 512G SSD than my 1TB laptop hard driv=
e (both
> > > drives being in the same thinkpad T530 with 3.4.4 kernel).
> > >=20
> > > How can things be so slow? 12-13 seconds to scan 15K inodes on a =
freshly
> > > made filesystem (and 22 secs with btrfs, so at least ext4 wins). =
The same
> > > thing on my spinning drive takes fewer than 4 seconds, and SSD sh=
ould be
> > > several times faster than that.
> > > SSD throughput was measured over 400MB/s on the raw device and 26=
8MB/s
> > > through the filesystem:
>=20
> Was this an identical file system image on HDD and SSD?

Not entirely, but I did another test on similar ext4 FS, one on the SSD
and one on th HDD:

gandalfthegreat:/boot# find /boot/src | wc -l
6261
gandalfthegreat:/boot# reset_cache; time du -sh /boot/src ; reset_cache=
; time du -sh /boot2/src
169M	/boot/src
real	0m5.248s

157M	/boot2/src
real	0m0.698s

gandalfthegreat:/boot# df -h /boot /boot2
=46ilesystem      Size  Used Avail Use% Mounted on
/dev/sda1       241M  226M  2.5M  99% /boot
/dev/sdb2       298M  273M  9.3M  97% /boot2
gandalfthegreat:/boot# grep boot /proc/mounts
/dev/sdb2 /boot2 ext4 rw,relatime,stripe=3D4,data=3Dordered 0 0
/dev/sda1 /boot ext4 rw,relatime,discard,stripe=3D32,data=3Dordered 0 0

The only sizeable difference is that sda1 is a 4K block size I forced t=
o
help with faster writes on the ssd.

In the example above, the SSD is almost 10 times slower than the HDD.

blktrace -d /dev/sda -o - | blkparse -i - during du is=20
http://marc.merlins.org/tmp/blktrace_du_sda1.txt

Does that give enough info on what's going on?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - =
A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet=
 cooking
Home page: http://marc.merlins.org/ =20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
