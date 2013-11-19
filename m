From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 20:20:02 +0800
Message-ID: <20131119122002.GB5339@gmail.com>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
 <20131119104508.GA4630@gmail.com>
 <20131119110147.GA3323@infradead.org>
 <20131119111947.GA4782@gmail.com>
 <20131119111826.GA20485@infradead.org>
 <20131119120112.GN11434@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62473 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3KSMRV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 07:17:21 -0500
Content-Disposition: inline
In-Reply-To: <20131119120112.GN11434@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 19, 2013 at 11:01:12PM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2013 at 03:18:26AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 19, 2013 at 07:19:47PM +0800, Zheng Liu wrote:
> > > Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
> > > it can pass the test.  But another question is why xfs fails when we do
> > > some append dio writes with doing buffered read.
> > 
> > Can you provide a test case for that issue?
> 
> For XFS, appending direct IO writes only hold the IOLOCK exclusive
> for as long as it takes to guarantee that the the region between the
> old EOF and the new EOF is full of zeros before it is demoted.  i.e.
> once the region is guaranteed not to expose stale data, the
> exclusive IO lock is demoted to to a shared lock and a buffered read
> is then allowed to proceed concurrently with the DIO write.
> 
> Hence even appending writes occur concurrently with buffered reads,
> and if the read overlaps the block at the old EOF then the page
> brought into the page cache will have zeros in it.
> 
> FWIW, there's a wonderful comment in generic_file_direct_write()
> that pretty much covers this case:
> 
>         /*
>          * Finally, try again to invalidate clean pages which might have been
>          * cached by non-direct readahead, or faulted in by get_user_pages()
>          * if the source of the write was an mmap'ed region of the file
>          * we're writing.  Either one is a pretty crazy thing to do,
>          * so we don't support it 100%.  If this invalidation
>          * fails, tough, the write still worked...
>          */
> 
> The kernel code simply does not have the exclusion mechanisms to
> make concurrent buffered and direct IO robust. This is one of the
> problems (amongst many) that we've been looking to solve with an VFS
> level IO range lock of some kind....

Thanks for pointing it out.

                                                - Zheng
