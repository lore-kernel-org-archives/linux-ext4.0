Return-Path: <SRS0=vdH8=2R=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BDEC2D0C3
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Dec 2019 19:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB0920838
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Dec 2019 19:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfL0ThT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Dec 2019 14:37:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:64345 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfL0ThT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 27 Dec 2019 14:37:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Dec 2019 11:37:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,364,1571727600"; 
   d="scan'208";a="212721151"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 27 Dec 2019 11:37:18 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ikvQE-00026n-2U; Sat, 28 Dec 2019 03:37:18 +0800
Date:   Sat, 28 Dec 2019 03:36:23 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-ext4@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [RFC PATCH] ext4: ext4_free_blocks_simple() can be static
Message-ID: <20191227193623.7l4rhtv6n6mweej3@4978f4969bb8>
References: <20191224081324.95807-17-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224081324.95807-17-harshadshirwadkar@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Fixes: bb863fa8f074 ("ext4: add idempotent helpers to manipulate bitmaps")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 05ca9001f8fa0..d5e9cc938338f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4778,8 +4778,8 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	return 0;
 }
 
-void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
-			     unsigned long count)
+static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
+				    unsigned long count)
 {
 	struct buffer_head *bitmap_bh;
 	struct super_block *sb = inode->i_sb;
