From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2image: fix invalid lseek error detection
Date: Wed, 24 Aug 2011 11:02:48 -0500
Message-ID: <4E5520A8.4030701@redhat.com>
References: <1314172834-18424-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab1HXQCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Aug 2011 12:02:51 -0400
In-Reply-To: <1314172834-18424-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/24/11 3:00 AM, Lukas Czerner wrote:
> In flush_l2_cache() we are using ext2fs_llseek() however we do not
> properly detect the error code returned from the function, because we
> are assigning it into ULL variable, hence we will not see negative
> values.
> 
> Fix this by changing the type of the variable to ext2_loff_t which is
> signed and hence will store negative values.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Yup!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  misc/e2image.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 83a9d02..bf0c0d4 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -759,7 +759,8 @@ static void put_used_table(struct ext2_qcow2_image *img,
>  
>  static void flush_l2_cache(struct ext2_qcow2_image *image)
>  {
> -	blk64_t offset, seek = 0;
> +	blk64_t seek = 0;
> +	ext2_loff_t offset;
>  	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
>  	struct ext2_qcow2_l2_table *table = cache->used_head;
>  	int fd = image->fd;

