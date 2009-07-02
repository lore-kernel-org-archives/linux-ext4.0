From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:
	libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Thu, 2 Jul 2009 10:25:15 -0400
Message-ID: <20090702142515.GA29429@mit.edu>
References: <200905311113.23004.arvidjaar@mail.ru> <200907011835.08501.vapier@gentoo.org> <20090702005858.GH17054@mit.edu> <200907012115.57826.vapier@gentoo.org> <ac3eb2510907020549g138c5dd2y3caa8eeba782c3ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike Frysinger <vapier@gentoo.org>,
	Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53178 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZGBOZ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jul 2009 10:25:28 -0400
Content-Disposition: inline
In-Reply-To: <ac3eb2510907020549g138c5dd2y3caa8eeba782c3ac@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 02, 2009 at 02:49:24PM +0200, Kay Sievers wrote:
> > Kay's rules look like they should be fairly straightforward to drop=
 into
> > e2fsprogs. =A0personally i'd use:
> > E =3D @:
> > when V=3D1, but this is probably just splitting hairs
>=20
> Ah nice, looks good to me, if that works.

Take a look at what I've checked into e2fsprogs' maint branch; it was
largely based on what you suggested.

If someone can point me at an autoconf test that determines whether or
not we're using gmake, I could even set up something which sucks in a
Makefile fragment that enhances what we can do for developers who are
using GNU make.  (i.e., if you're using GNU make, "make V=3D1" will
DTRT, but if you're using a Solaris or BSD make, you'll have to settle
for "configure --enable-verbose-makecmds")

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
