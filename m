From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] PING  ext4: fix double unlock buffer mess during fs-resize
Date: Tue, 25 Sep 2012 19:25:18 +0400
Message-ID: <87d31aw2e9.fsf@openvz.org>
References: <1347012884-29484-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, djwong@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36102 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2IYPZW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 11:25:22 -0400
Received: by lbon3 with SMTP id n3so294578lbo.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2012 08:25:21 -0700 (PDT)
In-Reply-To: <1347012884-29484-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  7 Sep 2012 14:14:44 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> bh_submit_read() is responsible for unlock bh on endio
> 
Hi, are any objections against this fix?
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/resize.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 41f6ef6..3b05198 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1076,17 +1076,12 @@ static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
>  	struct buffer_head *bh = sb_getblk(sb, block);
>  	if (!bh)
>  		return NULL;
> -
> -	if (bitmap_uptodate(bh))
> -		return bh;
> -
> -	lock_buffer(bh);
> -	if (bh_submit_read(bh) < 0) {
> -		unlock_buffer(bh);
> -		brelse(bh);
> -		return NULL;
> +	if (!bh_uptodate_or_lock(bh)) {
> +		if (bh_submit_read(bh) < 0) {
> +			brelse(bh);
> +			return NULL;
> +		}
>  	}
> -	unlock_buffer(bh);
>  
>  	return bh;
>  }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
