From: akpm@linux-foundation.org
Subject: - ext2-convert-byte-order-of-constant-instead-of-variable.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:14 -0700
Message-ID: <200804282200.m3SM0Eh4018676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: marcin.slusarz@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: convert byte order of constant instead of variable
has been removed from the -mm tree.  Its filename was
     ext2-convert-byte-order-of-constant-instead-of-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: convert byte order of constant instead of variable
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable which can be done at
compile time (vs run time).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/ext2/super.c~ext2-convert-byte-order-of-constant-instead-of-variable fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/ext2/super.c
@@ -51,8 +51,7 @@ void ext2_error (struct super_block * sb
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		sbi->s_mount_state |= EXT2_ERROR_FS;
-		es->s_state =
-			cpu_to_le16(le16_to_cpu(es->s_state) | EXT2_ERROR_FS);
+		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
 		ext2_sync_super(sb, es);
 	}
 
@@ -1126,10 +1125,9 @@ void ext2_write_super (struct super_bloc
 	if (!(sb->s_flags & MS_RDONLY)) {
 		es = EXT2_SB(sb)->s_es;
 
-		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS) {
+		if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 			ext2_debug ("setting valid to 0\n");
-			es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) &
-						  ~EXT2_VALID_FS);
+			es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
 			es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 			es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 			es->s_mtime = cpu_to_le32(get_seconds());
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
ntfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

