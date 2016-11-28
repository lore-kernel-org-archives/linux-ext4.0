From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix checks for data=ordered and journal_async_commit options
Date: Mon, 28 Nov 2016 15:43:42 +0100
Message-ID: <1480344222-1234-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Wolfgang Walter <linux@stwm.de>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932469AbcK1Onw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Nov 2016 09:43:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Combination of data=ordered mode and journal_async_commit mount option
is invalid. However the check in parse_options() fails to detect the
case where we simply end up defaulting to data=ordered mode and we
detect the problem only on remount which triggers hard to understand
failure to remount the filesystem.

Fix the checking of mount options to take into account also the default
mode by moving the check somewhat later in the mount sequence.

Reported-by: Wolfgang Walter <linux@stwm.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 52b0530c5d65..58017f54a016 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1883,12 +1883,6 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 		}
 	}
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA &&
-	    test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
-		ext4_msg(sb, KERN_ERR, "can't mount with journal_async_commit "
-			 "in data=ordered mode");
-		return 0;
-	}
 	return 1;
 }
 
@@ -3967,6 +3961,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	default:
 		break;
 	}
+
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA &&
+	    test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+		ext4_msg(sb, KERN_ERR, "can't mount with "
+			"journal_async_commit in data=ordered mode");
+		goto failed_mount_wq;
+	}
+
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
@@ -4857,6 +4859,13 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			err = -EINVAL;
 			goto restore_opts;
 		}
+	} else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA) {
+		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				"journal_async_commit in data=ordered mode");
+			err = -EINVAL;
+			goto restore_opts;
+		}
 	}
 
 	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_DAX) {
-- 
2.6.6

