From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: use strlcpy() instead of strncpy()
Date: Tue, 9 Jan 2018 11:06:55 +0100
Message-ID: <20180109100655.bdbnsrvhceaimaxh@quack2.suse.cz>
References: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753870AbeAIKG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 05:06:57 -0500
Content-Disposition: inline
In-Reply-To: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-01-18 16:58:39, Xiongfeng Wang wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> 
> gcc-8 reports
> 
> fs/ext4/super.c: In function '__save_error_info.isra.6':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 32 equals destination size [-Wstringop-truncation]
> 
> We need to use strlcpy() to make sure the dest string is nul-terminated.
> 
> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>

Please have a look how s_last_error_func is used. If you do that, you'll
notice that we do take care to print only sizeof(s_last_error_func)
characters from the string or NUL-terminate it (in e2fsprogs). So your
patch just wastes one character for useless NUL-termination...

								Honza

> ---
>  fs/ext4/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7c46693..051b988 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -323,11 +323,11 @@ static void __save_error_info(struct super_block *sb, const char *func,
>  		return;
>  	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
>  	es->s_last_error_time = cpu_to_le32(get_seconds());
> -	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
> +	strlcpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
>  	es->s_last_error_line = cpu_to_le32(line);
>  	if (!es->s_first_error_time) {
>  		es->s_first_error_time = es->s_last_error_time;
> -		strncpy(es->s_first_error_func, func,
> +		strlcpy(es->s_first_error_func, func,
>  			sizeof(es->s_first_error_func));
>  		es->s_first_error_line = cpu_to_le32(line);
>  		es->s_first_error_ino = es->s_last_error_ino;
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
