From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 2/2] ext4: Make cache hits/misses per-cpu counts
Date: Thu, 5 May 2016 16:03:29 +0200
Message-ID: <20160505140329.GI1970@quack2.suse.cz>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <1461947276-25988-3-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461947276-25988-3-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 29-04-16 12:27:56, Waiman Long wrote:
> This patch changes the es_stats_cache_hits and es_stats_cache_misses
> statistics counts to percpu counters to reduce cacheline contention
> issues whem multiple threads are trying to update those counts
> simultaneously.
> 
> With a 38-threads fio I/O test with 2 shared files (on DAX-mount
> NVDIMM) running on a 4-socket Haswell-EX server with 4.6-rc1 kernel,
> the aggregated bandwidths before and after the patch were:
> 
>   Test          W/O patch       With patch      % change
>   ----          ---------       ----------      --------
>   Read-only     16499MB/s       17215MB/s        +4.3%
>   Read-write     4361MB/s        4794MB/s        +9.9%
> 
> Signed-off-by: Waiman Long <Waiman.Long@hpe.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
