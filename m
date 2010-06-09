From: tytso@mit.edu
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Date: Wed, 9 Jun 2010 11:44:49 -0400
Message-ID: <20100609154448.GC6162@thunk.org>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
 <20100528132318.0783675a.akpm@linux-foundation.org>
 <20100528211432.GM31073@ZenIV.linux.org.uk>
 <20100528141755.42958d81.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Artem Bityutskiy <dedekind1@gmail.com>,
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
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100528141755.42958d81.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 28, 2010 at 02:17:55PM -0700, Andrew Morton wrote:
> > 
> > The real issue is that it's almost certainly an overdesign.  Let's
> > get rid of the bogus uses first and figure out what's happening in
> > what remains, OK?
> 
> That would be good.

Can we figure out what the new names will be for these accessor
functions, and then pursuade Linus to be willing to add patch #1 in
this series to add these accessor functions (without any users for
these functions, that would wait until the next merge window) to
2.6.35-rc3 or -rc4, please?

It will make life much easier for fs maintainers to merge the patches,
especially if they've done some cleanup to reduce the bogus places
where s_dirt was getting set in the first place.  That way I can apply
my patch to reduce the use of s_dirt[1], then apply a patch I carry in
my own tree to convert to the new accessor functions without worrying
about patch conflicts.

[1] http://article.gmane.org/gmane.comp.file-systems.ext4/19499

Thanks,

						- Ted
