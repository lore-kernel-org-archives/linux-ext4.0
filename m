From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Reporting project quota usage?
Date: Wed, 16 Mar 2016 15:49:31 -0600
Message-ID: <A21F30FD-8207-473D-860A-F1B2118D35C0@dilger.ca>
References: <20160316052906.GA23610@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_640D3415-F987-40F7-A7B3-4EDEC1B063A3"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Li Xi <pkuelelixi@gmail.com>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35439 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002AbcCPVth (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2016 17:49:37 -0400
Received: by mail-ig0-f175.google.com with SMTP id vf5so128252489igb.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2016 14:49:37 -0700 (PDT)
In-Reply-To: <20160316052906.GA23610@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_640D3415-F987-40F7-A7B3-4EDEC1B063A3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Mar 15, 2016, at 11:29 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> Am I missing something, or do we currently don't have a way to report
> project quota usage with ext4?  The support doesn't appear to be in
> quota tools, and xfs_quota doesn't work without changes because it
> only tries to operate on XFS file systems.

At one time I thought Dave was going to patch xfs_quota to try the quota
ioctls for "foreign" filesystems like ext4 that supported them, but I'm
not sure if that patch was landed, nor whether it has been released.

On the opposite front, Jan was updating the generic quota tools to support
the XFS ioctls that project quota is using?

Cheers, Andreas






--Apple-Mail=_640D3415-F987-40F7-A7B3-4EDEC1B063A3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVunU63Kl2rkXzB/gAQir1Q//cxrglR6jTD9Cur6ihfDOGgBmBlmLhd0y
QChfRvnNAyzu8cJwuAzSJUTdfesGWY2xJMdSAIHjY3sZynfqQC8huAt3VJRYxEWP
naS5wGge5u9a+QdCxu6L+B1HtUaOhzgMB9J2Q95M2gie71ho9DZIx/H+D3NqlzMl
lGx9kWN5PnIXp4PcnsEjYr6sukEI4e/jfIQ+SaTdxJfnxmxlxL/LECp6eMOLG/cl
+aaPNi21dMDjy7om1MZmFBTy/9meeb8zj4a4CpGqaHRSgbEnpCw/GlMmZA1cMu0/
qfB7Thk+ymaIXIMPh7Hzxs79QTnyrOjkOwzUWG0yaxy5YTKimyMSq+NADugdRNYS
tUiEbq9/uFGxXuMRv07Yjv4sn8lnIfVoFFSAq7EXQrZH1xCMWO/Urjn7nhRJLaf2
kZavI/ZK3XvF+Z7om4888WsAUOw4A4XGwxzb4fgf/NVdO1mO9sO1ctOPPHrWrUCU
Zfez9J9kpj4NxTp54YSKK+cRnGjwZVcsZsd8JOG4ufdcQ/7K5hy6mafhfrJo0SoC
EJAucaF8Vdevgt7A9MKhQiCuxx34Jmhfhsd24rKIsxMB6u8643oAo7PiYUoU3bTe
DB7/LcqfQ+TNLGEWrceo9D2OvFg4LgV3fBTJo3TNudUK0o8JOgqom4Vp/8Wy2tNx
cW+kBr1MMfI=
=gUuj
-----END PGP SIGNATURE-----

--Apple-Mail=_640D3415-F987-40F7-A7B3-4EDEC1B063A3--
