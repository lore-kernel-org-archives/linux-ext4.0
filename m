From: Andre Noll <maan@systemlinux.org>
Subject: Re: [Bug 14830] When other IO is running sync times go to 10 to 20 minutes
Date: Thu, 28 Jan 2010 11:25:24 +0100
Message-ID: <20100128102524.GS7517@skl-net.de>
References: <bug-14830-13602@http.bugzilla.kernel.org/> <201001251119.o0PBJDXw012169@demeter.kernel.org> <20100127130625.GQ7517@skl-net.de> <20100128075328.GG28459@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="213E7WwkW+nU62+Y"
Cc: Michael Godfrey <godfrey@isl.stanford.edu>,
	linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:43426 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0A1KZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jan 2010 05:25:39 -0500
Content-Disposition: inline
In-Reply-To: <20100128075328.GG28459@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--213E7WwkW+nU62+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02:53, tytso@mit.edu wrote:
> On Wed, Jan 27, 2010 at 02:06:25PM +0100, Andre Noll wrote:
> > On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > After kill -9 of the sync run it took about 20 minutes before=20
> > > it died.
> >=20
> > I was seeing similar behaviour on one of our servers, and changing
> > the io scheduler to noop fixed things for me. So it seems to be an
> > issue with cfq which is somehow triggered by ext4 but not by ext3.
> >=20
> > To change the IO scheduler, just execute
> >=20
> > 	echo noop > /sys/block/sda/queue/scheduler
> >=20
> > (replace sda if necessary).
>=20
> Andre or Michael.  If switching away from cfq helps, that's
> definitely... interesting.  Given that cfq is the default scheduler, I
> definitely want to understand what might be going on here.  Are either
> if you able to run blktrace so we can get a sense of what is going on
> under the cfq and deadline/noop I/O schedulers?

Yes, I can use that machine freely for testing purposes, including
reboots. It is just our fallback server which creates hardlink-based
snapshots using rsync.

However, I have to recompile the kernel to include debugfs which is
needed by blktrace and I'd like to wait until the currently running
rsync completes before rebooting. Would you like to see the output of

	btrace /dev/mapper/...

or should I use more sophisticated command line options?

> And in both of your cases, were you using a new file system freshly
> created using mke2fs -t ext4, or was this a ext2/ext3 filesystem that
> was converted for use under ext4?

The ext4 file system was created from scratch using -O
dir_index,uninit_bg,extent, a block size of 4096 and 32768 bytes
per inode.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--213E7WwkW+nU62+Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLYWYUWto1QDEAkw8RAg8SAJ46JnjbmZM/ppo3aI1WnLr1+5KsEgCcDFzd
66qzJqTf6XwXyfpNGcD24M8=
=5VoX
-----END PGP SIGNATURE-----

--213E7WwkW+nU62+Y--
