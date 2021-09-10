Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43574C4332F
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Sep 2021 00:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A7F60C40
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Sep 2021 00:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhIJAqA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233902AbhIJAWF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6316B6023D;
        Fri, 10 Sep 2021 00:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233255;
        bh=uPgnDOaA8SeLYi8s9PsGRztLS/aCdIpB1JE54sRchGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzwfblW9FGIn3ILuuGVp4NhAFVotVdKgmEwtvOOjaPnHcbYcjVuFyN4wu4r4zoN7R
         dzsc8hVn9HUq7Bj8m4yG2z+Bdq3aBQbFtdm4n5ufyN4rydC6mfoNg7xUDBdgY8c1qo
         g+oFsKMn6scmQYbEs7SDdvryciPhYpmAQl+7v77zJdrH4aCG6HyxgBSfUquOdKfIlN
         757+Ms+I1xQnHwvjtnww8hvY7WdTXUDHJo/AJQ7GKlwarUgTec33L9TiqSvQ8Yzaj8
         AH6jif34eD/ccdCKfoMYRhMGvQuqO/DOzqaKje5X32s814IKQ32Ok+vVAJs9XA3OQT
         qwXhercZFq5mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 19/53] jbd2: fix clang warning in recovery.c
Date:   Thu,  9 Sep 2021 20:19:54 -0400
Message-Id: <20210910002028.175174-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 390add0cc9f4d7fda89cf3db7651717e82cf0afc ]

Remove unused variable store which was never used.

This fix is also in e2fsprogs commit 99a2294f85f0 ("e2fsck: value
stored to err is never read").

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/recovery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 25744f088a6c..48b5efd2ad45 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -760,7 +760,6 @@ static int do_one_pass(journal_t *journal,
 				 */
 				jbd_debug(1, "JBD2: Invalid checksum ignored in transaction %u, likely stale data\n",
 					  next_commit_ID);
-				err = 0;
 				brelse(bh);
 				goto done;
 			}
-- 
2.30.2

