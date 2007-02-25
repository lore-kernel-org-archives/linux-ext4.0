From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Sun, 25 Feb 2007 02:36:51 -0800
Message-ID: <20070225023651.8c89f8fc.akpm@linux-foundation.org>
References: <1170427180.6086.17.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com, tytso@mit.edu,
	sct@redhat.com
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59337 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699AbXBYKhq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Feb 2007 05:37:46 -0500
In-Reply-To: <1170427180.6086.17.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Fri, 02 Feb 2007 20:09:40 +0530 Kalpak Shah <kalpak@clusterfs.com> wrote:
> +#define EXT3_INODE_GET_XTIME(xtime, extra_xtime, inode, raw_inode)
> \
> +do {
> \
> +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);
> \
> +									      \
> +	if (offsetof(typeof(*raw_inode), extra_xtime) -
> \
> +	    offsetof(typeof(*raw_inode), i_extra_isize) +
> \
> +   	    sizeof((raw_inode)->extra_xtime) <=
> \
> +	    le16_to_cpu((raw_inode)->i_extra_isize)) {
> \
> +		if (sizeof((inode)->xtime.tv_sec) > 4)                        \
> +			(inode)->xtime.tv_sec |=                              \
> +			(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &       \
> +				EXT3_EPOCH_MASK) << 32;                       \
> +			(inode)->xtime.tv_nsec =                              \
> +				(le32_to_cpu((raw_inode)->extra_xtime) &      \
> +				EXT3_NSEC_MASK) >> 2;                         \
> +	}
> \
> +} while (0)

ow, my eyes.  Can we find a way to do this in C rather than in cpp?

> +static inline struct timespec ext3_current_time(struct inode *inode)
> +{
> +	return (inode->i_sb->s_time_gran < 1000000000) ?

NSEC_PER_SEC

> +		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
> +}
