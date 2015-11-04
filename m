From: Jan Kara <jack@suse.com>
Subject: [PATCH 4/4] ext4/001: Select different output based on mount options
Date: Wed,  4 Nov 2015 17:31:38 +0100
Message-ID: <1446654698-23577-5-git-send-email-jack@suse.com>
References: <1446654698-23577-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1446654698-23577-1-git-send-email-jack@suse.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Depending on mount options, we handle unwritten extents somewhat
differently. So sometimes we end up zeroing out unwritten extent and
converting it to written one and sometimes we just split it. Choose
expected output based on mount options.

Signed-off-by: Jan Kara <jack@suse.com>
---
 tests/ext4/001             |   3 +
 tests/ext4/001.cfg         |   2 +
 tests/ext4/001.out         | 333 ---------------------------------------------
 tests/ext4/001.out.default | 333 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/001.out.nozero  | 333 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 671 insertions(+), 333 deletions(-)
 create mode 100644 tests/ext4/001.cfg
 delete mode 100644 tests/ext4/001.out
 create mode 100644 tests/ext4/001.out.default
 create mode 100644 tests/ext4/001.out.nozero

diff --git a/tests/ext4/001 b/tests/ext4/001
index 5409f488dd54..e3d607784d23 100755
--- a/tests/ext4/001
+++ b/tests/ext4/001
@@ -48,6 +48,9 @@ _supported_os Linux
 _require_xfs_io_command "fzero"
 _require_test
 
+# Select appropriate golden output based on mount options
+_select_output
+
 testfile=$TEST_DIR/001.$$
 
 # Standard zero range tests
diff --git a/tests/ext4/001.cfg b/tests/ext4/001.cfg
new file mode 100644
index 000000000000..1942203f91ea
--- /dev/null
+++ b/tests/ext4/001.cfg
@@ -0,0 +1,2 @@
+dax: nozero
+dioread_nolock: nozero
diff --git a/tests/ext4/001.out b/tests/ext4/001.out
deleted file mode 100644
index c2f728483b23..000000000000
--- a/tests/ext4/001.out
+++ /dev/null
@@ -1,333 +0,0 @@
-QA output created by 001
-	1. into a hole
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	2. into allocated space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	3. into unwritten space
-0: [0..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
-	4. hole -> data
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..31]: data
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
-	5. hole -> unwritten
-0: [0..7]: hole
-1: [8..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: hole
-1b3779878366498b28c702ef88c4a773
-	7. data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
-	8. unwritten -> hole
-0: [0..23]: unwritten
-1: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	9. unwritten -> data
-0: [0..23]: unwritten
-1: [24..31]: data
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
-	10. hole -> data -> hole
-0: [0..7]: hole
-1: [8..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	12. unwritten -> data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-daa100df6e6711906b61c9ab5aa16032
-	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: unwritten
-e1f024eedd27ea6b1c3e9b841c850404
-	15. data -> hole @ 0
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	16. data -> cache cold ->hole
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	17. data -> hole in single block file
-0: [0..7]: data
-0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-0000200 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-	1. into a hole
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	2. into allocated space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	3. into unwritten space
-0: [0..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
-	4. hole -> data
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..31]: data
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
-	5. hole -> unwritten
-0: [0..7]: hole
-1: [8..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: hole
-1b3779878366498b28c702ef88c4a773
-	7. data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
-	8. unwritten -> hole
-0: [0..23]: unwritten
-1: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	9. unwritten -> data
-0: [0..23]: unwritten
-1: [24..31]: data
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
-	10. hole -> data -> hole
-0: [0..7]: hole
-1: [8..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	11. data -> hole -> data
-0: [0..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	12. unwritten -> data -> unwritten
-0: [0..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
-	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: unwritten
-e1f024eedd27ea6b1c3e9b841c850404
-	15. data -> hole @ 0
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	16. data -> cache cold ->hole
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	17. data -> hole in single block file
-0: [0..7]: data
-0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-0000200 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-	1. into a hole
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	2. into allocated space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	3. into unwritten space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	12. unwritten -> data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: unwritten
-e1f024eedd27ea6b1c3e9b841c850404
-	15. data -> hole @ 0
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	16. data -> cache cold ->hole
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	17. data -> hole in single block file
-0: [0..7]: data
-0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-0000200 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-	1. into a hole
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
-	2. into allocated space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	3. into unwritten space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
-	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	12. unwritten -> data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
-	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: unwritten
-e1f024eedd27ea6b1c3e9b841c850404
-	15. data -> hole @ 0
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	16. data -> cache cold ->hole
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
-	17. data -> hole in single block file
-0: [0..7]: data
-0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
-0000200 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-*
diff --git a/tests/ext4/001.out.default b/tests/ext4/001.out.default
new file mode 100644
index 000000000000..c2f728483b23
--- /dev/null
+++ b/tests/ext4/001.out.default
@@ -0,0 +1,333 @@
+QA output created by 001
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..23]: unwritten
+1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..23]: unwritten
+1: [24..31]: data
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+daa100df6e6711906b61c9ab5aa16032
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..23]: unwritten
+1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..23]: unwritten
+1: [24..31]: data
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
diff --git a/tests/ext4/001.out.nozero b/tests/ext4/001.out.nozero
new file mode 100644
index 000000000000..c631034e3ec1
--- /dev/null
+++ b/tests/ext4/001.out.nozero
@@ -0,0 +1,333 @@
+QA output created by 001
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..23]: unwritten
+1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..23]: unwritten
+1: [24..31]: data
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..23]: unwritten
+1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..23]: unwritten
+1: [24..31]: data
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
-- 
2.1.4
