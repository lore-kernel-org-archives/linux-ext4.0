From: Pavel Machek <pavel@ucw.cz>
Subject: bcache with existing ext4 filesystem
Date: Mon, 24 Jul 2017 20:57:04 +0200
Message-ID: <20170724185703.GA31422@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
To: linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33585 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdGXS5I (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jul 2017 14:57:08 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Would it be feasible to run bcache (write-through) with existing ext4
filesystem?

I have 400GB of data I'd rather not move, and SSD I could use for
caching. Ok, SSD is connecte over USB2, but I guess it is still way
faster then seeking harddrive on random access... I have kernels on
that partition, so it would be nice if grub2 could still read it, and
it would be good if I could go back to old kernel.

IIRC ext* filesystems have first 1024 bytes reserved for the
bootloader. Unfortunately, cache_sb is bigger than that, and it is
normally at offset 4K in the disk.

Is cache_sb.d[] being used for backing devices? Could I just make
SB_JOURNAL_BUCKETS smaller?

Remaining problem is how to invalidate the cache when someone mounts
the filesystem without bcache; but I believe that should be possible
to check using "last mount time" field in ext4 superblock.

bache would save "last mount time" during shutdown, and would just
consider the cache stale if someone mounted it in between....

Does the plan look reasonable?

Thanks,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll2Qv8ACgkQMOfwapXb+vLBngCeO7J1ABPRAldDX+BIytk6D0ao
c2cAn33GpkDHsLsV1YQ05zyhXAByGwsx
=bhhb
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
