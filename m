From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 14:02:13 -0400
Message-ID: <20110421180213.GA19255@infradead.org>
References: <1303322378-sup-1722@think>
 <20110421083258.GA26784@infradead.org>
 <1303407205-sup-6141@think>
 <20110421174120.GA7267@infradead.org>
 <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1DUSCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 14:02:15 -0400
Content-Disposition: inline
In-Reply-To: <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 21, 2011 at 11:59:37AM -0600, Andreas Dilger wrote:
> But doesn't XFS have potentially very large extents, especially in the case of files that were fallocate()'d or linearly written?  If there is a single 8GB extent, and then random writes within that extent (seems very database like) grouping the all of the writes in the extent doesn't seem so great.

It doesn't cluster any writes in an extent.  It only writes out
additional dirty pages directly following that one we were asked to
write out.  As soon as we hit a non-dirty page we give up.

