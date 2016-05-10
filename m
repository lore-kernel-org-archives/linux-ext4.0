From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 3/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
Date: Tue, 10 May 2016 16:16:41 +0200
Message-ID: <20160510141641.GM11897@quack2.suse.cz>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
 <1462571591-3361-4-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1462571591-3361-4-git-send-email-vishal.l.verma@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 06-05-16 15:53:09, Vishal Verma wrote:
> From: Matthew Wilcox <matthew.r.wilcox@intel.com>
> 
> dax_clear_sectors() cannot handle poisoned blocks.  These must be
> zeroed using the BIO interface instead.  Convert ext2 and XFS to use
> only sb_issue_zerout().
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> [vishal: Also remove the dax_clear_sectors function entirely]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
