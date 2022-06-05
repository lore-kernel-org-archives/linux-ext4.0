Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488CBC433EF
	for <linux-ext4@archiver.kernel.org>; Sun,  5 Jun 2022 14:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345029AbiFEOi3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 5 Jun 2022 10:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiFEOi0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2022 10:38:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25EA95B1;
        Sun,  5 Jun 2022 07:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cxz9vtDg6tQp33UVqRoZm+qra1+zb3h6BmXcevlS8kw=; b=MF3TfzT4Wexo7WfhudlQCzBRXq
        9ocyabD851lHuXfVbCJygE+JDdrImD3bgjctsUVRFMW6+orsrdS34q02RC73YRjnVZdbVfaMsXlQE
        bVit62RUfmuX2wLChWhG0P5zC0AUZqP3uFqdiM4KuTnPYn8FLPNT+0+otk8wH8CvJM+qD84RYz04b
        Bi4XeJ74lkO3exoVYwVqCmKtF1ICuHfD9J45z8CDAtwq6zvZvDShH3EkuN+ssNjNclb4xkTgJr8KH
        +BivtsxEnuvmxtNqeP7gUF0LOhnaqCvjGne9Pvn3f+WZgcVfANMoyV238YiB5eVl98OviuS1U5ofl
        CvzQUQYA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxrOU-009mNo-JT; Sun, 05 Jun 2022 14:38:18 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jan Kara <jack@suse.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, tytso@mit.edu,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3] Cache quota files in the page cache
Date:   Sun,  5 Jun 2022 15:38:12 +0100
Message-Id: <20220605143815.2330891-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I don't really want to be working on this ... I'm a bit outside my zone
of knowledge here, and I'd much rather be working on folio conversions.
It mostly works, but a full xfstests run dies, probably from a memory
leak.

Matthew Wilcox (Oracle) (3):
  quota: Prevent memory allocation recursion while holding dq_lock
  quota: Support using the page cache for quota files
  ext4: Use generic_quota_read()

 fs/ext4/super.c          | 81 ++++++++++------------------------------
 fs/quota/dquot.c         | 77 ++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h       |  2 +
 include/linux/quotaops.h |  1 +
 4 files changed, 100 insertions(+), 61 deletions(-)

-- 
2.35.1

