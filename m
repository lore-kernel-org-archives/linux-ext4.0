From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 23 Mar 2012 19:10:31 -0600
Message-ID: <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Andi Kleen <ak@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34457 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2CXBJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Mar 2012 21:09:22 -0400
In-Reply-To: <20120323221715.GA6712@tassilo.jf.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-23, at 4:17 PM, Andi Kleen wrote:
> We found that the super block cache line containing the extent cache
> hit/miss statistics counters is very hot in IO workloads.  
> 
> Besides the counter seems racy anyways and can lose updates because
> it's not atomic.
> 
> Disabling the counter make a very measurable difference in some IO
> micro benchmarks on a 4S system.
> 
> I just disabled it for now because it doesn't seem very useful due
> to its racy nature. An alternative would be to turn it into a per
> cpu counter, if someone really needs it.
> 
> Simple patch to disable it appended.
> 
> -Andi

The patch only disables the statistics counting, but not the sysfs
files that will now report bogus statistics.  I don't disagree with
disabling these stats, but if you are disabling the accounting you
should also comment out the functions in fs/ext4/super.c that are
printing out these statistics.

Cheers, Andreas

> ---
> 
> Disable statistics counter in ext4
> 
> This super bloc cache line is very hot and slows down high IO 
> workloads.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 74f23c2..7310b0e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2049,10 +2049,12 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
> 		ret = 1;
> 	}
> errout:
> +#if 0
> 	if (!ret)
> 		sbi->extent_cache_misses++;
> 	else
> 		sbi->extent_cache_hits++;
> +#endif
> 	trace_ext4_ext_in_cache(inode, block, ret);
> 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 	return ret;
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




