Return-Path: <SRS0=p1TA=TI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9632C04A6B
	for <linux-ext4@archiver.kernel.org>; Wed,  8 May 2019 04:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96EDD20850
	for <linux-ext4@archiver.kernel.org>; Wed,  8 May 2019 04:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557291331;
	bh=XWiJafixRm/GHlU7alPE6TKP6lFV6i9YyfGzNa5UgYY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=zwFkFkRhyYPjH4TJuBJZEEBUXpzAb0+MdkmOec9FtwFFEN2GHOonr3lDgRMxGkn59
	 n+OVjHzhctKBUI7uDxzPInRsDIX7qHImSZhC4hueV6k+5s9NLvhKSB6k1xoRV3TYZI
	 8kCLz/WweWmxZihYBkaKkW5NUjDrgJMj1qv3VTwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfEHEzR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 May 2019 00:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfEHEzR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 8 May 2019 00:55:17 -0400
Subject: Re: [GIT PULL] ext4 changes for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557291316;
        bh=XWiJafixRm/GHlU7alPE6TKP6lFV6i9YyfGzNa5UgYY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=OqweP0BG/KA2mFcC07HjF+np5qnkUb5WM5ZtnIN6Jn2WiPg6ExnJAXOdUUrCiAKat
         R3xoWq+aop5vSip06O/YeQwO/Pxx0TsYiStZg2FQzgGXHMGG5UaO2AxfvI62n4KKS4
         K0QqDAvs2Hg2tWPCLxfCd2KuuEAabpN371iBI984=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190507232823.GA28416@mit.edu>
References: <20190507232823.GA28416@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190507232823.GA28416@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4_for_linus
X-PR-Tracked-Commit-Id: db90f41916cf04c020062f8d8b0385942248283e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5abe37954e9a315c35c9490f78d55f307c3c636b
Message-Id: <155729131654.10324.4928528529149948067.pr-tracker-bot@kernel.org>
Date:   Wed, 08 May 2019 04:55:16 +0000
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Tue, 7 May 2019 19:28:23 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5abe37954e9a315c35c9490f78d55f307c3c636b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
