From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] FLEX_BG Kernel support v2.
Date: Wed, 12 Sep 2007 01:27:54 -0600
Message-ID: <20070912072754.GE5377@schatzie.adilger.int>
References: <20070912000701.10301.40946.stgit@toolssf2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:45738 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbXILH13 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2007 03:27:29 -0400
Content-Disposition: inline
In-Reply-To: <20070912000701.10301.40946.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 11, 2007  19:07 -0500, Jose R. Santos wrote:
> @@ -1248,13 +1248,17 @@ static int ext4_check_descriptors (struct super_block * sb)
>  	ext4_fsblk_t inode_table;
>  	struct ext4_group_desc * gdp = NULL;
>  	int desc_block = 0;
> +	int flexbg_bg = 0;
>  	int i;
>  
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +		flexbg_flag = 1;

Umm, have you compiled this?  "int flexbg_bg" and "flexbg_flag"...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
