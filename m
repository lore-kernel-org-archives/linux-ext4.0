From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Thu, 02 Oct 2008 21:11:02 -0400
Message-ID: <1222996262.12099.42.camel@think.oraclecorp.com>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081001215239.ee2ae63f.akpm@linux-foundation.org>
	 <1222950054.6745.18.camel@think.oraclecorp.com>
	 <20081002181856.GB29613@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:57538 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYJCBLS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 21:11:18 -0400
In-Reply-To: <20081002181856.GB29613@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-10-02 at 23:48 +0530, Aneesh Kumar K.V wrote:
> On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > On Wed, 01 Oct 2008 14:40:51 -0400 Chris Mason <chris.mason@oracle.com> wrote:
> > > 
> > > > The patch below changes write_cache_pages to only use writeback_index
> > > > when current_is_pdflush().  The basic idea is that pdflush is the only
> > > > one who has concurrency control against the bdi, so it is the only one
> > > > who can safely use and update writeback_index.
> > > 
> > > Another approach would be to only update mapping->writeback_index if
> > > nobody else altered it meanwhile.
> > > 
> > 
> > Ok, I can give that a short.
> > 
> > > That being said, I don't really see why we get lots of seekiness when
> > > two threads start their writing the file from the same offset.
> > 
> > For metadata, it makes sense.  Pages get dirtied in strange order, and
> > if writeback_index is jumping around, we'll get the seeky metadata
> > writeback.
> > 
> > Data makes less sense, especially the very high extent count from ext4.
> > An extra printk shows that ext4 is calling redirty_page_for_writepage
> > quite a bit in ext4_da_writepage.  This should be enough to make us jump
> > around in the file.
> 
> 
> We need to do  start the journal before locking the page with jbd2.
> That prevent us from doing any block allocation in writepage() call
> back. So with ext4/jbd2 we do block allocation only in writepages()
> call back where we start the journal with credit needed to write
> a single extent. Then we look for contiguous unallocated logical
> block and request the block allocator for 'x' blocks. If we get
> less than that. The rest of the pages which we iterated in
> writepages  are redirtied so that we try to allocate them again.
> We loop inside ext4_da_writepages itself looking at wbc->pages_skipped
> 
> 2481         if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
> 2482                 /* We skipped pages in this loop */
> 2483                 wbc->range_start = range_start;
> 2484                 wbc->nr_to_write = to_write +
> 
> 
> > 
> > For a 4.5GB streaming buffered write, this printk inside
> > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > 
> 
> Part of that can happen due to shrink_page_list -> pageout -> writepagee
> call back with lots of unallocated buffer_heads(blocks). Also a journal
> commit with jbd2 looks at the inode and all the dirty pages, rather than
> the buffer_heads (journal_submit_data_buffers). We don't force commit
> pages that doesn't have blocks allocated with the ext4. The consistency
> is only with i_size and data.

In general, I don't think pdflush or the VM expect
redirty_pages_for_writepage to be used this aggressively.

At this point I think we're best off if one of the ext4 developers is
able to reproduce and explain things in better detail than my hand
waving.

My patch is pretty lame, but it isn't a horrible bandage until we can
rethink the pdflush<->balance_dirty_pages<->kudpate interactions in
detail.

Two other data points, ext3 runs at 200MB/s with and without the patch.
Btrfs runs at 320MB/s with and without the patch, but only when I turn
checksums off.  The IO isn't quite as sequential with checksumming on
because the helper threads submit things slightly out of order (220MB/s
with checksums on).

Btrfs does use redirty_page_for_writepage if (current->flags &
PF_MEMALLOC) in my writepage call, but doesn't call it from the
writepages path.

-chris


