From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd jbd2: fix dio
	writereturningEIOwhentry_to_release_page fails
Date: Wed, 13 Aug 2008 12:16:50 +0200
Message-ID: <20080813101650.GA14392@duck.suse.cz>
References: <1217971027.7516.20.camel@mingming-laptop> <1218029114.15342.58.camel@think.oraclecorp.com> <20080806135337.GA3615@duck.suse.cz> <1218063477.6383.41.camel@mingming-laptop> <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2> <1218104494.15342.171.camel@think.oraclecorp.com> <6.0.0.20.2.20080808113605.04141328@172.19.0.2> <1218200055.15342.230.camel@think.oraclecorp.com> <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2> <1218547706.15342.305.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zach Brown <zach.brown@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42117 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751362AbYHMKQw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 06:16:52 -0400
Content-Disposition: inline
In-Reply-To: <1218547706.15342.305.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 12-08-08 09:28:26, Chris Mason wrote:
> On Mon, 2008-08-11 at 15:25 +0900, Hisashi Hifumi wrote:
> > >> >> >I am wondering why we need stronger invalidate hurantees for DIO->
> > >> >> >invalidate_inode_pages_range(),which force the page being removed from
> > >> >> >page cache? In case of bh is busy due to ext3 writeout,
> > >> >> >journal_try_to_free_buffers() could return different error number(EBUSY)
> > >> >> >to try_to_releasepage() (instead of EIO).  In that case,  could we just
> > >> >> >leave the page in the cache, clean pageuptodate() (to force later buffer
> > >> >> >read to read from disk) and then invalidate_complete_page2() return
> > >> >> >successfully? Any issue with this way?
> > >> >> 
> > >> >> My idea is that journal_try_to_free_buffers returns EBUSY if it fails due to
> > >> >> bh busy, and dio write falls back to buffered write. This is easy to fix.
> > >> >> 
> > >> >> 
> > >> >
> > >> >What about the invalidates done after the DIO has already run
> > >> >non-buffered?
> > >> 
> > >> Dio write falls back to buffered IO when writing to a hole on ext3, I 
> > >think. I want to 
> > >> apply this mechanism to fix this issue. When try_to_release_page fails on 
> > >a page 
> > >> due to bh busy, dio write does buffered write, sync_page_range, and 
> > >> wait_on_page_writeback, imvalidates page cache to preserve dio semantics. 
> > >> Even if page invalidation that is carried out after 
> > >wait_on_page_writeback fails, 
> > >> there is no inconsistency between HDD and page cache.
> > >> 
> > >
> > >Sorry, I'm sure I wasn't very clear, I was referencing this code from
> > >mm/filemap.c:
> > >
> > >        written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
> > >
> > >        /*
> > >         * Finally, try again to invalidate clean pages which might have been
> > >         * cached by non-direct readahead, or faulted in by get_user_pages()
> > >         * if the source of the write was an mmap'ed region of the file
> > >         * we're writing.  Either one is a pretty crazy thing to do,
> > >         * so we don't support it 100%.  If this invalidation
> > >         * fails, tough, the write still worked...
> > >         */
> > >        if (mapping->nrpages) {
> > >                invalidate_inode_pages2_range(mapping,
> > >                                              pos >> PAGE_CACHE_SHIFT, end);
> > >        }
> > >
> > >If this second invalidate fails during a DIO write, we'll have up to
> > >date pages in cache that don't match the data on disk.  It is unlikely
> > >to fail because the conditions that make jbd unable to free a buffer are
> > >rare, but it can still happen with the write combination of mmap usage.
> > >
> > >The good news is the second invalidate doesn't make O_DIRECT return
> > >-EIO.  But, it sounds like fixing do_launder_page to always call into
> > >the FS can fix all of these problems.  Am I missing something?
> > >
> > 
> > My approach is not implementing do_launder_page for ext3.
> > It is needed to modify VFS.
> > 
> > My patch is as follows:
> 
> Sorry, I'm still not sure why the do_launder_page implementation is a
> bad idea.  Clearly Mingming spent quite some time on it in the past, but
> given that it could provide a hook for the FS to do expensive operations
> to make the page really go away, why not do it?
  I don't see any harm in doing this either. Only that launder_page() name
stops being appropriate after such change (because laundering means making
a clean page from a dirty one) hence the function was originally intended
for a different purpose AFAICT. Another thing is that using launder_page()
does not solve the problem with second invalidate_inode_pages2() failing
(mmap can still instantiate the page again before DIO write starts, modify
the page and commit code / writepage makes it busy during the invalidate) -
but the comment above that call seems to suggest that this is a known
problem and I agree that if somebody mixes mmapped and DIO writes,
he deserves unexpected results.

> As far as I can tell, the only current users afs, nfs and fuse.  Pushing
> down the PageDirty check to those filesystems should be trivial.
  Yes, not a big deal.

> With that said, I don't have strong feelings against falling back to
> buffered IO when the invalidate fails.  Maybe Zach remembers something I
> don't?
  I don't have a strong opinion either. Falling back to buffered writes is
simpler at least for ext3/ext4 because properly synchronizing against
writepage() call does not seem to have a nice solution either in
do_launder_page() or in releasepage(). OTOH is hides the fact the invalidate
is failing and so if we screw up something in future and it fails often, it
might be hard to notice / track down the performance penalty.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
