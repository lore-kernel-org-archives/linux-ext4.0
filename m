From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] resize2fs: let online resizing report new blocks count right
Date: Sun, 1 Apr 2012 09:19:54 -0600
Message-ID: <B2459A4E-E00B-4FC9-9A7C-77B9142F20BD@dilger.ca>
References: <1328065448-13693-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "dsd@laptop.org" <dsd@laptop.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail121c7-2520.megamailservers.com ([69.49.98.23]:42621 "EHLO
	mail121c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751372Ab2DAP0J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Apr 2012 11:26:09 -0400
In-Reply-To: <1328065448-13693-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2012-01-31, at 20:04, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> After online resizing finishes, resize2fs loads the latest super block
> so that the new blocks count is reported correctly.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> resize/online.c |   16 ++++++++++++++--
> 1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/resize/online.c b/resize/online.c
> index 966ea1e..cb48556 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -97,8 +97,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>            exit(1);
>        }
>    } else {
> -        close(fd);
> -        return 0;
> +        goto succeeded;
>    }
> 
>    if ((ext2fs_blocks_count(sb) > MAX_32_NUM) ||
> @@ -220,6 +219,19 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>    }
> 
>    ext2fs_free(new_fs);
> +succeeded:
> +    /*
> +     * load the lastest super block.
> +     */
> +    io_channel_set_blksize(fs->io, SUPERBLOCK_OFFSET);
> +    retval = io_channel_read_blk(fs->io, 1, -SUPERBLOCK_SIZE,
> +                 fs->super);

Instead of using io_channel_read_blk() directly it is also possible to use ext2fs_read_block() with a negative size to force it to bypass the ext2fs cache. 

Cheers, Andreas

> +    if (retval == 0)
> +        *new_size = ext2fs_blocks_count(fs->super);
> +    else
> +        printf(_("Resize succeeded, however an error happened "
> +               "when loading super block.\n\n"));
> +
>    close(fd);
> 
>    return 0;
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
