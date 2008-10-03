From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Fri, 3 Oct 2008 12:43:51 +1000
Message-ID: <200810031243.51277.nickpiggin@yahoo.com.au>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <1222996262.12099.42.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:41067 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753978AbYJCCoA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 22:44:00 -0400
In-Reply-To: <1222996262.12099.42.camel@think.oraclecorp.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 03 October 2008 11:11, Chris Mason wrote:
> On Thu, 2008-10-02 at 23:48 +0530, Aneesh Kumar K.V wrote:
> > On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > > On Wed, 01 Oct 2008 14:40:51 -0400 Chris Mason 
<chris.mason@oracle.com> wrote:
> > > > > The patch below changes write_cache_pages to only use
> > > > > writeback_index when current_is_pdflush().  The basic idea is that
> > > > > pdflush is the only one who has concurrency control against the
> > > > > bdi, so it is the only one who can safely use and update
> > > > > writeback_index.
> > > >
> > > > Another approach would be to only update mapping->writeback_index if
> > > > nobody else altered it meanwhile.
> > >
> > > Ok, I can give that a short.
> > >
> > > > That being said, I don't really see why we get lots of seekiness when
> > > > two threads start their writing the file from the same offset.
> > >
> > > For metadata, it makes sense.  Pages get dirtied in strange order, and
> > > if writeback_index is jumping around, we'll get the seeky metadata
> > > writeback.
> > >
> > > Data makes less sense, especially the very high extent count from ext4.
> > > An extra printk shows that ext4 is calling redirty_page_for_writepage
> > > quite a bit in ext4_da_writepage.  This should be enough to make us
> > > jump around in the file.
> >
> > We need to do  start the journal before locking the page with jbd2.
> > That prevent us from doing any block allocation in writepage() call
> > back. So with ext4/jbd2 we do block allocation only in writepages()
> > call back where we start the journal with credit needed to write
> > a single extent. Then we look for contiguous unallocated logical
> > block and request the block allocator for 'x' blocks. If we get
> > less than that. The rest of the pages which we iterated in
> > writepages  are redirtied so that we try to allocate them again.
> > We loop inside ext4_da_writepages itself looking at wbc->pages_skipped
> >
> > 2481         if (wbc->range_cont && (pages_skipped !=
> > wbc->pages_skipped)) { 2482                 /* We skipped pages in this
> > loop */
> > 2483                 wbc->range_start = range_start;
> > 2484                 wbc->nr_to_write = to_write +
> >
> > > For a 4.5GB streaming buffered write, this printk inside
> > > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> >
> > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > call back with lots of unallocated buffer_heads(blocks). Also a journal
> > commit with jbd2 looks at the inode and all the dirty pages, rather than
> > the buffer_heads (journal_submit_data_buffers). We don't force commit
> > pages that doesn't have blocks allocated with the ext4. The consistency
> > is only with i_size and data.
>
> In general, I don't think pdflush or the VM expect
> redirty_pages_for_writepage to be used this aggressively.

BTW. redirty_page_for_writepage and the whole model of cleaning the page's
dirty bit *before* calling into the filesystem is really nasty IMO. For
one thing it opens races that mean a filesystem can't keep metadata about
the pagecache properly in synch with the page's dirty bit.

I have a patch in my fsblock series that fixes this and has the writepage()
function itself clear the page's dirty bit. This basically makes
redirty_page_for_writepages go away completely (at least the uses I looked
at, I didn't look at ext4 though).

Shall I break it out and submit it?
