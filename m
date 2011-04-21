From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 14:08:05 -0400
Message-ID: <20110421180805.GA2627@infradead.org>
References: <1303322378-sup-1722@think>
 <20110421083258.GA26784@infradead.org>
 <1303407205-sup-6141@think>
 <20110421174120.GA7267@infradead.org>
 <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
 <20110421180213.GA19255@infradead.org>
 <1303408883-sup-1495@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1303408883-sup-1495@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 21, 2011 at 02:02:43PM -0400, Chris Mason wrote:
> For this program, they are almost all dirty pages.
> 
> I tried patching it to give up if we seek but it is still pretty slow.
> There's something else going on in addition to the xfs clustering being
> too aggressive.

I'm not sure where you this beeing to agressive from - it's doing
exactly the same amount of I/O as a filesystem writing out a single
page from ->writepage or using write_cache_pages (either directly
or as a copy) as ->writepages.  The only thing special compared to
the no ->writepages case is that it's submitting a large I/O
from the first ->writepage call.

