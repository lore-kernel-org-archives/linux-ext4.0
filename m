From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH] mke2fs.conf: Enable 64bit feature by default
Date: Mon, 3 Mar 2014 16:47:12 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403031646550.2258@localhost.localdomain>
References: <1371825747-9031-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbaCCPrQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2014 10:47:16 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s23FlEre020837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2014 10:47:15 -0500
Received: from dhcp-1-138.brq.redhat.com (dhcp-1-138.brq.redhat.com [10.34.1.138])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s23FlC5K021005
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2014 10:47:14 -0500
In-Reply-To: <1371825747-9031-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Jun 2013, Lukas Czerner wrote:

> Date: Fri, 21 Jun 2013 16:42:27 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: Lukas Czerner <lczerner@redhat.com>
> Subject: [RFC][PATCH] mke2fs.conf: Enable 64bit feature by default

Hi Ted,

are you going to take this in ?

Thanks!
-Lukas

> 
> The 64bit feature has been added to the ext4 a long time ago (2006?) so
> it should be ok to enable it by default by now. This would allow us to
> resize the file system past 16TB when it was originally smaller than
> that and user did not specified 64bit feature manually.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  misc/mke2fs.conf.in | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
> index 178733f..dde3219 100644
> --- a/misc/mke2fs.conf.in
> +++ b/misc/mke2fs.conf.in
> @@ -11,8 +11,7 @@
>  		features = has_journal
>  	}
>  	ext4 = {
> -		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
> -		auto_64-bit_support = 1
> +		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
>  		inode_size = 256
>  	}
>  	ext4dev = {
> 
