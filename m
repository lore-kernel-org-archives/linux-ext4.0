From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
Date: Mon, 13 Aug 2007 03:01:28 -0600
Message-ID: <20070813090128.GJ6689@schatzie.adilger.int>
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>
To: joe@perches.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40518 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970905AbXHMJB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 05:01:26 -0400
Content-Disposition: inline
In-Reply-To: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 12, 2007  23:27 -0700, joe@perches.com wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 814168d..992a314 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1808,10 +1808,16 @@ F:	fs/ext3/
>  F:	include/linux/ext3*
>  
>  EXT4 FILE SYSTEM
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
> +F:	fs/ext4/
> +F:	include/linux/ext4*

To be honest, Stephen and Andrew haven't been directly involved in
the ext4 development.  It probably makes more sense to have e.g.
Eric Sandeen, Ted Ts'o, and MingMing Cao in their place.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
