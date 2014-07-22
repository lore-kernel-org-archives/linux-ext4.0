From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Tue, 22 Jul 2014 11:38:38 +0200
Message-ID: <20140722093838.GA22331@quack.suse.cz>
References: <53CDF437.4090306@lge.com>
 <20140722073005.GT3935@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gioh Kim <gioh.kim@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140722073005.GT3935@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 22-07-14 09:30:05, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 02:18:47PM +0900, Gioh Kim wrote:
> > Hello,
> > 
> > This patch try to solve problem that a long-lasting page cache of
> > ext4 superblock disturbs page migration.
> > 
> > I've been testing CMA feature on my ARM-based platform
> > and found some pages for page caches cannot be migrated.
> > Some of them are page caches of superblock of ext4 filesystem.
> > 
> > Current ext4 reads superblock with sb_bread(). sb_bread() allocates page
> > from movable area. But the problem is that ext4 hold the page until
> > it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
> > 
> > I introduce a new API for allocating page from non-movable area.
> > It is useful for ext4 and others that want to hold page cache for a long time.
> 
> There's no word on why you can't teach ext4 to still migrate that page.
> For all I know it might be impossible, but at least mention why.
  It doesn't seem to be worth the effort to make that page movable to me
(it's reasonably doable since superblock buffer isn't accessed in *that*
many places but single movable page doesn't seem like a good tradeoff for
the complexity).

But this made me look into the migration code and it isn't completely clear
to me what makes the migration code decide that sb buffer isn't movable? We
seem to be locking the buffers before moving the underlying page but we
don't do any reference or state checks on the buffers... That seems to be
assuming that noone looks at bh->b_data without holding buffer lock. That
is likely true for ordinary data but definitely not true for metadata
buffers (i.e., buffers for pages from block device mappings).

Added linux-mm to CC to enlighten me a bit ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
