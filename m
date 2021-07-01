Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FFBC11F64
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Jul 2021 19:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 390816141D
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Jul 2021 19:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhGATWp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Jul 2021 15:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhGATWn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Jul 2021 15:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 89DCC6140D;
        Thu,  1 Jul 2021 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625167212;
        bh=faOP19Wfz1HqZ1a2JpuUoGjy1CgGwlgerd9WFjwTQ54=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AUSU8BBedQ73KTRDI+WSfjbBCDzmMbPUn+1VwNcBTEKabm+cSsFu8prJ2Z0f1hcAt
         0CrW+/+n/nMYWR4qBv/dUKEcy+hVnc5mAJY3cWrlre55JxeXReDu3p4U763+IiZ6oV
         3m1C8h8HElDQ8GguOkp1JuearcbBfsVEpSB5xMxIeIT1q+5dbHAt9J7SRQQVRTmLHh
         oR971dMPUWgYgB9aMZ6J5xW9MI/N7klfZIRuqp+OYv0/3VophksUi0j1bgbcratCy9
         l1RIcREHS1XwPBLwacPO4mykx87xLz2MtFJOOYLzYsMQXVJDFsgZfg+LV8u7jSorVV
         J+j6QBH2Z1d1Q==
Subject: Re: [GIT PULL] ext4 updates for v5.14
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YNzY12HgR4UViC4/@mit.edu>
References: <YNzY12HgR4UViC4/@mit.edu>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <YNzY12HgR4UViC4/@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus
X-PR-Tracked-Commit-Id: 16aa4c9a1fbe763c147a964cdc1f5be8ed98ed13
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a6ecc2a491e378e00e65e59a006d4005e1c2f4af
Message-Id: <162516721252.9675.12595777913228008412.pr-tracker-bot@kernel.org>
Date:   Thu, 01 Jul 2021 19:20:12 +0000
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Wed, 30 Jun 2021 16:49:27 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a6ecc2a491e378e00e65e59a006d4005e1c2f4af

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
