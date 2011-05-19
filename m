From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/4] ext4: fix possible use-after-free ext4_remove_li_request()
Date: Thu, 19 May 2011 15:05:59 -0500
Message-ID: <4DD57827.9060104@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com> <1304956630-20384-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670Ab1ESUGC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 16:06:02 -0400
In-Reply-To: <1304956630-20384-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/9/11 10:57 AM, Lukas Czerner wrote:
> We need to take reference to the s_li_request after we take a mutex,
> because it might be freed since then, hence result in accessing old
> already freed memory. Also we should protect the whole
> ext4_remove_li_request() because ext4_li_info might be in the process of
> being freed in ext4_lazyinit_thread().

It'd be really great to have some comments which explain just what
ext4_li_mtx protects, but I'm working on an add-comments patch for
the lazyinit stuff (I commented things a bit as I reviewed your 
changes) so I'll send that along later.

in any case, the change looks ok, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/super.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c379af6..6a8e48f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2721,14 +2721,16 @@ static void ext4_remove_li_request(struct ext4_li_request *elr)
>  
>  static void ext4_unregister_li_request(struct super_block *sb)
>  {
> -	struct ext4_li_request *elr = EXT4_SB(sb)->s_li_request;
> -
> -	if (!ext4_li_info)
> +	mutex_lock(&ext4_li_mtx);
> +	if (!ext4_li_info) {
> +		mutex_unlock(&ext4_li_mtx);
>  		return;
> +	}
>  
>  	mutex_lock(&ext4_li_info->li_list_mtx);
> -	ext4_remove_li_request(elr);
> +	ext4_remove_li_request(EXT4_SB(sb)->s_li_request);
>  	mutex_unlock(&ext4_li_info->li_list_mtx);
> +	mutex_unlock(&ext4_li_mtx);
>  }
>  
>  static struct task_struct *ext4_lazyinit_task;

