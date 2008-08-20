From: Andreas Dilger <adilger@sun.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 17:42:08 -0600
Message-ID: <20080820234208.GO3392@webber.adilger.int>
References: <20080820054339.GB6381@skywalker>
 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
 <1219265808.7895.14.camel@mingming-laptop>
 <1219274535.7895.55.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38659 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYHTXmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 19:42:22 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7KNgHvC007822
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 16:42:18 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5X00E01B2WJX00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 20 Aug 2008 16:42:17 -0700 (PDT)
In-reply-to: <1219274535.7895.55.camel@mingming-laptop>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 20, 2008  16:22 -0700, Mingming Cao wrote:
> ext4: fall back to non delalloc mode if filesystem is almost full
> From: Mingming Cao <cmm@us.ibm.com>
> 
> In the case of filesystem is close to full (free blocks is below 
> the watermark NRCPUS *4) and there is not enough to reserve blocks for
> delayed allocation, instead of return user back with ENOSPC error, with
> this patch, it tries to fall back to non delayed allocation mode.

I don't think that making a low watermark of only 4 blocks is enough,
because each of the per-CPU counters could be off by as much as FBC_BATCH.
I think dropping delalloc support earlier is safer, something like
(FBC_BATCH * NR_CPUS).

> +static int ext4_write_begin_nondelalloc(struct file *file,
> +				struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned flags,
> +				struct page **pagep, void **fsdata)
> +{
> +	struct inode *inode = mapping->host;
> +
> +	/* turn off delalloc for this inode*/
> +	ext4_set_aops(inode, 0);
> +
> +	return mapping->a_ops->write_begin(file, mapping, pos, len,
> +					   flags, pagep, fsdata);
> +}

Hmm, I don't understand this - isn't delalloc already off here, because
this is "ext4_write_begin_nondelalloc()"?
 
> +void ext4_set_aops(struct inode *inode, int delalloc)
>  {
> +	if (test_opt(inode->i_sb, DELALLOC)) {
> +		if (ext4_has_free_blocks(EXT4_SB(inode->i_sb),
> +			 EXT4_MIN_FREE_BLOCKS) > EXT4_MIN_FREE_BLOCKS)
> +			delalloc = 0;
> +
> +		if (delalloc) {
> +			inode->i_mapping->a_ops = &ext4_da_aops;
> +			return;
> +		} else
> +			printk(KERN_INFO "filesystem is close to full, "
> +				"delayed allocation is turned off for "
> +				" inode %lu\n", inode->i_ino);
> +	}

Also, if you are doing this by changing the aops on the inode, isn't
it possible that a large write starts outside the EXT4_MIN_FREE_BLOCKS
boundary and then still runs out of space without changing the aops?

Instead it is maybe better to do the check at the start of
ext4_da_write_begin() and if it fails then call the non-delalloc
write_begin from there?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

