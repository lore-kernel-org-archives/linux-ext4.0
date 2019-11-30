Return-Path: <SRS0=cPVr=ZW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF794C432C0
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Nov 2019 19:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00BA208C3
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Nov 2019 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575142822;
	bh=N+rsug/ZtuUigw4CLCSPaBHBMvsO1wStSIKd5U3I6Ss=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Izl3pOQL9pGNwa7u5HLU2agkZ/OZK2WanXVJdB0/qI4a+d4Sft48WdE2UgEbNe7yF
	 EJqflauguzB1Bz6kvcCBXrbDdACGIZRYCx+gvoEOnxHMeNAY8yrM8KJlJwJAKnUJzZ
	 KZp+IPwFEGi/rRT8kwfb8/WY2v9zp/3nUPsjEcG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfK3TkW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 Nov 2019 14:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfK3TkW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 30 Nov 2019 14:40:22 -0500
Subject: Re: [GIT PULL] ext4 updates for 5.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575142821;
        bh=N+rsug/ZtuUigw4CLCSPaBHBMvsO1wStSIKd5U3I6Ss=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=BbYNSUoKKxzhhonQt+HE4VpqOU3HqeX9CuRm7i1nLiNVNRMMFzNQ0UIs6GuJ+YJ4S
         83GirszrlwFM2FHjgP+YcbVfvwBSyeD3mfOA8t7NAXWWFN7KC1hNJzL74hsSOVaXyR
         pALRsft6tA9TvPdhMUtzPZNQbFDRJj8pB3YYb5E8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191126125304.GA20746@mit.edu>
References: <20191126125304.GA20746@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191126125304.GA20746@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4_for_linus
X-PR-Tracked-Commit-Id: dfdeeb41fb08fbe11d3cfefba9c0fcd00c95a36d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50b8b3f85a01543fb82d3bb9bfe7d06659522c70
Message-Id: <157514282159.12928.1847717818069852936.pr-tracker-bot@kernel.org>
Date:   Sat, 30 Nov 2019 19:40:21 +0000
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Tue, 26 Nov 2019 07:53:04 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50b8b3f85a01543fb82d3bb9bfe7d06659522c70

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
