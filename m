From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning
	EIOwhentry_to_release_page fails
Date: Thu, 07 Aug 2008 06:21:34 -0400
Message-ID: <1218104494.15342.171.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
	 <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
	 <1218063477.6383.41.camel@mingming-laptop>
	 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2008-08-07 at 12:15 +0900, Hisashi Hifumi wrote:
> >/*
> > * This is like invalidate_complete_page(), except it ignores the page's
> > * refcount.  We do this because invalidate_inode_pages2() needs
> >stronger
> > * invalidation guarantees, and cannot afford to leave pages behind
> >because
> > * shrink_page_list() has a temp ref on them, or because they're
> >transiently
> > * sitting in the lru_cache_add() pagevecs.
> > */
> >
> >
> >I am wondering why we need stronger invalidate hurantees for DIO->
> >invalidate_inode_pages_range(),which force the page being removed from
> >page cache? In case of bh is busy due to ext3 writeout,
> >journal_try_to_free_buffers() could return different error number(EBUSY)
> >to try_to_releasepage() (instead of EIO).  In that case,  could we just
> >leave the page in the cache, clean pageuptodate() (to force later buffer
> >read to read from disk) and then invalidate_complete_page2() return
> >successfully? Any issue with this way?
> 
> My idea is that journal_try_to_free_buffers returns EBUSY if it fails due to
> bh busy, and dio write falls back to buffered write. This is easy to fix.
> 
> 

What about the invalidates done after the DIO has already run
non-buffered?

-chris


