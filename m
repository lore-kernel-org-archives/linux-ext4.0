From: Coly Li <i@coly.li>
Subject: Re: [PATCH 2/2] add '-s' flags for dumpe2fs manual
Date: Tue, 25 Jan 2011 17:07:02 +0800
Message-ID: <4D3E92B6.5050406@coly.li>
References: <1295935368-2516-1-git-send-email-hao.bigrat@gmail.com>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45035 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752841Ab1AYIlF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 03:41:05 -0500
In-Reply-To: <1295935368-2516-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B401=E6=9C=8825=E6=97=A5 14:02, Robin Dong Wrote:
> From: Robin Dong<sanbai@taobao.com>
>
> Singed-off-by: Robin Dong<sanbai@taobao.com>
> ---
>   misc/dumpe2fs.8.in |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
> index c1dfcbd..c48acc0 100644
> --- a/misc/dumpe2fs.8.in
> +++ b/misc/dumpe2fs.8.in
> @@ -55,6 +55,9 @@ can cause some of dumpe2fs's display to be suspect)=
=2E
>   only display the superblock information and not any of the block
>   group descriptor detail information.
>   .TP
> +.B \-s
> +display the block usage information.

How about modifying the above line like,

display the statistical information of file system blocks usage.

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
