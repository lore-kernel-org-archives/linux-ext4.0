From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv7 0/5] ext4: stop using write_supers and s_dirt
Date: Wed, 11 Jul 2012 17:32:21 +0300
Message-ID: <1342017141.18274.57.camel@sauron.fi.intel.com>
References: <1342014404-14834-1-git-send-email-dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fG1AhFxsLS9nIHkcvnJf"
Cc: Jan Kara <jack@suse.cz>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5962 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2GKO2G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 10:28:06 -0400
In-Reply-To: <1342014404-14834-1-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-fG1AhFxsLS9nIHkcvnJf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 16:46 +0300, Artem Bityutskiy wrote:
> This patch-set makes ext4 file-system stop using the VFS '->write_supers(=
)'
> call-back and the '->s_dirt' superblock field because I plan to remove th=
em
> once all users are gone.

Hi Ted, is there any chance for this stuff to hit 3.6?

Basically I have 3 pending file-systems:
1. ext4 (these patches)
2. sysv - trivial, I hope Andrew would pick them.
3. ufs - should be straight-forward to change the same way I changed
hfs. I'll send patches soon. I hope Andrew would pick them as well.

Everything else - either in upstream or in -mm or in sub-system trees.

After this, I can kill sync_supers and have a chance that Linus would
accept the patches at 3.6-rc1, and end up with sync_super-less 3.6.

--=20
Best Regards,
Artem Bityutskiy

--=-fG1AhFxsLS9nIHkcvnJf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/Y51AAoJECmIfjd9wqK00i0P/Riv9H4w/5mJHWksCxYkJvk5
p+JxXiF4NGdwqur++B0g2EFBnYsNg1Zg8GThUB0T+9z5Ooopb5tm+KFDcvUXFUBQ
MqfOhbRRJ46Vc+7j02XSIm3L+oJWPVdfgWZOmYhfHZrUnxdSXe1LemoE8TAkDY5z
5C0wdmj6c1gJHxS5Z63bcAm51FAfZS67GdL+A7fmPiZSMZnm5w9UoaPhcqg5DWss
c52H82vNW4/R+k3InkR8KccqvWbm7zipP4sE/wyo0EvGVsq0OEof3zzcMd8JDeS1
wCXQjBbQuejaP3UUk/Vr1iQa5hzIF+XFTAciZT0UAEqhJR5J5i+a44uUECHzAjHh
behhtYJh7NUwt2WJZoMJTW7w/lVER1Rk+w4qeJmflSVOtLFG03FIfwGlnF4xIpy1
Bto6+KdEfwAkQ0HDa/Nf0jCUSIu/5tsGKlGsN05T9ESqzfB8SDW+q2WeHZQmSQ9G
cvuSNx76D0deHCdd674hluADz5V8rlleJBK8ePVw9JdbHFJuKPkSLfqMHC+WS1ZH
S4eQ9dE3D2LzAmcVxT1Tq+tYK5lIE0YSCID0E9RvdUd8Vdtv98NtShVqua045ans
sJGp3WoiA9O0UCFbG/UD2IuLWP3JVw27DMsauWmKDwHb820YZf9oQnatjidNrRlc
0zVs84QRuCf0ET5YL+tY
=//t4
-----END PGP SIGNATURE-----

--=-fG1AhFxsLS9nIHkcvnJf--

