From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h
 in super.c
Date: Mon, 19 Nov 2012 21:39:45 +0800
Message-ID: <20121119133944.GA11095@gmail.com>
References: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, patches@linaro.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65349 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2KSN1N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 08:27:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so453918pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 05:27:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 04:47:22PM +0530, Sachin Kamat wrote:
> ext4_extents.h was included twice.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  fs/ext4/super.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ad6cd8a..c8a6138 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -50,7 +50,6 @@
>  #include "xattr.h"
>  #include "acl.h"
>  #include "mballoc.h"
> -#include "ext4_extents.h"

Hi Sachin,

Sorry, I don't find this duplicated code in mainline kernel 3.7-rc6.

Regards,
                                                - Zheng

>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ext4.h>
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
