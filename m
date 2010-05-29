From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Date: Sat, 29 May 2010 11:11:50 +0300
Message-ID: <1275120710.2668.20.camel@localhost.localdomain>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	 <20100528132318.0783675a.akpm@linux-foundation.org>
	 <20100528211432.GM31073@ZenIV.linux.org.uk>
	 <20100528141755.42958d81.akpm@linux-foundation.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0E2IL4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 May 2010 04:11:56 -0400
In-Reply-To: <20100528141755.42958d81.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2010-05-28 at 14:17 -0700, Andrew Morton wrote:
> On Fri, 28 May 2010 22:14:32 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
>=20
> > On Fri, May 28, 2010 at 01:23:18PM -0700, Andrew Morton wrote:
> >=20
> > > A more conventional and superior naming scheme is
> > > subsystemid_specific_function_identifier().  eg, bio_add_page() i=
nstead
> > > of add_page_to_bio().
> > >=20
> > > So these want to be sb_mark_dirty(), etc.
> > >=20
> > > Being very old code written by very yound people, the VFS kinda i=
gnores
> > > that convention, but it doesn't hurt to use it for new code.
> > >=20
> > > Feel free to ignore me if that's too much of a PITA ;)
> >=20
> > The real issue is that it's almost certainly an overdesign.  Let's
> > get rid of the bogus uses first and figure out what's happening in
> > what remains, OK?
>=20
> That would be good.

Yes, I just mechanically introduced the wrappers to all FS-es. But as
per Al's request, I am going to try looking at how FSwe use it and
validate the usage. It'll take some time as this stuff is my background
task. Will see.

> > I have no problems with doing such wrappers, but if we touch every
> > place using ->s_dirt anyway, let's at least take a good look at the=
m.
>=20
> When adding wrappers we should also rename ->s_dirt (say, to __s_dirt=
)
> to catch out any unconverted code.

Right, I did this in the following patch:
	[PATCHv4 16/17] VFS: rename s_dirt to s_dirty

I thought that adding a leading '_' is not very neat, so added 'y' at
the end.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
