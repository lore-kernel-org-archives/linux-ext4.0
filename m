Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E076C4361B
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Dec 2020 10:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E94E2313B
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Dec 2020 10:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgLPKTb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Dec 2020 05:19:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:48330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgLPKTb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Dec 2020 05:19:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3D932AC7F;
        Wed, 16 Dec 2020 10:18:50 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CF8031E135E; Wed, 16 Dec 2020 11:18:49 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        harshad shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8 v2 PARTIAL] ext4: Fix error handling
Date:   Wed, 16 Dec 2020 11:18:36 +0100
Message-Id: <20201216101844.22917-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

This is repost of the second half of the series originally posted here [1].
I'm reposting just this part because Ted has already picked up first 7 patches.

Changes since v1:
* Added missed bdev_read_only() check spotted by Harshad
* Added one more fix and one more cleanup for related problems noticed by
  Andreas

								Honza

[1] https://lore.kernel.org/linux-ext4/20201127113405.26867-1-jack@suse.cz/
