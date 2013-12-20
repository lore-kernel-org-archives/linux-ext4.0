From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] ext4: fix a typo in extents.c
Date: Fri, 20 Dec 2013 12:56:43 +0800
Message-ID: <CAGBYx2bx1_ojsnW4OEWtagkKsOry8xqk_xzGqcy-0BfnTyTa3w@mail.gmail.com>
References: <1387434983-8137-1-git-send-email-yangyongqiang01@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Yongqiang Yang <yangyongqiang01@baidu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61943 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LTE5F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Dec 2013 23:57:05 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so803722eek.39
        for <linux-ext4@vger.kernel.org>; Thu, 19 Dec 2013 20:57:03 -0800 (PST)
In-Reply-To: <1387434983-8137-1-git-send-email-yangyongqiang01@baidu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

   Here is the 1st patch.

Thanks,
Yongqiang.

On Thu, Dec 19, 2013 at 2:36 PM, Yongqiang Yang
<yangyongqiang01@baidu.com> wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
> ---
>  fs/ext4/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 54d52af..3654dac 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3492,7 +3492,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>         WARN_ON(map->m_lblk < ee_block);
>         /*
>          * It is safe to convert extent to initialized via explicit
> -        * zeroout only if extent is fully insde i_size or new_size.
> +        * zeroout only if extent is fully inside i_size or new_size.
>          */
>         split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
>
> --
> 1.8.5.2
>



-- 
Best Wishes
Yongqiang Yang
