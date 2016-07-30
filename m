From: nborisov <n.borisov.lkml@gmail.com>
Subject: Re: Open bugs found by fuzzing as of 2016-07-30
Date: Sat, 30 Jul 2016 21:39:28 +0300
Message-ID: <09df1f58-ed4c-6887-e112-bbc68d9ec1d6@gmail.com>
References: <579CA5EB.1070707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Vegard Nossum <vegard.nossum@oracle.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36451 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbcG3Sjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jul 2016 14:39:31 -0400
Received: by mail-wm0-f42.google.com with SMTP id q128so324707581wma.1
        for <linux-ext4@vger.kernel.org>; Sat, 30 Jul 2016 11:39:30 -0700 (PDT)
In-Reply-To: <579CA5EB.1070707@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 30.07.2016 16:04, Vegard Nossum wrote:
> Hi,

Hi Vegard,

> 
> It's been two weeks since I posted the first list of bugs found using
> AFL: https://www.spinics.net/lists/linux-ext4/msg53022.html
> 
> With a bunch of ext4 patches going into 4.8 we're down from 15 to 6
> with current linus/master:

Are the patches going into 4.8 tagged for stable or are they going to go
just in to 4.8?

> 
> 1. general protection fault: 0000 [#1] KASAN
> http://139.162.151.198/f/ext4/57be666646a37e9821d52bc64846a3b3b785ee7a
> 
> 2. kernel BUG at fs/buffer.c:3061!
> http://139.162.151.198/f/ext4/7df880da89c82579c15ca8bc786a3467ca9c47f7
> 
> 3. kernel BUG at fs/ext4/inode.c:3738!
> http://139.162.151.198/f/ext4/5bdefda69f39b2f2c56d9b67d5b7d9e2cc8dfd5f
> (discussion: https://www.spinics.net/lists/linux-ext4/msg53032.html)
> 
> 4. kernel BUG at fs/ext4/mballoc.c:3191!
> http://139.162.151.198/f/ext4/34284738d67f0405325b2c43211c56020b9d0211
> 
> 5. kernel BUG at fs/jbd2/commit.c:825!
> http://139.162.151.198/f/ext4/3143febf7925bd1ea398bd1a775551133bd69ffd
> 
> 6. WARNING: CPU: 0 PID: 58 at fs/ext4/ext4.h:2748
> ext4_block_bitmap_csum_set+0x358/0x600
> http://139.162.151.198/f/ext4/9628c19aff0bbaaae4149a03486305c7f6cd7523
> 
> 
> Vegard
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
