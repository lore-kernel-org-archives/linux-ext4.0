From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH]:dir.c patch
Date: Sat, 25 Aug 2012 23:36:09 +0200
Message-ID: <50394549.5070308@fastmail.fm>
References: <CAGh4K3+7+4E0rt1Lwu-z1n-XrDtaiE4Vk82S0a98GVo4VnDA7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Christopher Sacchi <chris.sacchi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40468 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab2HYVgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Aug 2012 17:36:12 -0400
In-Reply-To: <CAGh4K3+7+4E0rt1Lwu-z1n-XrDtaiE4Vk82S0a98GVo4VnDA7Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2012 10:37 PM, Christopher Sacchi wrote:
> Here is a non-style issue dir.c-patch, and as far as I can see from
> the lines of code, the compilation errors weren't about what I put in.
> This patch fixes a "break" statement inside an "if" statement, as
> obviously not correct.

Why should that not be correct? It breaks the while(1) loop?

> Here's the patch for the kernel version v3.6.0rc3:
> 
> --
> Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
> --- dir.c	2012-08-25 15:47:24.260443900 -0400
> +++ dir.c	2012-08-25 16:02:05.458845600 -0400
> @@ -580,7 +580,6 @@ static int ext4_dx_readdir(struct file *
>  				return ret;
>  			if (ret == 0) {
>  				filp->f_pos = ext4_get_htree_eof(filp);
> -				break;

So ext4_htree_fill_tree() did not return more entries and the while(1)
loop shall be stopped?


Cheers,
Bernd
