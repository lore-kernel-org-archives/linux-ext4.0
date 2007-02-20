From: Adrian Bunk <bunk@stusta.de>
Subject: [RFC: 2.6.16 patch] ext3: fix ext3 block bitmap leakage
Date: Tue, 20 Feb 2007 16:19:50 +0100
Message-ID: <20070220151950.GV13958@stusta.de>
References: <45DA2CB2.4080507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kirill Korotaev <dev@openvz.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37114 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965046AbXBTPTv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Feb 2007 10:19:51 -0500
Content-Disposition: inline
In-Reply-To: <45DA2CB2.4080507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 19, 2007 at 06:03:14PM -0500, Chuck Ebbert wrote:

> This was dropped from 2.6.16-stable somehow:
> 
> http://lkml.org/lkml/2006/6/30/54

Thanks for forwarding it.

This patch didn't went in this form into Linus' tree, I'd therefore like 
to get an ACK from the ext3 maintainers (Cc'ed) before applying it.

> Below is probably mangled by Thunderbird, you'll have
> to fetch it yourself if you want to merge it:

patch(1) has a nice -l option for applying such patches.  :-)

> From:	Kirill Korotaev <>
> 
> This patch fixes ext3 block bitmap leakage,
> which leads to the following fsck messages on
> _healthy_ filesystem:
> Block bitmap differences:  -64159 -73707
> 
> All kernels up to 2.6.17 have this bug.
> 
> Found by
>    Vasily Averin <vvs@sw.ru> and Andrey Savochkin <saw@sawoct.com>
> Test case triggered the issue was created by
>    Dmitry Monakhov <dmonakhov@sw.ru>
> 
> Signed-Off-By: Vasiliy Averin <vvs@sw.ru>
> Signed-Off-By: Andrey Savochkin <saw@sawoct.com>
> Signed-Off-By: Kirill Korotaev <dev@openvz.org>
> CC: Dmitry Monakhov <dmonakhov@sw.ru>
> 
> --- ./fs/ext3/inode.c.e3crp	2006-06-28 05:22:40.000000000 +0400
> +++ ./fs/ext3/inode.c	2006-06-27 13:31:20.000000000 +0400
> @@ -585,6 +585,7 @@ static int ext3_alloc_branch(handle_t *h
> 
>   	branch[0].key = cpu_to_le32(parent);
>   	if (parent) {
> +		keys = 1;
>   		for (n = 1; n < num; n++) {
>   			struct buffer_head *bh;
>   			/* Allocate the next block */

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
