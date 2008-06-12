From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] ext3: kill 2 useless magic numbers
Date: Thu, 12 Jun 2008 00:38:47 -0600
Message-ID: <20080612063847.GR3726@webber.adilger.int>
References: <48507964.1060309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47107 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYFLGiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 02:38:52 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5C6cnQu017820
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 23:38:52 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2C00F017S3YL00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 11 Jun 2008 23:38:49 -0700 (PDT)
In-reply-to: <48507964.1060309@cn.fujitsu.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 12, 2008  09:18 +0800, Li Zefan wrote:
> dx_root_limit() will never return 20, and I can't figure out
> what 20 stands for. This function has never changed since htree
> directory indexing was merged.
> 
> Similar for dx_node_limit() and the magic 22.

This was for testing htree split code more aggressively, but can be
removed.

Acked-by: Andreas Dilger <adilger@sun.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/ext3/namei.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 0b8cf80..d282ea8 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -240,13 +240,13 @@ static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
>  {
>  	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
>  		EXT3_DIR_REC_LEN(2) - infosize;
> -	return 0? 20: entry_space / sizeof(struct dx_entry);
> +	return entry_space / sizeof(struct dx_entry);
>  }
>  
>  static inline unsigned dx_node_limit (struct inode *dir)
>  {
>  	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
> -	return 0? 22: entry_space / sizeof(struct dx_entry);
> +	return entry_space / sizeof(struct dx_entry);
>  }
>  
>  /*
> -- 
> 1.5.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

