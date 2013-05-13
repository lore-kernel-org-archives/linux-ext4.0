From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] mke2fs: do not change root dir ownership
Date: Mon, 13 May 2013 12:12:27 -0400
Message-ID: <201305131212.28657.vapier@gentoo.org>
References: <1367875316-3089-1-git-send-email-vapier@gentoo.org> <20130513133731.GC4845@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart40257069.JQLg13x5Vg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:51395 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab3EMQM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:12:27 -0400
In-Reply-To: <20130513133731.GC4845@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart40257069.JQLg13x5Vg
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday 13 May 2013 09:37:31 Theodore Ts'o wrote:
> On Mon, May 06, 2013 at 05:21:56PM -0400, Mike Frysinger wrote:
> > If you use `mke2fs` on a file, the code will automatically chown the ro=
ot
> > dir to the active uid/gid.  It doesn't do this to any other files thoug=
h.
> >=20
> > I can't see where this would really be desirable: you still need root in
> > order to mount, and the lost+found dir is owned by root.  It means if y=
ou
> > want to generate a rootfs as a non-root user, you first have to run it
> > through sudo or manually run `chown 0:0` after you've mounted it.
>=20
> Yeah, this was something that we've been doing in e2fsprogs since 0.5b
> (i.e., dating back to 1997).  I agree that the behavior is a bit silly
> and we should probably change it.  It *is* a behavioural change,
> though, so I'm going to make it something that changes in 1.43, as
> opposed to a 1.42.x maintenance release.

np.  as long as it eventually gets fixed, i'm happy :).

> A workarond that I'd recommend (since we will have lots of people
> creating file systems for various mobile/embedded systems, and they
> will have scripts that need to work on existing versions of e2fsprogs)
> is to do something like this:
>=20
>    mke2fs -t ext4 /tmp/foo.img 16384
>    debugfs /tmp/foo.img -R "set_inode_field / uid 0"
>    debugfs /tmp/foo.img -R "set_inode_field / gid 0"

nifty.  we already have to mount the fs to populate it, so putting a chown =
in=20
there isn't a big deal in the current setup.

now if only e2fsprogs would integrate the `genext2fs` project :).
=2Dmike

--nextPart40257069.JQLg13x5Vg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRkRDsAAoJEEFjO5/oN/WBFq4P/Rn6wWkaivUr6zFE6oM8qyQe
uaHguZDPf7/HT65vmxZZgGee3UljCEiORcLyVyYinClkGWWyyuXhv7fV2DhgvwAa
LMfxp3XBYNcyu7EKXfk8xaXfywcXqnoELze+Yxl+1GqYKUWb5wLWMVkUx6GSAbEV
Jg2qqpGIY/umgjtOfpHtKuU+bCNeeaNiN2vTWaIX8GGxkqKmOj6Welx5tM3Hk2VE
HbnkaK33W3iqn2bhv795mX5b70h54IMZV2lNV4LlhpU0HbCl3z+cTNVAL/hOdgk9
YbcJZ6cODnR+EVr5fBDRVdpHCFDOOV+XAqmbjyydagtcjCjIVRvnJhrxRe4ax88t
CcXVAzVnYrAOpricculeAykuTqkVJ9kCyr0RgCF2SpcICFNq+PAFiHDruWJJBNO3
DCbIyy6u5n6mJPTJf8kRSq2RfpiodRVmg33JfnzDedCmCcE8mLywQY8ctqnlvJZ7
//Xie2C2la7DzUXM93QC5th1QRTlDFcScp89bJNPtUdtihNCrAbPbgEOERNbl6CV
KswDZhTYf27tVBCRZg/OdhO8RQAFtCE5irGcvxHGdCamEo+lfrWHtCFuiLZISKSK
tm725U+KG07DKBrRF8MC1Z4h5ysJvag3LW6mpAQLo2B0mCRvp+ureyxRXmIen+0W
hM5SedCy5cR09u7C5g2g
=9hCo
-----END PGP SIGNATURE-----

--nextPart40257069.JQLg13x5Vg--
