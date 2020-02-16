Return-Path: <SRS0=spdg=4E=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA935C3B1BF
	for <linux-ext4@archiver.kernel.org>; Sun, 16 Feb 2020 19:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C154E20726
	for <linux-ext4@archiver.kernel.org>; Sun, 16 Feb 2020 19:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581882628;
	bh=WKQi7KUTHW18qnotC/iBi1/osnN5kFcWzVplBEWyJTE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=0mkPUyt2cPSsMjE2+1MwIarx9opUXOBWXmxWx4YRPjIn7izRZE5bKBHY10XXGSNLU
	 l8tlqxVtGmbDSA/TdJw6ykflNn1EcLWsKRMM4RM8Z0toDBwTVFBZnzPN1kaEGV0a4d
	 uVZCYplTL3mLahHTrVHsTpeDlaiUoWBtBrZag7y4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgBPTuT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 16 Feb 2020 14:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgBPTuT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 16 Feb 2020 14:50:19 -0500
Subject: Re: [GIT PULL] ext4 bug fixes for 5.6-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581882618;
        bh=WKQi7KUTHW18qnotC/iBi1/osnN5kFcWzVplBEWyJTE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=MByUNTGxMW68v1jryVA9dxxuPvVph3I/b/CPgtmmFHfBTsJU1mPWPotRHVQAyv2xu
         DEepOJAuoiyfD9igKZYHlYRCoG0Wc7qbtJF6U9sk1/27BLulzubE6598Qp16tAn1F+
         MxL2uGmXKoJ9zxprVBBE+yI0ExkyJpf22SOEDnMQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200216025822.GA721338@mit.edu>
References: <20200216025822.GA721338@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200216025822.GA721338@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4_for_linus_stable
X-PR-Tracked-Commit-Id: d65d87a07476aa17df2dcb3ad18c22c154315bec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a8b80967b421218d89c1af61e759c54ab94fdb6
Message-Id: <158188261850.7458.819464209091406484.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Feb 2020 19:50:18 +0000
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Sat, 15 Feb 2020 21:58:22 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a8b80967b421218d89c1af61e759c54ab94fdb6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
