Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC659C64E7B
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Nov 2020 11:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 892D920B80
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Nov 2020 11:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgK0LeK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Nov 2020 06:34:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:51520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbgK0LeJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 27 Nov 2020 06:34:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 249DAADA2;
        Fri, 27 Nov 2020 11:34:08 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AE3941E131B; Fri, 27 Nov 2020 12:34:07 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 02/12] ext4: Remove redundant sb checksum recomputation
Date:   Fri, 27 Nov 2020 12:33:55 +0100
Message-Id: <20201127113405.26867-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201127113405.26867-1-jack@suse.cz>
References: <20201127113405.26867-1-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Superblock is written out either through ext4_commit_super() or through
ext4_handle_dirty_super(). In both cases we recompute the checksum so it
is not necessary to recompute it after updating superblock free inodes &
blocks counters.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2b08b162075c..61e6e5f156f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5004,13 +5004,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	block = ext4_count_free_clusters(sb);
 	ext4_free_blocks_count_set(sbi->s_es, 
 				   EXT4_C2B(sbi, block));
-	ext4_superblock_csum_set(sb);
 	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
 				  GFP_KERNEL);
 	if (!err) {
 		unsigned long freei = ext4_count_free_inodes(sb);
 		sbi->s_es->s_free_inodes_count = cpu_to_le32(freei);
-		ext4_superblock_csum_set(sb);
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
-- 
2.16.4

