From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: only call ext4_jbd2_file_inode when an inode has
 been extended
Date: Tue, 6 Sep 2011 17:57:39 +0200
Message-ID: <20110906155739.GA29735@quack.suse.cz>
References: <1315291106-25551-1-git-send-email-tytso@mit.edu>
 <20110906100253.GB23747@quack.suse.cz>
 <20110906153601.GA20571@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab1IFP5o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 11:57:44 -0400
Content-Disposition: inline
In-Reply-To: <20110906153601.GA20571@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-09-11 11:36:01, Ted Tso wrote:
> On Tue, Sep 06, 2011 at 12:02:53PM +0200, Jan Kara wrote:
> > That would seem possible as I'm looking e.g. into
> > ext4_convert_unwritten_extents(). But then any waiting for writeback from
> > kjournald is prone to deadlocks. In fact regardless of what kjournald does
> > there does not seem to be sane lock ordering since we have:
> > 
> > transaction start -> PageWriteback -> transaction start
> >                   ^                ^
> >                   |         end_io handling if I'm right
> >       enforced by write_cache_pages_da
> > 
> >   Which is really nasty. We cannot end page writeback until the page is
> > readable from disk which means until we have properly updated extent tree.
> > But for extent tree update we need a transaction. The only way out I can
> > see is to reserve space for extent tree update in a transaction in
> > writepages() and holding the transaction open until end_io time when we
> > change extent tree and close the transaction. But I'm afraid that's going
> > to suck under heavy load... 
> 
> Yes, that's a problem with ext4_convert_unwritten_extents() being
> called out of end_io handling, and of course dioread_nolock does a lot
> more of that, hence why it shows up in that mode.
> 
> I think the long-term solution here is that we have to reserve space
> and make the allocation decision at writepages() time, but we don't
> actually modify any on-disk state, hence we don't have to hold a
> transaction open.  We just prevent those disk blocks from getting
> allocated anywhere else, and we tentative assoicate physical blocks
> with the logical block numbers, but in a memory structure only.  Then
> when the pages are written, we can drop PageWriteback.  We don't have
> to wait until the extent blocks are written to disk, so long as any
> callers of ext4_map_blocks() get the right information (via an
> in-memory cache that we would have to add to make this whole thing
> first), and so long as fsync() not only calls filemap_fdatawrite(),
> but also waits for the metadata updates to the extent tree/indirect
> blocks have been completed.
  I have originally disregarded this option because it seemed to fragile.
But as you outline it here, it looks it should be doable.

								Honza
