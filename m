From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Thu, 13 Nov 2008 22:11:21 -0600
Message-ID: <20081114041121.GB11746@untroubled.org>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:34838 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751123AbYKNELZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 23:11:25 -0500
Content-Disposition: inline
In-Reply-To: <20081113204240.GF21652@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2008 at 03:42:40PM -0500, Theodore Tso wrote:
> Hmm... how very strange.  Can you run the command:
>=20
>        ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:16,comm
>=20
> during one of the quiescent periods, and see what is in the WCHAN
> field for the unlink command?

Mostly I see this:

  PID   TID CLS RTPRIO  NI PRI PSR %CPU STAT WCHAN            COMMAND
 5932  5932 TS       -   0  19   0  2.4 D+   sync_buffer      rm

I had been running these benchmarks over dm-crypt (which is the target
environment for which I was testing).  So I re-ran the tests both bare
and with dm-crypt to compare.  The stalls reported by vmstat did not
show up when running the test bare.

I also sat and watched the drive LED while the unlink test was running.
The drive LED showed the occasional 1/2 second stall, but at the same
time vmstat was showing 5-20 second stalls, so there that would seem to
point to some kind of reporting problem.

For completeness, I re-ran the benchmark both with and without dm-crypt
to see if it was the cause of the problem, all times mounting with
barrier=3D0.  As expected, it did slow down the process, but the problem
remains:

ext4  128  plain  unlink:  665.523   elapsed  0.276  user  34.882  sys  5.2=
8%
ext4  128  crypt  unlink:  907.934   elapsed  0.356  user  34.698  sys  3.8=
6%
ext4  256  plain  unlink:  1435.964  elapsed  0.248  user  40.319  sys  2.8=
2%
ext4  256  crypt  unlink:  1504.660  elapsed  0.304  user  35.186  sys  2.3=
5%
ext3  128  plain  unlink:  133.863   elapsed  0.248  user  24.618  sys  18.=
57%
ext3  128  crypt  unlink:  133.092   elapsed  0.280  user  23.661  sys  17.=
98%
ext3  256  plain  unlink:  309.635   elapsed  0.296  user  27.362  sys  8.9=
3%
ext3  256  crypt  unlink:  319.819   elapsed  0.268  user  23.713  sys  7.4=
9%

Is there anything else I can try to see what's happening?

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJHPpp6W+y3GmZgOgRAoG3AKCggl/+H5hsLkMyXEqjo89Z4ncUdwCeN+1O
PQoHoWEnorTKSgc5pIi0ebc=
=749f
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
