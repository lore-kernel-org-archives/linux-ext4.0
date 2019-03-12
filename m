Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5837C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 22:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A337C2175B
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 22:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552429239;
	bh=8lBg1inzQoWCA+gYf6av7s4SEokCx/TPlRU61jq+H8w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=cXtOoVBspUO9pHfQLf2BCX2d/gNPP58sWwiMgF8LesbJOfoiIuY8lcxa6iZ1pm43L
	 ddVggjheks7WaI5Q4cFs6MxWJwx+H9EILxN4hx0J+8yvHoeQfwADhGvYWCrBReejIJ
	 /jRbhq33fZFFfaSX8RWzs1xFDWAwZj/54kvUG3Lg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfCLWUY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Mar 2019 18:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfCLWUY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Mar 2019 18:20:24 -0400
Subject: Re: [GIT PULL] ext4 changes for 5.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552429223;
        bh=8lBg1inzQoWCA+gYf6av7s4SEokCx/TPlRU61jq+H8w=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=eoHQ50daj85oxkT2b7CoraqAqJvpj+1EtNmONnZ5InxVwtglSjWiZWbXxEJuro2Lg
         u/tUuZQGpAMvTl4Q4MT2CJ7MFrDjskd8boNjPoB72/rHIweV+nta5iq7a4klzGfOCM
         5AOTQO7mDSH7rMQhaCVzClwpeBDMJvtiOOhoK3x8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190312195059.GA19660@mit.edu>
References: <20190312195059.GA19660@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190312195059.GA19660@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4_for_linus
X-PR-Tracked-Commit-Id: 0df6f46995a9fc92a6b9e591428e77527dd9609a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a5adcfcad55d5f034b33f79f1a873229d1e77b24
Message-Id: <155242922363.11942.5417722659855901310.pr-tracker-bot@kernel.org>
Date:   Tue, 12 Mar 2019 22:20:23 +0000
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Tue, 12 Mar 2019 15:50:59 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a5adcfcad55d5f034b33f79f1a873229d1e77b24

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
