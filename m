From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 13:41:21 -0400
Message-ID: <20110421174120.GA7267@infradead.org>
References: <1303322378-sup-1722@think>
 <20110421083258.GA26784@infradead.org>
 <1303407205-sup-6141@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1303407205-sup-6141@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 21, 2011 at 01:34:44PM -0400, Chris Mason wrote:
> Sorry, this doesn't do it.  I think that given what a strange special
> case this is, we're best off waiting for the IO-less throttling, and
> maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
> maybe not, it has to get written eventually either way.

I'm not sure what you mean with seek aware.  XFS only clusters
additional pages that are in the same extent, and in fact only does
so for asynchrononous writeback.  Not sure how this should be more
seek aware.

