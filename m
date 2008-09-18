From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] ext3: truncate block allocated on a failed
	ext3_write_begin
Date: Thu, 18 Sep 2008 12:33:40 +0530
Message-ID: <20080918070340.GA7042@skywalker>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu> <1221319971-29879-2-git-send-email-tytso@mit.edu> <20080917122254.a704eff1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:47419 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbYIRHEx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2008 03:04:53 -0400
Content-Disposition: inline
In-Reply-To: <20080917122254.a704eff1.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 17, 2008 at 12:22:54PM -0700, Andrew Morton wrote:
> On Sat, 13 Sep 2008 11:32:49 -0400
> "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> 
> > From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > For blocksize < pagesize we need to remove blocks that got allocated in
> > block_write_begin() if we fail with ENOSPC for later blocks.
> > block_write_begin() internally does this if it allocated page
> > locally. This makes sure we don't have blocks outside inode.i_size
> > during ENOSPC.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: linux-ext4@vger.kernel.org
> > ---
> >  fs/ext3/inode.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index 507d868..bff22b9 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -1178,6 +1178,13 @@ write_begin_failed:
> >  		ext3_journal_stop(handle);
> >  		unlock_page(page);
> >  		page_cache_release(page);
> > +		/*
> > +		 * block_write_begin may have instantiated a few blocks
> > +		 * outside i_size.  Trim these off again. Don't need
> > +		 * i_size_read because we hold i_mutex.
> > +		 */
> > +		if (pos + len > inode->i_size)
> > +			vmtruncate(inode, inode->i_size);
> >  	}
> >  	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
> >  		goto retry;
> 
> Well we used to do this trimming in core VFS, but Nick broke it.  We
> still do it if the fs doesn't implement ->write_begin().

We still do it in block_write_begin if the pages are allocated by
block_write_begin.
> 
> Should we do this trimming in pagecache_write_begin() in both cases?


pagecache_write_begin is not used in the write_begin call path for
ext3/ext4.
generic_file_buffered_write
	generic_perform_write
		ext3_write_begin
			block_write_begin

-aneesh
