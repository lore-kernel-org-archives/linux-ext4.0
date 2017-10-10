From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: shorten test descriptions to fit in 80 columns
Date: Tue, 10 Oct 2017 16:43:46 -0600
Message-ID: <1507675426-70319-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:35243 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756645AbdJJWos (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 18:44:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While not critical to functionality, it is easier to see the pass/fail
status of each test if they are not wrapped onto the next line.
Shorten test descriptions so the name+description fit in 80 columns.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/e_brel_bma/name                            | 2 +-
 tests/e_irel_ima/name                            | 2 +-
 tests/f_bigalloc_symlink_with_xattr/name         | 2 +-
 tests/f_boundscheck/name                         | 2 +-
 tests/f_convert_bmap_and_extent/name             | 2 +-
 tests/f_deleted_inode_bad_csum/name              | 2 +-
 tests/f_dir_bad_csum/name                        | 2 +-
 tests/f_htree_bad_csum/name                      | 2 +-
 tests/f_hugedir_blocks/name                      | 2 +-
 tests/f_jnl_etb_alloc_fail/name                  | 2 +-
 tests/f_rebuild_csum_rootdir/name                | 2 +-
 tests/f_uninit_ext_past_eof2/name                | 2 +-
 tests/f_write_ea_toosmall_extra_isize/name       | 2 +-
 tests/j_corrupt_ext_jnl_sb_block/name            | 2 +-
 tests/j_corrupt_ext_jnl_sb_csum/name             | 2 +-
 tests/j_ext_long_revoke_trans/name               | 2 +-
 tests/j_long_revoke_trans_mcsum_32bit/name       | 2 +-
 tests/j_long_revoke_trans_mcsum_64bit/name       | 2 +-
 tests/j_long_trans_mcsum_32bit/name              | 2 +-
 tests/j_long_trans_mcsum_64bit/name              | 2 +-
 tests/j_short_revoke_trans_mcsum_64bit/name      | 2 +-
 tests/j_short_trans_mcsum_64bit/name             | 2 +-
 tests/j_short_trans_old_csum/name                | 2 +-
 tests/j_short_trans_open_recover/name            | 2 +-
 tests/j_short_trans_recover_mcsum_64bit/name     | 2 +-
 tests/j_short_uncommitted_trans_mcsum_64bit/name | 2 +-
 tests/m_hugefile_slack/name                      | 2 +-
 tests/r_32to64bit_expand_full/name               | 2 +-
 tests/r_32to64bit_move_itable/name               | 2 +-
 tests/t_change_uuid_mcsum_seed_mounted/script    | 2 +-
 tests/t_disable_changed_csum_seed/script         | 2 +-
 tests/t_disable_changed_csum_seed_mounted/script | 2 +-
 tests/u_revert_64bitmcsum_onefile/script         | 2 +-
 tests/u_revert_all_onefile/script                | 2 +-
 tests/u_revert_upgrade_to_64bitmcsum/script      | 2 +-
 35 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/tests/e_brel_bma/name b/tests/e_brel_bma/name
index d745587..9843871 100644
--- a/tests/e_brel_bma/name
+++ b/tests/e_brel_bma/name
@@ -1 +1 @@
-block relocation table using the memory array implementation
+block relocation table using memory array implementation
diff --git a/tests/e_irel_ima/name b/tests/e_irel_ima/name
index 6efd72e..d19d277 100644
--- a/tests/e_irel_ima/name
+++ b/tests/e_irel_ima/name
@@ -1 +1 @@
-inode relocation table using the memory array implementation
+inode relocation table using memory array implementation
diff --git a/tests/f_bigalloc_symlink_with_xattr/name b/tests/f_bigalloc_symlink_with_xattr/name
index f612796..8adbd9a 100644
--- a/tests/f_bigalloc_symlink_with_xattr/name
+++ b/tests/f_bigalloc_symlink_with_xattr/name
@@ -1 +1 @@
-fast symlink with external xattr block on bigalloc filesystem
+fast symlink + xattr block on bigalloc fs
diff --git a/tests/f_boundscheck/name b/tests/f_boundscheck/name
index 192d279..7d71be5 100644
--- a/tests/f_boundscheck/name
+++ b/tests/f_boundscheck/name
@@ -1 +1 @@
-infinite loop due to off by one error when finding free space for inode table relocation
+infinite loop when finding table free space
diff --git a/tests/f_convert_bmap_and_extent/name b/tests/f_convert_bmap_and_extent/name
index c9394c6..1a58794 100644
--- a/tests/f_convert_bmap_and_extent/name
+++ b/tests/f_convert_bmap_and_extent/name
@@ -1 +1 @@
-convert blockmap and extents files to extents files
+convert blockmap to extents files
diff --git a/tests/f_deleted_inode_bad_csum/name b/tests/f_deleted_inode_bad_csum/name
index 516701a..c034ace 100644
--- a/tests/f_deleted_inode_bad_csum/name
+++ b/tests/f_deleted_inode_bad_csum/name
@@ -1 +1 @@
-deleted inode with a bad csum that wasn't getting fixed (metadata_csum)
+deleted inode with bad metadata_csum wasn't fixed
diff --git a/tests/f_dir_bad_csum/name b/tests/f_dir_bad_csum/name
index 140ae45..6397e9d 100644
--- a/tests/f_dir_bad_csum/name
+++ b/tests/f_dir_bad_csum/name
@@ -1 +1 @@
-dir block w/ missing/bad csum, no tail, or dir block corruption (metadata_csum)
+dir block w/ missing/bad csum/tail or block corruption
diff --git a/tests/f_htree_bad_csum/name b/tests/f_htree_bad_csum/name
index ebfc3ea..3388353 100644
--- a/tests/f_htree_bad_csum/name
+++ b/tests/f_htree_bad_csum/name
@@ -1 +1 @@
-htree block w/ missing/bad csum, bad protective dirent, or htree index corruption (metadata_csum)
+htree block bad csum/tail dirent/htree index corruption
diff --git a/tests/f_hugedir_blocks/name b/tests/f_hugedir_blocks/name
index d74761b..58b7916 100644
--- a/tests/f_hugedir_blocks/name
+++ b/tests/f_hugedir_blocks/name
@@ -1 +1 @@
-crash e2fsck with a dir with an impossibly high logical blk offset
+dir crashes e2fsck with impossible logical blk offset
diff --git a/tests/f_jnl_etb_alloc_fail/name b/tests/f_jnl_etb_alloc_fail/name
index 7651fdc..d9bce1c 100644
--- a/tests/f_jnl_etb_alloc_fail/name
+++ b/tests/f_jnl_etb_alloc_fail/name
@@ -1 +1 @@
-can't allocate extent tree block while recreating journal
+can't allocate extent tree block recreating journal
diff --git a/tests/f_rebuild_csum_rootdir/name b/tests/f_rebuild_csum_rootdir/name
index b246f48..5ea2097 100644
--- a/tests/f_rebuild_csum_rootdir/name
+++ b/tests/f_rebuild_csum_rootdir/name
@@ -1 +1 @@
-force fsck to rebuild a corrupted rootdir w/ metadata_csum
+force rebuild corrupted rootdir w/ metadata_csum
diff --git a/tests/f_uninit_ext_past_eof2/name b/tests/f_uninit_ext_past_eof2/name
index 352a0f5..025cc44 100644
--- a/tests/f_uninit_ext_past_eof2/name
+++ b/tests/f_uninit_ext_past_eof2/name
@@ -1 +1 @@
-fallocated extents after nonzero i_size and total extents > 4
+fallocate extents w/ nonzero i_size and extents > 4
diff --git a/tests/f_write_ea_toosmall_extra_isize/name b/tests/f_write_ea_toosmall_extra_isize/name
index 718c12c..a1ebc7f 100644
--- a/tests/f_write_ea_toosmall_extra_isize/name
+++ b/tests/f_write_ea_toosmall_extra_isize/name
@@ -1 +1 @@
-write EA when i_extra_size is too small to make sense
+write EA when i_extra_size is too small
diff --git a/tests/j_corrupt_ext_jnl_sb_block/name b/tests/j_corrupt_ext_jnl_sb_block/name
index a5188be..35f1689 100644
--- a/tests/j_corrupt_ext_jnl_sb_block/name
+++ b/tests/j_corrupt_ext_jnl_sb_block/name
@@ -1 +1 @@
-corrupt external journal fs superblock block (metadata_csum)
+corrupt mcsum ext jnl fs superblock block
diff --git a/tests/j_corrupt_ext_jnl_sb_csum/name b/tests/j_corrupt_ext_jnl_sb_csum/name
index c182f81..7e73971 100644
--- a/tests/j_corrupt_ext_jnl_sb_csum/name
+++ b/tests/j_corrupt_ext_jnl_sb_csum/name
@@ -1 +1 @@
-corrupt external journal fs superblock csum (metadata_csum)
+corrupt external journal superblock metadata_csum
diff --git a/tests/j_ext_long_revoke_trans/name b/tests/j_ext_long_revoke_trans/name
index 777010d..932a5bd 100644
--- a/tests/j_ext_long_revoke_trans/name
+++ b/tests/j_ext_long_revoke_trans/name
@@ -1 +1 @@
-revoked transaction nuking free space w/ ext. journal
+revoke trans nuking free space w/ ext. journal
diff --git a/tests/j_long_revoke_trans_mcsum_32bit/name b/tests/j_long_revoke_trans_mcsum_32bit/name
index 3d78c07..1aca67d 100644
--- a/tests/j_long_revoke_trans_mcsum_32bit/name
+++ b/tests/j_long_revoke_trans_mcsum_32bit/name
@@ -1 +1 @@
-revoked transaction nuking free space on 32bit,metadata_csum
+revoked trans nuking free space 32bit,mcsum
diff --git a/tests/j_long_revoke_trans_mcsum_64bit/name b/tests/j_long_revoke_trans_mcsum_64bit/name
index 809900b..0fa20fe 100644
--- a/tests/j_long_revoke_trans_mcsum_64bit/name
+++ b/tests/j_long_revoke_trans_mcsum_64bit/name
@@ -1 +1 @@
-revoked transaction nuking free space on 64bit,metadata_csum
+revoke trans nuking free space 64bit,mcsum
diff --git a/tests/j_long_trans_mcsum_32bit/name b/tests/j_long_trans_mcsum_32bit/name
index ac43f51..d4473d9 100644
--- a/tests/j_long_trans_mcsum_32bit/name
+++ b/tests/j_long_trans_mcsum_32bit/name
@@ -1 +1 @@
-transaction nuking free space on 32bit,metadata_csum
+trans nuking free space 32bit,meta_csum
diff --git a/tests/j_long_trans_mcsum_64bit/name b/tests/j_long_trans_mcsum_64bit/name
index 9dab338..e204e79 100644
--- a/tests/j_long_trans_mcsum_64bit/name
+++ b/tests/j_long_trans_mcsum_64bit/name
@@ -1 +1 @@
-transaction nuking free space on 64bit,metadata_csum
+trans nuking free space 64bit,meta_csum
diff --git a/tests/j_short_revoke_trans_mcsum_64bit/name b/tests/j_short_revoke_trans_mcsum_64bit/name
index fb286fd..de05e51 100644
--- a/tests/j_short_revoke_trans_mcsum_64bit/name
+++ b/tests/j_short_revoke_trans_mcsum_64bit/name
@@ -1 +1 @@
-revoke blocks of transaction nuking the bitmaps on 64bit,metadata_csum
+revoke trans nuking bmap 64bit,meta_csum
diff --git a/tests/j_short_trans_mcsum_64bit/name b/tests/j_short_trans_mcsum_64bit/name
index 4751cc2..da839e9 100644
--- a/tests/j_short_trans_mcsum_64bit/name
+++ b/tests/j_short_trans_mcsum_64bit/name
@@ -1 +1 @@
-transaction nuking the bitmaps on 64bit,metadata_csum
+trans nuking bitmaps 64bit,meta_csum
diff --git a/tests/j_short_trans_old_csum/name b/tests/j_short_trans_old_csum/name
index 2e81f94..435e9bc 100644
--- a/tests/j_short_trans_old_csum/name
+++ b/tests/j_short_trans_old_csum/name
@@ -1 +1 @@
-transaction nuking the bitmaps with old journal checksum (v1)
+trans nuking bitmaps v1 journal csum
diff --git a/tests/j_short_trans_open_recover/name b/tests/j_short_trans_open_recover/name
index 892e95c..c6bb568 100644
--- a/tests/j_short_trans_open_recover/name
+++ b/tests/j_short_trans_open_recover/name
@@ -1 +1 @@
-ensure we can't recover the journal with journal open
+don't recover open journal
diff --git a/tests/j_short_trans_recover_mcsum_64bit/name b/tests/j_short_trans_recover_mcsum_64bit/name
index 7ccdcb0..01b4acd 100644
--- a/tests/j_short_trans_recover_mcsum_64bit/name
+++ b/tests/j_short_trans_recover_mcsum_64bit/name
@@ -1 +1 @@
-uncommitted transaction nuking the bitmaps on 64bit,metadata_csum (debugfs recover)
+uncommitted trans nuking bmap 64bit,mcsum
diff --git a/tests/j_short_uncommitted_trans_mcsum_64bit/name b/tests/j_short_uncommitted_trans_mcsum_64bit/name
index 9771f4b..9113950 100644
--- a/tests/j_short_uncommitted_trans_mcsum_64bit/name
+++ b/tests/j_short_uncommitted_trans_mcsum_64bit/name
@@ -1 +1 @@
-uncommitted transaction nuking the bitmaps on 64bit,metadata_csum
+uncommitted trans nuking bmap 64b,mcsum
diff --git a/tests/m_hugefile_slack/name b/tests/m_hugefile_slack/name
index 8d51fd6..fd4e4d0 100644
--- a/tests/m_hugefile_slack/name
+++ b/tests/m_hugefile_slack/name
@@ -1 +1 @@
-mke2fs creating a hugefile fs with a lot of slack
+mke2fs create hugefile fs with slack
diff --git a/tests/r_32to64bit_expand_full/name b/tests/r_32to64bit_expand_full/name
index 2f04601..34b08c7 100644
--- a/tests/r_32to64bit_expand_full/name
+++ b/tests/r_32to64bit_expand_full/name
@@ -1 +1 @@
-convert a totally full filesystem to 64bit, then expand
+convert+expand full fs to 64bit
diff --git a/tests/r_32to64bit_move_itable/name b/tests/r_32to64bit_move_itable/name
index 7e6bb25..7dc2155 100644
--- a/tests/r_32to64bit_move_itable/name
+++ b/tests/r_32to64bit_move_itable/name
@@ -1 +1 @@
-convert 32bit fs to 64bit fs, forcing inode table move
+convert 32 to 64bit w/ itable move
diff --git a/tests/t_change_uuid_mcsum_seed_mounted/script b/tests/t_change_uuid_mcsum_seed_mounted/script
index 05b0bd7..2b437fb 100755
--- a/tests/t_change_uuid_mcsum_seed_mounted/script
+++ b/tests/t_change_uuid_mcsum_seed_mounted/script
@@ -1,4 +1,4 @@
-test_description="change uuid on a metadata-csum with mcsum-seed"
+test_description="change meta-csum uuid with mcsum-seed"
 
 trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
diff --git a/tests/t_disable_changed_csum_seed/script b/tests/t_disable_changed_csum_seed/script
index 9443731..bd48925 100755
--- a/tests/t_disable_changed_csum_seed/script
+++ b/tests/t_disable_changed_csum_seed/script
@@ -1,4 +1,4 @@
-test_description="disable csum seed via tune2fs after changing uuid"
+test_description="tune2fs disable csum seed after uuid change"
 
 trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
diff --git a/tests/t_disable_changed_csum_seed_mounted/script b/tests/t_disable_changed_csum_seed_mounted/script
index 3be6dd9..203253c 100755
--- a/tests/t_disable_changed_csum_seed_mounted/script
+++ b/tests/t_disable_changed_csum_seed_mounted/script
@@ -1,4 +1,4 @@
-test_description="disable csum seed on mounted fs via tune2fs after changing uuid"
+test_description="mounted tune2fs disable csum+uuid"
 
 trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
diff --git a/tests/u_revert_64bitmcsum_onefile/script b/tests/u_revert_64bitmcsum_onefile/script
index f1d7c2b..6249ff2 100644
--- a/tests/u_revert_64bitmcsum_onefile/script
+++ b/tests/u_revert_64bitmcsum_onefile/script
@@ -1,4 +1,4 @@
-test_description="convert fs to 64bit,metadata_csum and revert as one undo file"
+test_description="convert fs to 64bit,mcsum and revert undo file"
 if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
 
 TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
diff --git a/tests/u_revert_all_onefile/script b/tests/u_revert_all_onefile/script
index 27b3b23..6911ec6 100644
--- a/tests/u_revert_all_onefile/script
+++ b/tests/u_revert_all_onefile/script
@@ -1,4 +1,4 @@
-test_description="convert fs to 64bit,metadata_csum and revert as one undo file"
+test_description="convert 64bit,mcsum and revert undo file"
 if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
 
 TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
diff --git a/tests/u_revert_upgrade_to_64bitmcsum/script b/tests/u_revert_upgrade_to_64bitmcsum/script
index 6120d00..6599b05 100644
--- a/tests/u_revert_upgrade_to_64bitmcsum/script
+++ b/tests/u_revert_upgrade_to_64bitmcsum/script
@@ -1,4 +1,4 @@
-test_description="convert fs to 64bit,metadata_csum and revert both changes"
+test_description="convert 64bit,mcsum and revert both"
 if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
 
 TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
-- 
1.8.0
