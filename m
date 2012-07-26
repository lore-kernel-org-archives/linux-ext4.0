From: Marc MERLIN <marc@merlins.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Wed, 25 Jul 2012 20:35:35 -0700
Message-ID: <20120726033535.GT3888@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58646 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2GZDfg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2012 23:35:36 -0400
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
>=20
> The obvious thing to do is to get a blktrace of du -sh w/ a cold cach=
e
> for both the HDD and SSD.  Regardless of whether it's something we ca=
n
> address at the fs level, or in the block device layer, the blktrace
> should make it really clear what is going on.

I'm not very familiar with blktrace, but here is one run I did when I w=
as
trying to debug why dd of my dmcrypted FS was running at 27MB/s instead=
 of
270MB/s.
http://marc.merlins.org/tmp/blktrace.txt
(dd shows up as 'bash' for some reason).

If that format isn't good, can you tell me which blktrace command lines=
 I
should use to get you the exact output you'd like?

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
