From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/5] ext4: Use filemap_write_and_wait_range() correctly
 in collapse range
Date: Wed, 16 Apr 2014 20:38:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404162035010.2368@localhost.localdomain>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linkinjeon@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbaDPSiF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 14:38:05 -0400
In-Reply-To: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

there are still endianness problems with collapse range, I kind of
remember seeing some patches to fix that but I can not find those
anywhere. So let me know if you have those, otherwise I'll send
some.

Also since this patch set (or rather the patch #5) fixes the
collapse range so that it does not fail on fsx and fsstress we can
drop the fallocate mode block patches I think :)

Thanks!
-Lukas

On Wed, 16 Apr 2014, Lukas Czerner wrote:

> Date: Wed, 16 Apr 2014 20:32:58 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: linkinjeon@gmail.com, Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH 1/5] ext4: Use filemap_write_and_wait_range() correctly in
>     collapse range
> 
> Currently we're passing -1 as lend argumnet for
> filemap_write_and_wait_range() which is wrong since lend is signed type
> so it would cause some confusion and we might not write_and_wait for the
> entire range we're expecting to write.
> 
> Fix it by using LLONG_MAX instead.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ff823b7..821c1d4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5378,7 +5378,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
>  
>  	/* Write out all dirty pages */
> -	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
> +	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
>  	if (ret)
>  		return ret;
>  
> 
