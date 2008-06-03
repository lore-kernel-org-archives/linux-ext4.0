From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: delalloc  block reservation fix
Date: Wed, 4 Jun 2008 01:11:10 +0530
Message-ID: <20080603194110.GA17371@skywalker>
References: <1212514177-7249-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:35552 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbYFCTl0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 15:41:26 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m53JesIp028342
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 05:40:54 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m53Jf7Aj4108390
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 05:41:07 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m53JfOqg016092
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 05:41:24 +1000
Content-Disposition: inline
In-Reply-To: <1212514177-7249-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2008 at 10:59:37PM +0530, Aneesh Kumar K.V wrote:
> a) We need to decrement the meta data blocks that got allocated
> from percpu s_freeblocks_counter
> 
> b) We need to protect the reservation block counter so that
> reserve and release space doesn't race each other.
> 
> c) don't check for free space in ext4_mb_new_blocks with delalloc
> We already reserved the space.
> 

Needs this change to get fsstress running.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2e485a3..787ce99 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1565,7 +1565,8 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 		bh_result->b_size = (ret << inode->i_blkbits);
 
 		/* release reserved-but-unused meta blocks */
-		ext4_da_release_space(inode, ret, 0);
+		if (buffer_delay(bh_result))
+			ext4_da_release_space(inode, ret, 0);
 
 		/*
 		 * Update on-disk size along with block allocation
