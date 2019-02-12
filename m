Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7AFC282CA
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 21:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D03222C0
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 21:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550007932;
	bh=IgM4ezCIG86NCZV3+7Jn2Hxmgd/On6ckwP5q/IJ/p40=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=wiWIrdVti8VysvtijqjdSkYIZe1YIDGtiNAq1Mgklt+p9cCp2S7rLSlMM8IAO4E7m
	 bwyCHSj/2O8j1FUBt1MDj+47qTNcs13JRwdtXIx0lzaz5pJMfl3QKXqBHTnk7VuNHc
	 uMKwOsaibXzX5rYei/jaa6/7+nf2BshyL2oW3zDM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbfBLVpH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 16:45:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732594AbfBLVpD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 16:45:03 -0500
Subject: Re: [GIT PULL] ext4 fix for 5.0-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550007903;
        bh=IgM4ezCIG86NCZV3+7Jn2Hxmgd/On6ckwP5q/IJ/p40=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Jerlec1bNroEswSrkUWdoEM3WR2wfqD2NoFMEvii9GAXWi0iqjknkytLiXwti5kSd
         KJEU+DX2IluX5rftQTy6vSiOka4a4FHx0409J8UWTfzhq36x4Ft798g74Cs+JZcOI4
         ACSbJNY1361vs7TZ89zEZ79IByoQ/9MBjYaoFiYU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190212043324.GA15822@mit.edu>
References: <20190212043324.GA15822@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190212043324.GA15822@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/ext4_for_linus_stable
X-PR-Tracked-Commit-Id: 8fdd60f2ae3682caf2a7258626abc21eb4711892
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ae757efd32bd4962fa16366875416a55307f7c4
Message-Id: <155000790296.22230.355337373843353995.pr-tracker-bot@kernel.org>
Date:   Tue, 12 Feb 2019 21:45:02 +0000
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Mon, 11 Feb 2019 23:33:24 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ae757efd32bd4962fa16366875416a55307f7c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
