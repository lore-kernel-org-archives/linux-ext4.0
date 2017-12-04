From: piaojun <piaojun@huawei.com>
Subject: Re: [PATCH] ext4: no need flush workqueue before destroying it
Date: Mon, 4 Dec 2017 08:43:13 +0800
Message-ID: <5A249A21.7090305@huawei.com>
References: <5A210840.1020807@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:44719 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752079AbdLDAnb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 3 Dec 2017 19:43:31 -0500
In-Reply-To: <5A210840.1020807@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Could you help reviewing my patch?

thanks,
Jun

On 2017/12/1 15:44, piaojun wrote:
> destroy_workqueue() will do flushing work for us.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ext4/super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0556cd0..2f46b0b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -870,7 +870,6 @@ static void ext4_put_super(struct super_block *sb)
>  	ext4_unregister_li_request(sb);
>  	ext4_quota_off_umount(sb);
> 
> -	flush_workqueue(sbi->rsv_conversion_wq);
>  	destroy_workqueue(sbi->rsv_conversion_wq);
> 
>  	if (sbi->s_journal) {
> 
