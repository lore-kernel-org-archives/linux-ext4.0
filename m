Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96072C4332F
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Oct 2022 17:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiJGRAp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 Oct 2022 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiJGRAX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2022 13:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C6C6B669;
        Fri,  7 Oct 2022 10:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EF961DCB;
        Fri,  7 Oct 2022 17:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4DB1C43141;
        Fri,  7 Oct 2022 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665162017;
        bh=bWDlBIilzoaw9yJkWw43+Vp+gq8dtlFaYO9UEXmQ7rE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ULjiRZz0BFJ7nC8cCTIslsuvsBiL+DdPMCOtLood3F6DgjqI0Xayw9qN69CIGMCCc
         4J8vDmlVNoiF3tAcjZNaEdcTpByzP2gez3jI+PFBs4eGNxHBwQ4CWificR5v2zQyha
         7FW+yTriGzvIa37j25QX33G+5lalmSTTwvASSy9IMTg2ZKeAf09Gti2PvTPlIwySib
         pAqxo+iw359W7ICjDaHE9VqXto2s6jD/RzXMCMmAQF8ed8CXF12Ibxkvqy5t7Z0Bvo
         UqFyBsZX0zyLj4aHbA5QVcfA+h5gsCmAuKrRPKJqgPi+mcXIqtzAmxkBO87CZPDCZl
         QlrxkGsSY4XBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1A51E21ED6;
        Fri,  7 Oct 2022 17:00:17 +0000 (UTC)
Subject: Re: [GIT PULL] ext2, udf, reiserfs, and quota fixes for v6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221007125406.oaw57vy5zmino5rj@quack3>
References: <20221007125406.oaw57vy5zmino5rj@quack3>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221007125406.oaw57vy5zmino5rj@quack3>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs-for_v6.1-rc1
X-PR-Tracked-Commit-Id: 191249f708897fc34c78f4494f7156896aaaeca9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 188943a15638ceb91f960e072ed7609b2d7f2a55
Message-Id: <166516201772.22254.17741104946754308536.pr-tracker-bot@kernel.org>
Date:   Fri, 07 Oct 2022 17:00:17 +0000
To:     Jan Kara <jack@suse.cz>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Fri, 7 Oct 2022 14:54:06 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs-for_v6.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/188943a15638ceb91f960e072ed7609b2d7f2a55

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
