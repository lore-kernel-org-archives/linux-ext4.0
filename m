Return-Path: <SRS0=FVYV=BR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF179C433E0
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Aug 2020 02:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A256C2177B
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Aug 2020 02:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596767955;
	bh=bvjeBD1saQji7LMSZpFdeOzskozO9njyGtkfYo31rxE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=oUPbD09Uypms8K/JNoVO+g2DEEnc3CrNiX1YjZQ9nXvzy5N3XuEvTGN4r3AmESQcW
	 jQ42i8lkhTB2E044Dhg8W9kcyHc3eGjMgCv5IYgzMaRhP5+LDLeF3sknMnYHdJG9jW
	 qMf6NYtxX20lBraoWZEZQMTBKPsoyuSQo8UXLHew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHGCjO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 22:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgHGCjJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Aug 2020 22:39:09 -0400
Subject: Re: [GIT PULL] ext2, udf, reiserfs, quota cleanups and minor fixes for
 5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596767948;
        bh=bvjeBD1saQji7LMSZpFdeOzskozO9njyGtkfYo31rxE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ZLWS3BwUwE0mk1N7heCmzyJ9pql54IecDciUJjesi/fPJ78IIjT9y4sNEnaXzC0pT
         j9/iIzv+Q+foK5uN3OvvZCuPr+EsGpAj7ej8FibQWkZKQoQ32Ndt3qa51vkzQrH0jM
         RYEM0T9T9fgtFluJGJKSywzSW02NrGbUMde96bKg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200805091205.GD4117@quack2.suse.cz>
References: <20200805091205.GD4117@quack2.suse.cz>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200805091205.GD4117@quack2.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_v5.9-rc1
X-PR-Tracked-Commit-Id: 9436fb4d899333f612e051a6940af52028f7168b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 09e70bb4d89f727bafa6349155e08ce6ac0d8d9f
Message-Id: <159676794814.23087.2830802387498915624.pr-tracker-bot@kernel.org>
Date:   Fri, 07 Aug 2020 02:39:08 +0000
To:     Jan Kara <jack@suse.cz>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Wed, 5 Aug 2020 11:12:05 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_v5.9-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/09e70bb4d89f727bafa6349155e08ce6ac0d8d9f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
