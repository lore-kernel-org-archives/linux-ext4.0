From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch] ext4: clean up the flags passed to __blockdev_direct_IO
 for extent-based files
Date: Fri, 24 Feb 2012 15:52:53 -0600
Message-ID: <4F4806B5.1040908@redhat.com>
References: <x49zkc7c36m.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab2BXVw4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 16:52:56 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1OLqt15023107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2012 16:52:55 -0500
In-Reply-To: <x49zkc7c36m.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/24/12 3:49 PM, Jeff Moyer wrote:
> Hi,
> 
> For extent-based files, you can perform DIO to holes, as mentioned in
> the comments in ext4_ext_direct_IO.  However, that function passes
> DIO_SKIP_HOLES to __blockdev_direct_IO, which is *really* confusing to
> the uninitiated reader.  The key, here, is that the get_block function
> passed in, ext4_get_block_write, completely ignores the create flag that
> is passed to it (the create flag is passed in from the direct I/O code,
> which uses the DIO_SKIP_HOLES flag to determine whether or not it should
> be cleared).
> 
> This is a long-winded way of saying that the DIO_SKIP_HOLES flag is
> ultimately ignored.  So, in the interest of preserving sanity, I propose
> the following patch.
> 
> Cheers,
> Jeff
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Thank you sir.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..521ca03 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2940,7 +2940,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  					 ext4_get_block_write,
>  					 ext4_end_io_dio,
>  					 NULL,
> -					 DIO_LOCKING | DIO_SKIP_HOLES);
> +					 DIO_LOCKING);
>  		if (iocb->private)
>  			EXT4_I(inode)->cur_aio_dio = NULL;
>  		/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

