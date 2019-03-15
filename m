Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413E0C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 07:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C96321872
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 07:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfCOHL2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 03:11:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728060AbfCOHL2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 15 Mar 2019 03:11:28 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ED2574CB7E2B0CCF0FF6;
        Fri, 15 Mar 2019 15:05:59 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.408.0; Fri, 15 Mar 2019
 15:05:52 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v2 0/2] ext4: fix buffer references leak problem
Date:   Fri, 15 Mar 2019 15:10:11 +0800
Message-ID: <1552633813-42832-1-git-send-email-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

This patch set want to fix a buffer references leak problem in
ext4_ind_remove_space() and do some cleanup of the releasing code.

Change since v1:
 - Separate the cleanup code from the fix patch.

zhangyi (F) (2):
  ext4: brelse all indirect buffer in ext4_ind_remove_space()
  ext4: cleanup bh release code in ext4_ind_remove_space()

 fs/ext4/indirect.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

-- 
2.7.4

