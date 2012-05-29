From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: libquota: add a quotactl prototype
Date: Mon, 28 May 2012 20:37:49 -0400
Message-ID: <201205282037.50920.vapier@gentoo.org>
References: <1337715689-7116-1-git-send-email-vapier@gentoo.org> <20120528142032.GA1578@thunk.org> <9479769F-26BE-415D-804A-4766736ACEF5@whamcloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart29105995.FXikarN3xH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60067 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2E2Af7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 20:35:59 -0400
In-Reply-To: <9479769F-26BE-415D-804A-4766736ACEF5@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart29105995.FXikarN3xH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday 28 May 2012 11:31:42 Andreas Dilger wrote:
> On 2012-05-28, at 8:20, Ted Ts'o <tytso@mit.edu> wrote:
> > On Tue, May 22, 2012 at 09:41:29AM -0000, Mike Frysinger wrote:
> >> The commit 0df8a27bbaf51b55c0e8c3a533ef4c2ff9d79c9f removed the system
> >> quota.h include, but in doing so, added the problem:
> >> mkquota.c:55:2: warning: implicit declaration of function 'quotactl'
> >>=20
> >> Since we're maintaining a copy of quota.h, add a proper func prototype.
> >>=20
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >=20
> > Thanks, applied.
>=20
> This patch caused a compile failure on my FC 13 system, when I had no
> problem before, because caddr_t was not defined...

your definition of "no problem" is different from mine.  Ted's latest patch=
=20
works fine for me though -- punt the call completely.
=2Dmike

--nextPart29105995.FXikarN3xH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPxBpeAAoJEEFjO5/oN/WBL9YP/36/8pmHnbZ72xnf5SZdde21
RtPRHoWm9377t1PP1ZIeRVWgPP8RWFl1e7h9gl/FUfgBDOZgkHIX77nlC8ZvUkQ+
5zXrDyhFKPntGcpg3XF3hucRzTdcv/2Go0P5l9UN7LmPnPcUfwlMeovo1Oj/TvPE
gTWjCJhg0h2btTTmssijxHLQ8NO+xcBLqvpuM3dZe8IN6MU3axOpUCxX51T3Qiz6
EGqULfwBdsWpcbpDQcYNKuVkEI/PdkYLyXlH4VfE4fVUMQWU2Kq1V4lZcawqDDMA
HmWn63pxDSVAAft0L0xtDkquc62YD7eN9Ny6KeByTylbRsnfsk4mv6jZh2B2P4Lq
y+bNTy7Iv9nBrCoiXz/pmwJfVFEgE/zWNSF2T/TxCQFJlk9DIWM/a+t9TJb1ySoQ
ZSvRr4myT8gYN6udNzmZAZoqvzm4OkgyAruSR17cX1vgjqvMyFNlHxuuPBy2eAOq
gfgNRz379sizKTUvD5TtLfMH3L6vDiLeCrflJA/A6Ci+aU6gz0NbAMw3gajzgmOl
OelFpA61eAqq0euAUsbvh+pWU0omzKoFfcmFzwgo0jiOBTO1gkoho/flZhlHSd8a
1iJq49A6wNh45epQZZnvWFDWkc6krY2ymTmrhZd2lkjB/JnbfmF6cw26GeUmkcCq
Qxvz8SpAjxHOx1+x+DO3
=U+/T
-----END PGP SIGNATURE-----

--nextPart29105995.FXikarN3xH--
