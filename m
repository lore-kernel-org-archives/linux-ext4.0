From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: acl option silently ignored?
Date: Thu, 6 Feb 2014 10:09:37 -0500
Message-ID: <20140206150937.GA19884@thunk.org>
References: <52F39B29.4030303@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54797 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaBFPJl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 10:09:41 -0500
Content-Disposition: inline
In-Reply-To: <52F39B29.4030303@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 09:24:41AM -0500, Phillip Susi wrote:
> I came across a debian bug report and confirmed that when you remount
> - -o acl, dmesg shows ext4 acknowledging the remount with the acl
> option, but /proc/mounts does not show the acl option.  Is this a
> kernel bug or is it intentional?

The acl mount option is now defaulted on, so it's not a bug that if
you specify the acl option, it won't get displayed in /proc/mounts.
What *is* a bug is that if you specify "mount -o noacl", that doesn't
show up in /proc/mounts.

Cheers,

						- Ted

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS86WrAAoJENNvdpvBGATwkscQAMNWfEcwRjETcIHh7lQJt5sZ
esbxLjB9XQyickIJhWj5D2XynIODXdGdrH40Rqnqe7IyA59IS5hRjHGCke0EoeOO
jYOjryokC2jXizZwoMJVxI/0h/yVZOa8Nbbg9QgfTHXxf5pPso02sn+AuO6kzM7q
2OL6wHt3nOK3DzqUwshRaB0swodrLyK0EBNvNy63qV8IJkRBEIOswKBCBXqAVliq
qGfZlMbfWZtBTiccOn59mQ7H0R0gXCfM13DUe4TipvCvzn6YEtGCVfNP2pCu/FPq
DvC31zT0rYnzNdKrEFCL6zrYeHsoWmBjlU2xjYRn8u48kPnlDO/+sOXzOeh3njf1
DPkaUfS6MdoOkDV1hk7xsowOPrBcCkvbictwWBy6T3g2V2k3JhkuR7aj4RfAjEP5
DvIoMM7Og2TdF6xJnWC/GKlwNesFvyzmnl+bq+ojsasDI8lZhlflHX/ekVSCrXzB
0Sd3yYpFX+44R0CqcE78YrxFnhZOsW4u7/c0bkUxU1oF4WyVK+kbdblYv39pMeIY
LhtdEzH4BDnFsIcuMgMyjpkkkfkf5eLKdS03F8kocEDgbywW2kWtmgmEHHjs2cFY
eXndUFr2C3xnpvGUz+F8uh9Wx+5cZE5x20C0Y0QTkTdTaEeR04e9/34IgEYeJog7
t49UlDGrY26qz0bHDFLw
=D9/G
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
