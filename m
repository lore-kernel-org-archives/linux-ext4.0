From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Mon, 16 Jul 2007 00:34:57 -0600
Message-ID: <20070716063457.GA5992@schatzie.adilger.int>
References: <20070710112307.34c2ba5c@rx8> <20070711041213.GH6417@schatzie.adilger.int> <20070711003004.531c9307@naruto> <20070711221425.GH19456@thunk.org> <20070712100906.2e2afb9c@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53946 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXGPGfA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jul 2007 02:35:00 -0400
Content-Disposition: inline
In-Reply-To: <20070712100906.2e2afb9c@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 12, 2007  10:09 -0500, Jose R. Santos wrote:
> @@ -1271,6 +1271,9 @@ static int ext4_check_descriptors (struc
>  
>  	ext4_debug ("Checking group descriptors");
>  
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +		return 1;
> +
>  	for (i = 0; i < sbi->s_groups_count; i++)
>  	{
>  		if (i == sbi->s_groups_count - 1)

It looks pretty straight forward to just change this code to leave
first_block at s_first_data_block, and leave last_block at ext4_blocks_count()
if FLEX_BG is set.

Even with FLEX_BG we want to keep the group metadata within the bounds of
the filesystem.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
