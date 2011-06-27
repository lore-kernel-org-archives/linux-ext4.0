From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Deprecate data=journal mount option
Date: Mon, 27 Jun 2011 17:37:24 +0200
Message-ID: <1309189044-21791-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, jack@suse.cz, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1F0Phn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 11:37:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Data journalling mode (data=journal) is known to be neglected by
developers and only minority of people is actually using it. This
mode is also less tested than the other two modes by the developers.

This creates a dangerous combination, because the option which seems
*safer* is actually less safe the others. So this commit adds a warning
message in case that data=journal mode is used, so the user is informed
that the mode has been deprecated and we do not recommend using it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..d5a3dea 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1631,6 +1631,10 @@ static int parse_options(char *options, struct super_block *sb,
 			sbi->s_min_batch_time = option;
 			break;
 		case Opt_data_journal:
+			ext4_msg(sb, KERN_WARNING,
+				 "Using data=journal is not recommended. It "
+				 "has been deprecated and can be removed "
+				 "in the future");
 			data_opt = EXT4_MOUNT_JOURNAL_DATA;
 			goto datacheck;
 		case Opt_data_ordered:
-- 
1.7.4.4

