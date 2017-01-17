From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: fix coping of empty file using fiemap
Date: Mon, 16 Jan 2017 17:37:08 -0800
Message-ID: <20170117013708.GC14029@birch.djwong.org>
References: <CAO3qy=HA2K9j0a86R1EyM-zCnQxEgUVP-trr_5cgaeJThmrWyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47827 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdAQBhj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2017 20:37:39 -0500
Content-Disposition: inline
In-Reply-To: <CAO3qy=HA2K9j0a86R1EyM-zCnQxEgUVP-trr_5cgaeJThmrWyQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 16, 2017 at 07:59:17PM +0300, Artem Blagodarenko wrote:
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
> ---
>  misc/create_inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 5122e56..6083d94 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -510,7 +510,7 @@ static errcode_t try_fiemap_copy(ext2_filsys fs,
> int fd, ext2_file_t e2_file,
>          if (err < 0 && (errno == EOPNOTSUPP || errno == ENOTTY)) {
>              err = EXT2_ET_UNIMPLEMENTED;
>              goto out;
> -        } else if (err < 0 || fiemap_buf->fm_mapped_extents == 0) {
> +        } else if (err < 0 && fiemap_buf->fm_mapped_extents == 0) {

I think we want the loop to terminate any time fm_mapped_extents == 0,
not just in the case that err < 0 and fiemap_buf still reflects the
earlier memset(0)...

} else if (err < 0) {
	err = errno;
	goto out;
} else if (!fiemap_buf->fm_mapped_extents)
	goto out;

...right?

--D

>              err = errno;
>              goto out;
>          }
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
