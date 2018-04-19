From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4 : fix comments in ext4_swap_extents
Date: Thu, 19 Apr 2018 16:50:28 +0200
Message-ID: <20180419145028.44fqs4wy5ofhvn5z@quack2.suse.cz>
References: <1521448449-25916-1-git-send-email-zhenwei.pi@youruncloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "zhenwei.pi" <zhenwei.pi@youruncloud.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521448449-25916-1-git-send-email-zhenwei.pi@youruncloud.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 19-03-18 16:34:09, zhenwei.pi wrote:
> "mark_unwritten" in comment and "unwritten" in variable
> argument lists is mismatch.
> 
> Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>

This seems to have fallen through cracks. The patch looks good to me. Ted,
can you please merge it? Thanks!

								Honza

> ---
>  fs/ext4/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 054416e..2fc4227 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5751,7 +5751,7 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
>   * @lblk1:	Start block for first inode
>   * @lblk2:	Start block for second inode
>   * @count:	Number of blocks to swap
> - * @mark_unwritten: Mark second inode's extents as unwritten after swap
> + * @unwritten: Mark second inode's extents as unwritten after swap
>   * @erp:	Pointer to save error value
>   *
>   * This helper routine does exactly what is promise "swap extents". All other
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
