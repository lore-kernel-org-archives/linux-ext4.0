From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: BUG_ON triggered in ext4_mb_complex_scan_group()
Date: Sun, 04 Apr 2010 23:36:06 -0500
Message-ID: <4BB968B6.1060005@redhat.com>
References: <m2uac8f92701004042130o76a81f3az89d538ebe0afea31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0DEEgR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 00:36:17 -0400
In-Reply-To: <m2uac8f92701004042130o76a81f3az89d538ebe0afea31@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jing zhang wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Mon Apr 5 12:10:50     2010
> 
> BUG_ON is triggered at [line:1762] in ext4_mb_complex_scan_group(),

Do you have a test case which can trigger this BUG_ON?

-Eric

> and fix is to change the return value of mb_find_extent() if the
> needed extent can not be found. The fix can also be applied to other
> points where mb_find_extent() is called.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> ---
>  fs/ext4/mballoc.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bba1282..fbb6899 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1321,7 +1321,7 @@ static int mb_find_extent(struct ext4_buddy
> *e4b, int order, int block,
>  		ex->fe_len = 0;
>  		ex->fe_start = 0;
>  		ex->fe_group = 0;
> -		return 0;
> +		return -ENOSPC;
>  	}
> 
>  	/* FIXME dorp order completely ? */
> @@ -1358,6 +1358,8 @@ static int mb_find_extent(struct ext4_buddy
> *e4b, int order, int block,
>  	}
> 
>  	BUG_ON(ex->fe_start + ex->fe_len > (1 << (e4b->bd_blkbits + 3)));
> +	if (needed > ex->fe_len)
> +		return -ENOSPC;
>  	return ex->fe_len;
>  }
> 
> @@ -1758,7 +1760,8 @@ void ext4_mb_complex_scan_group(struct
> ext4_allocation_context *ac,
>  			break;
>  		}
> 
> -		mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
> +		if (0 > mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex))
> +			break;
>  		BUG_ON(ex.fe_len <= 0);
>  		if (free < ex.fe_len) {
>  			ext4_grp_locked_error(sb, e4b->bd_group,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

