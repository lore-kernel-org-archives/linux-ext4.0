From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 14:00:29 -0400
Message-ID: <1303408265-sup-2454@think>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org> <1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:42029 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1DUSCg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 14:02:36 -0400
In-reply-to: <20110421174120.GA7267@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-04-21 13:41:21 -0400:
> On Thu, Apr 21, 2011 at 01:34:44PM -0400, Chris Mason wrote:
> > Sorry, this doesn't do it.  I think that given what a strange special
> > case this is, we're best off waiting for the IO-less throttling, and
> > maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
> > maybe not, it has to get written eventually either way.
> 
> I'm not sure what you mean with seek aware.  XFS only clusters
> additional pages that are in the same extent, and in fact only does
> so for asynchrononous writeback.  Not sure how this should be more
> seek aware.
> 

How big are extents?  fiemap tells me the file has a single 8GB extent.

There's a little room for seeking inside there.

-chris
