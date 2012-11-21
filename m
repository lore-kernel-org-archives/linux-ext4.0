From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH -next] ext4: remove duplicated include from super.c
Date: Wed, 21 Nov 2012 14:06:02 +0800
Message-ID: <20121121060602.GA13053@gmail.com>
References: <CAPgLHd_PAXe7SYKsLOmwYUuYf6CWfyuHA0RLTBFf3mUTKzJhVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45566 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2KUFxT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2012 00:53:19 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1820431pad.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2012 21:53:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPgLHd_PAXe7SYKsLOmwYUuYf6CWfyuHA0RLTBFf3mUTKzJhVA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 21, 2012 at 01:30:42PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.

Hi Yongjun,

Here is another patch to fix this problem.
http://article.gmane.org/gmane.comp.file-systems.ext4/35490/match

Thanks,
                                                - Zheng

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/ext4/super.c | 1 -
>  1 file changed, 1 deletion(-)
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
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ext4.h>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
