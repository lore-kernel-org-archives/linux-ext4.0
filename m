From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v2] ext3: ensure link targets are NULL-terminated
Date: Thu, 11 Dec 2008 19:32:28 -0800
Message-ID: <20081211193228.51c34114.akpm@linux-foundation.org>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	<1229022995-9898-2-git-send-email-duaneg@dghda.com>
	<1229022995-9898-3-git-send-email-duaneg@dghda.com>
	<1229022995-9898-4-git-send-email-duaneg@dghda.com>
	<1229022995-9898-5-git-send-email-duaneg@dghda.com>
	<1229022995-9898-6-git-send-email-duaneg@dghda.com>
	<20081211222605.GB18665@dastardly.home.dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Boaz Harrosh <bharrosh@panasas.com>, Stephen@kumera.dghda.com,
	Tweedie@kumera.dghda.com, sct@redhat.com, Andrew@kumera.dghda.com,
	Morton@kumera.dghda.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081211222605.GB18665@dastardly.home.dghda.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 11 Dec 2008 22:26:05 +0000 "Duane Griffin" <duaneg@dghda.com> wrote:

> Ensure link targets are NUL-terminated, even if corrupted on-disk.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
> 
> V2: terminate when the link is read instead of every time it is
> followed, as suggested by Dave Kleikamp.
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index f8424ad..c168781 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2817,9 +2817,10 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
>  		inode->i_op = &ext3_dir_inode_operations;
>  		inode->i_fop = &ext3_dir_operations;
>  	} else if (S_ISLNK(inode->i_mode)) {
> -		if (ext3_inode_is_fast_symlink(inode))
> +		if (ext3_inode_is_fast_symlink(inode)) {
>  			inode->i_op = &ext3_fast_symlink_inode_operations;
> -		else {
> +			((char *) ei->i_data)[inode->i_size] = '\0';
> +		} else {
>  			inode->i_op = &ext3_symlink_inode_operations;
>  			ext3_set_aops(inode);
>  		}

Really?  The ext2 on-disk format requires that the fast symlink be
null-terminated on disk?  Even though the length is already in i_size?

It seems that's true.  How un-ext2-like.

ext2 and ext4 need the same fix, yes?
