From: Andre Noll <maan@systemlinux.org>
Subject: Re: [Bug 14830] When other IO is running sync times go to 10 to 20 minutes
Date: Wed, 27 Jan 2010 14:06:25 +0100
Message-ID: <20100127130625.GQ7517@skl-net.de>
References: <bug-14830-13602@http.bugzilla.kernel.org/> <201001251119.o0PBJDXw012169@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w1A23YewkF9s+fLd"
Cc: linux-ext4@vger.kernel.org
To: Michael Godfrey <godfrey@isl.stanford.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:50535 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab0A0NiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jan 2010 08:38:07 -0500
Content-Disposition: inline
In-Reply-To: <201001251119.o0PBJDXw012169@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--w1A23YewkF9s+fLd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
> After kill -9 of the sync run it took about 20 minutes before=20
> it died.

I was seeing similar behaviour on one of our servers, and changing
the io scheduler to noop fixed things for me. So it seems to be an
issue with cfq which is somehow triggered by ext4 but not by ext3.

To change the IO scheduler, just execute

	echo noop > /sys/block/sda/queue/scheduler

(replace sda if necessary).

Just my 2 cents
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--w1A23YewkF9s+fLd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLYDpQWto1QDEAkw8RApAIAJsEnMS90FWnAJQjrsfhbe1KHn67CwCbB2nv
D8z/SEivUOQHaW9hAZp3fA4=
=y8KV
-----END PGP SIGNATURE-----

--w1A23YewkF9s+fLd--
