From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch]check NULL pointer
Date: Thu, 09 Jun 2011 11:31:32 +0800
Message-ID: <1307590292.15392.71.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64010 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab1FIDbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 23:31:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

orig_data could be NULL.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cc5c157..45fc255 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3057,6 +3057,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
 
+	if (!orig_data)
+		return ret;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out_free_orig;
@@ -4285,6 +4287,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 #endif
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 
+	if (!orig_data)
+		return -ENOMEM;
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;


