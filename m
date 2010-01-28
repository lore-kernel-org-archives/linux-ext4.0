From: Andre Noll <maan@systemlinux.org>
Subject: Re: [Bug 14830] When other IO is running sync times go to 10 to 20 minutes
Date: Thu, 28 Jan 2010 11:24:09 +0100
Message-ID: <20100128102409.GR7517@skl-net.de>
References: <bug-14830-13602@http.bugzilla.kernel.org/> <201001251119.o0PBJDXw012169@demeter.kernel.org> <20100127130625.GQ7517@skl-net.de> <6465E5ED-8392-4929-9FD6-EFCCA7D75E0B@sun.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCozLMBrA/OCc/kF"
Cc: Michael Godfrey <godfrey@isl.stanford.edu>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:43397 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0A1KY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jan 2010 05:24:27 -0500
Content-Disposition: inline
In-Reply-To: <6465E5ED-8392-4929-9FD6-EFCCA7D75E0B@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--uCozLMBrA/OCc/kF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:43, Andreas Dilger wrote:
> On 2010-01-27, at 06:06, Andre Noll wrote:
> >On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
> >>After kill -9 of the sync run it took about 20 minutes before
> >>it died.
> >
> >I was seeing similar behaviour on one of our servers, and changing
> >the io scheduler to noop fixed things for me. So it seems to be an
> >issue with cfq which is somehow triggered by ext4 but not by ext3.
> >
> >To change the IO scheduler, just execute
> >
> >	echo noop > /sys/block/sda/queue/scheduler
>=20
> Andre, could you please also test deadline instead of noop?

Sure. I just switched to deadline and the system still feels responsive
while rsync is running. With cfq a simple "ls" command took ages
to complete. I'll let you know if the system becomes sluggish again
after a while.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--uCozLMBrA/OCc/kF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLYWXJWto1QDEAkw8RAoSgAJ9JXxuzAfAhhVKNSt1zE2drd16dowCgo9qE
G/tGrKsSGH3X8oKIuBIse2o=
=NPRc
-----END PGP SIGNATURE-----

--uCozLMBrA/OCc/kF--
