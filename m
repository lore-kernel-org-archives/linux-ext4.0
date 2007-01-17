From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] more sanity check in extents
Date: Wed, 17 Jan 2007 15:23:31 -0700
Message-ID: <20070117222331.GL5236@schatzie.adilger.int>
References: <m364bd85cm.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54658 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXAQWXe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jan 2007 17:23:34 -0500
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m364bd85cm.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 12, 2007  03:18 +0300, Alex Tomas wrote:
> +/*
> + * the routine checks that every block start with key value specified
> + * in the pointed at the upper layer
> + */
> +static int __ext4_ext_check_interlevel(const char *function, struct inode *inode,
> +					struct ext4_ext_path *path, int depth)
> +{
> +	unsigned long key, first;
> +
> +	if (ext_depth(inode) == 0)
> +		return 0;
> +
> +	/* nothing to check at the top */
> +	if (depth == ext_depth(inode))
> +		return 0;
> +
> +	/* after split, a leaf can get zero entries
> +	 * thus there is nothing to check */
> +	if (le16_to_cpu(path->p_hdr->eh_entries) == 0)
> +		return 0;
> +
> +	if (depth == 0)
> +		first = le32_to_cpu(EXT_FIRST_EXTENT(path->p_hdr)->ee_block);
> +	else
> +		first = le32_to_cpu(EXT_FIRST_INDEX(path->p_hdr)->ei_block);
> +	path--;
> +	key = le32_to_cpu(path->p_idx->ei_block);
> +	
> +	if (likely(first == key))
> +		return 0;

What happens if, say, a leaf is split and then the first part of the split
is removed?  This could only happen with punch() on a running filesystem,
but in e2fsck a corrupt extent will be removed from the leaf without
updating the parent index's range.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
