From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH] ext4: make it possible to interrupt initial readdir call
Date: Fri, 8 Apr 2016 14:18:41 -0400
Message-ID: <20160408181841.GI8871@kvack.org>
References: <20160302171511.GM12913@kvack.org> <20160302214330.GB24012@thunk.org> <20160314175732.GL17923@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:42740 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbcDHSSm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2016 14:18:42 -0400
Content-Disposition: inline
In-Reply-To: <20160314175732.GL17923@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No response on this patch yet....  Given that it's clearly a bug, and we've 
got a test case that reproduces it, why isn't this being applied?

		-ben

On Mon, Mar 14, 2016 at 01:57:32PM -0400, Benjamin LaHaise wrote:
> This patch is a follow up to the email "ext4 bug: getdents uninterruptible 
> for 117 seconds".  When doing the initial readdir on an ext4 filesystem 
> that grew a directory to 497MB (the filesystem image can be downloaded at
> http://www.kvack.org/~bcrl/ext4/ext4-readdir.img.xz), the first getdents64() 
> system call blocked for 117 seconds.  Begin to address this issue by making 
> the ext4 readdir() operation interruptible by fatal signals so that it is 
> possible to abort a process that is stuck on this operation.
> 
>  fs/ext4/dir.c   |    3 +++
>  fs/ext4/namei.c |    4 ++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 33f5e2a..a3e32e8 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -553,6 +553,9 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
>  		info->curr_node = rb_first(&info->root);
>  
>  	while (1) {
> +		if (fatal_signal_pending(current))
> +			return -ERESTARTSYS;
> +
>  		/*
>  		 * Fill the rbtree if we have no more entries,
>  		 * or the inode has changed since we last read in the
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 48e4b89..8097cd1 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -959,6 +959,10 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  	bh = ext4_read_dirblock(dir, block, DIRENT);
>  	if (IS_ERR(bh))
>  		return PTR_ERR(bh);
> +	if (fatal_signal_pending(current)) {
> +		brelse(bh);
> +		return -ERESTARTSYS;
> +	}
>  
>  	de = (struct ext4_dir_entry_2 *) bh->b_data;
>  	top = (struct ext4_dir_entry_2 *) ((char *) de +
> -- 
> "Thought is the essence of where you are now."

-- 
"Thought is the essence of where you are now."
