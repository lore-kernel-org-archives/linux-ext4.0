From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] ext4: enable journal checksum if metadata checksum
 feature enabled
Date: Mon, 20 Oct 2014 18:05:01 -0700
Message-ID: <20141021010501.21404.59849.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36472 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaJUBFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2014 21:05:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If metadata checksumming is turned on for the FS, we might as well
enable it for the journal too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index de38a96..5d51dbf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3506,6 +3506,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
+	/* if metadata_csum, journal_csum is now defaulted on */
+	if (ext4_has_metadata_csum(sb))
+		set_opt(sb, JOURNAL_CHECKSUM);
+
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		set_opt(sb, JOURNAL_DATA);
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)

