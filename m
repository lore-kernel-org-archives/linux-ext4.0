From: akpm@osdl.org
Subject: + remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code.patch added to -mm tree
Date: Thu, 19 Oct 2006 15:51:42 -0700
Message-ID: <200610192251.k9JMpgF5028344@shell0.pdx.osdl.net>
Cc: agruen@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:47808 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1946614AbWJSWvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Oct 2006 18:51:46 -0400
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     Remove superfluous lock_super() in extN xattr code

has been added to the -mm tree.  Its filename is

     remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove superfluous lock_super() in extN xattr code
From: Andreas Gruenbacher <agruen@suse.de>

lock_super() is unnecessary for setting super-block feature flags.  Use the
provided *_SET_COMPAT_FEATURE() macros as well.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/xattr.c |    5 +----
 fs/ext3/xattr.c |    5 +----
 fs/ext4/xattr.c |    5 +----
 3 files changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/ext2/xattr.c~remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code
+++ a/fs/ext2/xattr.c
@@ -342,12 +342,9 @@ static void ext2_xattr_update_super_bloc
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR))
 		return;
 
-	lock_super(sb);
-	EXT2_SB(sb)->s_es->s_feature_compat |=
-		cpu_to_le32(EXT2_FEATURE_COMPAT_EXT_ATTR);
+	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
 	sb->s_dirt = 1;
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	unlock_super(sb);
 }
 
 /*
diff -puN fs/ext3/xattr.c~remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code
+++ a/fs/ext3/xattr.c
@@ -459,14 +459,11 @@ static void ext3_xattr_update_super_bloc
 	if (EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_EXT_ATTR))
 		return;
 
-	lock_super(sb);
 	if (ext3_journal_get_write_access(handle, EXT3_SB(sb)->s_sbh) == 0) {
-		EXT3_SB(sb)->s_es->s_feature_compat |=
-			cpu_to_le32(EXT3_FEATURE_COMPAT_EXT_ATTR);
+		EXT3_SET_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_EXT_ATTR);
 		sb->s_dirt = 1;
 		ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
 	}
-	unlock_super(sb);
 }
 
 /*
diff -puN fs/ext4/xattr.c~remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code
+++ a/fs/ext4/xattr.c
@@ -459,14 +459,11 @@ static void ext4_xattr_update_super_bloc
 	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR))
 		return;
 
-	lock_super(sb);
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
-		EXT4_SB(sb)->s_es->s_feature_compat |=
-			cpu_to_le32(EXT4_FEATURE_COMPAT_EXT_ATTR);
+		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
 		sb->s_dirt = 1;
 		ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
 	}
-	unlock_super(sb);
 }
 
 /*
_

Patches currently in -mm which might be from agruen@suse.de are

fs-kconfig-move-generic_acl-fix-acl-call-errors.patch
remove-superfluous-lock_super-in-ext2-and-ext3-xattr-code.patch
