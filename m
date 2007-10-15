From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 2/5] ext4: Add support for 48 bit inode i_blocks.
Date: Mon, 15 Oct 2007 12:12:25 -0600
Message-ID: <20071015181225.GV8122@schatzie.adilger.int>
References: <1192445738-17591-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1192445738-17591-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1192445738-17591-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:57098 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765687AbXJOSM1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 14:12:27 -0400
Content-Disposition: inline
In-Reply-To: <1192445738-17591-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 15, 2007  16:25 +0530, Aneesh Kumar K.V wrote:
>  		ei->i_flags |= EXT4_DIRSYNC_FL;
>  }
> +static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
> +					struct ext4_inode_info *ei)
> +{

Please put an empty line between functions.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
