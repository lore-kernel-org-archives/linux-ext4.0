From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/4] block: support compat discard mode by default.
Date: Thu, 11 Feb 2010 14:25:09 +0300
Message-ID: <87mxzgqaju.fsf@openvz.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
	<1265885870-21858-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jens.axboe@oracle.com, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48054 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0BKLZO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 06:25:14 -0500
In-Reply-To: <1265885870-21858-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Thu, 11 Feb 2010 13:57:50 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Currently there are many filesystems which has implemented
> discard support, but ssd discs not widely used yet.
> Let's allow user to use compat discard mode by default.
> After this feature is enabled by default for all devices which has
> no native discard support it will be possible to use this feature
> simply by passing appropriate mount option to fs (-odiscard in ext4)
BTW i've run tested ext4 with -odiscard option, and it survived more
24hour of stress tests test which consists of fsstress, compilation,
and etc
>
> This default option has many advantages:
> - Hope that this helps in real filesystem testing.
> - People who are crazy about data security whould be really happy.
> - Virtual machine developers also would like this feature.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/blkdev.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c762c9f..d7d028c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1010,7 +1010,7 @@ static inline int sb_issue_discard(struct super_block *sb,
>  	block <<= (sb->s_blocksize_bits - 9);
>  	nr_blocks <<= (sb->s_blocksize_bits - 9);
>  	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
> -				    DISCARD_FL_BARRIER);
> +				    DISCARD_FL_BARRIER|DISCARD_FL_COMPAT);
>  }
>  
>  extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
