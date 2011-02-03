From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix up ext4 error handling
Date: Thu,  3 Feb 2011 00:55:40 -0500
Message-ID: <1296712540-29518-1-git-send-email-tytso@mit.edu>
References: <1295276437-27966-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58477 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab1BCFzn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 00:55:43 -0500
In-Reply-To: <1295276437-27966-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure we the correct cleanup happens if we die while trying to
load the ext4 file system.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

While I was looking over the patch "unregister features interface on
module unload", I noticed that we weren't correctly checking all of the
error returns in ext4_init_fs().

 fs/ext4/super.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4898cb1..86b0548 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4810,13 +4810,17 @@ static int __init ext4_init_fs(void)
 		return err;
 	err = ext4_init_system_zone();
 	if (err)
-		goto out5;
+		goto out7;
 	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
 	if (!ext4_kset)
-		goto out4;
+		goto out6;
 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
+	if (!ext4_proc_root)
+		goto out5;
 
 	err = ext4_init_feat_adverts();
+	if (err)
+		goto out4;
 
 	err = ext4_init_mballoc();
 	if (err)
@@ -4847,11 +4851,13 @@ out2:
 	ext4_exit_mballoc();
 out3:
 	ext4_exit_feat_adverts();
+out4:
 	remove_proc_entry("fs/ext4", NULL);
+out5:
 	kset_unregister(ext4_kset);
-out4:
+out6:
 	ext4_exit_system_zone();
-out5:
+out7:
 	ext4_exit_pageio();
 	return err;
 }
-- 
1.7.3.1

