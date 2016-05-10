From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 4/5] dax: for truncate/hole-punch, do zeroing through
 the driver if possible
Date: Tue, 10 May 2016 16:21:19 +0200
Message-ID: <20160510142119.GN11897@quack2.suse.cz>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
 <1462571591-3361-5-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	Boaz Harrosh <boaz@plexistor.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462571591-3361-5-git-send-email-vishal.l.verma@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 06-05-16 15:53:10, Vishal Verma wrote:
> +static bool dax_range_is_aligned(struct block_device *bdev,
> +				 struct blk_dax_ctl *dax, unsigned int offset,
> +				 unsigned int length)
> +{
> +	unsigned short sector_size = bdev_logical_block_size(bdev);
> +
> +	if (((u64)dax->addr + offset) % sector_size)
> +		return false;
> +	if (length % sector_size)
> +		return false;

sector_size should better be a power of two so you can save some cycles by
using & instead of %.

> @@ -1240,11 +1254,17 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
>  			.size = PAGE_SIZE,
>  		};
>  
> -		if (dax_map_atomic(bdev, &dax) < 0)
> -			return PTR_ERR(dax.addr);
> -		clear_pmem(dax.addr + offset, length);
> -		wmb_pmem();
> -		dax_unmap_atomic(bdev, &dax);
> +		if (dax_range_is_aligned(bdev, &dax, offset, length))
> +			return blkdev_issue_zeroout(bdev, dax.sector,
> +					length / bdev_logical_block_size(bdev),
> +					GFP_NOFS, true);

This is actually wrong. blkdev_issue_zeroout() expects length to be simply
in units of 512-bytes. So you need length >> 9 here.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
