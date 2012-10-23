From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Notify when discard is not supported
Date: Tue, 23 Oct 2012 11:14:19 -0200
Message-ID: <20121023131419.GA14662@andromeda.usersys.redhat.com>
References: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab2JWNOX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2012 09:14:23 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9NDENYw031351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2012 09:14:23 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-84.phx2.redhat.com [10.3.113.84])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9NDEKcO009879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2012 09:14:22 -0400
Content-Disposition: inline
In-Reply-To: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 19, 2012 at 02:12:37PM +0200, Lukas Czerner wrote:
> Notify user when mounting the file system with -o discard option, but
> the device does not support discard. Obviously we do not want to fail
> the mount or disable the options, because the underlying device might
> change in future even without file system remount.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/super.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7265a03..fd3ff41 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4017,6 +4017,14 @@ no_journal:
>  	}
>  #endif  /* CONFIG_QUOTA */
>  
> +	if (test_opt(sb, DISCARD)) {
> +		struct request_queue *q = bdev_get_queue(sb->s_bdev);
> +		if (!blk_queue_discard(q))
> +			ext4_msg(sb, KERN_WARNING,
> +				 "mounting with \"discard\" option, but "
> +				 "the device does not support discard");
> +	}
> +
>  	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
>  		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
>  		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
