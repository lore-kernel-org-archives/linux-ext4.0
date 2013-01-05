From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] ext4: release buffer in failed path in dx_probe()
Date: Sat, 5 Jan 2013 11:41:35 -0800
Message-ID: <20130105194135.GK20106@blackbox.djwong.org>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
 <1357371781-18194-2-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29387 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3AETlm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 14:41:42 -0500
Content-Disposition: inline
In-Reply-To: <1357371781-18194-2-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 03:43:00PM +0800, Guo Chao wrote:
> If checksum fails, we should also release the buffer
> read from previous iteration.
> 
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/namei.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 843e29f..e249a47 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -722,7 +722,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
>  			ext4_warning(dir->i_sb, "Node failed checksum");
>  			brelse(bh);
>  			*err = ERR_BAD_DX_DIR;
> -			goto fail;
> +			goto fail2;

Good catch!

Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
>  		}
>  		set_buffer_verified(bh);
>  
> -- 
> 1.7.9.5
> 
