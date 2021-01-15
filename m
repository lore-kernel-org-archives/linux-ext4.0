Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93C7C433E0
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Jan 2021 23:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D4823339
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Jan 2021 23:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbhAOXBt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Jan 2021 18:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbhAOXBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 15 Jan 2021 18:01:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 15DE723339;
        Fri, 15 Jan 2021 23:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610751667;
        bh=QTUgHN4CSEZqzsn2irWl4mPqICGEikhGZ2NcOnsv1Ro=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cW9O/RbSGamwz9hZlrh116ZUNLsxEkWou498RDcgMhO7UK98yW3rKAk2juifYvycq
         8DdAZBfSrO+lMP5q4vAajy7jEdXzTYNd2xbQKny1rXyIzMFfPYjkBnOryRgQJUisW2
         yUxrBUXp/KIthj2gOwQlF8t0fPtwxlStWqfBig/Df5fuTkq/2eSyE4VD+ni7uXTeln
         p7wNmxVOJ1/Aq5CYSko2EVNRAsG9DYuHl6JRdKGFYl+d7+MrTxoBMh0E/j02XRg/z/
         g3wtzDGgEWnyFxBLMobP0qMVBNgUbGcvr0Qf3pMeGvpGwqyKC5CLF7iffE6Qr+Hse4
         n7ncFEiT5SaFg==
Subject: Re: [GIT PULL] ext4 bug fixes for v5.11-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YAIHHfxGQfj96di/@mit.edu>
References: <YAIHHfxGQfj96di/@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YAIHHfxGQfj96di/@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable
X-PR-Tracked-Commit-Id: e9f53353e166a67dfe4f8295100f8ac39d6cf10b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0bc9bc1d8b2fa0d5a7e2132e89c540099ea63172
Message-Id: <161075166704.23598.17060319411892856713.pr-tracker-bot@kernel.org>
Date:   Fri, 15 Jan 2021 23:01:07 +0000
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Fri, 15 Jan 2021 16:20:29 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0bc9bc1d8b2fa0d5a7e2132e89c540099ea63172

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
