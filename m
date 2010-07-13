From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
Date: Mon, 12 Jul 2010 18:21:34 -0600
Message-ID: <3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
References: <871vbax86w.fsf@patl.com> <87zkxyvtjt.fsf@patl.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51741 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0GMAVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jul 2010 20:21:37 -0400
In-Reply-To: <87zkxyvtjt.fsf@patl.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-11, at 11:04, Patrick J. LoPresti wrote:
> +/* Check to make sure entire volume is addressable on this system.
> +   Requires osb_clusters_at_boot to be valid and for the journal to
> +   have been initialized by ocfs2_journal_init(). */
> +static int ocfs2_check_addressable(struct ocfs2_super *osb)
> +{
> +	/* Absolute addressability check (borrowed from ext4/super.c) */
> +	if ((max_block >
> +	     (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
> +	    (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
> +					     osb->sb->s_blocksize_bits))) {
> +		mlog(ML_ERROR, "Volume too large "
> +		     "to mount safely on this system");
> +		status = -EFBIG;
> +		goto out;
> +	}

This hunk of code is actually in several filesystems.  It wouldn't be a bad idea to make it a library function that can be called by the filesystem to check the kernel page cache and block layer can handle these large filesystems.

Cheers, Andreas





