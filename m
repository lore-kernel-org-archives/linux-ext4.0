From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: possible different donor file naming in e4defrag
Date: Thu, 11 Sep 2014 15:19:44 -0600
Message-ID: <25905DD3-CD3E-42F2-A101-715E7C205CEB@dilger.ca>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl> <20140815203909.GM2808@birch.djwong.org> <BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>,<4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca> <BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_461A9DAE-252A-4F1C-8CA0-1F7DF29D95EB"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57078 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaIKVTR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 17:19:17 -0400
Received: by mail-pa0-f44.google.com with SMTP id kx10so10675372pab.17
        for <linux-ext4@vger.kernel.org>; Thu, 11 Sep 2014 14:19:16 -0700 (PDT)
In-Reply-To: <BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_461A9DAE-252A-4F1C-8CA0-1F7DF29D95EB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Sep 11, 2014, at 1:48 PM, TR Reardon <thomas_reardon@hotmail.com> =
wrote:
> Picking this back up.  How would O_TMPFILE avoid races?  It definitely =
avoids the unwanted mtime/atime update, but then the existing =
"<filename>.defrag" pseudo-lock file would no longer be available.  How =
could you use O_TMPFILE and still avoid multiple defrag?  If this isn't =
possible, then resetting the parent times on unlink(tmpfile), as you =
suggest, is the simplest way out of this.

Looking at this the opposite way - what are the chances that there
will be concurrent defrags on the same file?  Basically no chance at
all.  So long as it doesn't explode (the kernel would need to protect
against this anyway to avoid malicious apps), the worst case is that
there will be some extra defragmentation done in a very rare case.

Conversely, creating a temporary filename and then resetting the
parent directory timestamp is extra work for every file defragmented,
and is racy because e4defrag may "reset" the time to before the temp
file was created, but clobber a legitimate timestamp update in the
directory from some other concurrent update.  That timestamp update
is always going to be racy, even if e4defrag tries to be careful.

Cheers, Andreas

>> From: adilger@dilger.ca
>> Subject: Re: possible different donor file naming in e4defrag
>> Date: Fri, 15 Aug 2014 23:04:21 +0200
>> To: thomas_reardon@hotmail.com
>>=20
>> The reason the donor file is created in the same directory as the =
source is to try and keep the block allocation policy consistent with =
the original inode.
>>=20
>> You may not need a SIGINT handler, since the timestamp could be reset =
as soon as the file is created and unlinked.
>>=20
>> It may also be possible to use O_TMPFILE on newer kernels to create =
the donor file to avoid any races?
>>=20
>> Cheers, Andreas
>>=20
>=20
> 		 	   		 =20


Cheers, Andreas






--Apple-Mail=_461A9DAE-252A-4F1C-8CA0-1F7DF29D95EB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVBIR8HKl2rkXzB/gAQIbhg//ZxTZ4zts+JcAc39VooQ3GnDAoxM05Jj7
PxInOalLppKGMTK774MVg8EJA5KGQOBhaqB4AtGiy63/4MGRwOpPZ9wGaNHghWXm
wmThi5vizTFo9sPUzh11fz+WOGRjp38c830Z3ffyLmQIScuJm3UA8RzKV5ewEx90
0Qp7uIzNXeysXfpWc6EGb/9oA9Of9qh/JZDaIUYGVWLXrrPnFi9/M5eMkuDyIwxy
AnsQUFrDjFnSN98+N+oLO6501wK+7li8lOexbhAL9PL92KoIowDC36heLUBy5hbP
7Czk9nwVYnww6lvV1CsaT3ocFhk+ioAgOdKhEtYZPSVnZpzVrO3RDm0hC/8voqx6
z4Hnx7Zx8Q90tleQfiMlqxtlGcCVAbAV/zMEVFVsspgsOQPYu53ukW6eQpmXoBjp
L0Asjlp9jUMPpv6JdAGurwL7TKHkbqQtZLhRDQC+e4fJPUMotcGLaA60vxlXU4wH
K95iWHR9pQTzUN7wAYf1FqrEGjLmdQcP2KVa2yH2BkdYRndQaZCnGoXDJOPjn5HH
k2slLlEndVvjqe2XfmmgQVzOYwSx0v2H+aRtM77oFmJniHaauF2XNApCESacPTWo
DD7hGVEvOoqWmGoVi0gGE1jvWZLtr++Mc6Yo/PRXWYhqrIaFay3KcIDN66I3wAol
q6nK1FJYvd8=
=u76E
-----END PGP SIGNATURE-----

--Apple-Mail=_461A9DAE-252A-4F1C-8CA0-1F7DF29D95EB--
