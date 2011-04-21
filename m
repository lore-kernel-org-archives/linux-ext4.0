From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 13:34:44 -0400
Message-ID: <1303407205-sup-6141@think>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:48456 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1DURgw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 13:36:52 -0400
In-reply-to: <20110421083258.GA26784@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-04-21 04:32:58 -0400:
> On Wed, Apr 20, 2011 at 02:23:29PM -0400, Chris Mason wrote:
> But given that you are able to reproduce it, does the following patch
> help your latencies?  Currently XFS actually does stop I/O when
> nr_to_write reaches zero, but only for non-blocking I/O. This behaviour
> was introduced in commit efceab1d563153a2b1a6e7d35376241a48126989
> 
>     "xfs: handle negative wbc->nr_to_write during sync writeback"
> 
> and works around issues in the generic writeback code.
> 
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c    2011-04-21 10:20:48.303550404 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c    2011-04-21 10:20:58.203496773 +0200
> @@ -765,8 +765,7 @@ xfs_convert_page(
>          SetPageUptodate(page);
>  
>      if (count) {
> -        if (--wbc->nr_to_write <= 0 &&
> -            wbc->sync_mode == WB_SYNC_NONE)
> +        if (--wbc->nr_to_write <= 0)
>              done = 1;
>      }
>      xfs_start_page_writeback(page, !page_dirty, count);

Sorry, this doesn't do it.  I think that given what a strange special
case this is, we're best off waiting for the IO-less throttling, and
maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
maybe not, it has to get written eventually either way.

-chris
