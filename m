From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: remove redundant assignment in
 ext4_iomap_begin()
Date: Thu, 21 Dec 2017 11:47:50 -0500
Message-ID: <20171221164750.GD27177@thunk.org>
References: <20171127092127.26193-1-sunqiuyang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: sunqiuyang <sunqiuyang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46130 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752522AbdLUQry (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Dec 2017 11:47:54 -0500
Content-Disposition: inline
In-Reply-To: <20171127092127.26193-1-sunqiuyang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 27, 2017 at 05:21:27PM +0800, sunqiuyang wrote:
> From: Qiuyang Sun <sunqiuyang@huawei.com>
> 
> This line will not change the value of map.m_lblk in any case.

I don't see that it is absolutely guaranteed.  And if you are
depending on ext4_es_find_delayed_extent() returns, then (a) the
following line which adjusts map.m_len could also be dropped, and (b)
we should add a WARN_ON to make the code robust against future changes
to the above function.

						- Ted

> 
> Signed-off-by: Qiuyang Sun <sunqiuyang@huawei.com>
> ---
>  fs/ext4/inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9f836e2..d4a42b1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3443,7 +3443,6 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  
>  				if (es.es_lblk < map.m_lblk)
>  					offs = map.m_lblk - es.es_lblk;
> -				map.m_lblk = es.es_lblk + offs;
>  				map.m_len = es.es_len - offs;
>  				delalloc = true;
>  			}
> -- 
> 2.5.0
> 
