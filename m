From: Coly Li <colyli@gmail.com>
Subject: Re: [PATCH] ext4: critical info format fix in __acquire
Date: Wed, 16 Mar 2011 18:42:33 +0800
Message-ID: <4D809419.1020508@gmail.com>
References: <1300268245-18752-1-git-send-email-hao.bigrat@gmail.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60965 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752270Ab1CPKOs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2011 06:14:48 -0400
In-Reply-To: <1300268245-18752-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B403=E6=9C=8816=E6=97=A5 17:37, Robin Dong Wrote:
> From: Robin Dong<sanbai@taobao.com>
>
> When we do performence-testing on ext4 filesystem, we observe a warni=
ng
[snip]

This bug is found on upstream 2.6.36 kernel. We ran a 2.6.36 kernel on =
the online system with 8 Ext4 file systems. 2 of=20
them are mounted with delayed allocation feature. This warning is only =
observed on delayed allocation enabled Ext4 file=20
systems.

This issue is not easy to reproduce, on two servers with 2.6.36 kenrel =
+ ext4, after running 110+ days, the error starts=20
to appear on kernel log. When check the error log, we found the info fo=
rmat should be fixed, that's how this patch comes.

=46or the bug mentioned in Robin's patch, we will start another thread =
to discuss.

Thanks.

Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
