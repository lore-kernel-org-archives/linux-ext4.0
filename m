From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext2 statfs speed up
Date: Thu, 5 Jul 2007 15:06:51 -0600
Message-ID: <20070705210651.GN5633@schatzie.adilger.int>
References: <1183659089.19473.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:41973 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbXGEVGx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 17:06:53 -0400
Content-Disposition: inline
In-Reply-To: <1183659089.19473.7.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 05, 2007  11:11 -0700, Badari Pulavarty wrote:
> @@ -1131,17 +1134,22 @@ static int ext2_statfs (struct dentry * 
>  	buf->f_bfree = ext2_count_free_blocks(sb);
> +	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
>  	buf->f_ffree = ext2_count_free_inodes(sb);
> +	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);

Hmm, this is still sub-optimal.  For ext3 and ext4 it just uses
percpu_counter_sum() instead of the slow ext*_count_free_blocks(), which
walks all of the groups.  Not that this is a reason to hold this patch,
because at least we are removing 1/2 of the overhead for ext2.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
