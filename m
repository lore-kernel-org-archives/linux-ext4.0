From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: crypto return correct error for file_mmap when
 get_encryption_info failed.
Date: Sun, 1 Nov 2015 16:32:35 -0800
Message-ID: <20151102003235.GT10390@birch.djwong.org>
References: <CAOjcEBL6QQYdSpVq_6mSuzyMq6XO6kJGhseF6bD3WOeYLgC6Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Xu Cang <cangxumu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51259 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbbKBAcn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2015 19:32:43 -0500
Content-Disposition: inline
In-Reply-To: <CAOjcEBL6QQYdSpVq_6mSuzyMq6XO6kJGhseF6bD3WOeYLgC6Vw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 01, 2015 at 05:01:37PM -0500, Xu Cang wrote:
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 113837e..1c0086a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -295,7 +295,7 @@ static int ext4_file_mmap(struct file *file,
> struct vm_area_struct *vma)
>         if (ext4_encrypted_inode(inode)) {
>                 int err = ext4_get_encryption_info(inode);
>                 if (err)
> -                       return 0;
> +                       return -EACCES;

Shouldn't this return err here?

--D

>                 if (ext4_encryption_info(inode) == NULL)
>                         return -ENOKEY;
>         }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
