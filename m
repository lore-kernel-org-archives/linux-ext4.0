From: Tony Vroon <tony@linx.net>
Subject: Re: BUG in ext4 with 2.6.37-rc1
Date: Sat, 06 Nov 2010 00:39:36 +0000
Message-ID: <1289003976.2961.10.camel@localhost>
References: <20101102202013.GA3861@elliptictech.com>
	 <1288998589.2961.3.camel@localhost>
	 <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MUsoZQRCX9but9rvyXEo"
Cc: Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:52209 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab0KFAj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Nov 2010 20:39:27 -0400
In-Reply-To: <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-MUsoZQRCX9but9rvyXEo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-05 at 20:33 -0400, Theodore Tso wrote:
> What did you have running which triggered this, and can you try the patch=
 that I sent in this patch, and see if you get the same other BUG_ON?

Updating /cvs/gentoo-x86 seemed to trigger it; it is a rather large
collection of small files. Basic contents visible here:
http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/

Unlike Nick however, I do not have a specific "this does it 100% of the
time" command. At least, I updated CVS again after it died roughly 90%
in; after deleting the directories CVS was unhappy with the sync
completed.
Syncing CVS too often would be a bit unfair on the server at the other
end, so I will try this again tomorrow.

> And if you have the stack trace easily to hand, it would be useful to mak=
e sure that part is the same as well.

I will sift through my quick snaps now to see if it is legible enough to
type it out for you. More news in half an hour or so.

> Many thanks,
> -- Ted

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-MUsoZQRCX9but9rvyXEo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkzUo8gACgkQp5vW4rUFj5p7XgCePhDcpLqUCJBDinYcl533OstN
QooAnRFB/M817wlzG4l6O69EIVzkfgV7
=/zGJ
-----END PGP SIGNATURE-----

--=-MUsoZQRCX9but9rvyXEo--

