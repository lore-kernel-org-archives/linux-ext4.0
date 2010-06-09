From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Date: Wed, 09 Jun 2010 18:49:15 +0300
Message-ID: <1276098555.5677.131.camel@localhost>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	 <20100528132318.0783675a.akpm@linux-foundation.org>
	 <20100528211432.GM31073@ZenIV.linux.org.uk>
	 <20100528141755.42958d81.akpm@linux-foundation.org>
	 <20100609154448.GC6162@thunk.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	linux-ext4@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>
To: tytso@mit.edu
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20100609154448.GC6162@thunk.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2010-06-09 at 11:44 -0400, tytso@mit.edu wrote:
> On Fri, May 28, 2010 at 02:17:55PM -0700, Andrew Morton wrote:
> > >=20
> > > The real issue is that it's almost certainly an overdesign.  Let'=
s
> > > get rid of the bogus uses first and figure out what's happening i=
n
> > > what remains, OK?
> >=20
> > That would be good.
>=20
> Can we figure out what the new names will be for these accessor
> functions, and then pursuade Linus to be willing to add patch #1 in
> this series to add these accessor functions (without any users for
> these functions, that would wait until the next merge window) to
> 2.6.35-rc3 or -rc4, please?
>=20
> It will make life much easier for fs maintainers to merge the patches=
,
> especially if they've done some cleanup to reduce the bogus places
> where s_dirt was getting set in the first place.  That way I can appl=
y
> my patch to reduce the use of s_dirt[1], then apply a patch I carry i=
n
> my own tree to convert to the new accessor functions without worrying
> about patch conflicts.

Yes, that would be nice, Al?

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
