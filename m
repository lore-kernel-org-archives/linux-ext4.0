From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [patch] ext4: simplify some code in read_mmp_block()
Date: Mon, 10 Aug 2015 17:07:47 -0600
Message-ID: <3FC4DED5-76F2-45DE-8E01-8796850CB120@dilger.ca>
References: <20150810213416.GB31724@mwanda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150810213416.GB31724@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


> On Aug 10, 2015, at 3:34 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> My static checker complains because it is not necessary to test
> "if (*bh)" when we just tested "if (!*bh)" on the lines before.
> We can remove the condition and pull everything in one indent level.
> 
> Then we have another "if (unlikely(!*bh))" check and the only way that
> can be true is if the "if (!buffer_uptodate(*bh))" condition was true so
> we can combine them together.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 8313ca3..736f12e 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -80,18 +80,15 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
> 	if (!*bh)
> 		*bh = sb_getblk(sb, mmp_block);
> 	if (!*bh)
> 		return -ENOMEM;

It may also be clearer if the second "if (!*bh)" check were below
the first one, like:

	if (!*bh) {
		*bh = sb_getblk(sb, mmp_block);
		if (!*bh)
			return -ENOMEM;
	}

That moves the second check out-of-line since it can only happen if
the first one is already true.

That said, it looks like this second "if (!*bh)" check was added
later on in commit 860d21e2 and the original logic made sense when
it was written, so that the ext4_warning() message below would get
printed in this case.  Otherwise the mount can fail without any
message being printed on the console at all. Other ext4 mount
failures print error messages, so this should be done here also.

> -	if (*bh) {
> -		get_bh(*bh);
> -		lock_buffer(*bh);
> -		(*bh)->b_end_io = end_buffer_read_sync;
> -		submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
> -		wait_on_buffer(*bh);
> -		if (!buffer_uptodate(*bh)) {
> -			brelse(*bh);
> -			*bh = NULL;
> -		}
> -	}
> -	if (unlikely(!*bh)) {
> +
> +	get_bh(*bh);
> +	lock_buffer(*bh);
> +	(*bh)->b_end_io = end_buffer_read_sync;
> +	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
> +	wait_on_buffer(*bh);
> +	if (!buffer_uptodate(*bh)) {
> +		brelse(*bh);
> +		*bh = NULL;
> 		ext4_warning(sb, "Error while reading MMP block %llu",
> 			     mmp_block);
> 		return -EIO;

Maybe it would be better to move the ext4_warning() to the end of the
function and then set rc in the failure cases with a goto err: and
print the message only once?

Cheers, Andreas





