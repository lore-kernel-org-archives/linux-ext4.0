From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext2/ext3/ext4: Add block bitmap validation
Date: Mon, 9 Jul 2007 13:16:31 -0600
Message-ID: <20070709191631.GX5633@schatzie.adilger.int>
References: <11840054832202-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:51908 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbXGITQe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 15:16:34 -0400
Content-Disposition: inline
In-Reply-To: <11840054832202-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 09, 2007  23:54 +0530, Aneesh Kumar K.V wrote:
> When a new block bitmap is read from disk in read_block_bitmap()
> there are a few bits that should ALWAYS be set. In particular, the
> blocks given by ext4_blk_bitmap, ext4_inode_bitmap and ext4_inode_table.
> Validate the block bitmap against these blocks.

Ah, our emails passed each other...  Mine has the added change that it
checks all of the itable bits, but otherwise it seems we made the same
cleanups.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
