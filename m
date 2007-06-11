From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 2/12] add new macro EXT2_DESC_PER_BLOCK in e2fsprogs
Date: Mon, 11 Jun 2007 17:23:06 -0600
Message-ID: <20070611232306.GG5181@schatzie.adilger.int>
References: <466D7B68.30307@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38293 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbXFKXXI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 19:23:08 -0400
Content-Disposition: inline
In-Reply-To: <466D7B68.30307@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:42 +0200, Valerie Clement wrote:
> +#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / \
> +	((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
> +	 sizeof(struct ext4_group_desc) : sizeof(struct ext2_group_desc)))

This should actually use s_desc_size and not "sizeof(struct ext4_group_desc)",
as we may want to increase the size of s_desc_size for some other reason in
the future.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
