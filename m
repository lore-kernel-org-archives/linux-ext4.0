From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 7/8][e2fsprogs] change access to the reserved blocks counter
Date: Thu, 30 Aug 2007 17:42:06 +0200
Message-ID: <1188488526.15770.58.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43853 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbXH3N05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:57 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

This patch replaces all references to super->s_r_blocks_count by
ext2_r_blocks_count(super) in preparation for 64-bit support.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 e2fsck/super.c          |    2 +-
 lib/ext2fs/initialize.c |    4 ++--
 misc/mke2fs.c           |    8 ++++----
 misc/tune2fs.c          |    8 ++++----
 resize/online.c         |    3 ++-
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index d2693db..f7e4e89 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -507,7 +507,7 @@ void check_super_block(e2fsck_t ctx)
 			  MIN_CHECK | MAX_CHECK, 8, bpg_max);
 	check_super_value(ctx, "inodes_per_group", sb->s_inodes_per_group,
 			  MIN_CHECK | MAX_CHECK, inodes_per_block, ipg_max);
-	check_super_value(ctx, "r_blocks_count", sb->s_r_blocks_count,
+	check_super_value(ctx, "r_blocks_count", ext2_r_blocks_count(sb),
 			  MAX_CHECK, 0, ext2_blocks_count(sb) / 2);
 	check_super_value(ctx, "reserved_gdt_blocks", 
 			  sb->s_reserved_gdt_blocks, MAX_CHECK, 0,
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index cb68191..6969745 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -188,8 +188,8 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
 	
 	ext2_blocks_count_set(super, ext2_blocks_count(param));
-	super->s_r_blocks_count = param->s_r_blocks_count;
-	if (super->s_r_blocks_count >= ext2_blocks_count(param)) {
+	ext2_r_blocks_count_set(super, ext2_r_blocks_count(param));
+	if (ext2_r_blocks_count(super) >= ext2_blocks_count(param)) {
 		retval = EXT2_ET_INVALID_ARGUMENT;
 		goto cleanup;
 	}
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 021625a..074c985 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -687,8 +687,8 @@ static void show_stats(ext2_filsys fs)
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
 	       ext2_blocks_count(s));
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
-		s->s_r_blocks_count,
-	       100.0 * s->s_r_blocks_count / ext2_blocks_count(s));
+		ext2_r_blocks_count(s),
+	       100.0 * ext2_r_blocks_count(s) / ext2_blocks_count(s));
 	printf(_("First data block=%u\n"), s->s_first_data_block);
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
@@ -1547,8 +1547,8 @@ static void PRS(int argc, char *argv[])
 	/*
 	 * Calculate number of blocks to reserve
 	 */
-	fs_param.s_r_blocks_count = e2p_percent(reserved_ratio, 
-						ext2_blocks_count(&fs_param));
+	ext2_r_blocks_count_set(&fs_param, e2p_percent(reserved_ratio,
+						ext2_blocks_count(&fs_param)));
 }
 
 int main (int argc, char *argv[])
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5eaa252..2d3e3c0 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -825,11 +825,11 @@ int main (int argc, char ** argv)
 		printf (_("Setting interval between checks to %lu seconds\n"), interval);
 	}
 	if (m_flag) {
-		sb->s_r_blocks_count = e2p_percent(reserved_ratio,
-						   ext2_blocks_count(sb));
+		ext2_r_blocks_count_set(sb,
+			 e2p_percent(reserved_ratio, ext2_blocks_count(sb)));
 		ext2fs_mark_super_dirty(fs);
 		printf (_("Setting reserved blocks percentage to %g%% (%u blocks)\n"),
-			reserved_ratio, sb->s_r_blocks_count);
+			reserved_ratio, ext2_r_blocks_count(sb));
 	}
 	if (r_flag) {
 		if (reserved_blocks >= ext2_blocks_count(sb) / 2) {
@@ -838,7 +838,7 @@ int main (int argc, char ** argv)
 				 reserved_blocks);
 			exit (1);
 		}
-		sb->s_r_blocks_count = reserved_blocks;
+		ext2_r_blocks_count_set(sb, reserved_blocks);
 		ext2fs_mark_super_dirty(fs);
 		printf (_("Setting reserved blocks count to %lu\n"),
 			reserved_blocks);
diff --git a/resize/online.c b/resize/online.c
index ebc4ff9..f5bc0c0 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -79,7 +79,8 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		exit(1);
 	}
 
-	r_frac = ext2fs_div_ceil(100 * sb->s_r_blocks_count, ext2_blocks_count(sb));
+	r_frac = ext2fs_div_ceil(100 * ext2_r_blocks_count(sb),
+				 ext2_blocks_count(sb));
 
 	retval = ext2fs_read_bitmaps(fs);
 	if (retval)
