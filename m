From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: ext4 df regression introduced by commit 9d0be50
Date: Thu, 20 May 2010 14:59:11 -0600
Message-ID: <20100520205911.GA2317@untroubled.org>
References: <20100510180531.GA13538@untroubled.org>
 <20100520161121.GB28963@atrey.karlin.mff.cuni.cz>
 <20100520163214.GC28770@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:44710 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753355Ab0ETU7P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2010 16:59:15 -0400
Content-Disposition: inline
In-Reply-To: <20100520163214.GC28770@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 20, 2010 at 10:32:14AM -0600, Bruce Guenter wrote:
> IIRC this only affects NFS clients.  The same test running locally on
> the server doesn't show the same problem.  I will retest shortly and
> confirm (and also test with 2.6.34).

Sorry, I was mistaken.  Running 'df' either locally or remotely shows
the same results.

I have been unable to reproduce the problem with a simplified test
program as of yet, and have so far been unable to reproduce the problem
with 2.6.34 with any program either.

Hopefully this means the problem has been solved, but I'll let you know
if it reappears in 2.6.34

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkv1op8ACgkQ6W+y3GmZgOhQiACgo++0T/LQERg5M9DKH2pJJM10
xBUAnRH2PgKR/Igvtetk5BqytLti3G4F
=ILOS
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
