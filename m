From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] ext4: remove duplicate remount check for JOURNAL_CHECKSUM
 change
Date: Tue, 10 Feb 2015 10:41:31 -0600
Message-ID: <54DA34BB.8030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbBJQld (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2015 11:41:33 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1AGfXtD020207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 11:41:33 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t1AGfVOM020190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 11:41:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commits c6d3d56d and 6b992ff2 each added the same test for, and
rejection of, changing journal_checksum during remount.  One suffices.

While we're at it, remove old comment about the "check" option
which has been deprecated for some time now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 74c5f53..f300a56 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4845,9 +4845,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_journal && sbi->s_journal->j_task->io_context)
 		journal_ioprio = sbi->s_journal->j_task->io_context->ioprio;
 
-	/*
-	 * Allow the "check" option to be passed as a remount option.
-	 */
 	if (!parse_options(data, sb, NULL, &journal_ioprio, 1)) {
 		err = -EINVAL;
 		goto restore_opts;
@@ -4861,14 +4858,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
-	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
-	    test_opt(sb, JOURNAL_CHECKSUM)) {
-		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-			 "during remount not supported");
-		err = -EINVAL;
-		goto restore_opts;
-	}
