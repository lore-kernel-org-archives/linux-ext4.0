From: Mikulas Patocka <mpatocka@redhat.com>
Subject: GFP_KERNEL in ext4 (was: [PATCH 4/4] Support discard if at least
 one underlying device supports it)
Date: Fri, 2 Jul 2010 16:08:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007021605410.13662@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
 <20100702181430.GD26916@redhat.com> <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab0GBUIQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 16:08:16 -0400
In-Reply-To: <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> ---
>  include/linux/blkdev.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.35-rc3-fast/include/linux/blkdev.h
> ===================================================================
> --- linux-2.6.35-rc3-fast.orig/include/linux/blkdev.h	2010-07-02 21:59:21.000000000 +0200
> +++ linux-2.6.35-rc3-fast/include/linux/blkdev.h	2010-07-02 21:59:37.000000000 +0200
> @@ -1021,7 +1021,7 @@ static inline int sb_issue_discard(struc
>  	block <<= (sb->s_blocksize_bits - 9);
>  	nr_blocks <<= (sb->s_blocksize_bits - 9);
>  	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
> 				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
>  }
>  
>  extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
> 

A note for ext4 developers: is that GFP_KERNEL safe? Can't it recurse back 
to ext4 and attempt to flush more data?

I'm not familiar enough with ext4 to declare that it is/isn't a bug, but 
it looks suspicious.

Mikulas
