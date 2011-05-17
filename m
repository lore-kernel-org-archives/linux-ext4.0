From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] fs: Create __block_page_mkwrite() helper passing
 error values back
Date: Tue, 17 May 2011 11:09:03 -0400
Message-ID: <20110517150903.GA6653@infradead.org>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <1305066574-1573-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1EQPJE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 11:09:04 -0400
Content-Disposition: inline
In-Reply-To: <1305066574-1573-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +	if (unlikely(ret < 0))
>  		unlock_page(page);
> +	else
>  		ret = VM_FAULT_LOCKED;
>  out:
>  	return ret;

Using two different types of return values here seems rather unclean.
I'd rather use 0 instead of VM_FAULT_LOCKED here, and maybe overload
-EAGAIN for VM_FAULT_NOPAGE.

> +int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> +		   get_block_t get_block)
> +{
> +	int ret = __block_page_mkwrite(vma, vmf, get_block);
> +
> +	if (unlikely(ret < 0)) {
> +		if (ret == -ENOMEM)
> +			return VM_FAULT_OOM;
> +		/* -ENOSPC, -EIO, etc */
> +		return VM_FAULT_SIGBUS;
> +	}
> +	return ret;

and maybe also add a small inlined block_page_mkwrite_error helper
to translate the values.

Alternatively it might make sense to add a VM_FAULT_ENOSPC return value
so that you could re-use block_page_mkwrite unmodified, and we could
also have better error reporting for that case for the core VM.

