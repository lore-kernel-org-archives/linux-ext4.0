From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Tue, 7 Oct 2008 09:29:11 -0400
Message-ID: <20081007132911.GA6905@mit.edu>
References: <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker> <20081007090554.GA23811@infradead.org> <20081007100257.GA30745@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46111 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753384AbYJGNab (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 09:30:31 -0400
Content-Disposition: inline
In-Reply-To: <20081007100257.GA30745@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2008 at 03:32:57PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Oct 07, 2008 at 05:05:54AM -0400, Christoph Hellwig wrote:
> > On Tue, Oct 07, 2008 at 02:15:31PM +0530, Aneesh Kumar K.V wrote:
> > > +static int ext4_write_cache_pages(struct address_space *mapping,
> > > +		      struct writeback_control *wbc, writepage_t writepage,
> > > +		      void *data)
> > > +{
> > 
> > Looking at this functions the only difference is killing the
> > writeback_index and range_start updates.  If they are bad why would we
> > only remove them from ext4?
> 
> I am also not updating wbc->nr_to_write.
    ...
> I don't think other filesystem have this requirement.

That's true, but there is a lot of code duplication, which means that
bugs or changes in write_cache_pages() would need to be fixed in
ext4_write_cache_pages().  So another approach that might be better
from a long-term code maintenance point of view is to add a flag in
struct writeback_control that tells write_cache_pages() not to update
those fields, and avoid duplicating approximately 95 lines of code.
It means a change in a core mm function, though, so if folks thinks
its too ugly, we can make our own copy in fs/ext4.

Opinions?  Andrew, as someone who often weighs in on fs and mm issues,
what do you think?  My preference would be to make the change to
mm/page-writeback.c, controlled by a flag which ext4 would set be set
by fs/ext4 before it calls write_cache_pages().

						- Ted
