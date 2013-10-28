From: Jakob Haufe <sur5r@sur5r.net>
Subject: Re: online resize of ext4 hung (3.2.51 / 1.42.5)
Date: Mon, 28 Oct 2013 15:39:25 +0100
Message-ID: <20131028153925.0aa4f31c@samsa>
References: <20131025220632.62b4f9b3@samsa>
	<20131025235745.GA2448@thunk.org>
	<20131026225124.5fcfd7b0@samsa>
	<20131027060812.GB12361@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512; protocol="application/pgp-signature"; boundary="=_libri-24139-1382971173-0001-2"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:39115 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab3J1Ojg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Oct 2013 10:39:36 -0400
Received: from samsa (localhost [127.0.0.1])
	by samsa (Postfix) with ESMTP id 8EC63BFA347
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 15:39:30 +0100 (CET)
In-Reply-To: <20131027060812.GB12361@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_libri-24139-1382971173-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Oct 2013 02:08:12 -0400
Theodore Ts'o <tytso@mit.edu> wrote:

> (Sorry for the delay in responding, a number of us have been attending
> a conference in Edinburgh, and I'm currently on vacation in Dublin.)

No problem. I'm really happy about all the responses I got.

> In any case, I think it should be safe for you to reboot your file
> system, and after an fsck -f, I think your file system should be OK.

I did so. For the sake of completeness I've put the log here:

http://permalink.sur5r.net/1/linux-3.2.51-resize2fs-1.42.5-hung-fsck.log

I decided to recreate the filesystem to be on the safe side.

> P.S.  To ext4 developers, please note that the kernel involved,
> v3.2.52 does _not_ have Jan Kara's reserved handles changes, which
> were added in commit 8f7d89f36829.  I at first thought it might have
> been related to changes involving how jbd2_journal_lock_updates()
> waits for j_reserved_credits to go to zero, but that was a blind
> alley.

In case this wasn't just a typo: The box is running 3.2.51 but I guess this
doesn't make a difference regarding this paragraph.

Cheers,
Jakob

--=20
ceterum censeo microsoftem esse delendam.

--=_libri-24139-1382971173-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCgAGBQJSbnchAAoJEEzyshj1Ta49MEgP/3jkrAx3Ig3LmZZXEQHNFjls
t+Dt2TmVjWFS3LlFG87LETv8UaH10CpbZDk2SuTi6v1HywhN/BkrLm9YBbR7ZQTb
WGfY7Bev9LRWMeiFTiDHEDK4K7wXnyFngHHyInCZ9YlM1L+R/wIspkC8fVyQi9yh
7VBgQ+g9wm1Zq7HCLCsf5xeOgdiF6ISfBiM7X+20zYK3iXRo4fZFwmdCMottUf2C
JyEXxTuI89AJaSckyK7mV/8WMIKHlACfyNIC9CMS5H5yPNTrSod5NLCWplATtKsM
QmdmZ7lzLzPas/xjlA6PryN2kck1MZLFSQILLGHvegpeAoTD9RWxO1pA51LjjBPu
gfYPabV7uh7JEF6rU4ezU8JdOmjWRgQ69rn4mUIR/wHu0Os/xqzz9ofltUWhnbJV
DMpakFBCKL3Jo4HkQu46kvaXg+sgMsawUl8FK1eaJKgh/yRA4WM6AZJT2GQWdVNR
0PLUq7iJ4va6/6n7W8HZmx/NX6N9h/OUu1ip6fkBGdZpSMAfevbtnOnioShyA3G/
U8/oi9DN5Maw77mQV1oNQ9IVKr1ty1pAUXKsPrZHf4dbzSSnzZHx0oX9Rfk4kOWk
BaQzQcm9oFP602VIo7ZICGSGg1SCld82SHp7Ch8kW0lu8k+S0iyBYP7dOdXnFoB/
OcRYNcAHl4vVq6KR/zoM
=35yx
-----END PGP SIGNATURE-----

--=_libri-24139-1382971173-0001-2--
