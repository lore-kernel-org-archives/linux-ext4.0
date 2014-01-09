From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Fix up workarounds for dietlibc breakage
Date: Wed, 8 Jan 2014 20:59:54 -0700
Message-ID: <18FF1403-0799-4877-88F2-31FC6D960F03@dilger.ca>
References: <1389238019-18921-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_0135DB23-B790-41B7-99D7-F5D6505A7651"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52264 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaAID77 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jan 2014 22:59:59 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so2653364pde.0
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jan 2014 19:59:58 -0800 (PST)
In-Reply-To: <1389238019-18921-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0135DB23-B790-41B7-99D7-F5D6505A7651
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 8, 2014, at 8:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> The dietlibc doesn't support the TZ environment variable, which is
> required by the standard.  Work around this so that we can run the
> regression test suite when building with dietlibc.  (This is useful
> for finding problems.)
> 
> With this change, the only thing which doesn't work as far as dietlibc
> is concerned is the posix_memalign test, and the MMP support tests
> (because posix_memalign isn't provided by dietlibc, sigh.)


Before e2fsprogs used posix_memalign() the MMP code just allocated a
2x sized buffer, and then picked the region in the middle that was
page aligned.  I'd be fine going back to this to reduce the dependency
on this interface.

Cheers, Andreas






--Apple-Mail=_0135DB23-B790-41B7-99D7-F5D6505A7651
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUs4eunKl2rkXzB/gAQLUuRAAqT1M8ruOfrEePAa5/sy5HvLfUXEbwk0d
6ZGxLQhQRk/HvPAZDwT7WHWRAGisaAytpvBngsrzd5nVZthFsqbbCvjuREuXUlU2
MSVlUM3cm7QLVi2FJMmfB5lRhUsCp1sStnDhYiTgU9NX5xiNl1UU+7VSnektYDhP
l9CgfpmXJtuEbaLHyyfXj8EWs9Vslfud5aGU+Q1k0v92HxKWg8PsK7guK4Nszv1e
zbhTKzfF5xJRqLycmZO6hN5nmid5ckZQtLxQVQMVuDbcvPmisIt+1Lf8Wb2oC4mt
gGSjBHVg/AcICiRrUVOnQof3TTzq+g3I8RAIj/awOTeOXEH2szB0znTG3PWlpddp
LoGTqEFvLw966hEdWAdS10Zi7vJgQh68Xli4zQWqlhgTGf1TbYnD9ouXkO1Tp7AL
jyXcNujwNyN2AY1GeEbE1zk3mAiyFntCMKngAx2cOJppKSzFngXyM1pzkaek73+5
dn9h5Tm2kMQlXkNyEqpmHfu0/Gu1zbw6cf5D9Ee3uzDAO9BjoApJKadx0jKc6f3n
o4bdFWINxNe+oN1I8vui3jOc84GEu7sZuzTMVwFPkkm0dzr63mfe2L2CgkOjAyG0
O6GYGfc4EzixY5jmAchgd49yU6aoBg82K9qasi0PXid3QZdLwNY8hFBdGaK+W/2R
vpA9DDJtn34=
=k61d
-----END PGP SIGNATURE-----

--Apple-Mail=_0135DB23-B790-41B7-99D7-F5D6505A7651--
