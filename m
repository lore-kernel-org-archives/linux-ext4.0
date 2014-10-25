From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/39] dumpe2fs: 80 column outputs, please
Date: Sat, 25 Oct 2014 13:57:59 -0700
Message-ID: <20141025205759.532.70518.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43944 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaJYU6X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:23 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Try to reduce dumpe2fs output to 80 columns or less.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/dumpe2fs.c                                    |    6 +++++-
 tests/f_jnl_errno/expect.0                         |    3 ++-
 tests/j_short_revoke_trans/script                  |    2 +-
 tests/j_short_revoke_trans_mcsum_64bit/script      |    2 +-
 tests/j_short_trans/script                         |    2 +-
 tests/j_short_trans_64bit/script                   |    2 +-
 tests/j_short_trans_mcsum_64bit/script             |    2 +-
 tests/j_short_trans_old_csum/script                |    2 +-
 tests/j_short_trans_open_recover/script            |    2 +-
 tests/j_short_trans_recover/script                 |    2 +-
 tests/j_short_trans_recover_mcsum_64bit/script     |    2 +-
 tests/j_short_uncommitted_trans/script             |    2 +-
 tests/j_short_uncommitted_trans_mcsum_64bit/script |    2 +-
 tests/m_64bit_flexbg/expect.1                      |    3 ++-
 tests/m_bigjournal/script                          |    3 +++
 tests/m_dasd_bs/expect.1                           |    6 ++++--
 tests/m_desc_size_128/script                       |    3 +++
 tests/m_extent_journal/script                      |    3 +++
 tests/m_large_file/expect.1                        |    3 ++-
 tests/m_meta_bg/script                             |    3 +++
 tests/m_mmp/expect.1                               |    6 ++++--
 tests/m_no_opt/script                              |    3 +++
 tests/m_quota/script                               |    3 +++
 tests/m_raid_opt/script                            |    3 +++
 tests/m_root_owner/expect.1                        |    3 ++-
 tests/m_std/script                                 |    3 +++
 tests/m_uninit/script                              |    3 +++
 tests/r_fixup_lastbg/expect                        |    9 ++++++---
 tests/r_fixup_lastbg_big/expect                    |   10 ++++++----
 tests/r_move_itable/script                         |    8 ++++----
 tests/r_resize_inode/script                        |    6 +++---
 31 files changed, 78 insertions(+), 34 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index e565f2d..f39cb3c 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -264,7 +264,11 @@ static void list_desc(ext2_filsys fs, int grp_only)
 		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 			printf(_(", csum 0x%08x"),
 			       ext2fs_block_bitmap_checksum(fs, i));
