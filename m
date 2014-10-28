From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/3] ext4: enable journal checksum when metadata checksum
 feature enabled
Date: Mon, 27 Oct 2014 18:19:22 -0700
Message-ID: <20141028011922.30103.65942.stgit@birch.djwong.org>
References: <20141028011916.30103.50751.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40784 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaJ1BT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 21:19:27 -0400
In-Reply-To: <20141028011916.30103.50751.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If metadata checksumming is turned on for the FS, we need to tell the
journal to use checksumming too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1eda6ab..5c11e21 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3526,6 +3526,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
+	/* don't forget to enable journal_csum when metadata_csum is enabled. */
+	if (ext4_has_metadata_csum(sb))
+		set_opt(sb, JOURNAL_CHECKSUM);
+
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		set_opt(sb, JOURNAL_DATA);
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)

