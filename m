From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] vfs: Block mmapped writes while the fs is frozen
Date: Wed, 18 May 2011 14:12:06 -0400
Message-ID: <20110518181206.GB10163@infradead.org>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <1305731882-8334-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>, tytso@mit.edu,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305731882-8334-3-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>  
>  	if (unlikely(ret < 0))
>  		unlock_page(page);
> +	else {
> +		/*
> +		 * Freezing in progress? We check after the page is marked
> +		 * dirty and with page lock held so if the test here fails, we
> +		 * are sure freezing code will wait during syncing until the
> +		 * page fault is done - at that point page will be dirty and
> +		 * unlocked so freezing code will write it and writeprotect it
> +		 * again.
> +		 */
> +		set_page_dirty(page);
> +		if (inode->i_sb->s_frozen != SB_UNFROZEN) {
> +			unlock_page(page);
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +	}
>  out:
>  	return ret;

The code structure looks a bit odd, why not:

	if (ret < 0)
		goto out_unlock;

	set_page_dirty(page);
	if (inode->i_sb->s_frozen != SB_UNFROZEN) {
		ret = -EAGAIN;
		goto out_unlock;
	}

	return 0;

out_unlock:
	unlock_page(page);
	return ret;
}

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
