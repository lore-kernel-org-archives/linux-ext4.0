Return-Path: <SRS0=vdH8=2R=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713B5C2D0C6
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Dec 2019 11:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6D9208C4
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Dec 2019 11:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfL0LQv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Dec 2019 06:16:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:35886 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfL0LQv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 27 Dec 2019 06:16:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Dec 2019 03:16:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,362,1571727600"; 
   d="scan'208";a="212621126"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 27 Dec 2019 03:16:50 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iknbt-0003xx-T5; Fri, 27 Dec 2019 19:16:49 +0800
Date:   Fri, 27 Dec 2019 19:16:00 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-ext4@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [RFC PATCH] ext4: __ext4_fc_track_range() can be static
Message-ID: <20191227111600.vn3t4tvjlztvq5gj@4978f4969bb8>
References: <20191224081324.95807-7-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224081324.95807-7-harshadshirwadkar@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Fixes: 9b03f2f7eee6 ("ext4: add generic diff tracking routines and range tracking")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 ext4_jbd2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 0907b1b913013..b65625bbe7146 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -414,7 +414,7 @@ struct __ext4_fc_track_range_args {
 #define MIN(__a, __b)  ((__a) < (__b) ? (__a) : (__b))
 #define MAX(__a, __b)  ((__a) > (__b) ? (__a) : (__b))
 
-int __ext4_fc_track_range(struct inode *inode, void *arg, bool update)
+static int __ext4_fc_track_range(struct inode *inode, void *arg, bool update)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct __ext4_fc_track_range_args *__arg =
