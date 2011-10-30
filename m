From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/3] ext4: move variables to its scope
Date: Sun, 30 Oct 2011 22:00:37 +0800
Message-ID: <4EAD5885.2070308@coly.li>
References: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:35252 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755582Ab1J3NvO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 09:51:14 -0400
In-Reply-To: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B410=E6=9C=8830=E6=97=A5 19:30, Yongqiang Yang Wrote:
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/inode.c |    3 ++-
[snip]

Yongqiang,

Could you please to add any commit log to this patch set ? That could b=
e much helpful then only one line SOB :-)

Thanks.

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
