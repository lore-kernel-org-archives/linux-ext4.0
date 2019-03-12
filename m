Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE4DC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 09:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F4C2147C
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 09:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfCLJtM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:49:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:33930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfCLJtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Mar 2019 05:49:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E18DAEF2;
        Tue, 12 Mar 2019 09:49:11 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 587D41E426A; Tue, 12 Mar 2019 10:49:11 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Petr Mladek <pmladek@suse.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Avoid panic during forced reboot
Date:   Tue, 12 Mar 2019 10:49:06 +0100
Message-Id: <20190312094906.5974-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When admin calls "reboot -f" - i.e., does a hard system reboot by
directly calling reboot(2) - ext4 filesystem mounted with errors=panic
can panic the system. This happens because the underlying device gets
disabled without unmounting the filesystem and thus some syscall running
in parallel to reboot(2) can result in the filesystem getting IO errors.

This is somewhat surprising to the users so try improve the behavior by
switching to errors=remount-ro behavior when the system is running
reboot(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

What do people think about this? Arguably this change has some potential
for breakage if e.g. an ext4 error would somehow block reboot(2). I don't
see how that would be possible but I wanted to raise this just in case...

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 60da0a6e4d86..f7b6f95fa8dd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -430,6 +430,12 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	spin_unlock(&sbi->s_md_lock);
 }
 
+static bool system_going_down(void)
+{
+	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
+		|| system_state == SYSTEM_RESTART;
+}
+
 /* Deal with the reporting of failure conditions on a filesystem such as
  * inconsistencies detected or read IO failures.
  *
@@ -460,7 +466,12 @@ static void ext4_handle_error(struct super_block *sb)
 		if (journal)
 			jbd2_journal_abort(journal, -EIO);
 	}
-	if (test_opt(sb, ERRORS_RO)) {
+	/*
+	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
+	 * could panic during 'reboot -f' as the underlying device got already
+	 * disabled.
+	 */
+	if (test_opt(sb, ERRORS_RO) || system_going_down()) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		/*
 		 * Make sure updated value of ->s_mount_flags will be visible
-- 
2.16.4

