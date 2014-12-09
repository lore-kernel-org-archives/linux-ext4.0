From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext2fs: fix integer overflow in rb_get_bmap_range
Date: Tue, 09 Dec 2014 23:48:41 +0400
Message-ID: <87wq60wqna.fsf@openvz.org>
References: <1418153416-17750-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40147 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaLITso (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2014 14:48:44 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so11255194wiv.4
        for <linux-ext4@vger.kernel.org>; Tue, 09 Dec 2014 11:48:43 -0800 (PST)
In-Reply-To: <1418153416-17750-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

This is the patch for the issue which I complain you about prev
Friday. It takes longer than I expect, but now all my resize tests
succeeded. In fact issue may be triggered in real life situation
if someone use ballooning technique (consume space via fallocate)
> bmap_rb_extent is defined as __u64:blk __u64:count. So count can exceed INT_MAX on
> populated filesystems
>
> TESTCASE: xfstest ext4/004
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  lib/ext2fs/blkmap64_rb.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index 8d1778d..e290ade 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -733,7 +733,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
>  	struct rb_node *parent = NULL, *next, **n;
>  	struct ext2fs_rb_private *bp;
>  	struct bmap_rb_extent *ext;
> -	int count;
> +	__u64 count;
>  	__u64 pos;
>  
>  	bp = (struct ext2fs_rb_private *) bitmap->private;
> @@ -765,9 +765,9 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
>  		if (pos >= start + num)
>  			break;
>  		if (pos < start) {
> -			count -= start - pos;
> -			if (count < 0)
> +			if (pos + count <  start)
>  				continue;
> +			count -= start - pos;
>  			pos = start;
>  		}
>  		if (pos + count > start + num)
> -- 
> 1.8.3.1
