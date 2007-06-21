From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][1/4] ext2/3/4: enlarge blocksize
Date: Thu, 21 Jun 2007 16:34:43 -0600
Message-ID: <20070621223443.GA2178@schatzie.adilger.int>
References: <20060908131144sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: sho@tnes.nec.co.jp
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:49500 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbXFUWer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 18:34:47 -0400
Content-Disposition: inline
In-Reply-To: <20060908131144sho@rifu.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 08, 2006  13:11 +0900, sho@tnes.nec.co.jp wrote:
> On July 7, 2006, sho wrote:
> These patches support large blocksize up to PAGESIZE (max 64KB).
> NOTE:
> They limit the end of a directory block to 65532(64K - 4)
> to avoid overflow only when using 64KB block.

Takashi, in light of the (very exciting ;-) patches to handle 64kB
PAGE_SIZE on x86 systems, could you please update the large blocksize
patch to the latest ext4 tree?

> diff -upNr -X linux-2.6.18-rc4-mingming/Documentation/dontdiff linux-2.6.18-rc4-mingming/fs/ext2/super.c linux-2.6.18-rc4-mingming-tnes/fs/ext2/super.c
> --- linux-2.6.18-rc4-mingming/fs/ext2/super.c	2006-08-07 03:20:11.000000000 +0900
> +++ linux-2.6.18-rc4-mingming-tnes/fs/ext2/super.c	2006-09-08 09:00:40.000000000 +0900
> @@ -725,7 +725,7 @@ static int ext2_fill_super(struct super_
>  		brelse(bh);
>  
>  		if (!sb_set_blocksize(sb, blocksize)) {
> -			printk(KERN_ERR "EXT2-fs: blocksize too small for device.\n");
> +			printk(KERN_ERR "EXT2-fs: bad blocksize %d.\n", blocksize);
>  			goto failed_sbi;
>  		}

We need a check in ext2 (like ext3/ext4) to ensure that blocksize <
EXT2_MAX_BLOCK_SIZE.  It could be increased to 32768 without danger
I think, only the directory problem prevents it from working with 65536.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
