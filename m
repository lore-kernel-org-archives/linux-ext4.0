From: Andreas Dilger <adilger@sun.com>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 2 Jan 2008 10:41:57 -0700
Message-ID: <20080102174157.GD3351@webber.adilger.int>
References: <20080102013218.GO27566@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:33748 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYABRl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2008 12:41:59 -0500
Content-Disposition: inline
In-Reply-To: <20080102013218.GO27566@does.not.exist>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 02, 2008  03:32 +0200, Adrian Bunk wrote:
> It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> but I've already seen people using ext4 simply because a stable kernel 
> offered it - and that's definitely not intended.
> 
> Anyone who _really_ wants to test ext4 should anyway be able to do the 
> trivial change of removing the "depends on BROKEN" line.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> @@ -138,7 +138,7 @@ config EXT3_FS_SECURITY
>  
>  config EXT4DEV_FS
>  	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	depends on BROKEN
>  	select JBD2
>  	select CRC16
>  	help

Isn't CONFIG_EXPERIMENTAL enough?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
