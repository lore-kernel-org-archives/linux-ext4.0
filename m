From: Adrian Bunk <bunk@kernel.org>
Subject: ext4/balloc.c:read_block_bitmap(): inconsequent NULL checking
Date: Fri, 19 Oct 2007 15:47:00 +0200
Message-ID: <20071019134700.GB3778@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43304 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755263AbXJSNqb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Oct 2007 09:46:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 7c9e69faa28027913ee059c285a5ea8382e24b5d results in the following 
inconsequent NULL checking in fs/ext4/balloc.c:

<--  snip  -->

...
struct buffer_head *
read_block_bitmap(struct super_block *sb, unsigned int block_group)
{
...
        if (!bh)
                ext4_error (sb, __FUNCTION__,
                            "Cannot read block bitmap - "
                            "block_group = %d, block_bitmap = %llu",
                            block_group, bitmap_blk);

        /* check whether block bitmap block number is set */
        if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
...                                       ^^^^^^^^^^

<--  snip  -->

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
