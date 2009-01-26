From: Jan Kara <jack@suse.cz>
Subject: Re: The meaning of data=ordered as it relates to delayed allocation
Date: Mon, 26 Jan 2009 14:24:45 +0100
Message-ID: <20090126132445.GC18681@atrey.karlin.mff.cuni.cz>
References: <E1LOiN8-0001Cj-91@closure.thunk.org> <20090119044345.GB9482@skywalker> <20090119124513.GC7598@mit.edu> <20090119144554.GJ9482@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42649 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAZNYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 08:24:47 -0500
Content-Disposition: inline
In-Reply-To: <20090119144554.GJ9482@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Jan 19, 2009 at 07:45:13AM -0500, Theodore Tso wrote:
> > On Mon, Jan 19, 2009 at 10:13:45AM +0530, Aneesh Kumar K.V wrote:
> > > > So I wonder if we should either:
> > > > 
> > > > (a) make data=ordered force block allocation and writeback --- which
> > > >     should just be a matter of disabling the
> > > >     redirty_page_for_writepage() code path in ext4_da_writepage()
> > > 
> > > We can't do that because we cannot do block allocation there. So we need
> > > to redirty the page that have unmapped buffer_heads.
> > 
> > What is preventing us from doing block allocation from
> > ext4_da_writepage()?
> > 
> The callback is called with page lock held and we can't start a journal
> with page lock held.
  There is actually even more fundamental problem with this.
ext4_da_writepage() is called from JBD2 commit code to commit ordered
mode data buffers. But when you're committing a transaction you might
not have enough space in the journal to do the allocation. OTOH I think
in it would be a good thing to allocate blocks on transaction commit
(in ordered mode) exactly because we'd have better consistency
guarantees. As Andreas points out, the downside would be that the fsync
problem we have with ext3 starts manifesting itself again.
  The question is how to technically implement allocation on commit time
- if we had transaction credits reserved it would not be a big deal, but
the problem is, we usually highly overestimate number of credits needed
for an allocation and these errors accumulate. So the result would be
that we'd have to commit transactions much earlier then we do now.
  So technically simpler might be to just ask pdflush to flush dirty
data on ext4 filesystem more often. We could actually queue a writeout
after every transaction commit. For users the result should be roughly
the same as writeout on transaction commit. Although it might take a bit
of time to allocate and writeout those 100M of dirty memory that can in
theory accumulate on average desktop so there might be noticable
differences. But it's going to be less noticable than that 30s kupdate
timeout which is default now.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
