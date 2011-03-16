From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: critical info format fix in __acquire
Date: Wed, 16 Mar 2011 22:52:06 +0800
Message-ID: <4D80CE96.1080300@tao.ma>
References: <1300268245-18752-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
	stable-commits@vger.kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56897 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751131Ab1CPOw2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2011 10:52:28 -0400
In-Reply-To: <1300268245-18752-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Robin,
	The function that has the problem isn't ;__acquire', but
__ext4_grp_locked_error. the description __acquire is used for sparse
check. So I guess it is a little misleading for the subject. Please
change it. Thanks.

btw, You can add Cc: stable@kernel.org in your patch if you want this
patch to be in stable.

Regards,
Tao
On 03/16/2011 05:37 PM, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> When we do performence-testing on ext4 filesystem, we observe a warning
> like this:
> 
> [ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy:718: group 259825901 blocks in bitmap, 26057 in gd
> 
> indeed, it should be
> 
> group 2598, 25901 blocks in bitmap, 26057 in gd.
> 
> Reviewed-by: Coly Li <bosong.ly@taobao.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext4/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f6a318f..bb38475 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -594,7 +594,7 @@ __acquires(bitlock)
>  
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
> -	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u",
> +	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u, ",
>  	       sb->s_id, function, line, grp);
>  	if (ino)
>  		printk(KERN_CONT "inode %lu: ", ino);

