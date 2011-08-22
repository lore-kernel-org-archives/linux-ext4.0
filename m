From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/6 v5] ext4: Correct large hole offset calcuation
Date: Mon, 22 Aug 2011 10:50:30 -0500
Message-ID: <4E527AC6.30905@redhat.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com> <1313893787-25460-5-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1HVPue (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Aug 2011 11:50:34 -0400
In-Reply-To: <1313893787-25460-5-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/20/11 9:29 PM, Allison Henderson wrote:
> This bug was reported by Lukas Czerner while working on a
> new patch to add discard support for loop devices using
> punch hole.
> 
> The bug is happens because the data type for logical blocks is

s/is //

> not large enough to calculate the block offset for holes that are

Should that be "the _byte_ offset for holes ...?"

> very large.  This bug is resolved by casting the ext4_lblk_t
> to an loff_t before calculating the byte offset of the block.
> 
> Reviewed-and-Tested-by: Lukas Czerner <lczerner@redhat.com>
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>


I wonder if it'd be more straightforward to just use a mask
to compute these rather than the right shift / left shift, but
no big deal I guess esp. since we need the intermediate value
anyway?

Aside from the question about the commit message,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> :100644 100644 0d7617d... b417e47... M	fs/ext4/extents.c
>  fs/ext4/extents.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0d7617d..b417e47 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4179,8 +4179,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  		EXT4_BLOCK_SIZE_BITS(sb);
>  	last_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
>  
> -	first_block_offset = first_block << EXT4_BLOCK_SIZE_BITS(sb);
> -	last_block_offset = last_block << EXT4_BLOCK_SIZE_BITS(sb);
> +	first_block_offset = ((loff_t)first_block) << EXT4_BLOCK_SIZE_BITS(sb);
> +	last_block_offset = ((loff_t)last_block) << EXT4_BLOCK_SIZE_BITS(sb);
>  
>  	first_page = (offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>  	last_page = (offset + length) >> PAGE_CACHE_SHIFT;

