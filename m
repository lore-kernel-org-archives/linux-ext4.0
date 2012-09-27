From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 06/10] vfs: enable hot data tracking
Date: Thu, 27 Sep 2012 13:54:25 +1000
Message-ID: <20120927035425.GN15236@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-7-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348404995-14372-7-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 23, 2012 at 08:56:31PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Miscellaneous features that implement hot data tracking
> and generally make the hot data functions a bit more friendly.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/direct-io.c               |   10 ++++++++++
>  include/linux/hot_tracking.h |   11 +++++++++++
>  mm/filemap.c                 |    8 ++++++++
>  mm/page-writeback.c          |   21 +++++++++++++++++++++
>  mm/readahead.c               |    9 +++++++++
>  5 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index f86c720..3773f44 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -37,6 +37,7 @@
>  #include <linux/uio.h>
>  #include <linux/atomic.h>
>  #include <linux/prefetch.h>
> +#include "hot_tracking.h"
>  
>  /*
>   * How many user pages to map in one call to get_user_pages().  This determines
> @@ -1297,6 +1298,15 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	prefetch(bdev->bd_queue);
>  	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
>  
> +	/* Hot data tracking */
> +	if (TRACK_THIS_INODE(iocb->ki_filp->f_mapping->host)
> +			&& iov_length(iov, nr_segs) > 0) {
> +		hot_rb_update_freqs(iocb->ki_filp->f_mapping->host,
> +				(u64)offset,
> +				(u64)iov_length(iov, nr_segs),
> +				rw & WRITE);
> +	}

That's a bit messy. I'd prefer a static inline function that hides
all this. e.g.

track_hot_inode_ranges(inode, offset, length, rw)
{
	if (inode->i_sb->s_flags & MS_HOT_TRACKING)
		hot_inode_freq_update(inode, offset, length, rw);
}

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 5ad5ce2..552c861 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -35,6 +35,7 @@
>  #include <linux/buffer_head.h> /* __set_page_dirty_buffers */
>  #include <linux/pagevec.h>
>  #include <linux/timer.h>
> +#include <linux/hot_tracking.h>
>  #include <trace/events/writeback.h>
>  
>  /*
> @@ -1895,13 +1896,33 @@ EXPORT_SYMBOL(generic_writepages);
>  int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	int ret;
> +	pgoff_t start = 0;
> +	u64 prev_count = 0, count = 0;
>  
>  	if (wbc->nr_to_write <= 0)
>  		return 0;
> +
> +	/* Hot data tracking */
> +	if (TRACK_THIS_INODE(mapping->host)
> +		&& wbc->range_cyclic) {
> +		start = mapping->writeback_index << PAGE_CACHE_SHIFT;
> +		prev_count = (u64)wbc->nr_to_write;
> +	}

Why only wbc->range_cyclic? This won't record things like
synchronous writes or fsync-triggered writes, are are far more
likely to be to hot ranges in a file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
