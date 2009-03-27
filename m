From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 22:54:54 +0100
Message-ID: <20090327215454.GH31071@duck.suse.cz>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com> <20090327213052.GC5176@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers Lis
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZC0Vy5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 17:54:57 -0400
Content-Disposition: inline
In-Reply-To: <20090327213052.GC5176@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 27-03-09 17:30:52, Theodore Tso wrote:
> On Fri, Mar 27, 2009 at 05:03:38PM -0400, Chris Mason wrote:
> > > Ric had asked me about a test program that would show the worst case
> > > ext3 behavior.  So I've modified your ext3 program a little.  It now
> > > creates a 8G file and forks off another proc to do random IO to that
> > > file.
> > > 
> > 
> > My understanding of ext4 delalloc is that once blocks are allocated to
> > file, we go back to data=ordered.  
> 
> Yes, that's correct.
> 
> > Ext4 is going pretty slowly for this fsync test (slower than ext3), it
> > looks like we're going for a very long time in
> > jbd2_journal_commit_transaction -> write_cache_pages.
> 
> One of the things that we can do to optimize this case for ext4 (and
> ext3) is that if block has already been written out to disk once, we
> don't have to flush it to disk a second time.  So if we add a new
> buffer_head flag which can distinguish between blocks that have been
> newly allocated (and not yet been flushed to disk) versus blocks that
> have already been flushed to disk at least once, we wouldn't need to
> force I/O for blocks in the latter case.
>
> After all, most of the applications which do random I/O to a file
> normally will use fsync() appropriately such that they are rewriting
> already allocated blocks.  So there really is no reason to flush those
> blocks out to disk even in data=ordered mode.
> 
> We currently flush *all* blocks out to disk in data=ordered mode
> because we don't have a good way of telling the difference between the
> two cases.
  Yes, but OTOH this will make the problem "my data was lost after crash"
worse... Although rewrites aren't that common either so maybe it won't
be that bad.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
