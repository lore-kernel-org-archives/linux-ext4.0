From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] fiemap support for ext3
Date: Wed, 23 Apr 2008 17:27:25 -0600
Message-ID: <20080423232725.GK3095@webber.adilger.int>
References: <20080423193914.GA25173@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63343 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbYDWX1b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 19:27:31 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3NNRVad029812
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 16:27:31 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZS00E01WXHIZ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Apr 2008 16:27:31 -0700 (PDT)
In-reply-to: <20080423193914.GA25173@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2008  15:39 -0400, Josef Bacik wrote:
> Here is my reworked fiemap patch for ext3.  The generic fiemap handler takes the
> get_block_t from the filesystem and does the fiemap that way, so then adding
> ext2 support should be a snap, as well as any other fs that wants to use this.

The generic mechanism is really good, some minor issues still exist.

> +int generic_block_fiemap(struct inode *inode, unsigned long arg,
> +			 get_block_t *get_block)
> +{
> +	/*
> +	 * if fm_start is in the middle of the current block, get the next
> +	 * block so we don't end up returning a start thats before the given
> +	 * fm_start
> +	 */
> +	start_blk = (fiemap_s->fm_start + (1 << inode->i_blkbits) - 1) >>
> +		inode->i_blkbits;

This should return the start of the current block (so the requested fm_start
is included in the returned mapping), instead of the start of the next block.

> +	/*
> +	 * we want the comparisons to be unsigned, in case somebody passes -1,
> +	 * meaning they want they want the entire file, but the result has to be
> +	 * signed so we can handle the case where we get more blocks than the
> +	 * size of the file
> +	 */
> +	length = (long)min((unsigned long)fiemap_s->fm_length,
> +			   (unsigned long)i_size_read(inode));

This might be written as:

	length = (long)min_t(unsigned long,fiemap_s->fm_len,i_size_read(inode));

Also, what about files that have blocks mapped after i_size?

> +		if (!tmp.b_blocknr) {
> +
> +			if (!hole) {

No empty line above "if (!hole)".

> +			fiemap_e.fe_offset = tmp.b_blocknr <<
> +				inode->i_blkbits;

This doesn't need to wrap.

> +			fiemap_e.fe_length = tmp.b_size;
> +
> +			if (length <= 0)
> +				fiemap_e.fe_flags |= FIEMAP_EXTENT_LAST;

Should the exit condition should be the first hole (block == 0) after i_size?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

