Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A42C4743D
	for <linux-ext4@archiver.kernel.org>; Sun,  6 Jun 2021 22:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E470A61185
	for <linux-ext4@archiver.kernel.org>; Sun,  6 Jun 2021 22:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFFWty (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 6 Jun 2021 18:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231143AbhFFWtx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Jun 2021 18:49:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A69F6141E;
        Sun,  6 Jun 2021 22:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623019683;
        bh=6WgVq3fHdJOIf7AZ+J5/HRDsb1lorC9/S3M2coj3RG8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=frAzwBeNOazyuSHgRe3l2BgFOBH2ruZAssuPeRyfzrv81IhD9+VGMY0+4BadNDlAQ
         MqT7zTR0Glfcu1t79GV05bjQhPSGPcYna9cfusTe5PwBIKQ+Oab9zRr4KQABjJ0HIk
         0fKKPzpajnR7XGlmfjkWgTJEDoOJ56Rsf7vqSDWKsc7Fhp5TU2rbUW9lSbtNhH+Ih+
         MzmtKQszFtXgwlRyxuUGSqrn17Qi9mSH8IwFwGUwU7r4KGfG447bEwYov2Rzkhsfcr
         kMbhONryzgAzGMNDxQc7AlFwUy4VkCQgzhnXGnikOZbl7gtflCnZB5dm87nTsHOeA0
         wkOr+i2hppsQg==
Subject: Re: [GIT PULL] ext4 fixes for v5.13
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YLzZz/Mh2HQQd80+@mit.edu>
References: <YLzZz/Mh2HQQd80+@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YLzZz/Mh2HQQd80+@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable
X-PR-Tracked-Commit-Id: e71f99f2dfb45f4e7203a0732e85f71ef1d04dab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 20e41d9bc80456207deb71141147a3de2c34e676
Message-Id: <162301968317.14999.16965060077439289773.pr-tracker-bot@kernel.org>
Date:   Sun, 06 Jun 2021 22:48:03 +0000
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Sun, 6 Jun 2021 10:21:03 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/20e41d9bc80456207deb71141147a3de2c34e676

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
