From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Mon, 30 Mar 2009 07:44:22 -0400
Message-ID: <1238413462.30488.0.camel@think.oraclecorp.com>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
	 <1238187031.27455.212.camel@think.oraclecorp.com>
	 <1238187818.27455.217.camel@think.oraclecorp.com>
	 <20090327213052.GC5176@mit.edu>  <20090330112330.GA11357@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:49248 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZC3Low (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 07:44:52 -0400
In-Reply-To: <20090330112330.GA11357@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-03-30 at 16:53 +0530, Aneesh Kumar K.V wrote:
> On Fri, Mar 27, 2009 at 05:30:52PM -0400, Theodore Tso wrote:
> > On Fri, Mar 27, 2009 at 05:03:38PM -0400, Chris Mason wrote:
> > > > Ric had asked me about a test program that would show the worst case
> > > > ext3 behavior.  So I've modified your ext3 program a little.  It now
> > > > creates a 8G file and forks off another proc to do random IO to that
> > > > file.
> > > > 
> > > 
> > > My understanding of ext4 delalloc is that once blocks are allocated to
> > > file, we go back to data=ordered.  
> > 
> > Yes, that's correct.
> > 
> > > Ext4 is going pretty slowly for this fsync test (slower than ext3), it
> > > looks like we're going for a very long time in
> > > jbd2_journal_commit_transaction -> write_cache_pages.
> > 
> > One of the things that we can do to optimize this case for ext4 (and
> > ext3) is that if block has already been written out to disk once, we
> > don't have to flush it to disk a second time.  So if we add a new
> > buffer_head flag which can distinguish between blocks that have been
> > newly allocated (and not yet been flushed to disk) versus blocks that
> > have already been flushed to disk at least once, we wouldn't need to
> > force I/O for blocks in the latter case.
> 
> write_cache_pages should only look at pages which are marked dirty right
> ?. So why are we writing these pages again and again ?

The test program is constantly creating new dirty pages to random
offsets on the disk ;)

-chris


