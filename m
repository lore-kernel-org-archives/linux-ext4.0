From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Corruption from interrupted e2fsck
Date: Mon, 2 Nov 2015 14:31:01 -0700
Message-ID: <273A3EEA-06EB-4C6B-BD51-060EC20543D4@dilger.ca>
References: <B9F63236-3539-492E-83EB-3377836C2FDB@dilger.ca> <20151102152353.GA4024@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4873A10C-51C2-4A0E-B334-60821F61CF6D"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33119 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbKBVbG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2015 16:31:06 -0500
Received: by pabfh17 with SMTP id fh17so35586320pab.0
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2015 13:31:06 -0800 (PST)
In-Reply-To: <20151102152353.GA4024@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4873A10C-51C2-4A0E-B334-60821F61CF6D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 2, 2015, at 8:23 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Sun, Nov 01, 2015 at 06:16:50PM -0700, Andreas Dilger wrote:
>> Is there a reason not to have a cancel check right after the return =
from
>> e2fsck_run() rather than trying to recover the journal and quota =
files?
>> I can imagine that there is a desire to flush out modified inodes and =
such
>> that have been repaired, so that restarting an interrupted e2fsck =
will make
>> progress, but the quota file update is plain wrong unless at least =
pass1
>> has finished, and the journal recreation is also dangerous if the =
block
>> bitmaps have not been fully updated.
>=20
> You're right.  My suggested fix would be in the case of
> E2F_FLAG_CANCEL, we set the ctx->invalid_bitmaps flag, and then avoid
> writing out the quota file if invalid_bitmaps is enabled.

I was looking at that too.  In some sense it isn't a bad idea to allow
updating the quota file in this case, but it still bothers me that =
e2fsck
would continue on to update the quotas if the user wants to kill it, so
my preference would be to not write the quota files at all if e2fsck is
interrupted.

It would probably make more sense to have an option like "-E quota-only"
to allow running a shorter e2fsck (maybe useful for link-farm backups
that take a long time in later passes) but most of the time pass 1 is
the slowest so there is usually minimal benefit from skipping later =
passes.

Cheers, Andreas






--Apple-Mail=_4873A10C-51C2-4A0E-B334-60821F61CF6D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjfWFnKl2rkXzB/gAQg+pQ//Uf/5D0ebYW6dFIAx0FCKobMINaClP/x3
Fc/9IUAj3InUxis7T6GzT7X/nQsStR+7Eboz4OIx5ghCQN0+R2GoR9kXbYUvWZ6z
rRtNMMW+j2JY5qG9f0zy6U/ir+No7EbUXlmqb+M7VanIQxcsOQJj6LKqh8n4PbAs
AtK7W9oja6J73qHVbZL29C+foU2HaUb5Vq3fP3XjbfQWnn/uYeylI+YAQ1Cc9zEc
eFcfz3MYurjvMwBJNqdcEe3qM4taYmbffBQFPGYs15mHOxS9gPuksyrL/qSnHEFI
N/+eh7MLN13ZCBzErmaEBmouoqkpnfIc/J5rdeO6Vf+8U7a6n6xA+ZVjwLeY5WQ3
0UDJixL8u9bKBN8VonSJpGiafXeFgSVojIBZpx2AtASPcrOrx4i7Mecp4CFZUg6L
TE70o4PEKkRBr1FyeLd90edtOlNsKJS0die/KdNGwvrWmPIcCVakbe/4w5OE0rc3
9D9SJU3xJvXqV1rcsFlk4v/yRIRSL0tzf1mv+7zPuXaSGPj+h9C+sTPrdL9x/DYA
xlIKoEa3Q4kB0MHlY425Xe5sekU2LrOeZ8QRoxhumpm631qmYMLuSfQMghrrSd2o
QvTan0TZK0Rln3V2b+XdJpkd+uAcJDSEzGBfoKV52sPupFg1pzQmsUCkLgMFQUnx
VujUw/jrlss=
=m7Rq
-----END PGP SIGNATURE-----

--Apple-Mail=_4873A10C-51C2-4A0E-B334-60821F61CF6D--
