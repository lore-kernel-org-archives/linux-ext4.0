From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] dax: handle media errors in dax_do_io
Date: Fri, 25 Mar 2016 03:45:49 -0700
Message-ID: <20160325104549.GB10525@infradead.org>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
 <1458861450-17705-6-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458861450-17705-6-git-send-email-vishal.l.verma@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 24, 2016 at 05:17:30PM -0600, Vishal Verma wrote:
> dax_do_io (called for read() or write() for a dax file system) may fail
> in the presence of bad blocks or media errors. Since we expect that a
> write should clear media errors on nvdimms, make dax_do_io fall back to
> the direct_IO path, which will send down a bio to the driver, which can
> then attempt to clear the error.

Leave the fallback on -EIO to the callers please.  They generally call
__blockdev_direct_IO anyway, so it should actually become simpler that
way.
