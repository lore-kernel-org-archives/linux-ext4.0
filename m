From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: avoid possible overflow in ext4_map_blocks()
Date: Wed, 19 Feb 2014 22:11:34 -0800
Message-ID: <143F882D-0091-4F04-9A2D-882581305CC8@dilger.ca>
References: <1392875454-4281-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2EF0D92A-A194-40AD-9A85-DB896763238B"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35978 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaBTGLk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Feb 2014 01:11:40 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so1477599pab.38
        for <linux-ext4@vger.kernel.org>; Wed, 19 Feb 2014 22:11:39 -0800 (PST)
In-Reply-To: <1392875454-4281-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2EF0D92A-A194-40AD-9A85-DB896763238B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Feb 19, 2014, at 9:50 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> The ext4_map_blocks() function returns the number of blocks which
> satisfying the caller's request.  This number of blocks requested by
> the caller is specified by an unsigned integer, but the return value
> of ext4_map_blocks() is a signed integer (to accomodate error codes
> per the kernel's standard error signalling convention).

[snip]
> return a number large enough that it would overflow a signed integer,
> resultimg in a ext4 thinking that the ext4_map_blocks() call had

(typo) s/resultimg/resulting/

> @@ -514,6 +514,9 @@ int ext4_map_blocks(handle_t *handle, struct inode =
*inode,
> 		  "logical block %lu\n", inode->i_ino, flags, =
map->m_len,
> 		  (unsigned long) map->m_lblk);
>=20
> +	if (map->m_len >=3D (1UL << 31))
> +		map->m_len =3D (1UL << 31) - 1;
> +

Should this instead be INT_MAX?  That makes it more clear why the limit
is here, and in theory on a platform with 64-bit int it would work
properly with a value over (2^31 - 1).

Cheers, Andreas






--Apple-Mail=_2EF0D92A-A194-40AD-9A85-DB896763238B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUwWclnKl2rkXzB/gAQJaPw/+KgaFHq6366C85st3lOe1RLvNNBMbv8gv
T6vp8AFtyawALQHbgOeMzJ1bSwuw61OELGVImtF4+BNs2Julve0QKw/SU8GYJf12
Fn9DR1TWDeNp1Dtzd9eNuY3wvAuN4pXOlJHHHLoHjsHAdcfDHmeyvUQb1YajcxYk
wjAM70CiF0fd2dN4CxDFzQyGt45dcY9MHjtc4rV87aHZt9jnIc2HokAX+eju4/jt
nzYLICvYkiH0qOsNQXxACB0g+hTaHWH2BFQkX032yH5FKiKAS6VhENUApJDoAYK5
2MDL2tWUcTUNGcdeyRVaMswvBENizrV/cyA42h+1H+aStAz6XOvftPDPO47Ukm7Z
6ZXloCicr8wqmHV4KqcU72sSX1v8UqC5RS5lIyi2iAIgzFV2H8KWvGsyxf6vcrNM
FIR3tDYZ66YL45A4L4S+F4IicyDOUrgPmYSdb9BfXKEGf2R2aJffQz4NEul24ASm
ze/wXyFVPdoraXjOeN6PS94Pm5KtuMTT8yL1uHreBMCpmn20qUM5+UQquol4XtN/
9TFbVzt1vlLAtEEoFfPuyVhPXtluvnh1uZdpgTT7km/noXDOOdKGfjtEfCc9KPRR
z58nZQyit90DBSkCCO4FuoHaMSjv5yGMqGLahsblu6KhZVhzogOUJhBQE+a+f/ax
YLYB7P2VaNg=
=0g4f
-----END PGP SIGNATURE-----

--Apple-Mail=_2EF0D92A-A194-40AD-9A85-DB896763238B--
