From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 11:59:37 -0600
Message-ID: <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org> <1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:25112 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1DUR7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 13:59:39 -0400
In-Reply-To: <20110421174120.GA7267@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-21, at 11:41 AM, Christoph Hellwig wrote:
> On Thu, Apr 21, 2011 at 01:34:44PM -0400, Chris Mason wrote:
>> Sorry, this doesn't do it.  I think that given what a strange special
>> case this is, we're best off waiting for the IO-less throttling, and
>> maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
>> maybe not, it has to get written eventually either way.
> 
> I'm not sure what you mean with seek aware.  XFS only clusters
> additional pages that are in the same extent, and in fact only does
> so for asynchrononous writeback.  Not sure how this should be more
> seek aware.

But doesn't XFS have potentially very large extents, especially in the case of files that were fallocate()'d or linearly written?  If there is a single 8GB extent, and then random writes within that extent (seems very database like) grouping the all of the writes in the extent doesn't seem so great.


Cheers, Andreas





