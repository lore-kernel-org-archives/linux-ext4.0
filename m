From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/3] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Thu, 17 Apr 2014 13:15:48 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404171313210.2143@localhost.localdomain>
References: <002b01cf59c3$878af780$96a0e680$@samsung.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2015149015-1397733352=:2143"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaDQLP5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 07:15:57 -0400
In-Reply-To: <002b01cf59c3$878af780$96a0e680$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2015149015-1397733352=:2143
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Thu, 17 Apr 2014, Namjae Jeon wrote:

> Date: Thu, 17 Apr 2014 07:30:54 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
>     Luká¹ Czerner <lczerner@redhat.com>
> Subject: [PATCH 3/3] ext4: disable COLLAPSE_RANGE for bigalloc
> 
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Once COLLAPSE RANGE is be disable for ext4 with bigalloc feature till finding
> root-cause of problem. It will be enable with fixing that regression of
> xfstest(generic 075 and 091) again.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/extents.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a64242f..8d45ef8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5461,6 +5461,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  		goto out_mutex;
>  	}
>  
> +	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
> +		ret = -EOPNOTSUPP;
> +		goto out_mutex;
> +	}
> +

I do not think we need to hold mutex for this. You can move it to
the beginning of the function preferably right after S_ISREG check.

Otherwise it looks ok, but it would be better if we could fix it :)

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

>  	truncate_pagecache_range(inode, ioffset, -1);
>  
>  	/* Wait for existing dio to complete */
> 
--8323328-2015149015-1397733352=:2143--
