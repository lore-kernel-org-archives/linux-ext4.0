From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix race between write and fcntl(F_SETFL)
Date: Thu, 9 Oct 2014 14:50:34 -0600
Message-ID: <948E780F-14EB-4E38-9BAC-A5410F339441@dilger.ca>
References: <1412853287-10496-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_52B20915-E49D-4378-A4FB-01712ACF9EA7"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, sasha.levin@oracle.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33617 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaJIUuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 16:50:04 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so394228pad.19
        for <linux-ext4@vger.kernel.org>; Thu, 09 Oct 2014 13:50:03 -0700 (PDT)
In-Reply-To: <1412853287-10496-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_52B20915-E49D-4378-A4FB-01712ACF9EA7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 9, 2014, at 5:14 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
> O_DIRECT flags can be toggeled via fcntl(F_SETFL).
> But this value checked twice inside ext4_file_write_iter() and =
__generic_file_write()
> which result in BUG_ON (see typical stack trace below)
> In order to fix this we have to use our own copy of =
__generic_file_write
> and pass o_direct status explicitly.

This seems like a generic problem that would be better served by fixing
the core code instead of making a private copy of such a large function
for ext4.  I expect other filesystems might have similar issues if the
O_DIRECT state is changed in the middle of IO?

One option is to flush pending IO on the file if the O_DIRECT flag is
changed in setfl(). This is a bit heavyweight but I can't imagine any
sane app that is changing the O_DIRECT state on a file repeatedly.

Cheers, Andreas






--Apple-Mail=_52B20915-E49D-4378-A4FB-01712ACF9EA7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVDb1G3Kl2rkXzB/gAQIaIRAArEPc3CEd/xW2kX2fo7bqHUzocaqyptzl
raFXWtYOT7qHESbqJUJHQkff5WHahB5tgUlCWUpJlTQVQQ23ZomAoSDf2AtOZoW6
x2Ec1uRF9VrHmQCYMxxpY1L6jNBpn9MrnYmeb4xYUmUNea14a0dETeY7xf75ghKl
84hlrUjc7u3Pm6QmE3mDJ6gu/6eDRXukWUnSC3n7tAgzCHEzq+1moZAIufOvZjKc
ydtxEI8JBreMizRzFH399JQBbR3ln5PQaE6nnDGXngiZw2IU3DE1NrZxJlVm5ZHb
+0WB3iysMatTmNnEHjpbQzrHvpFdAH33pv5+syy1asAzb2SrcHp3vI6eyoTpNzOr
ggl/CJFncnacddy0FSf4Ihr+sukHyCtQE/gvjbRLHk0vQk/ZZEzt1AG+o1D2P21D
YJZQsNuUF1zLK964WT2K4jlN7f5bfsCscmm87J6tNjaQSinjebIGq2KqZfvIrZAw
TtAV9lMWC3zgHTbDA2uo+Sl9QUP1M9o2MDOnNY1yYCq/3MwkwC6UlMi5bK4ebXX1
Gi/XxswSu1L+jQVzraBMN6ljP4Nqc+OGrEoAgHL2SgiTWJ0rza0pXZJJzKBuqgou
8JwAxS9O2SECY4IGFPLLHBsdwpFalNzgTRKHmG0KNuJqzNhOiAMXhvoaK+X0D4v4
HnkXMbXJW3w=
=HAxs
-----END PGP SIGNATURE-----

--Apple-Mail=_52B20915-E49D-4378-A4FB-01712ACF9EA7--
