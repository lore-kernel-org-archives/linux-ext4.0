From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Enable quotas before orphan cleanup
Date: Tue, 26 Feb 2013 00:36:09 +0100
Message-ID: <1361835369-19850-2-git-send-email-jack@suse.cz>
References: <1361835369-19850-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759702Ab3BYXgW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 18:36:22 -0500
In-Reply-To: <1361835369-19850-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When using quota feature we need to enable quotas before orphan cleanup
so that changes happening during it are properly reflected in quota
accounting.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

This is based on Jeff Mahoney's patch to tear down kobj when quota init fails:
ext4: cleanup sbi->s_kobj after quota initialization failure

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1746a6e..ef1c69e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4001,6 +4001,16 @@ no_journal:
 	if (err)
 		goto failed_mount7;
 
+#ifdef CONFIG_QUOTA
+	/* Enable quota usage during mount. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+	    !(sb->s_flags & MS_RDONLY)) {
+		err = ext4_enable_quotas(sb);
+		if (err)
+			goto failed_mount8;
+	}
+#endif  /* CONFIG_QUOTA */
+
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
@@ -4018,16 +4028,6 @@ no_journal:
 	} else
 		descr = "out journal";
 
-#ifdef CONFIG_QUOTA
-	/* Enable quota usage during mount. */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-	    !(sb->s_flags & MS_RDONLY)) {
-		err = ext4_enable_quotas(sb);
-		if (err)
-			goto failed_mount8;
-	}
-#endif  /* CONFIG_QUOTA */
