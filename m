From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 1/4] fs: new infrastructure for writeback error
 handling and reporting
Date: Mon, 3 Apr 2017 07:47:22 -0700
Message-ID: <20170403144722.GB30811@bombadil.infradead.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <20170331192603.16442-2-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz, neilb@suse.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbdDCOrX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Apr 2017 10:47:23 -0400
Content-Disposition: inline
In-Reply-To: <20170331192603.16442-2-jlayton@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 31, 2017 at 03:26:00PM -0400, Jeff Layton wrote:
> This set adds a wb_error field and a sequence counter to the
> address_space, and a corresponding sequence counter in the struct file.
> When errors are reported during writeback, we set the error field in the
> mapping and increment the sequence counter.

> +++ b/fs/open.c
> @@ -709,6 +709,9 @@ static int do_dentry_open(struct file *f,
>  	f->f_inode = inode;
>  	f->f_mapping = inode->i_mapping;
>  
> +	/* Don't need the i_lock since we're only interested in sequence */
> +	f->f_wb_err_seq = inode->i_mapping->wb_err_seq;
> +

Do we need READ_ONCE() though, to ensure we get a consistent view of
wb_err_seq?  In particular, you made it 64 bit, so 32-bit architectures
are going to have a problem if it's rolling over between 2^32-1 and 2^32.

> +++ b/include/linux/fs.h
> @@ -394,6 +394,8 @@ struct address_space {
>  	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
>  	struct list_head	private_list;	/* ditto */
>  	void			*private_data;	/* ditto */
> +	u64			wb_err_seq;
> +	int			wb_err;
>  } __attribute__((aligned(sizeof(long))));
>  	/*
>  	 * On most architectures that alignment is already the case; but

I thought we had you convinced to make wb_err_seq an s32 and do clock
arithmetic?

> +int filemap_report_wb_error(struct file *file)
> +{
> +	int err = 0;
> +	struct inode *inode = file_inode(file);
> +	struct address_space *mapping = file->f_mapping;
> +
> +	spin_lock(&inode->i_lock);
> +	if (file->f_wb_err_seq < mapping->wb_err_seq) {
> +		err = mapping->wb_err;
> +		file->f_wb_err_seq = mapping->wb_err_seq;
> +	}
> +	spin_unlock(&inode->i_lock);
> +	return err;
> +}

Now that I think about this some more, I don't think you even need clock
arithmetic -- you just need !=.  And that means there's only a 1 in 2^32
chance that you miss an error.  Good enough, I say!  Particularly since
if errors are occurring that frequently that we wrapped the sequence
counter, the chance that we hit that magic point are really low.

We could even combine the two (I know Dave Chinner has been really
against growing struct address_space in the past):

int decode_wb_err(u32 wb_err)
{
	if (wb_err & 1)
		return -EIO;
	if (wb_err & 2)
		return -ENOSPC;
	return 0;
}

void set_wb_err(struct address_space *mapping, int err)
{
	if (err == -EIO)
		mapping->wb_err |= 1;
	else if (err == -ENOSPC)
		mapping->wb_err |= 2;
	else
		return;
	mapping->wb_err += 4;
}

...
	if (file->f_wb_err != mapping->wb_err) {
		err = decode_wb_err(mapping->wb_err);
		file->f_wb_err = mapping->wb_err;
	}
