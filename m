Return-Path: <SRS0=jTk8=74=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEC1C433DF
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Jun 2020 20:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A5082078E
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Jun 2020 20:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592253632;
	bh=wjpybQKruHjtYD8Kk/8OLydua65XsNiYD/6c4clFLQ0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ljInKbyd/KWm5lpP9PpX0jcD6r41LfzH7GMUfenduX+f46uGua+YyIz2a+0I8eH9y
	 RClp2rpGUA5ZBmZrx5/9lCg3b5Hj10LW+oOsGKEf11VHqXkPLN4IJsoJXph7gId381
	 Xwrd+mSoS0IYpzqcovUegw2jyBaICRHiilrL16+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbgFOUk2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Jun 2020 16:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbgFOUk1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Jun 2020 16:40:27 -0400
Subject: Re: [GIT PULL] ext4 changes part 2 for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592253627;
        bh=wjpybQKruHjtYD8Kk/8OLydua65XsNiYD/6c4clFLQ0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=sqij5dVg8ceQF1nueSpqqeQxwvq9uwwSsNy5g/pz9h0yGVCz+T+LjuHd2s5hY73u8
         8j3zPjFA5gfPtcbF8iLxOtfkh50bLKV4nFduSeOrgsx5OoH/XxzPML9pes+jQCWB5S
         c0CO8meT3D+bGzaqD130MImS1l3TV7pZ6xdopreY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200614200034.GA3294624@mit.edu>
References: <20200614200034.GA3294624@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200614200034.GA3294624@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4-for-linus-5.8-rc1-2
X-PR-Tracked-Commit-Id: 7b97d868b7ab2448859668de9222b8af43f76e78
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3be20b6fc13abff843901fcd7cd9c7a3a7f95b90
Message-Id: <159225362762.7348.13591738167025096808.pr-tracker-bot@kernel.org>
Date:   Mon, 15 Jun 2020 20:40:27 +0000
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Sun, 14 Jun 2020 16:00:34 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4-for-linus-5.8-rc1-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3be20b6fc13abff843901fcd7cd9c7a3a7f95b90

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
