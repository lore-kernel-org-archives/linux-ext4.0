From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: update uninitialized-block-groups.patch and mballoc-core.patch
Date: Wed, 3 Oct 2007 12:37:18 -0600
Message-ID: <20071003183718.GM5578@schatzie.adilger.int>
References: <47036832.7030107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:47336 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbXJCShX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2007 14:37:23 -0400
Content-Disposition: inline
In-Reply-To: <47036832.7030107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 03, 2007  15:30 +0530, Aneesh Kumar K.V wrote:
> +	if (block_group == sbi->s_gdb_count - 1) {
> +		/*
> +		 * Even though mke2fs always initialize first and last group
> +		 * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we 
> need
> +		 * to make sure we calculate the right free blocks
> +		 */
> +		free_blocks = ext4_blocks_count(sbi->s_es) -
> +				le32_to_cpu(sbi->s_es->s_first_data_block) -
> +				(EXT4_BLOCKS_PER_GROUP(sb) * 
> sbi->s_groups_count) -
> +				bit_max;

Did you verify that subtracting s_first_data_block is indeed the right
thing to do.  I _think_ yes, but I didn't look at it very closely when
I wrote it late last night.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
