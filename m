From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix suboptimal seek_{data,hole} extents traversial
Date: Thu, 27 Nov 2014 17:48:44 +0300
Message-ID: <87sih4bsxf.fsf@openvz.org>
References: <87egu7k6ym.fsf@openvz.org> <1413552334-32240-1-git-send-email-dmonakhov@openvz.org> <20141125211433.GB28449@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63569 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK0OtP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2014 09:49:15 -0500
In-Reply-To: <20141125211433.GB28449@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Oct 17, 2014 at 05:25:34PM +0400, Dmitry Monakhov wrote:
>> It is rediculus practice to scan inode block by block, this technique
>> applicable only for old indirect files. This takes signifficant amount
>> of time for really large files. Let's reuse ext4_fiemap which already
>> traverse inode-tree in most optimal meaner.
>>=20
>> TESTCASE:
>> ftruncate64(fd, 0);
>> ftruncate64(fd, 1ULL << 40);
>> /* lseek will spin very long time */
>> lseek64(fd, 0, SEEK_DATA);
>> lseek64(fd, 0, SEEK_HOLE);
>>=20
>>=20
>> Original report: https://lkml.org/lkml/2014/10/16/620
>>=20
>> ##################################
>> BTW: Why do we need i_mutex here?
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
> Note: this patch causes generic/285 to loop forever in inline-data
> mode.  My guess is in the special case handling of inline data in
> ext4_fiemap not playing well with this change, but I haven't had a
> chance to look deeply into this yet.
Correct, it is appeared I've missed inline case. Will fix.
BTW: this happens because xfstests-bld contains obsolete e2fsprogs-lib 1.41=
.14
>
> 					- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUdznMAAoJELhyPTmIL6kBBP4IAIP/jNRW3Jhf99uscSvTw5Tb
rrjOubT/hKc5nM39i8IilDuKNdK4smC7R92ogWxx6jPYBQQCs+dfp+OZe6IBWaCI
N6bU/SwAEpcFF9dUmelDgwPwAS/YgjVpuCNE5ujXX2ibsu0+VA6Z+LWFmM4ratiP
plWeSJL45mYj4dduTri+bIGOw2B5Z99ATlfko3cs3yeuuODBP10swRcQG6W2lZDH
LeOJdJbc8dCyNWwraz8yDH1ovZxc2Gh6ifpXanuRF+wcALyyrNccYdaqXmFNVWm3
B+jMOJj1rm8PcZlcz20jFWxw6Sg9cC9YaI36xgKrcgxKxQiULy5PUE9R78BApp0=
=6+Gu
-----END PGP SIGNATURE-----
--=-=-=--
