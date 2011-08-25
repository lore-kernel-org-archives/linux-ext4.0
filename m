From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: remove redundant argument in mb_find_extent()
Date: Thu, 25 Aug 2011 10:28:13 -0600
Message-ID: <3F2A8D93-FAB2-4121-93CE-AB96DC687449@dilger.ca>
References: <1314272192-7414-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Ronbin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:43148 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1HYQ2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 12:28:15 -0400
In-Reply-To: <1314272192-7414-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-25, at 5:36 AM, Robin Dong wrote:
> From: Ronbin Dong <sanbai@taobao.com>
> 
> The argument of "ord" in mb_find_extent is not necessary anymore.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> fs/ext4/mballoc.c |    3 +--
> 1 files changed, 1 insertions(+), 2 deletions(-)

This patch doesn't remove the declaration "int ord;" at the start of the function.

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 17a5a57..0702627 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1432,9 +1432,8 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
> 		if (mb_test_bit(next, EXT4_MB_BITMAP(e4b)))
> 			break;
> 
> -		ord = mb_find_order_for_block(e4b, next);
> +		order = mb_find_order_for_block(e4b, next);
> 
> -		order = ord;
> 		block = next >> order;
> 		ex->fe_len += 1 << order;
> 	}
> -- 
> 1.7.4.1

Cheers, Andreas





