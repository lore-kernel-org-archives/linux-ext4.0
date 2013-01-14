From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented
 byteswapping routines
Date: Mon, 14 Jan 2013 16:56:22 -0500
Message-ID: <20130114215622.GA24179@thunk.org>
References: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org>
 <20130114141356.GA12052@thunk.org>
 <20130114142005.GC12052@thunk.org>
 <50F4254B.9040102@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43351 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab3ANV40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 16:56:26 -0500
Content-Disposition: inline
In-Reply-To: <50F4254B.9040102@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 12:33:31PM -0300, Cristian Rodr=EDguez wrote:
> On 01/14/2013 11:20 AM, Theodore Ts'o wrote:
>=20
> >why bother using autoconf and automake
>=20
> For a very simple reason, fixing hand written makefiles is the
> number 1 burden in distribution mainteniance.
>=20
> Any autotools stuff provided is always better and causes less pain
> than ad-hoc build scripts.

Maybe for distribution people (although I haven't had that many
complaints with my hand-written Makefile.in files).  But automake
causes ***huge*** amounts of pain for developers, especially when they
want to run binaries out of the build tree for debugging purposes or
for regression testing.

I hate automake almost as much as I dispise GNOME 3.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
