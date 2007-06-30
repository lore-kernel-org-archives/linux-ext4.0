From: Theodore Tso <tytso@mit.edu>
Subject: Re: E2fsprogs 1.40 release imminent!
Date: Fri, 29 Jun 2007 21:04:35 -0400
Message-ID: <20070630010435.GE32178@thunk.org>
References: <E1I2aKE-0008RV-KP@tinytim.thunk.org> <200706292351.33006.ml@hboeck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <ml@hboeck.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38189 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbXF3BEn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2007 21:04:43 -0400
Content-Disposition: inline
In-Reply-To: <200706292351.33006.ml@hboeck.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 29, 2007 at 11:51:29PM +0200, Hanno B=F6ck wrote:
> Am Montag 25 Juni 2007 schrieb Theodore Ts'o:
> > ... contains what I hope to be the e2fsprogs 1.40 release.  If folk=
s
> > could test it and let me know if they find any embarassing bugs, I =
would
> > greatly appreciate it.  It can also be found at:
>=20
> There are a bunch of patches applied in the gentoo package that might=
 be worth=20
> looking at:
> http://dev.gentoo.org/~hanno/e2fsprogs/
>=20
> All of them still seem to apply to the current mercurial source. I'm =
not=20
> really familiar with them, just noted that there are a lot of patches=
 and=20
> nobody seemed to care sending upstream in the past.
>=20
> e2fsprogs-1.32-mk_cmds-cosmetic.patc
> e2fsprogs-1.38-tests-locale.patch
> e2fsprogs-1.39-makefile.patch
> e2fsprogs-1.39-parse-types.patch
> e2fsprogs-1.39-util-strptime.patch
> e2fsprogs-1.40-libintl.patch

Thanks, none of these are critical.  I'll go through them and apply
them after the 1.40 release.

e2fsprogs-1.39-util-strptime.patch was fixed in another way in my
sources.

					- Ted
