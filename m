From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger than 32-bit blocks (take 2).
Date: Mon, 4 Jun 2007 17:32:23 -0600
Message-ID: <20070604233223.GB5181@schatzie.adilger.int>
References: <20070601105234.4be40028@rx8> <20070601225441.GF5181@schatzie.adilger.int> <20070604113210.1a76934b@gara> <20070604175728.GT5181@schatzie.adilger.int> <1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:55356 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbXFDXc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2007 19:32:26 -0400
Content-Disposition: inline
In-Reply-To: <1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 04, 2007  16:01 -0700, Mingming Cao wrote:
> Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> than 32bit block sizes during mount time.  This ensure proper record
> lenth when writing to the journal.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

You can add Signed-off-by: Andreas Dilger <adilger@clusterfs.com> also.

> Index: linux-2.6.22-rc3/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650 -0500
> +++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-04 11:05:11.389126418 -0500
> @@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
>  		goto failed_mount3;
>  	}
> 
> +        /*
> +	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
> +	 * with more that 32-bit block counts
> +	 */
> +	if (le32_to_cpu(es->s_blocks_count_hi) &&
> +	   !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
> +				      JBD2_FEATURE_INCOMPAT_64BIT)){
> +		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
> +		goto failed_mount4;
> +	}
> +
>  	/* We have now updated the journal if required, so we can
>  	 * validate the data journaling mode. */
>  	switch (test_opt(sb, DATA_FLAGS)) {

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
