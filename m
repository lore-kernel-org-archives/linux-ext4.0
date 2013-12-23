From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Fwd: [RESEND PATCH 1/2] ext4: fix a typo in extents.c
Date: Mon, 23 Dec 2013 10:17:30 -0200
Message-ID: <20131223121729.GB4284@orion.maiolino.org>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2buHtAYoRMAoJZqRHKAK2LQy68uPswWUP_oGWom1BYwbg@mail.gmail.com>
 <CAGBYx2bJKzNU9qQEbQjWKk3c=DzBEHu_5waa=2uShHwX3JbpYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab3LWMRf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 07:17:35 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBNCHZ6p011175
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 07:17:35 -0500
Received: from orion.maiolino.org (ovpn-113-60.phx2.redhat.com [10.3.113.60])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id rBNCHVs3016214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 07:17:34 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2bJKzNU9qQEbQjWKk3c=DzBEHu_5waa=2uShHwX3JbpYQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 01:11:38PM +0800, Yongqiang Yang wrote:
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
> @@ -3492,7 +3492,7 @@ static int
> ext4_ext_convert_to_initialized(handle_t *handle,
>         WARN_ON(map->m_lblk < ee_block);
>         /*
>          * It is safe to convert extent to initialized via explicit
> -        * zeroout only if extent is fully insde i_size or new_size.
> +        * zeroout only if extent is fully inside i_size or new_size.
>          */
>         split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
> 
Looks good
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
Carlos
