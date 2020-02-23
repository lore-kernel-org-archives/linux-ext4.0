Return-Path: <SRS0=bKTL=4L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686D1C35673
	for <linux-ext4@archiver.kernel.org>; Sun, 23 Feb 2020 17:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42CB520880
	for <linux-ext4@archiver.kernel.org>; Sun, 23 Feb 2020 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582480214;
	bh=aGkUUNdudtdMjreO5BreUuCWHEu5YI+KmTD3P3FdV7I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=IFtsUEvfYh2VS1zuDH7AWxqP5qXV92vCx4d6N/tz7pmYQU4MJpXLnt7j372qM3swc
	 WQU6UBbUZqWiL/MjOkM6OllmKcTubnH2YHJz5x/FZNn36kKzIiIXGELPz2LwmlJwA0
	 1LjmI30rJS3NrwfsCm/d7KVcYtAKUFykQh+Q/uJA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBWRuL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWRuL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Feb 2020 12:50:11 -0500
Subject: Re: [GIT PULL] ext4 bug fixes for 5.6-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582480210;
        bh=aGkUUNdudtdMjreO5BreUuCWHEu5YI+KmTD3P3FdV7I=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qig4nw2nUQQtao2JR+biCJz9tQPoEDF96fYEuhXdQy87oSMKP0BZMTpW7oX9cx21V
         X7H3pYvDrHtKknSNiLnYF4/B+oFnHYybSwDGQiLUcuXQ86iiSBK4O5mVyb23lX9v+O
         8GnsTUpcsQ4+fIiVlUyFML7pA+QM+KRs4FsvcYTc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200223034152.GA1035793@mit.edu>
References: <20200223034152.GA1035793@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200223034152.GA1035793@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4_for_linus_stable
X-PR-Tracked-Commit-Id: 9db176bceb5c5df4990486709da386edadc6bd1d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3163ca03f9913ba2c2fb6a06305f3dca98adfd1
Message-Id: <158248021070.10261.5966340377820886917.pr-tracker-bot@kernel.org>
Date:   Sun, 23 Feb 2020 17:50:10 +0000
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Sat, 22 Feb 2020 22:41:52 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3163ca03f9913ba2c2fb6a06305f3dca98adfd1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
