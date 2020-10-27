Return-Path: <SRS0=Q+OU=EC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE2AC56201
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 10:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0FB21D24
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 10:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603792881;
	bh=nmVlHJl4ky1onYW7Dq+mrJQd7XAD9Hsjyr0pZ7lcwnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nFpMQIJPV39Zf7pA02ykmEtPXNVqv+Q/U9HQLBowxU2ZJIgORstg3MJ1ob5b7oyb+
	 hOtrm7DApeD+3loE+OUTicomEleSfzddvKr2pqlWEtc5hoNUsjPQrBTtmpksbunY5B
	 v9BIun2sFjqzx0+Ijv3Ko7GgrXJTfeseHNSIxtcY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896739AbgJ0KBG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 27 Oct 2020 06:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896053AbgJ0Jvn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Oct 2020 05:51:43 -0400
Received: from mail.kernel.org (ip5f5ad5af.dynamic.kabel-deutschland.de [95.90.213.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9F424199;
        Tue, 27 Oct 2020 09:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603792301;
        bh=nmVlHJl4ky1onYW7Dq+mrJQd7XAD9Hsjyr0pZ7lcwnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfA4ech+UxL7gl/KMolyJ45N5ZQ5YTWHlr0nl6u/lRLKHTorLbFYfForbQXrl1JpC
         P/egqjtOJ+mjvCPGko4KCwjbgMVTgINy0wvgLWUMZu6OgJuK1/ceLnjnuA/zGWGAJi
         WsubpSveoltMGUAGQjNzhN/6XOQ6f6YBwKJpn36Q=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kXLdj-003FFT-OF; Tue, 27 Oct 2020 10:51:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 23/32] jbd2: fix a kernel-doc markup
Date:   Tue, 27 Oct 2020 10:51:27 +0100
Message-Id: <6055927ada2015b55b413cdd2670533bdc9a8da2.1603791716.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603791716.git.mchehab+huawei@kernel.org>
References: <cover.1603791716.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The kernel-doc markup that documents _fc_replay_callback is
missing an asterisk, causing this warning:

	../include/linux/jbd2.h:1271: warning: Function parameter or member 'j_fc_replay_callback' not described in 'journal_s'

When building the docs.

Fixes: 609f928af48f ("jbd2: fast commit recovery path")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/jbd2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index fb3d71ad6eea..3c5f76ce88f1 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1253,7 +1253,7 @@ struct journal_s
 	 */
 	void (*j_fc_cleanup_callback)(struct journal_s *journal, int);
 
-	/*
+	/**
 	 * @j_fc_replay_callback:
 	 *
 	 * File-system specific function that performs replay of a fast
-- 
2.26.2

