From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext3/4: remove some unnecessary comments
Date: Thu, 27 Feb 2014 12:44:17 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402271241590.2247@localhost.localdomain>
References: <1393521230-3254-1-git-send-email-zhenzhang.zhang@huawei.com> <530F04B1.40105@huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
To: ZhangZhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaB0Lo1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 06:44:27 -0500
In-Reply-To: <530F04B1.40105@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 27 Feb 2014, ZhangZhen wrote:

> Date: Thu, 27 Feb 2014 17:26:09 +0800
> From: ZhangZhen <zhenzhang.zhang@huawei.com>
> To: jack@suse.cz, tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH] ext3/4: remove some unnecessary comments
> 
> The comments in the code are unnecessary, because every generic_file_write()
> is replaced by generic_file_aio_write().

I am sorry I do not understand. Is it unnecessary or wrong ? If it's
wrong why it is wrong ?

Your description suggests that this should be changed to mention
generic_file_aio_write() rather than generic_file_write().

Thanks!
-Lukas

> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> ---
>  fs/ext3/inode.c | 4 ----
>  fs/ext4/inode.c | 4 ----
>  2 files changed, 8 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 384b6eb..e08c2eb 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3212,10 +3212,6 @@ out_brelse:
>   *
>   * We are called from a few places:
>   *
> - * - Within generic_file_write() for O_SYNC files.
> - *   Here, there will be no transaction running. We wait for any running
> - *   transaction to commit.
> - *
>   * - Within sys_sync(), kupdate and such.
>   *   We wait on commit, if tol to.
>   *
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6e39895..5ef32f0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4399,10 +4399,6 @@ out_brelse:
>   *
>   * We are called from a few places:
>   *
> - * - Within generic_file_write() for O_SYNC files.
> - *   Here, there will be no transaction running. We wait for any running
> - *   transaction to commit.
> - *
>   * - Within sys_sync(), kupdate and such.
>   *   We wait on commit, if tol to.
>   *
> 
