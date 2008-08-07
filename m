From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
	whentry_to_release_page fails
Date: Wed, 06 Aug 2008 21:07:24 -0400
Message-ID: <1218071244.15342.169.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
	 <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
	 <1218063477.6383.41.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1218063477.6383.41.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2008-08-06 at 15:57 -0700, Mingming Cao wrote:
> > 
> > > Does it make more sense to fix do_launder_page to call into the FS on
> > > every page, and let the FS check for PageDirty on its own?  That way
> > > invalidate_inode_pages2_range basically gets its own private call into
> > > the FS that says wait around until this page is really free.
> >   That would certainly work as well. But IMHO waiting for ->writepage()
> > call to finish isn't really a big deal even in try_to_release_page() if
> > __GFP_FS (and __GFP_WAIT) is set. The only problem is that there is no
> > effective way to do so and so Hisashi used that "wait for b_count to drop"
> > which looks really scary and I don't like it as well.
> > 
> 
> I was  looking at the comment in invalidate_complete_page2(), which is
> now only called from DIO path, it saids
> 
> /*
>  * This is like invalidate_complete_page(), except it ignores the page's
>  * refcount.  We do this because invalidate_inode_pages2() needs
> stronger
>  * invalidation guarantees, and cannot afford to leave pages behind
> because
>  * shrink_page_list() has a temp ref on them, or because they're
> transiently
>  * sitting in the lru_cache_add() pagevecs.
>  */
> 
> 
> I am wondering why we need stronger invalidate hurantees for DIO->
> invalidate_inode_pages_range(),which force the page being removed from
> page cache? In case of bh is busy due to ext3 writeout,
> journal_try_to_free_buffers() could return different error number(EBUSY)
> to try_to_releasepage() (instead of EIO).  In that case,  could we just
> leave the page in the cache, clean pageuptodate() (to force later buffer
> read to read from disk) and then invalidate_complete_page2() return
> successfully? Any issue with this way?

Isn't this similar to the recent splice thread?  It seems like there are
places in the kernel that expect an up to date page they have a
reference against to stay up to date.

-chris


