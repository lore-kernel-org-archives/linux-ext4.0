From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 3/8] ext2: write superblock only once on unmount
Date: Mon, 02 Apr 2012 16:44:09 +0300
Message-ID: <1333374249.22146.2.camel@sauron.fi.intel.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
	 <1332346475-1441-4-git-send-email-dedekind1@gmail.com>
	 <20120331115332.GB4569@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jU81SvMyQCnDSK4700vl"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2DBNk4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 09:40:56 -0400
In-Reply-To: <20120331115332.GB4569@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-jU81SvMyQCnDSK4700vl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-03-31 at 13:53 +0200, Jan Kara wrote:
> On Wed 21-03-12 18:14:30, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >=20
> > Currently on unmount if we are mounted R/W, we first write the superblo=
ck to
> > the media if it is dirty, and then write it again, which is not optimal=
. This
> > patch makes ext2 write the superblock on unmount less times.
>   Looks good. I've added the patch to my tree.

I would like to test v2 against your tree, I found this one:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git

but I do not see this patch there - is that the right tree, or may be
you did not push out? Which branch should I use?

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-jU81SvMyQCnDSK4700vl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPea0pAAoJECmIfjd9wqK0TbYQAKEyoh4m9A6fNd/As+aqwsHv
WKQdCdWC5h6BZbZPwB0XUJf6Umj41rUbYhySqIV2ucVCPszEMIk+ZBw20FHyPZxE
06gL6qFKSKcWqeJF2p+azZWSVHjsjGkEJUKvveYg9+ugWctHFBuRiQUEHJjNH5cd
EYHGW9ti+3s/4sSqPVAQZAyy2wtfoNP84qYvq3svkTv8O52RgYJWbajIkPSYOtZP
ao4Ww9x0FUOSsHbZCQd42YOrhPAjmj/oieUCHEYqD9qetLc+koMRZASz5ZHAZT8Y
QJIRItiFtBqyG6LbfB57As1hiiehmyhU0WA7Cyf2fbrG96swRHBGAa9v503egb9W
STrfacEGcAtyYSOX4V56ZSGIB2UYl3IQU8RbegQYPmIEvakAlQLB8poeuEhHRstd
pJpX7nkJtX3RlMzx/wJVdQxHmlf5rqCagJaDpcqsJjKvVbytw8m2GJnal0tqqUCd
bwgO662pRD1mTsZHPnJDZsi2+3WtQd5IPeYt9aVFjxwO5i0pl4BfR7Qtw00Rfoez
H5e6Euq36+F6U6PmYJapKKOJUE2WWgy1X23Jrfp7dPmT+KgkesfpquX7tzv0nE0A
WJ9swkp74d/QjJc/HfYfcMSQ3eJG4SgaL8mU1tWzf/vu0fnatuY9BWZor2Oy4q2T
DU2qL0cHroBe9hqDkYUZ
=/lf3
-----END PGP SIGNATURE-----

--=-jU81SvMyQCnDSK4700vl--

