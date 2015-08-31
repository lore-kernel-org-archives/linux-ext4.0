From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] fs/ext4: fix potential endless loop in ext4_mb_discard_group_preallocations()
Date: Mon, 31 Aug 2015 16:34:36 -0600
Message-ID: <0E3B5981-84C9-474C-91C2-311CB8B85C24@dilger.ca>
References: <1441013790-87948-1-git-send-email-zhenzhang.zhang@huawei.com> <55E42270.9040503@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	adilger.kernel@dilger.ca,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35647 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbbHaWek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2015 18:34:40 -0400
Received: by pacdd16 with SMTP id dd16so152794986pac.2
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 15:34:40 -0700 (PDT)
In-Reply-To: <55E42270.9040503@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2015, at 3:46 AM, Zhang Zhen <zhenzhang.zhang@huawei.com> wrote:
> 
> In ext4_mb_discard_group_preallocations(), if free is always less
> than needed, and some PAs are always used in every loop, it will
> be endless loop.
> 
> Here we pick a random value to limit the max number of loop.
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> ---
> fs/ext4/mballoc.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 34b610e..553fbde 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3836,6 +3836,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
> 	int err;
> 	int busy = 0;
> 	int free = 0;
> +	int tried = 0;
> 
> 	mb_debug(1, "discard preallocation for group %u\n", group);
> 
> @@ -3886,9 +3887,11 @@ repeat:
> 		list_add(&pa->u.pa_tmp_list, &list);
> 	}
> 
> -	/* if we still need more blocks and some PAs were used, try again */
> -	if (free < needed && busy) {
> +	/* if we still need more blocks and some PAs were used, try again,
> +	   here 20 is a ramdon value. */

(typo) s/ramdon/random/

> +	if (free < needed && busy && tried < 20) {
> 		busy = 0;
> +		tried++;
> 		ext4_unlock_group(sb, group);
> 		cond_resched();
> 		goto repeat;

Looks OK otherwise.

Cheers, Andreas





