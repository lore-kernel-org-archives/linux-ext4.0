From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Wed, 3 Dec 2008 19:18:33 +0100
Message-ID: <200812031918.38067.andres@anarazel.de>
References: <200811291418.24672.andres@anarazel.de> <20081203153441.GD9481@skywalker> <20081203172309.GB30610@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2570269.h9IKZta58x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Jonathan Bastien-Filiatrault" <joe@x2a.org>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754644AbYLCSSy@vger.kernel.org>
In-Reply-To: <20081203172309.GB30610@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--nextPart2570269.h9IKZta58x
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 03 December 2008 18:23:09 Theodore Tso wrote:
> On Wed, Dec 03, 2008 at 09:04:41PM +0530, Aneesh Kumar K.V wrote:
> > Can you make sure you have the below patch in the kernel.
> > c001077f4003fa75793bb62979baa6241dd8eb19
Yes, I do have that patch in kernel (verified through git and looking at th=
e=20
source). Its a part of linus' tree.

> Mmmm, good point, thanks.  I had been assuming this was caused by some
> failure in the delayed allocation code with block accounting, but we
> also had a bug fix that was causing a problem with inode allocation.
>
> That doesn't explain a report of an ENOSPC error with metadata only
> changes were failing (i.e., touching a file that already exists),
> although I don't think we've gotten a lot of information about that
> scenario and it feels a little unconfirmed to me still...
Unfortunately I am not absolutely sure (I reported this) as well, this is t=
he=20
reason I did not report it at first but only after no culprit could be foun=
d.

Still no luck reproducing it once more.


Andres


--nextPart2570269.h9IKZta58x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk2zXoACgkQporPraT14igjOQCgpBlMgHrTpxblKo9vXy2DJEcT
sBkAoJHZ686JapU5G2RB4yUH0H/Kxnvs
=GDvN
-----END PGP SIGNATURE-----

--nextPart2570269.h9IKZta58x--
