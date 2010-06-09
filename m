From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Date: Wed, 9 Jun 2010 23:33:26 +0100
Message-ID: <20100609223326.GC31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
 <20100528132318.0783675a.akpm@linux-foundation.org>
 <20100528211432.GM31073@ZenIV.linux.org.uk>
 <20100528141755.42958d81.akpm@linux-foundation.org>
 <20100609154448.GC6162@thunk.org>
 <20100609093157.cd040633.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Artem Bityutskiy <dedekind1@gmail.com>,
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100609093157.cd040633.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 09, 2010 at 09:31:57AM -0700, Andrew Morton wrote:
> > Can we figure out what the new names will be for these accessor
> > functions,
> 
> sb_mark_dirty(), sb_mark_clean(), sb_is_dirty().

Fine by me.  If Linus doesn't take such a patch, I certainly will and put
it into for-next ASAP.