-		fputs(_(", Inode bitmap at "), stdout);
+		if (getenv("DUMPE2FS_IGNORE_80COL"))
+			fputs(_(","), stdout);
+		else
+			fputs(_("\n "), stdout);
+		fputs(_(" Inode bitmap at "), stdout);
 		print_number(ext2fs_inode_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
diff --git a/tests/f_jnl_errno/expect.0 b/tests/f_jnl_errno/expect.0
index 6dad72a..2a9426d 100644
--- a/tests/f_jnl_errno/expect.0
+++ b/tests/f_jnl_errno/expect.0
@@ -40,7 +40,8 @@ Journal start:            0
 Group 0: (Blocks 1-8191) [ITABLE_ZEROED]
   Primary superblock at 1, Group descriptors at 2-2
   Reserved GDT blocks at 3-33
-  Block bitmap at 34 (+33), Inode bitmap at 50 (+49)
+  Block bitmap at 34 (+33)
+  Inode bitmap at 50 (+49)
   Inode table at 66-321 (+65)
   6862 free blocks, 2037 free inodes, 2 directories, 2037 unused inodes
   Free blocks: 1330-8191
diff --git a/tests/j_short_revoke_trans/script b/tests/j_short_revoke_trans/script
index edf28f9..4c8a7a9 100644
--- a/tests/j_short_revoke_trans/script
+++ b/tests/j_short_revoke_trans/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
diff --git a/tests/j_short_revoke_trans_mcsum_64bit/script b/tests/j_short_revoke_trans_mcsum_64bit/script
index 8bd6e08..4c735dc 100644
--- a/tests/j_short_revoke_trans_mcsum_64bit/script
+++ b/tests/j_short_revoke_trans_mcsum_64bit/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
diff --git a/tests/j_short_trans/script b/tests/j_short_trans/script
index 00f4d6e..d03a548 100644
--- a/tests/j_short_trans/script
+++ b/tests/j_short_trans/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
diff --git a/tests/j_short_trans_64bit/script b/tests/j_short_trans_64bit/script
index daf0866..cb4af22 100644
--- a/tests/j_short_trans_64bit/script
+++ b/tests/j_short_trans_64bit/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
diff --git a/tests/j_short_trans_mcsum_64bit/script b/tests/j_short_trans_mcsum_64bit/script
index 0534941..eab3c17 100644
--- a/tests/j_short_trans_mcsum_64bit/script
+++ b/tests/j_short_trans_mcsum_64bit/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
diff --git a/tests/j_short_trans_old_csum/script b/tests/j_short_trans_old_csum/script
index b968bc1..8d1d036 100644
--- a/tests/j_short_trans_old_csum/script
+++ b/tests/j_short_trans_old_csum/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
diff --git a/tests/j_short_trans_open_recover/script b/tests/j_short_trans_open_recover/script
index fbbb714..7a7fa73 100644
--- a/tests/j_short_trans_open_recover/script
+++ b/tests/j_short_trans_open_recover/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
diff --git a/tests/j_short_trans_recover/script b/tests/j_short_trans_recover/script
index 7fa6158..9d30f97 100644
--- a/tests/j_short_trans_recover/script
+++ b/tests/j_short_trans_recover/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
diff --git a/tests/j_short_trans_recover_mcsum_64bit/script b/tests/j_short_trans_recover_mcsum_64bit/script
index c283fe2..5b0246e 100644
--- a/tests/j_short_trans_recover_mcsum_64bit/script
+++ b/tests/j_short_trans_recover_mcsum_64bit/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
diff --git a/tests/j_short_uncommitted_trans/script b/tests/j_short_uncommitted_trans/script
index 207d746..583c19d 100644
--- a/tests/j_short_uncommitted_trans/script
+++ b/tests/j_short_uncommitted_trans/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
diff --git a/tests/j_short_uncommitted_trans_mcsum_64bit/script b/tests/j_short_uncommitted_trans_mcsum_64bit/script
index de506be..969372e 100644
--- a/tests/j_short_uncommitted_trans_mcsum_64bit/script
+++ b/tests/j_short_uncommitted_trans_mcsum_64bit/script
@@ -19,7 +19,7 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
 
 $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
diff --git a/tests/m_64bit_flexbg/expect.1 b/tests/m_64bit_flexbg/expect.1
index 3635318..cfa3bc9 100644
--- a/tests/m_64bit_flexbg/expect.1
+++ b/tests/m_64bit_flexbg/expect.1
@@ -48,7 +48,8 @@ Default directory hash:   half_md4
 Group 0: (Blocks 1-1023)
   Primary superblock at 1, Group descriptors at 2-2
   Reserved GDT blocks at 3-9
-  Block bitmap at 10 (+9), Inode bitmap at 26 (+25)
+  Block bitmap at 10 (+9)
+  Inode bitmap at 26 (+25)
   Inode table at 42-57 (+41)
   982 free blocks, 117 free inodes, 2 directories
   Free blocks: 24-25, 28-41, 58-1023
diff --git a/tests/m_bigjournal/script b/tests/m_bigjournal/script
index 4c1ed9a..576d99e 100644
--- a/tests/m_bigjournal/script
+++ b/tests/m_bigjournal/script
@@ -1,8 +1,11 @@
 DESCRIPTION="journal over 4GB in size"
 FS_SIZE=11000000
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 MKE2FS_OPTS="-t ext4 -G 512 -N 1280 -J size=5000 -q -E lazy_journal_init,lazy_itable_init,nodiscard"
 if [ $(uname -s) = "Darwin" ]; then
 	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
 	return 0
 fi
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_dasd_bs/expect.1 b/tests/m_dasd_bs/expect.1
index 75a401d..0e55e8f 100644
--- a/tests/m_dasd_bs/expect.1
+++ b/tests/m_dasd_bs/expect.1
@@ -48,7 +48,8 @@ Default directory hash:   half_md4
 Group 0: (Blocks 0-16383)
   Primary superblock at 0, Group descriptors at 1-1
   Reserved GDT blocks at 2-32
-  Block bitmap at 33 (+33), Inode bitmap at 34 (+34)
+  Block bitmap at 33 (+33)
+  Inode bitmap at 34 (+34)
   Inode table at 35-546 (+35)
   15827 free blocks, 8181 free inodes, 2 directories
   Free blocks: 557-16383
@@ -56,7 +57,8 @@ Group 0: (Blocks 0-16383)
 Group 1: (Blocks 16384-32767)
   Backup superblock at 16384, Group descriptors at 16385-16385
   Reserved GDT blocks at 16386-16416
-  Block bitmap at 16417 (+33), Inode bitmap at 16418 (+34)
+  Block bitmap at 16417 (+33)
+  Inode bitmap at 16418 (+34)
   Inode table at 16419-16930 (+35)
   15837 free blocks, 8192 free inodes, 0 directories
   Free blocks: 16931-32767
diff --git a/tests/m_desc_size_128/script b/tests/m_desc_size_128/script
index de3def9..a4def21 100644
--- a/tests/m_desc_size_128/script
+++ b/tests/m_desc_size_128/script
@@ -1,4 +1,7 @@
 DESCRIPTION="enable 128-byte group descriptor on mkfs"
 FS_SIZE=131072
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 MKE2FS_OPTS="-b 1024 -O 64bit,extents -g 1024 -N 8192 -E desc_size=128"
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_extent_journal/script b/tests/m_extent_journal/script
index 5e0cac2..efade21 100644
--- a/tests/m_extent_journal/script
+++ b/tests/m_extent_journal/script
@@ -1,4 +1,7 @@
 DESCRIPTION="extent-mapped journal"
 FS_SIZE=65536
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 MKE2FS_OPTS="-O extents -j"
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
index 8ab2711..4acca41 100644
--- a/tests/m_large_file/expect.1
+++ b/tests/m_large_file/expect.1
@@ -48,7 +48,8 @@ Default directory hash:   half_md4
 Group 0: (Blocks 0-16383)
   Primary superblock at 0, Group descriptors at 1-1
   Reserved GDT blocks at 2-4
-  Block bitmap at 5 (+5), Inode bitmap at 6 (+6)
+  Block bitmap at 5 (+5)
+  Inode bitmap at 6 (+6)
   Inode table at 7-10 (+7)
   16367 free blocks, 53 free inodes, 2 directories
   Free blocks: 17-16383
diff --git a/tests/m_meta_bg/script b/tests/m_meta_bg/script
index 7ca2bea..5e285b4 100644
--- a/tests/m_meta_bg/script
+++ b/tests/m_meta_bg/script
@@ -1,4 +1,7 @@
 DESCRIPTION="meta blockgroup feature"
 FS_SIZE=131072
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 MKE2FS_OPTS="-O meta_bg,sparse_super,^resize_inode -g 1024"
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_mmp/expect.1 b/tests/m_mmp/expect.1
index aec0a84..a1452e6 100644
--- a/tests/m_mmp/expect.1
+++ b/tests/m_mmp/expect.1
@@ -51,7 +51,8 @@ MMP update interval:      5
 Group 0: (Blocks 0-32767)
   Primary superblock at 0, Group descriptors at 1-1
   Reserved GDT blocks at 2-16
-  Block bitmap at 17 (+17), Inode bitmap at 18 (+18)
+  Block bitmap at 17 (+17)
+  Inode bitmap at 18 (+18)
   Inode table at 19-1042 (+19)
   31718 free blocks, 32757 free inodes, 2 directories
   Free blocks: 1050-32767
@@ -59,7 +60,8 @@ Group 0: (Blocks 0-32767)
 Group 1: (Blocks 32768-65535)
   Backup superblock at 32768, Group descriptors at 32769-32769
   Reserved GDT blocks at 32770-32784
-  Block bitmap at 32785 (+17), Inode bitmap at 32786 (+18)
+  Block bitmap at 32785 (+17)
+  Inode bitmap at 32786 (+18)
   Inode table at 32787-33810 (+19)
   31725 free blocks, 32768 free inodes, 0 directories
   Free blocks: 33811-65535
diff --git a/tests/m_no_opt/script b/tests/m_no_opt/script
index 6d1d0eb..223f117 100644
--- a/tests/m_no_opt/script
+++ b/tests/m_no_opt/script
@@ -1,4 +1,7 @@
 DESCRIPTION="no filesystem extensions"
 FS_SIZE=65536
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 MKE2FS_OPTS="-O ^sparse_super,^filetype,^resize_inode,^dir_index,^ext_attr"
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_quota/script b/tests/m_quota/script
index 36ab630..fe63939 100644
--- a/tests/m_quota/script
+++ b/tests/m_quota/script
@@ -5,4 +5,7 @@ if [ "$QUOTA" != "y" ]; then
 	echo "$test_name: $DESCRIPTION: skipped"
 	return 0
 fi
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_raid_opt/script b/tests/m_raid_opt/script
index 296fe94..8c859e0 100644
--- a/tests/m_raid_opt/script
+++ b/tests/m_raid_opt/script
@@ -1,4 +1,7 @@
 DESCRIPTION="raid options"
 FS_SIZE=131072
 MKE2FS_OPTS="-E stride=13 -O sparse_super -g 1024"
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_root_owner/expect.1 b/tests/m_root_owner/expect.1
index cd94993..30d119e 100644
--- a/tests/m_root_owner/expect.1
+++ b/tests/m_root_owner/expect.1
@@ -46,7 +46,8 @@ Default directory hash:   half_md4
 Group 0: (Blocks 1-1023)
   Primary superblock at 1, Group descriptors at 2-2
   Reserved GDT blocks at 3-5
-  Block bitmap at 6 (+5), Inode bitmap at 7 (+6)
+  Block bitmap at 6 (+5)
+  Inode bitmap at 7 (+6)
   Inode table at 8-23 (+7)
   986 free blocks, 117 free inodes, 2 directories
   Free blocks: 38-1023
diff --git a/tests/m_std/script b/tests/m_std/script
index a2f2cda..61c50c7 100644
--- a/tests/m_std/script
+++ b/tests/m_std/script
@@ -1,3 +1,6 @@
 DESCRIPTION="standard filesystem options"
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 FS_SIZE=65536
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/m_uninit/script b/tests/m_uninit/script
index 0b565ac..d4d373a 100644
--- a/tests/m_uninit/script
+++ b/tests/m_uninit/script
@@ -1,4 +1,7 @@
 DESCRIPTION="uninitialized group feature"
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
 FS_SIZE=131072
 MKE2FS_OPTS="-O uninit_bg"
 . $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/r_fixup_lastbg/expect b/tests/r_fixup_lastbg/expect
index f9945b3..96b154a 100644
--- a/tests/r_fixup_lastbg/expect
+++ b/tests/r_fixup_lastbg/expect
@@ -8,13 +8,15 @@ Creating journal (1024 blocks): done
 Writing superblocks and filesystem accounting information:    done
 
 Group 2: (Blocks 16385-19999) [INODE_UNINIT, ITABLE_ZEROED]
-  Block bitmap at 83 (bg #0 + 82), Inode bitmap at 86 (bg #0 + 85)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
   Inode table at 295-398 (bg #0 + 294)
   3615 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-19999
   Free inodes: 833-1248
 Group 2: (Blocks 16385-19999)
-  Block bitmap at 83 (bg #0 + 82), Inode bitmap at 86 (bg #0 + 85)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
   Inode table at 295-398 (bg #0 + 294)
   3615 free blocks, 416 free inodes, 0 directories
   Free blocks: 16385-19999
@@ -23,7 +25,8 @@ Resizing the filesystem on test.img to 20004 (1k) blocks.
 The filesystem on test.img is now 20004 (1k) blocks long.
 
 Group 2: (Blocks 16385-20003) [INODE_UNINIT]
-  Block bitmap at 83 (bg #0 + 82), Inode bitmap at 86 (bg #0 + 85)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
   Inode table at 295-398 (bg #0 + 294)
   3619 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-20003
diff --git a/tests/r_fixup_lastbg_big/expect b/tests/r_fixup_lastbg_big/expect
index 1aa36fc..badf6cf 100644
--- a/tests/r_fixup_lastbg_big/expect
+++ b/tests/r_fixup_lastbg_big/expect
@@ -8,13 +8,15 @@ Creating journal (1024 blocks): done
 Writing superblocks and filesystem accounting information:    done
 
 Group 2: (Blocks 16385-19999) [INODE_UNINIT, ITABLE_ZEROED]
-  Block bitmap at 83 (bg #0 + 82), Inode bitmap at 86 (bg #0 + 85)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
   Inode table at 295-398 (bg #0 + 294)
   3615 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-19999
   Free inodes: 833-1248
 Group 2: (Blocks 16385-19999)
-  Block bitmap at 83 (bg #0 + 82), Inode bitmap at 86 (bg #0 + 85)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
   Inode table at 295-398 (bg #0 + 294)
   3615 free blocks, 416 free inodes, 0 directories
   Free blocks: 16385-19999
@@ -23,14 +25,14 @@ Resizing the filesystem on test.img to 40000 (1k) blocks.
 The filesystem on test.img is now 40000 (1k) blocks long.
 
 Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 83 (bg #0 + 82), Inode bitmap at 86 (bg #0 + 85)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
   Inode table at 295-398 (bg #0 + 294)
   8192 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-24576
   Free inodes: 833-1248
 Group 3: (Blocks 24577-32768) [INODE_UNINIT]
   Backup superblock at 24577, Group descriptors at 24578-24578
-  Reserved GDT blocks at 24579-24656
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
diff --git a/tests/r_move_itable/script b/tests/r_move_itable/script
index e567888..3f02a79 100644
--- a/tests/r_move_itable/script
+++ b/tests/r_move_itable/script
@@ -33,7 +33,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 echo "--------------------------------" >> $OUT
 
@@ -53,7 +53,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 echo "--------------------------------" >> $OUT
 
@@ -73,7 +73,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 echo "--------------------------------" >> $OUT
 
@@ -93,7 +93,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 rm -f $TMPFILE
 
diff --git a/tests/r_resize_inode/script b/tests/r_resize_inode/script
index 0f12138..4e3eb19 100644
--- a/tests/r_resize_inode/script
+++ b/tests/r_resize_inode/script
@@ -33,7 +33,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 echo "--------------------------------" >> $OUT
 
@@ -59,7 +59,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 echo "--------------------------------" >> $OUT
 
@@ -79,7 +79,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
 
 rm -f $TMPFILE
 cmp -s $OUT $EXP

