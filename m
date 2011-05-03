From: Jan Kara <jack@suse.cz>
Subject: Re: your mail
Date: Tue, 3 May 2011 17:36:32 +0200
Message-ID: <20110503153632.GC6009@quack.suse.cz>
References: <4DBFE09E.5070805@canonical.com>
 <1304428117-6195-1-git-send-email-surbhi.palande@canonical.com>
 <20110503134636.GA6009@quack.suse.cz>
 <4DC009A9.20308@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, toshi.okajima@jp.fujitsu.com,
	tytso@mit.edu, m.mizuma@jp.fujitsu.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DC009A9.20308@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 03-05-11 16:56:57, Surbhi Palande wrote:
> On 05/03/2011 04:46 PM, Jan Kara wrote:
> >On Tue 03-05-11 16:08:36, Surbhi Palande wrote:
> 
> Sorry for missing the subject line :(
> >>On munmap() zap_pte_range() is called which dirties the PTE dirty pages as
> >>Toshiyuki pointed out.
> >>
> >>zap_pte_range()
> >>   mapping->a_ops->set_page_dirty (= ext4_journalled_set_page_dirty)
> >>
> >>So, I think that it is here that we should do the checking for a ext4 F.S
> >>frozen state and also prevent a parallel ext4 F.S freeze from happening.
> >>
> >>Attaching a patch for initial review. Please do let me know your thoughts!
> >   This is definitely the wrong place. ->set_page_dirty() callbacks are
> >called with various locks held and the page need not be locked (thus
> >dereferencing page->mapping is oopsable). Moreover this particular callback
> >is called only in data=journal mode.
> Ok! Thanks for that!
> 
> >
> >Believe me, the right place is page_mkwrite() - you have to catch the
> >read-only =>  read-write page transition. Once the page is mapped
> >read-write, you've already lost the race.
> 
> My only point is:
> 1) something should prevent the freeze from happening. We cant
> merely check the vfs_check_frozen()?
  Yes, I agree - see my other email with patches.

> And this should be done where the page is marked dirty.Also, I
> thought that the page is marked read-write only in the page table in
> the __do_page_fault()? i.e the zap_pte_range() marks them dirty in
> the page cache? Is this understanding right?
  The page can become dirty either because it was written via standard
write - write_begin is responsible for reliable check here - or it was
written via mmap - here we rely on page_mkwrite to do a reliable check -
it is analogous to write_begin callback. There should be no other way
to dirty a page.

With dirty bits it is a bit complicated. We have two of them in fact. One
in page table entry maintained by mmu and one in page structure maintained
by kernel. Some functions (such as zap_pte_range()) copy the dirty bits
from page table into struct page. This is a lazy process so page can in
principle have new data without a dirty bit set in struct page because we
have not yet copied the dirty bit from page table. Only at moments where it
is important (like when we want to unmap the page, or throw away the page,
or so), we make sure struct page and page table bits are in sync.

Another subtle thing you need not be aware of it that when we clear page
dirty bit, we also writeprotect the page. So we are guaranteed to get a
page fault when the page is written to again.

> IMHO, whatever code dirties the page in the page cache should call a
> F.S specific function and let it _prevent_ a fsfreeze while the page
> is getting dirtied, so that a freeze called after this point flushes
> this page!
  Agreed, that's what code in write_begin() and page_mkwrite() should
achieve.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
