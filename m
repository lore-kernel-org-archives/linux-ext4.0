From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 3/3] mke2fs: document bigalloc and cluster-size
Date: Tue, 15 Jan 2013 14:46:17 -0500
Message-ID: <50F5B209.40900@ubuntu.com>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com> <1358068095-9034-3-git-send-email-wenqing.lz@taobao.com> <20130115031006.GB31857@thunk.org> <20130115191254.GD17719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50908 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3AOTqT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 14:46:19 -0500
In-Reply-To: <20130115191254.GD17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/15/2013 2:12 PM, Theodore Ts'o wrote:
> BTW, I used the following modified text:
>=20
> bigalloc This  feature  enables clustered allocation, so that the
> unit of allocation is a power of two  number  of blocks.   That
> is,  each bit in the what had tradi=E2=80=90 tionally been known as t=
he
> block  allocation  bitmap now  indicates  whether  a cluster is in
> use or not, where a cluster is by default composed of 16 blocks.=20
> This  feature  can  decrease the time spent on doing block
> allocation and brings  smaller  fragmentation, especially  for
> large files.  The size can be speci=E2=80=90 fied using the -C option=
=2E
>=20
> Warning: The bigalloc feature is still under  devel=E2=80=90 opment, =
 and
> may  not  be fully supported with your kernel or may have various
> bugs.  Please see the web page
> http://ext4.wiki.kernel.org/index.php/Bigalloc for details.

Does this mean that a cluster is the minimum allocation unit, or can
two small files allocate different blocks in the same cluster, leaving
the cluster partially used?  If the former, then how is this different
than just using a larger block size?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ9bIJAAoJEJrBOlT6nu75WskIAM6eNjA1updKy6Kh2SrMWavB
bX7EeTGmXMrxbQtMDgmG1+V2kOy9RoYtCZ5+pXijqJHzrovEtyIwHVdzntKSTtZi
tYSqjZrOpJ/bTJpXuP5AIew9mXRTKzGF8lNyPZkLIgX0AyhTsbC4cccpcmfsnGEX
RfuwDd2Z2NEKhmsXH4SI3HXDM2f4EGZmPqPG8It/B49HXrzfDq+YqzKwVqdrDJ5V
jdTLV5xjJ4E9Y+/P3EC1l2KvfDf0KjJjA2CiuG4sqrthwwQGfdEFK+MF2bfz5nMi
VBsuZQRF5kFgekpsHXy7b0Do9Qa3wMm9FL8Sv2QMy7xf92FxCwrLJFlpIZ9iuSQ=3D
=3DBKGM
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
