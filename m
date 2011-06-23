From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] ext4: Rewrite ext4_page_mkwrite() to use generic
 helpers
Date: Thu, 23 Jun 2011 06:39:37 -0400
Message-ID: <20110623103937.GB5171@infradead.org>
References: <1308767062-27695-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50046
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758860Ab1FWKji (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jun 2011 06:39:38 -0400
Content-Disposition: inline
In-Reply-To: <1308767062-27695-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>  	loff_t size;
>  	unsigned long len;
> +	int ret;
>  	struct file *file = vma->vm_file;
>  	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct address_space *mapping = inode->i_mapping;
> +	handle_t *handle;
> +	get_block_t *get_block;
> +	int retries = 0;
>  
>  	/*
> +	 * This check is racy but catches the common case. We rely on
> +	 * __block_page_mkwrite() to do a reliable check.
>  	 */
> +	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> +	/* Delalloc case is easy... */
> +	if (test_opt(inode->i_sb, DELALLOC) &&
> +	    !ext4_should_journal_data(inode) &&
> +	    !ext4_nonda_switch(inode->i_sb)) {
> +		do {
> +			ret = __block_page_mkwrite(vma, vmf,
> +						   ext4_da_get_block_prep);
> +		} while (ret == -ENOSPC &&
> +		       ext4_should_retry_alloc(inode->i_sb, &retries));
> +		goto out_ret;

Is there any way to simply provide a different vm_operations_struct
and thus ->fault implementation for the delalloc vs non-delalloc case?

I think splitting those two cases completely would make the code a lot
more readable, even if there is a tiny amount of code duplication.

