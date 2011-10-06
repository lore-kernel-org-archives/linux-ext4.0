From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3] [SIGNED-OFF] ext4: don't work without procfs
Date: Thu, 06 Oct 2011 09:01:18 -0700
Message-ID: <1317916878.1823.2.camel@Joe-Laptop>
References: <1317916276-2509-1-git-send-email-yargil@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
To: Fabrice Jouhaud <yargil@free.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:46495 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964856Ab1JFQBT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Oct 2011 12:01:19 -0400
In-Reply-To: <1317916276-2509-1-git-send-email-yargil@free.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2011-10-06 at 17:51 +0200, Fabrice Jouhaud wrote:
> From: Yargil <yargil@free.fr>

It would be better to use your full name on the "From: " line

> Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
> The problem come from the test of the return value of proc_mkdir
> that is always false without procfs and abort the init of ext4.
> 
> Signed-off-by: Fabrice Jouhaud <yargil@free.fr>
> ---
>  fs/ext4/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 44d0c8d..9b51b17 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4985,8 +4985,10 @@ static int __init ext4_init_fs(void)
>  	if (!ext4_kset)
>  		goto out6;
>  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
> +#ifdef CONFIG_PROC_FS
>  	if (!ext4_proc_root)
>  		goto out5;
> +#endif

It would make more sense as:

+#ifdef CONFIG_PROC_FS
	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
  	if (!ext4_proc_root)
 		goto out5;
+#endif


