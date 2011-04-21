From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 14:02:43 -0400
Message-ID: <1303408883-sup-1495@think>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org> <1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org> <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca> <20110421180213.GA19255@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20110421180213.GA19255@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Christoph Hellwig's message of 2011-04-21 14:02:13 -0400:
> On Thu, Apr 21, 2011 at 11:59:37AM -0600, Andreas Dilger wrote:
> > But doesn't XFS have potentially very large extents, especially in the case of files that were fallocate()'d or linearly written?  If there is a single 8GB extent, and then random writes within that extent (seems very database like) grouping the all of the writes in the extent doesn't seem so great.
> 
> It doesn't cluster any writes in an extent.  It only writes out
> additional dirty pages directly following that one we were asked to
> write out.  As soon as we hit a non-dirty page we give up.

For this program, they are almost all dirty pages.

I tried patching it to give up if we seek but it is still pretty slow.
There's something else going on in addition to the xfs clustering being
too aggressive.

I'll try dropping the clustering completley.

-chris
