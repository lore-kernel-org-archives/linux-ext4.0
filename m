From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] mke2fs: fix coping of empty file using fiemap
Date: Tue, 17 Jan 2017 08:49:02 -0800
Message-ID: <20170117164902.GD14029@birch.djwong.org>
References: <CAO3qy=EeD4y6cX3JaA4ZKptoL9JH0Kc9zYqPWj-UZ+ythC6LXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36735 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdAQQuB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jan 2017 11:50:01 -0500
Content-Disposition: inline
In-Reply-To: <CAO3qy=EeD4y6cX3JaA4ZKptoL9JH0Kc9zYqPWj-UZ+ythC6LXw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 17, 2017 at 06:14:19PM +0300, Artem Blagodarenko wrote:
> Hello,
> 
> Darrick J. Wong, thank you for inspection. Here is second version of the patch.
> 
> Changes since v1:
> * errno is returned in case failed ioctl
> * loop is terminated any time fm_mapped_extents == 0
> 
> During filesystem creation with -d option files copied from given
> directory. If supported, FS_IOC_FIEMAP ioctl is used to get file
> extents. For empty file fm_mapped_extents is 0 and no error code
> is returned, because this is not fail situation.
> 
> Without this patch errno from previous operation is returned and
> successful FS_IOC_FIEMAP ioctl call for empty file is interpreted
> as error.
> 
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  misc/create_inode.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 5122e56..d9e9b9b 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -510,10 +510,12 @@ static errcode_t try_fiemap_copy(ext2_filsys fs,
> int fd, ext2_file_t e2_file,
>          if (err < 0 && (errno == EOPNOTSUPP || errno == ENOTTY)) {
>              err = EXT2_ET_UNIMPLEMENTED;
>              goto out;
> -        } else if (err < 0 || fiemap_buf->fm_mapped_extents == 0) {
> +        } else if (err < 0) {
>              err = errno;
>              goto out;
> -        }
> +        } else if (fiemap_buf->fm_mapped_extents == 0)
> +            goto out;
> +
>          for (i = 0, ext = ext_buf; i < fiemap_buf->fm_mapped_extents;
>               i++, ext++) {
>              err = copy_file_range(fs, fd, e2_file, ext->fe_logical,
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
