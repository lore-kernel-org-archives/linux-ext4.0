From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 20 Jun 2012 14:45:43 +1000
Message-ID: <20120620044543.GA11330@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
 <20120619054751.GA2660@thor.bakeyournoodle.com>
 <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Cc: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:39623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab2FTEps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 00:45:48 -0400
Content-Disposition: inline
In-Reply-To: <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 19, 2012 at 12:01:54AM -0600, Andreas Dilger wrote:

Thanks for the feedback.

> That is what I would do, though perhaps with macro names that are not
> so confusingly similar to the actual macro names, which might otherwise
> cause confusion if someone doesn't read the code very closely.  Like:
>=20
> #ifdef ENABLE_MMP
> ...
> #define EXT2_LIB_INCOMPAT_SUPP_MMP EXT4_FEATURE_INCOMPAT_MMP
> #else
> #define EXT2_LIB_INCOMPAT_SUPP_MMP (0)
> #endif

Okay, since Ted doesn't mind I went with:
#ifdef CONFIG_MMP
#define EXT4_LIB_INCOMPAT_MMP          EXT2_FEATURE_INCOMPAT_MMP
#else
#define EXT4_LIB_INCOMPAT_MMP          (0)
#endif

Of course we /could/ #undef them once we're done to be really clear
that they're special.


> This should at least print a message like "This version of debugfs
> does not support MMP.  Recompile with --enable-mmp if necessary."

Okay done.

> Having conditionals inline in the code is frowned upon.  Better to
> put the conditionals inside ext2fs_mmp_stop(), or declare a no-op
> inline function and keep the rest of the code clean.

Okay I went with putting the conditionals in the ext2fs_mmp_*()
functions.  As this removes the changes to ext2fs.h and
lib/ext2fs/Makefile.in
=20
> These should all conditionally become static inline no-op functions
> here (returning zero as needed) so that the calling code does not need
> messy #ifdefs everywhere.

Well here you and Ted disagree :)  I'm happy with either.  For the time
being I've gone with Ted's idea.  I'll let you guys decide on the
relative merits of each approach and then go with whichever "wins"

I'll include by v3 patch in my reply to Ted.

Yours Tony

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4VV3AAoJEEsCiJRY75GKZY8P/A1yRi7EJNb19kthqFUDbGy+
IBPyGB2ecNS8YrtwHwzW56WXlccdoImiJ1aoHuNYmzMFM2YDgduYhrpzVgKxXB1i
V5vZip1Ty6NEDFCSlXdPm3aJdvzER9ZfJV/CIa9BvBZrp4jq78PDq+5eeWejniAH
oRqZi5aNEdlrlfydCTCrSJhHI6E9awp5lbHXBl9LLPanmRevRQDhsYj0DOOywV7v
6jxeaHd4VXRf7qz0lfHBE1mO5ZFz5xstEn/h9mg/+wuBQSftZE56Y2nvZrG88Z9a
WDmx+mLlS5JgUnDK1H8l3w68yMRNKOqSdHC+GKT8BwObj6Alg8qdvX9K2GJblWYc
dfDs4jsKGrwTHiBEd/+jtXzvkUDn2ojtSTVPLqpFv65+xTEQi4stXB0egt0bxNWJ
f2vx4cPWIIVsv8EEFJz7kR+avxQ5gwrYYEeR2mSgBgoTbdIVJ3earugQ7lhglrqq
b3Dj4/zKzBFZGvlXQ8FWtEaA3xxbf9KNkT1EHCzhNZeekKraRNpL4h9zxgiRqk4I
N5PFVyQlYIjb+HZLqm2oIPklV8gIUJQgw56UTzgxCT3v9zqUKOZUKv7juFgFZQo8
8Hs+8i4OQFEYA5ksEDh86g5ACIsOLrIAqS1BTTRUjEggh9FJS4IuJBlUo27FPswY
J7ZXNYaWFp46Y3CR8Q3o
=+hU6
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
