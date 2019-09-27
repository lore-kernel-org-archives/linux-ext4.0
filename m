Return-Path: <SRS0=SFt/=XW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B25C388F3
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Sep 2019 11:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98FB52146E
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Sep 2019 11:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfI0LQG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Sep 2019 07:16:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:52378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727275AbfI0LQE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 27 Sep 2019 07:16:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9DF7CB11E;
        Fri, 27 Sep 2019 11:16:03 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3E4451E41F5; Fri, 27 Sep 2019 13:16:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 03/15] ext4: Do not iput inode under running transaction in ext4_mkdir()
Date:   Fri, 27 Sep 2019 13:15:24 +0200
Message-Id: <20190927111536.16455-4-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190927111536.16455-1-jack@suse.cz>
References: <20190927111536.16455-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When ext4_mkdir() fails to add entry into directory, it ends up dropping
freshly created inode under the running transaction and thus inode
truncation happens under that transaction. That breaks assumptions that
ext4_evict_inode() does not get called from a transaction context
(although I'm not aware of any real issue) and is completely
unnecessary. Just stop the transaction before dropping inode reference.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 129029534075..46e203f100de 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2781,8 +2781,9 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		clear_nlink(inode);
 		unlock_new_inode(inode);
 		ext4_mark_inode_dirty(handle, inode);
+		ext4_journal_stop(handle);
 		iput(inode);
-		goto out_stop;
+		goto out_retry;
 	}
 	ext4_inc_count(handle, dir);
 	ext4_update_dx_flag(dir);
@@ -2796,6 +2797,7 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 out_stop:
 	if (handle)
 		ext4_journal_stop(handle);
+out_retry:
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
-- 
2.16.4

