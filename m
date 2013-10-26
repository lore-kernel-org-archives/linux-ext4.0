From: Jakob Haufe <sur5r@sur5r.net>
Subject: Re: online resize of ext4 hung (3.2.51 / 1.42.5)
Date: Sat, 26 Oct 2013 22:51:24 +0200
Message-ID: <20131026225124.5fcfd7b0@samsa>
References: <20131025220632.62b4f9b3@samsa>
	<20131025235745.GA2448@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512; protocol="application/pgp-signature"; boundary="=_libri-29752-1382820690-0001-2"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:59660 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab3JZUvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Oct 2013 16:51:32 -0400
Received: from samsa (localhost [127.0.0.1])
	by samsa (Postfix) with ESMTP id CE18FA8598D
	for <linux-ext4@vger.kernel.org>; Sat, 26 Oct 2013 22:51:28 +0200 (CEST)
In-Reply-To: <20131025235745.GA2448@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_libri-29752-1382820690-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2013 19:57:45 -0400
Theodore Ts'o <tytso@mit.edu> wrote:

> Can you run "echo t > /proc/sysrq-trigger" and send the output from
> the console (or from dmesg)?  Or otherwise trigger sysrq-t?  This will
> show the stacks of all of the processes, which would be useful to
> figure out what might be happening.

As the log was most probably too big to pass majordomo, i've put it here:

http://permalink.sur5r.net/1/linux-3.2.51-resize2fs-1.42.5-hung-sysrq-t.log

Please tell me whether you need anything beyond that (ssh access would be
possible) or whether I can put that machine back to production.

After a forced reboot, will an "fsck -f" be sufficient or should I create a
new filesystem? It was a newly set up backup target so I could scrap it if
necessary.

Cheers,
Jakob

--=20
ceterum censeo microsoftem esse delendam.

--=_libri-29752-1382820690-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCgAGBQJSbCtPAAoJEEzyshj1Ta49Hh0P/3KPtXJ7ZMet5X80E8s7jw2N
s6lM7ipQ8jtH0V3RkxPB6SwxwTGl6ZOZVrsVGx1HYNCPijiQNlTZMRtAkq1xxcli
jzbHCRHF59fIndKeh2wJJGjbqhGaMEIAnytslkLZV9PbEgIOFt8i9pxSUA+lVsDS
+VhMERXAEZfJQHoU9pnyFU5jHjEsCXw+twaxJxHbLRvNgjCyMRXAsb72qM/01DfT
P6hKPVK6TJ4m4G+ZNrQplOrI1QepaXHMjPQDlyeYWA4B/o/24ObWMMa+R6fixq54
SOoYxcI7fKDnvWSW1LBgjLMgRPP9NDFNKZXJ9JfjJU759d1ozA7oJUBDSM6o6urY
iUTg0a4D/9bX+cGmJBLT9V312LlfzlRsC8O8Whd0AGnbQRf4/Spcef3j5nfk7nLL
ew+Y3IZtES8I5z71nvqerTihcfJBzU7CL5aUqo6MlKhMvSpP8kxZ6LKI5/wQ9CPd
t0Am1M/KjzzRdOl0FLR0bFCTB9g3D3lSd39RyykSqGGzPjMI8JWmX8bcbVL67DFv
sRu/jZ41RfaOlKEM4kdPd+b3f63zCS7wD1etHiByDHRgUtxUSycibYs3H0Mt8bBz
PDcYnD/80o3Ob7plcBj9dq81H4LI5piQ5gbVGy3FYXcMWOxm4/tisLU/5+evJqmv
lK6XQ5XIGKnoXSE+IJKt
=4M7B
-----END PGP SIGNATURE-----

--=_libri-29752-1382820690-0001-2--
