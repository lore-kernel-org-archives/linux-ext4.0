Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367D8C4332F
	for <linux-ext4@archiver.kernel.org>; Tue, 13 Dec 2022 05:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiLMFAs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 13 Dec 2022 00:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbiLMFAS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2022 00:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511701DDFE;
        Mon, 12 Dec 2022 21:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C12D1B810B5;
        Tue, 13 Dec 2022 05:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DA4CC43392;
        Tue, 13 Dec 2022 05:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670907611;
        bh=j/wlCL9aGtoDNCTT8eX6UpvouMNpN1Nw/XXF2tXwSuA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TrclnJd3ws7Xk4MJLvekYgj7yOC04PSItr0b9ojpTjN8O+TSm78xqc4n6r/Gih35e
         HjfA4Bd7yM9oEmhc5jxwzBrUsJyGWEcIBCBQFo+EeZ5IaV+uoCtdoQAt3JI+6Sw66N
         2MOR9zG48Y+n0F/G4ttdf+RFfCus4MTvi0RbuJ8NAih9OOJ26hzfbpd/Pq5pcsMro0
         Tzc05Seo3ahNpdcyTlzA7krSwYW7jI7r11YWttfnKqqiPc/pleBz/8WWxTVR6EkYsp
         +CZ78jJakAcVQkxMXdMxK5pIs6mAFx6vRxKFq6hlsLfXWzmq65AGvpz89FgWlke16P
         eVzxOCSiGjUzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 766C0C00445;
        Tue, 13 Dec 2022 05:00:11 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 changes for 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y5awNvCXRRyck6LT@mit.edu>
References: <Y5awNvCXRRyck6LT@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y5awNvCXRRyck6LT@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus
X-PR-Tracked-Commit-Id: 1da18e38cb97e9521e93d63034521a9649524f64
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: deb9acc12250b13e40f7133f189d8a0891da53f3
Message-Id: <167090761148.4886.8380671155462466432.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Dec 2022 05:00:11 +0000
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Sun, 11 Dec 2022 23:38:14 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/deb9acc12250b13e40f7133f189d8a0891da53f3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
