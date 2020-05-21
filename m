Return-Path: <SRS0=JSyQ=7D=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1C7C433E1
	for <linux-ext4@archiver.kernel.org>; Thu, 21 May 2020 20:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEAE320878
	for <linux-ext4@archiver.kernel.org>; Thu, 21 May 2020 20:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590094510;
	bh=4utBsPibD/vb0wiZZmLK5DrFsrXhoZXeZ/nWqlmx9n8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=rffTv1sir6flzfQPmg0EtS1RtyePLhLtB9u74yROVGjVXgoOFBvvE4lwi8Y6HprPW
	 lgQcBZQE1xCU1wBkEGsSZMPEcwmxcl8hToTTRUNRNojeHdzwS8yXEM7iyTTzjQtSpN
	 76GZMq4REp4iqVG/jwWuYQyJtj7Xb9EHDlw6ClVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgEUUzJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 May 2020 16:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgEUUzF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 May 2020 16:55:05 -0400
Subject: Re: [GIT PULL] fixes for 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590094504;
        bh=4utBsPibD/vb0wiZZmLK5DrFsrXhoZXeZ/nWqlmx9n8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=p/NBGp6QTF/N/YltY3EFARBd5J9wu3YlmptlAIEFfNTYd5ub6d0EY1keHIIITt1PV
         7nQYs9b+pw62tdfSVkyR31Omh5RmFy5lHYdIU/5KvaNWVUgmfPr2/C1inDzBeC5q4F
         1m/+Dmb6oIDrqXOGv+gJ+c3C+p6Ls/mQEyni3VPc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200521141243.GA2942212@mit.edu>
References: <20200521141243.GA2942212@mit.edu>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200521141243.GA2942212@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 tags/fiemap-regression-fix
X-PR-Tracked-Commit-Id: 959f7584512941a614113bfddb41b6812214169d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 57f1b0cf2de82644efcc5e30f5054eae12329bbc
Message-Id: <159009450492.9071.7919920653549493426.pr-tracker-bot@kernel.org>
Date:   Thu, 21 May 2020 20:55:04 +0000
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ext4@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The pull request you sent on Thu, 21 May 2020 10:12:43 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/fiemap-regression-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/57f1b0cf2de82644efcc5e30f5054eae12329bbc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
