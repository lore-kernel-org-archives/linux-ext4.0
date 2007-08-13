From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] [187/2many] MAINTAINERS - EXT3 FILE SYSTEM
Date: Mon, 13 Aug 2007 02:59:41 -0600
Message-ID: <20070813085941.GI6689@schatzie.adilger.int>
References: <46bff9ca.G6SlSSqj37lZdpz+%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org
To: joe@perches.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:43514 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970787AbXHMI7k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 04:59:40 -0400
Content-Disposition: inline
In-Reply-To: <46bff9ca.G6SlSSqj37lZdpz+%joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 12, 2007  23:27 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 653b9a0..814168d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1796,10 +1796,16 @@ F:	fs/ext2/
>  F:	include/linux/ext2*
>  
>  EXT3 FILE SYSTEM
> -P:	Stephen Tweedie, Andrew Morton
> -M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
> +P:	Stephen Tweedie
> +M:	sct@redhat.com
> +P:	Andrew Morton
> +M:	akpm@linux-foundation.org
> +P:	Andreas Dilger
> +M:	adilger@clusterfs.com
>  L:	linux-ext4@vger.kernel.org
>  S:	Maintained
> +F:	fs/ext3/
> +F:	include/linux/ext3*

You may as well have fs/jbd/* and include/linux/jbd.h for ext3.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
