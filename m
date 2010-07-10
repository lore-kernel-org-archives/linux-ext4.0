From: David Beal <linux-kernel@davidbeal.net>
Subject: Re: [PATCH] avoid NULL deference in ext2_xattr_get
Date: Sat, 10 Jul 2010 12:10:26 -0700
Message-ID: <20100710191026.GA12443@ciphex>
References: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: shenghui <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63681 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0GJTKh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jul 2010 15:10:37 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Sheng-Hui,

There is no NULL dereference in this particular case.  In Linux's printing
routines, printk("%s",(char*)0) is safe, and would result in a "<NULL>" token
being printed.

Indicating that the "name" argument is "<NULL>" in the output of the ea_debug
routine is clearly valuable, as its purpose is to emit debugging messages.

If your patch were applied, then a log message indicating that "name" is
"<NULL>" would not appear.  Adding ternary operator inside printk() argument
body is also not necessary.

Specifically, in lib/vsnprintf.c, which services printk, a check against NULL
is made for the string format specifier, %s:

lib/vsnprintf.c:
...
static char *string(char *buf, char *end, char *s, struct printf_spec spec)
{
        int len, i;

        if ((unsigned long)s < PAGE_SIZE)
                s = "<NULL>";
...

The NULL check inside snprintf is GOOD, as it makes printk safer, and removes
the need for the thousands of conditional branches that would need to be done
OUTSIDE the printk function in order to check whether the argument to %s is
NULL.

Branch prediction has an easier time working with a branch in a function that
is more often in the cache.

Thank you,
David Beal


On Sat, Jul 10, 2010 at 04:07:28PM +0800, shenghui wrote:
> Hi,
> 
>          I walked through ext2 code, and found one potential NULL deference
> in ext2/xattr.c.  The version is 2.6.35-rc4, while earlier versions have the
> same problem.
>          If you configure EXT2_XATTR_DEBUG, you'll get:
> # define ea_idebug(inode, f...) do { \
>                 printk(KERN_DEBUG "inode %s:%ld: ", \
>                         inode->i_sb->s_id, inode->i_ino); \
>                 printk(f); \
>                 printk("\n"); \
>         } while (0)
> 
> In ext2/xttr.c ext2_xattr_get, NULL pointer check is done after
> ea_idebug call, so some may hit NULL deference here.
>  ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>                 void *buffer, size_t buffer_size)
>  {
>          struct buffer_head *bh = NULL;
>          struct ext2_xattr_entry *entry;
>          size_t name_len, size;
>          char *end;
>          int error;
> 
>          ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
>                    name_index, name, buffer, (long)buffer_size);
> 
>          if (name == NULL)
>                  return -EINVAL;
> 
> 
> Following is my patch. Please check it.
> The patch is against kernel 2.6.35-rc4.
> 
> 
> From adc1fa6535034db3b6d8deebda6ec7eaa8bfd2f8 Mon Sep 17 00:00:00 2001
> From: Wang Sheng-Hui <crosslonelyover@gmail.com>
> Date: Sat, 10 Jul 2010 16:05:53 +0800
> Subject: [PATCH] avoid NULL deference in ext2_xattr_get
> 
> 
> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> ---
>  fs/ext2/xattr.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..81ec1c6 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int
> name_index, const char *name,
>  	char *end;
>  	int error;
> 
> +	if (name == NULL)
> +		return -EINVAL;
> +
>  	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
>  		  name_index, name, buffer, (long)buffer_size);
> 
> -	if (name == NULL)
> -		return -EINVAL;
>  	down_read(&EXT2_I(inode)->xattr_sem);
>  	error = -ENODATA;
>  	if (!EXT2_I(inode)->i_file_acl)
> -- 
> 1.6.3.3
> 
> 
> 
> 
> -- 
> 
> 
> Thanks and Best Regards,
> shenghui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
