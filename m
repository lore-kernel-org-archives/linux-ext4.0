From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Tue, 29 Mar 2016 23:56:46 -0700
Message-ID: <20160330065646.GA13123@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
 <20160330063415.GA2132@infradead.org>
 <1459320877.4102.3.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, linux-mm@kvack.org,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
To: Vishal Verma <vishal@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1459320877.4102.3.camel@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 30, 2016 at 12:54:37AM -0600, Vishal Verma wrote:
> On Tue, 2016-03-29 at 23:34 -0700, Christoph Hellwig wrote:
> > Hi Vishal,
> > 
> > still NAK to calling the direct I/O code directly from the dax code.
> 
> Hm, I thought this was what you meant -- do the fallback/retry attempts
> at the callers of dax_do_io instead of the new dax wrapper function..
> Did I misunderstand you?

Sorry, it is.  I misread fs/block_dev.c as fs/dax.c before my first
coffee this morning.  I'll properly review the series in the afternoon..

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
