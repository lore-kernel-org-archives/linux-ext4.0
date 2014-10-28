From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/3] Subject: [PATCH] ext4: disallow changing journal_csum
 option during remount
Date: Mon, 27 Oct 2014 18:19:29 -0700
Message-ID: <20141028011929.30103.67158.stgit@birch.djwong.org>
References: <20141028011916.30103.50751.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40875 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaJ1BTd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 21:19:33 -0400
In-Reply-To: <20141028011916.30103.50751.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 does not permit changing the metadata or journal checksum feature
flag while mounted.  Until we decide to support that, don't allow a
remount to change the journal_csum flag (right now we silently fail to
change anything).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5c11e21..96059e0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4845,6 +4845,14 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
+	    test_opt(sb, JOURNAL_CHECKSUM)) {
+		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
+			 "during remount not supported");
+		err = -EINVAL;
+		goto restore_opts;
+	}
+
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "

