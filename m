From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH take3 1/1] nanosecond timestamps
Date: Tue, 27 Feb 2007 15:45:24 -0700
Message-ID: <20070227224523.GU10715@schatzie.adilger.int>
References: <1172569486.17385.12.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Johann Lombardi <johann.lombardi@bull.net>,
	TheodoreTso <tytso@mit.edu>, sct <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39933 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXB0Wp1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Feb 2007 17:45:27 -0500
Content-Disposition: inline
In-Reply-To: <1172569486.17385.12.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 27, 2007  15:14 +0530, Kalpak Shah wrote:
> +#define EXT4_EPOCH_BITS 2
> +
> +static inline __le32 ext4_encode_extra_time(struct timespec *time)
> +{
> +       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> +			   time->tv_sec >> 32 : 0) |
> +			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));

This should be "(time->tv_nsec << EXT4_EPOCH_BITS)".  We don't strictly
need the EXT4_NSEC_MASK because cpu_to_le32() will truncate the field to
32 bits anyways.

> +static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra) {
> +       if (sizeof(time->tv_sec) > 4)
> +	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> +			       << 32;
> +       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;

This should be ">> EXT4_EPOCH_BITS".  Similarly, le32_to_cpu() will truncate
extra to 32 bits and we shift away the "epoch" part of the field, so we don't
need the EXT4_NSEC_MASK at all.

> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)		  	       \
> +do {									       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, xtime))                              \
> +		(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);       \

We might consider doing this in the caller for the crtime field.  That is
only read/written in a single place, and it is the only one that needs the
extra check to determine if the seconds field is in the body of the inode.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
