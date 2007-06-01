From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger than 32-bit blocks.
Date: Fri, 1 Jun 2007 16:54:41 -0600
Message-ID: <20070601225441.GF5181@schatzie.adilger.int>
References: <20070601105234.4be40028@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:55780 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbXFAWyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 18:54:47 -0400
Content-Disposition: inline
In-Reply-To: <20070601105234.4be40028@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 01, 2007  10:52 -0500, Jose R. Santos wrote:
> Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> than 32bit block sizes during mount time.  This ensure proper record
> lenth when writing to the journal.
> 
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

Content is good, but indenting should be fixed, spaces removed.

> --- .pc/ext4-set_64-bit_JBD_incompat.patch/fs/ext4/super.c	2007-05-31 22:25:21.843984697 -0500
> +++ fs/ext4/super.c	2007-05-31 22:26:14.913670672 -0500
> @@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
>  		goto failed_mount3;
>  	}
>  
> +        /* 
> +	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
> +	 * with more that 32-bit block counts
> +	 */
> +	if(es->s_blocks_count_hi)
> +		if (!jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0, 
> +					       JBD2_FEATURE_INCOMPAT_64BIT)){
> +			printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
> +			goto failed_mount4;
> +		}

	/* 
	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
	 * with more that 32-bit block counts
	 */
	if (es->s_blocks_count_hi &&
	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0, 
				       JBD2_FEATURE_INCOMPAT_64BIT)) {
		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
		goto failed_mount4;
	}

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
