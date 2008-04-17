From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH] EXT: fix test ext_generic_write_end() copied return
	value
Date: Thu, 17 Apr 2008 08:44:36 -0700
Message-ID: <1208447076.17986.27.camel@badari-desktop>
References: <4806C23F.7080302@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	Nick Piggin <npiggin@suse.de>
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57653 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbYDQPod (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2008 11:44:33 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3HFiXtj001477
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2008 11:44:33 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3HFiXdW136248
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2008 09:44:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3HFiWbi013528
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2008 09:44:33 -0600
In-Reply-To: <4806C23F.7080302@tiscali.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-04-17 at 05:21 +0200, Roel Kluin wrote:
> 'copied' is unsigned, whereas 'ret2' is not. The test (copied < 0) fails
> 

While your patch is correct, we don't need it :(

"copied" can never be < 0. Infact, the check itself is NOT needed.
It might have been my fault to add that check, when we converted to
write_begin/end interfaces :(

As you can see block_write_end() never returns < 0.

Thanks,
Badari


> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index eb95670..43daaae 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1261,10 +1261,11 @@ static int ext3_ordered_write_end(struct file *file,
>  		new_i_size = pos + copied;
>  		if (new_i_size > EXT3_I(inode)->i_disksize)
>  			EXT3_I(inode)->i_disksize = new_i_size;
> -		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
> +		ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> -		if (copied < 0)
> -			ret = copied;
> +		copied = ret2;
> +		if (ret2 < 0)
> +			ret = ret2;
>  	}
>  	ret2 = ext3_journal_stop(handle);
>  	if (!ret)
> @@ -1289,10 +1290,11 @@ static int ext3_writeback_write_end(struct file *file,
>  	if (new_i_size > EXT3_I(inode)->i_disksize)
>  		EXT3_I(inode)->i_disksize = new_i_size;
>  
> -	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
> +	ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> -	if (copied < 0)
> -		ret = copied;
> +	copied = ret2;
> +	if (ret2 < 0)
> +		ret = ret2;
>  
>  	ret2 = ext3_journal_stop(handle);
>  	if (!ret)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 945cbf6..47d5d73 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1301,10 +1301,11 @@ static int ext4_ordered_write_end(struct file *file,
>  		new_i_size = pos + copied;
>  		if (new_i_size > EXT4_I(inode)->i_disksize)
>  			EXT4_I(inode)->i_disksize = new_i_size;
> -		copied = ext4_generic_write_end(file, mapping, pos, len, copied,
> +		ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> -		if (copied < 0)
> -			ret = copied;
> +		copied = ret2;
> +		if (ret2 < 0)
> +			ret = ret2;
>  	}
>  	ret2 = ext4_journal_stop(handle);
>  	if (!ret)
> @@ -1329,10 +1330,11 @@ static int ext4_writeback_write_end(struct file *file,
>  	if (new_i_size > EXT4_I(inode)->i_disksize)
>  		EXT4_I(inode)->i_disksize = new_i_size;
>  
> -	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
> +	ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> -	if (copied < 0)
> -		ret = copied;
> +	copied = ret2;
> +	if (ret2 < 0)
> +		ret = ret2;
>  
>  	ret2 = ext4_journal_stop(handle);
>  	if (!ret)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

