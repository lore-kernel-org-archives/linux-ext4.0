From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext2: Fix the max file size for ext2 file system.
Date: Thu, 11 Oct 2007 13:54:49 -0600
Message-ID: <20071011195449.GT8122@schatzie.adilger.int>
References: <1192114207-8168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:52136 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbXJKTyx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:54:53 -0400
Content-Disposition: inline
In-Reply-To: <1192114207-8168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 11, 2007  20:20 +0530, Aneesh Kumar K.V wrote:
> +	/* indirect blocks */
> +	meta_blocks = 1;
> +	/* double indirect blocks */
> +	meta_blocks += 1 + (1LL << (bits-2));
> +	/* tripple indirect blocks */
> +	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));

It may be worthwhile calculating how many indirect blocks there actually
are in a file that size.  Also note that your comments are backward -
there is at most a single triple indirect block per file.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
