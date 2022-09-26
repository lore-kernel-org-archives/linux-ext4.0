Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E051C32771
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Sep 2022 21:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIZV2O (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiIZV2M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2022 17:28:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D8EA2231;
        Mon, 26 Sep 2022 14:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F2F9B811CE;
        Mon, 26 Sep 2022 21:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0ABBC433C1;
        Mon, 26 Sep 2022 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664227686;
        bh=YniGDJvhgWvXx0tSXMolKeJckrcNppbLd/3jlGQpUVg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mkmzBaKMq+QfzYjMNSV9EAbUoFPa4JwS/wqybxLK+E7QtzHwAaVnh9sRCecnGyT0e
         MhcyT4wURl3xGMtDJ0S1sauOHh1zHAYhI92eywpxC/ntjQur/gBknuj/p4TYtux80i
         IRfj7VtYY4OYgPHvwC6tmmp8kmRBxZuxEOXuvITAPblEoGPZHTQfcbQsULtqexkhPM
         7pbwOxFL2HhlXxcqxwmQIhj9NyU6Y+ISJbqhCRoxGsnEbHsriJbaeLjFlL/31et2LX
         a3eFJoIUZvdzUOmnXZ7Q3/kMb8Fz7lVzMNoordVG7Ck9v1G6bJ/8+xHf39wg+H7kH8
         KXaYRN14k5OaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC134C070C8;
        Mon, 26 Sep 2022 21:28:06 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 last-minute fixup
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YzHqqg46Y34PX0Yq@mit.edu>
References: <YzHqqg46Y34PX0Yq@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YzHqqg46Y34PX0Yq@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_fixes2
X-PR-Tracked-Commit-Id: a078dff870136090b5779ca2831870a6c5539d36
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a710532cfe586710738670fb7e1ee44fc3c9b5c
Message-Id: <166422768676.13634.1452641480416843872.pr-tracker-bot@kernel.org>
Date:   Mon, 26 Sep 2022 21:28:06 +0000
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Mon, 26 Sep 2022 14:08:42 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_fixes2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a710532cfe586710738670fb7e1ee44fc3c9b5c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
