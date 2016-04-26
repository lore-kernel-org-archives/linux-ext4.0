From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2image: ignore checksum errors
Date: Tue, 26 Apr 2016 15:01:45 -0600
Message-ID: <F896D867-88C1-41BE-941D-ACD613B723FD@dilger.ca>
References: <20160419192030.GA16270@birch.djwong.org> <20160425160308.GB17864@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F58047F1-2267-400C-82EE-309798865F52"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38661 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbcDZVBy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2016 17:01:54 -0400
Received: by mail-ig0-f170.google.com with SMTP id m9so24313695ige.1
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2016 14:01:54 -0700 (PDT)
In-Reply-To: <20160425160308.GB17864@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F58047F1-2267-400C-82EE-309798865F52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Apr 25, 2016, at 10:03 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Tue, Apr 19, 2016 at 12:20:30PM -0700, Darrick J. Wong wrote:
>> Since e2image is used to capture broken fs images for debugging,
>> ignore checksum errors when creating the image.
>> 
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied.
> 
> BTW, the "m" series in tests was originally intended to be for mke2fs
> tests.  However, some MMP tests have already been named m_*, and it
> seems some folks have been assuming that miscellaneous tests should be
> named m_*.

I think the "m_mmp" test is appropriately named, since it is testing
enabling MMP at mke2fs time.  The "m_mmp_bad_{csum,magic}" tests were
added later, and I agree they should probably be renamed "f_mmp_bad_*".

Cheers, Andreas






--Apple-Mail=_F58047F1-2267-400C-82EE-309798865F52
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVx/XO3Kl2rkXzB/gAQjzig//fYWKV38ojwi7mxBrv7udP4XoH5+vt3mE
d+hvW+u+W4wanRcOeSZ8wjePu370jlisiI1Ic5uDIKdbKHE0cOci7pjCZveyq0gS
CA5sQaijTRZFDbP2LhMSrnplvclGBDRzwPPoGFPIkTG955Ql0b4wjDB8ILfxmz7o
Tiy2x3B09ixxQMhYkg36wwxE5jKPBeda28x0UXH3u+/FS2Q3exje3iiYzG+UtGUZ
dRoYSZBfPZUk8C3l4WlEqfwfZXKr6UjKi5sMW/rVG+RpyduxdLAfRpKJ/pQOWMp6
DGB+cXYLAoC9xMwlfFL0UtctAUO+UVJKpQBx2QR5ICbzdfb2xszWT5LtjLtpXfTf
NusfWRyXtqUGUOrW95R8q+vk8cERkyZjcTLcLfvRvn+z01YW7YDoOrDic6pBuThJ
qzuzvAVZXWf4wE4cVMlurXS4ACZac4a9Ig/sVt+NUE22h3OvkirfZ5T78k7g3Ccw
RJOTNcUqGzBg6UyKEtDb77+ozFElRA/xb7uv6f7cgwgU2sKuOEJV1QeBDcjTuOOd
DPPTLMIWjJsXCbz8w/8/qgpRDF5AzkYM0IJ08NjE1jM4VcK8ZpChH1dA4I8iHaHW
5iypte/zJGEcQekIWYhU+wGwqv67W6QmSqMRi8zQSHcHvofqPumTYonUuWjWcJn7
eecC1WtXtwk=
=4LsU
-----END PGP SIGNATURE-----

--Apple-Mail=_F58047F1-2267-400C-82EE-309798865F52--
