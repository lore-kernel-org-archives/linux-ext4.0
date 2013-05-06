From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: implement error handling of
 ext4_mb_new_preallocation()
Date: Mon, 6 May 2013 12:24:10 -0700
Message-ID: <20130506192410.GA5622@blackbox.djwong.org>
References: <1367787075-11626-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	spruce-project@linuxtesting.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1367787075-11626-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 06, 2013 at 12:51:15AM +0400, Alexey Khoroshilov wrote:
> If memory allocation in ext4_mb_new_group_pa() is failed,
> it returns error code, ext4_mb_new_preallocation() propages it,
> but ext4_mb_new_blocks() ignores it.
> 
> An observed result was:
> - allocation fail means ext4_mb_new_group_pa() does not update ext4_allocation_context;
> - ext4_mb_new_blocks() sets ext4_allocation_request->len (ar->len = ac->ac_b_ex.fe_len;)
>   to number of blocks preallocated (512) instead of number of blocks requested (1);
> - that activates update cycle in ext4_splice_branch():
>     for (i = 1; i < blks; i++) <-- blks is 512 instead of 1 here
>       *(where->p + i) = cpu_to_le32(current_block++);
> - it iterates 511 times and corrupts a chunk of memory including inode structure;
> - page fault happens at EXT4_SB(inode->i_sb) in ext4_mark_inode_dirty();
> - system hangs with 'scheduling while atomic' BUG.
> 
> The patch implements a check for ext4_mb_new_preallocation() error code
> and handles its failure as if ext4_mb_regular_allocator() fails.
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  fs/ext4/mballoc.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index b1ed9e0..95c6b0d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4401,17 +4401,18 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  repeat:
>  		/* allocate space in core */
>  		*errp = ext4_mb_regular_allocator(ac);
> +		if (!*errp) {
> +			/* as we've just preallocated more space than
> +			 * user requested orinally, we store allocated

"originally"

--D
> +			 * space in a special descriptor */
> +			if (ac->ac_status == AC_STATUS_FOUND &&
> +					ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
> +				*errp = ext4_mb_new_preallocation(ac);
> +		}
>  		if (*errp) {
>  			ext4_discard_allocated_blocks(ac);
>  			goto errout;
>  		}
> -
> -		/* as we've just preallocated more space than
> -		 * user requested orinally, we store allocated
> -		 * space in a special descriptor */
> -		if (ac->ac_status == AC_STATUS_FOUND &&
> -				ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
> -			ext4_mb_new_preallocation(ac);
>  	}
>  	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
>  		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_clstrs);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
