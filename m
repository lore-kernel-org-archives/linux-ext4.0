From: Vishal Verma <vishal@kernel.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Wed, 30 Mar 2016 00:54:37 -0600
Message-ID: <1459320877.4102.3.camel@kernel.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	 <20160330063415.GA2132@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton
	 <akpm@linux-foundation.org>, linux-nvdimm@ml01.01.org, Dave Chinner
	 <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox
	 <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Vishal Verma
	 <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160330063415.GA2132@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2016-03-29 at 23:34 -0700, Christoph Hellwig wrote:
> Hi Vishal,
> 
> still NAK to calling the direct I/O code directly from the dax code.

Hm, I thought this was what you meant -- do the fallback/retry attempts
at the callers of dax_do_io instead of the new dax wrapper function..
Did I misunderstand you?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
