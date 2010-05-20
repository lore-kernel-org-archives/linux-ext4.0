From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: ext4 df regression introduced by commit 9d0be50
Date: Thu, 20 May 2010 10:32:14 -0600
Message-ID: <20100520163214.GC28770@untroubled.org>
References: <20100510180531.GA13538@untroubled.org>
 <20100520161121.GB28963@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:50509 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752398Ab0ETQcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2010 12:32:16 -0400
Content-Disposition: inline
In-Reply-To: <20100520161121.GB28963@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 20, 2010 at 06:11:21PM +0200, Jan Kara wrote:
>   Hmm, I'm not seeing anything obviously wrong with that patch but
> apparently the number of blocks reserved for delayed allocation is
> miscomputed by a lot...

IIRC this only affects NFS clients.  The same test running locally on
the server doesn't show the same problem.  I will retest shortly and
confirm (and also test with 2.6.34).

>   Is your ext4 filesystem create from scratch or converted from ext3?

I converted from ext3.

>   Is
> your application using lots of different files or rather a couple of small
> ones?

The application writes over NFS two files using writev.  One is
currently about 38MB and the other is under 1MB.

The "application" FWIW is saving games over NFS from Wesnoth.  At least
that's the most obvious application I have found that can reliably
trigger the problem.  I did notice the problem at several times when the
game was not even running, but couldn't pin down what else was
happening.

> Anyways a reproducing program would be the best in this case...

I will try to code something up to reproduce the symptoms using the
system call trace as a reference.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkv1ZA4ACgkQ6W+y3GmZgOhxywCginDWCV96gDMSODGbIMfGkovU
eykAnApoLG2bDPCcCIhqmLYuZRNeD87m
=vw11
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
