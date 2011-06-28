From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Tue, 28 Jun 2011 13:26:03 +0200
Message-ID: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, jack@suse.cz, sandeen@redhat.com, adilger@dilger.ca,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab1F1L0U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Data journalling mode (data=journal) is known to be neglected by
developers and only minority of people is actually using it. This
mode is also less tested than the other two modes by the developers.

This creates a dangerous combination, because the option which seems
*safer* is actually less safe the others. So this commit adds a warning
message in case that data=journal mode is used, so the user is informed
that the mode might be removed in the future.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..9d189cf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1631,6 +1631,11 @@ static int parse_options(char *options, struct super_block *sb,
 			sbi->s_min_batch_time = option;
 			break;
 		case Opt_data_journal:
+			ext4_msg(sb, KERN_WARNING,
+				 "Using data=journal may be removed in the "
+				 "future. Please, contact "
+				 "linux-ext4@vger.kernel.org if you are "
+				 "using this feature.");
 			data_opt = EXT4_MOUNT_JOURNAL_DATA;
 			goto datacheck;
 		case Opt_data_ordered:
-- 
1.7.4.4

