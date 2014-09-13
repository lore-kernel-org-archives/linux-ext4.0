From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 27/34] debugfs: implement fallocate
Date: Sat, 13 Sep 2014 15:14:14 -0700
Message-ID: <20140913221414.13646.6622.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32530 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaIMWOV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:14:21 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement a fallocate function for debugfs, and add some tests to
demonstrate that it works (more or less).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debug_cmds.ct             |    3 
 debugfs/debugfs.c                 |   36 +++
 debugfs/debugfs.h                 |    1 
 tests/f_fallocate/expect          |  423 +++++++++++++++++++++++++++++++++++++
 tests/f_fallocate/name            |    1 
 tests/f_fallocate/script          |  175 +++++++++++++++
 tests/f_fallocate_bigalloc/expect |  364 ++++++++++++++++++++++++++++++++
 tests/f_fallocate_bigalloc/name   |    1 
 tests/f_fallocate_bigalloc/script |  176 +++++++++++++++
 tests/f_fallocate_blkmap/expect   |   58 +++++
 tests/f_fallocate_blkmap/name     |    1 
 tests/f_fallocate_blkmap/script   |   85 +++++++
 12 files changed, 1324 insertions(+)
 create mode 100644 tests/f_fallocate/expect
 create mode 100644 tests/f_fallocate/name
 create mode 100644 tests/f_fallocate/script
 create mode 100644 tests/f_fallocate_bigalloc/expect
 create mode 100644 tests/f_fallocate_bigalloc/name
 create mode 100644 tests/f_fallocate_bigalloc/script
 create mode 100644 tests/f_fallocate_blkmap/expect
 create mode 100644 tests/f_fallocate_blkmap/name
 create mode 100644 tests/f_fallocate_blkmap/script


diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index c6f6d6c..34dad9e 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -157,6 +157,9 @@ request do_dirsearch, "Search a directory for a particular filename",
 request do_bmap, "Calculate the logical->physical block mapping for an inode",
 	bmap;
 
+request do_fallocate, "Allocate uninitialized blocks to an inode",
+	fallocate;
+
 request do_punch, "Punch (or truncate) blocks from an inode by deallocating them",
 	punch, truncate;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index db85028..b30a5ab 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2073,6 +2073,42 @@ void do_punch(int argc, char *argv[])
 		return;
 	}
 }
+
+void do_fallocate(int argc, char *argv[])
+{
+	ext2_ino_t	ino;
+	blk64_t		start, end;
+	int		err;
+	errcode_t	errcode;
+
+	if (common_args_process(argc, argv, 3, 4, argv[0],
+				"<file> start_blk [end_blk]",
+				CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+	err = strtoblk(argv[0], argv[2], "logical block", &start);
+	if (err)
+		return;
+	if (argc == 4) {
+		err = strtoblk(argv[0], argv[3], "logical block", &end);
+		if (err)
+			return;
+	} else
+		end = ~0;
+
+	errcode = ext2fs_fallocate(current_fs, EXT2_FALLOCATE_INIT_BEYOND_EOF,
+				   ino, NULL, ~0ULL, start, end - start + 1);
+
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while fallocating inode %u from %llu to %llu\n", ino,
+			(unsigned long long) start, (unsigned long long) end);
+		return;
+	}
+}
 #endif /* READ_ONLY */
 
 void do_symlink(int argc, char *argv[])
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index e163d0a..76bb22c 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -166,6 +166,7 @@ extern void do_imap(int argc, char **argv);
 extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
 extern void do_punch(int argc, char **argv);
+extern void do_fallocate(int argc, char **argv);
 extern void do_symlink(int argc, char **argv);
 
 extern void do_dump_mmp(int argc, char **argv);
diff --git a/tests/f_fallocate/expect b/tests/f_fallocate/expect
new file mode 100644
index 0000000..e5aeb49
--- /dev/null
+++ b/tests/f_fallocate/expect
@@ -0,0 +1,423 @@
+Creating filesystem with 65536 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/4096 files (0.0% non-contiguous), 2345/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  1     0 -    39  1313 -  1352     40 Uninit
+debugfs: ex /sample
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10  5010 -  5010      1 Uninit
+ 0/ 0   2/  4    13 -    13  5013 -  5013      1 Uninit
+ 0/ 0   3/  4    26 -    26  5026 -  5026      1 Uninit
+ 0/ 0   4/  4    29 -    29  5029 -  5029      1 Uninit
+debugfs: ex /b8
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     8 -    12 10008 - 10012      5 Uninit
+ 0/ 0   2/  4    13 -    25 10013 - 10025     13 Uninit
+ 0/ 0   3/  4    26 -    28 10026 - 10028      3 Uninit
+ 0/ 0   4/  4    29 -    39 10029 - 10039     11 Uninit
+debugfs: ex /b9
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     9 -    12 10049 - 10052      4 Uninit
+ 0/ 0   2/  4    13 -    25 10053 - 10065     13 Uninit
+ 0/ 0   3/  4    26 -    28 10066 - 10068      3 Uninit
+ 0/ 0   4/  4    29 -    39 10069 - 10079     11 Uninit
+debugfs: ex /b10
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    12 10090 - 10092      3 Uninit
+ 0/ 0   2/  4    13 -    25 10093 - 10105     13 Uninit
+ 0/ 0   3/  4    26 -    28 10106 - 10108      3 Uninit
+ 0/ 0   4/  4    29 -    39 10109 - 10119     11 Uninit
+debugfs: ex /b11
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    12 10130 - 10132      3 Uninit
+ 0/ 0   2/  4    13 -    25 10133 - 10145     13 Uninit
+ 0/ 0   3/  4    26 -    28 10146 - 10148      3 Uninit
+ 0/ 0   4/  4    29 -    39 10149 - 10159     11 Uninit
+debugfs: ex /b12
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10170 - 10170      1 Uninit
+ 0/ 0   2/  4    12 -    25 10172 - 10185     14 Uninit
+ 0/ 0   3/  4    26 -    28 10186 - 10188      3 Uninit
+ 0/ 0   4/  4    29 -    39 10189 - 10199     11 Uninit
+debugfs: ex /b13
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10210 - 10210      1 Uninit
+ 0/ 0   2/  4    13 -    25 10213 - 10225     13 Uninit
+ 0/ 0   3/  4    26 -    28 10226 - 10228      3 Uninit
+ 0/ 0   4/  4    29 -    39 10229 - 10239     11 Uninit
+debugfs: ex /b14
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10250 - 10250      1 Uninit
+ 0/ 0   2/  4    13 -    25 10253 - 10265     13 Uninit
+ 0/ 0   3/  4    26 -    28 10266 - 10268      3 Uninit
+ 0/ 0   4/  4    29 -    39 10269 - 10279     11 Uninit
+debugfs: ex /b15
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10290 - 10290      1 Uninit
+ 0/ 0   2/  4    13 -    13 10293 - 10293      1 Uninit
+ 0/ 0   3/  4    15 -    28 10295 - 10308     14 Uninit
+ 0/ 0   4/  4    29 -    39 10309 - 10319     11 Uninit
+debugfs: ex /c24
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10320 - 10332     13 Uninit
+ 0/ 0   2/  4    13 -    24 10333 - 10344     12 Uninit
+ 0/ 0   3/  4    26 -    26 10346 - 10346      1 Uninit
+ 0/ 0   4/  4    29 -    29 10349 - 10349      1 Uninit
+debugfs: ex /c25
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10360 - 10372     13 Uninit
+ 0/ 0   2/  4    13 -    25 10373 - 10385     13 Uninit
+ 0/ 0   3/  4    26 -    26 10386 - 10386      1 Uninit
+ 0/ 0   4/  4    29 -    29 10389 - 10389      1 Uninit
+debugfs: ex /c26
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10400 - 10412     13 Uninit
+ 0/ 0   2/  4    13 -    25 10413 - 10425     13 Uninit
+ 0/ 0   3/  4    26 -    26 10426 - 10426      1 Uninit
+ 0/ 0   4/  4    29 -    29 10429 - 10429      1 Uninit
+debugfs: ex /c27
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10440 - 10452     13 Uninit
+ 0/ 0   2/  4    13 -    25 10453 - 10465     13 Uninit
+ 0/ 0   3/  4    26 -    27 10466 - 10467      2 Uninit
+ 0/ 0   4/  4    29 -    29 10469 - 10469      1 Uninit
+debugfs: ex /c28
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10480 - 10492     13 Uninit
+ 0/ 0   2/  4    13 -    25 10493 - 10505     13 Uninit
+ 0/ 0   3/  4    26 -    28 10506 - 10508      3 Uninit
+ 0/ 0   4/  4    29 -    29 10509 - 10509      1 Uninit
+debugfs: ex /c29
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10520 - 10532     13 Uninit
+ 0/ 0   2/  4    13 -    25 10533 - 10545     13 Uninit
+ 0/ 0   3/  4    26 -    28 10546 - 10548      3 Uninit
+ 0/ 0   4/  4    29 -    29 10549 - 10549      1 Uninit
+debugfs: ex /c30
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10560 - 10572     13 Uninit
+ 0/ 0   2/  4    13 -    25 10573 - 10585     13 Uninit
+ 0/ 0   3/  4    26 -    28 10586 - 10588      3 Uninit
+ 0/ 0   4/  4    29 -    30 10589 - 10590      2 Uninit
+debugfs: ex /c31
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10600 - 10612     13 Uninit
+ 0/ 0   2/  4    13 -    25 10613 - 10625     13 Uninit
+ 0/ 0   3/  4    26 -    28 10626 - 10628      3 Uninit
+ 0/ 0   4/  4    29 -    31 10629 - 10631      3 Uninit
+debugfs: ex /d
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     4 -    12 10644 - 10652      9 Uninit
+ 0/ 0   2/  4    13 -    25 10653 - 10665     13 Uninit
+ 0/ 0   3/  4    26 -    28 10666 - 10668      3 Uninit
+ 0/ 0   4/  4    29 -    35 10669 - 10675      7 Uninit
+debugfs: ex /e
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1353             30
+ 1/ 1   1/  5    10 -    10 10690 - 10690      1 Uninit
+ 1/ 1   2/  5    13 -    13 10693 - 10693      1 Uninit
+ 1/ 1   3/  5    19 -    20 10699 - 10700      2 Uninit
+ 1/ 1   4/  5    26 -    26 10706 - 10706      1 Uninit
+ 1/ 1   5/  5    29 -    29 10709 - 10709      1 Uninit
+debugfs: ex /f
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -     0  1354              1
+ 1/ 1   1/ 33     0 -     0  9000 -  9000      1 Uninit
+ 1/ 1   2/ 33     1 -  1007  9001 - 10007   1007 Uninit
+ 1/ 1   3/ 33  1008 -  1016 10040 - 10048      9 Uninit
+ 1/ 1   4/ 33  1017 -  1026 10080 - 10089     10 Uninit
+ 1/ 1   5/ 33  1027 -  1036 10120 - 10129     10 Uninit
+ 1/ 1   6/ 33  1037 -  1046 10160 - 10169     10 Uninit
+ 1/ 1   7/ 33  1047 -  1047 10171 - 10171      1 Uninit
+ 1/ 1   8/ 33  1048 -  1057 10200 - 10209     10 Uninit
+ 1/ 1   9/ 33  1058 -  1059 10211 - 10212      2 Uninit
+ 1/ 1  10/ 33  1060 -  1069 10240 - 10249     10 Uninit
+ 1/ 1  11/ 33  1070 -  1071 10251 - 10252      2 Uninit
+ 1/ 1  12/ 33  1072 -  1081 10280 - 10289     10 Uninit
+ 1/ 1  13/ 33  1082 -  1083 10291 - 10292      2 Uninit
+ 1/ 1  14/ 33  1084 -  1084 10294 - 10294      1 Uninit
+ 1/ 1  15/ 33  1085 -  1085 10345 - 10345      1 Uninit
+ 1/ 1  16/ 33  1086 -  1087 10347 - 10348      2 Uninit
+ 1/ 1  17/ 33  1088 -  1097 10350 - 10359     10 Uninit
+ 1/ 1  18/ 33  1098 -  1099 10387 - 10388      2 Uninit
+ 1/ 1  19/ 33  1100 -  1109 10390 - 10399     10 Uninit
+ 1/ 1  20/ 33  1110 -  1111 10427 - 10428      2 Uninit
+ 1/ 1  21/ 33  1112 -  1121 10430 - 10439     10 Uninit
+ 1/ 1  22/ 33  1122 -  1122 10468 - 10468      1 Uninit
+ 1/ 1  23/ 33  1123 -  1132 10470 - 10479     10 Uninit
+ 1/ 1  24/ 33  1133 -  1142 10510 - 10519     10 Uninit
+ 1/ 1  25/ 33  1143 -  1152 10550 - 10559     10 Uninit
+ 1/ 1  26/ 33  1153 -  1161 10591 - 10599      9 Uninit
+ 1/ 1  27/ 33  1162 -  1173 10632 - 10643     12 Uninit
+ 1/ 1  28/ 33  1174 -  1187 10676 - 10689     14 Uninit
+ 1/ 1  29/ 33  1188 -  1189 10691 - 10692      2 Uninit
+ 1/ 1  30/ 33  1190 -  1194 10694 - 10698      5 Uninit
+ 1/ 1  31/ 33  1195 -  1199 10701 - 10705      5 Uninit
+ 1/ 1  32/ 33  1200 -  1201 10707 - 10708      2 Uninit
+ 1/ 1  33/ 33  1202 -  8999 10710 - 18507   7798 Uninit
+debugfs: ex /g8
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     8 -    39  1355             32
+ 1/ 1   1/  9     8 -     9 20008 - 20009      2 Uninit
+ 1/ 1   2/  9    10 -    10 20010 - 20010      1 
+ 1/ 1   3/  9    11 -    12 20011 - 20012      2 Uninit
+ 1/ 1   4/  9    13 -    13 20013 - 20013      1 
+ 1/ 1   5/  9    14 -    25 20014 - 20025     12 Uninit
+ 1/ 1   6/  9    26 -    26 20026 - 20026      1 
+ 1/ 1   7/  9    27 -    28 20027 - 20028      2 Uninit
+ 1/ 1   8/  9    29 -    29 20029 - 20029      1 
+ 1/ 1   9/  9    30 -    39 20030 - 20039     10 Uninit
+debugfs: ex /g9
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     9 -    39  1356             31
+ 1/ 1   1/  9     9 -     9 20049 - 20049      1 Uninit
+ 1/ 1   2/  9    10 -    10 20050 - 20050      1 
+ 1/ 1   3/  9    11 -    12 20051 - 20052      2 Uninit
+ 1/ 1   4/  9    13 -    13 20053 - 20053      1 
+ 1/ 1   5/  9    14 -    25 20054 - 20065     12 Uninit
+ 1/ 1   6/  9    26 -    26 20066 - 20066      1 
+ 1/ 1   7/  9    27 -    28 20067 - 20068      2 Uninit
+ 1/ 1   8/  9    29 -    29 20069 - 20069      1 
+ 1/ 1   9/  9    30 -    39 20070 - 20079     10 Uninit
+debugfs: ex /g10
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1357             30
+ 1/ 1   1/  8    10 -    10 20090 - 20090      1 
+ 1/ 1   2/  8    11 -    12 20091 - 20092      2 Uninit
+ 1/ 1   3/  8    13 -    13 20093 - 20093      1 
+ 1/ 1   4/  8    14 -    25 20094 - 20105     12 Uninit
+ 1/ 1   5/  8    26 -    26 20106 - 20106      1 
+ 1/ 1   6/  8    27 -    28 20107 - 20108      2 Uninit
+ 1/ 1   7/  8    29 -    29 20109 - 20109      1 
+ 1/ 1   8/  8    30 -    39 20110 - 20119     10 Uninit
+debugfs: ex /g11
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1358             30
+ 1/ 1   1/  8    10 -    10 20130 - 20130      1 
+ 1/ 1   2/  8    11 -    12 20131 - 20132      2 Uninit
+ 1/ 1   3/  8    13 -    13 20133 - 20133      1 
+ 1/ 1   4/  8    14 -    25 20134 - 20145     12 Uninit
+ 1/ 1   5/  8    26 -    26 20146 - 20146      1 
+ 1/ 1   6/  8    27 -    28 20147 - 20148      2 Uninit
+ 1/ 1   7/  8    29 -    29 20149 - 20149      1 
+ 1/ 1   8/  8    30 -    39 20150 - 20159     10 Uninit
+debugfs: ex /g12
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1359             30
+ 1/ 1   1/  8    10 -    10 20170 - 20170      1 
+ 1/ 1   2/  8    12 -    12 20172 - 20172      1 Uninit
+ 1/ 1   3/  8    13 -    13 20173 - 20173      1 
+ 1/ 1   4/  8    14 -    25 20174 - 20185     12 Uninit
+ 1/ 1   5/  8    26 -    26 20186 - 20186      1 
+ 1/ 1   6/  8    27 -    28 20187 - 20188      2 Uninit
+ 1/ 1   7/  8    29 -    29 20189 - 20189      1 
+ 1/ 1   8/  8    30 -    39 20190 - 20199     10 Uninit
+debugfs: ex /g13
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1360             30
+ 1/ 1   1/  7    10 -    10 20210 - 20210      1 
+ 1/ 1   2/  7    13 -    13 20213 - 20213      1 
+ 1/ 1   3/  7    14 -    25 20214 - 20225     12 Uninit
+ 1/ 1   4/  7    26 -    26 20226 - 20226      1 
+ 1/ 1   5/  7    27 -    28 20227 - 20228      2 Uninit
+ 1/ 1   6/  7    29 -    29 20229 - 20229      1 
+ 1/ 1   7/  7    30 -    39 20230 - 20239     10 Uninit
+debugfs: ex /g14
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1361             30
+ 1/ 1   1/  7    10 -    10 20250 - 20250      1 
+ 1/ 1   2/  7    13 -    13 20253 - 20253      1 
+ 1/ 1   3/  7    14 -    25 20254 - 20265     12 Uninit
+ 1/ 1   4/  7    26 -    26 20266 - 20266      1 
+ 1/ 1   5/  7    27 -    28 20267 - 20268      2 Uninit
+ 1/ 1   6/  7    29 -    29 20269 - 20269      1 
+ 1/ 1   7/  7    30 -    39 20270 - 20279     10 Uninit
+debugfs: ex /g15
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1362             30
+ 1/ 1   1/  7    10 -    10 20290 - 20290      1 
+ 1/ 1   2/  7    13 -    13 20293 - 20293      1 
+ 1/ 1   3/  7    15 -    25 20295 - 20305     11 Uninit
+ 1/ 1   4/  7    26 -    26 20306 - 20306      1 
+ 1/ 1   5/  7    27 -    28 20307 - 20308      2 Uninit
+ 1/ 1   6/  7    29 -    29 20309 - 20309      1 
+ 1/ 1   7/  7    30 -    39 20310 - 20319     10 Uninit
+debugfs: ex /h24
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1363             40
+ 1/ 1   1/  7     0 -     9 20320 - 20329     10 Uninit
+ 1/ 1   2/  7    10 -    10 20330 - 20330      1 
+ 1/ 1   3/  7    11 -    12 20331 - 20332      2 Uninit
+ 1/ 1   4/  7    13 -    13 20333 - 20333      1 
+ 1/ 1   5/  7    14 -    24 20334 - 20344     11 Uninit
+ 1/ 1   6/  7    26 -    26 20346 - 20346      1 
+ 1/ 1   7/  7    29 -    29 20349 - 20349      1 
+debugfs: ex /h25
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1364             40
+ 1/ 1   1/  7     0 -     9 20360 - 20369     10 Uninit
+ 1/ 1   2/  7    10 -    10 20370 - 20370      1 
+ 1/ 1   3/  7    11 -    12 20371 - 20372      2 Uninit
+ 1/ 1   4/  7    13 -    13 20373 - 20373      1 
+ 1/ 1   5/  7    14 -    25 20374 - 20385     12 Uninit
+ 1/ 1   6/  7    26 -    26 20386 - 20386      1 
+ 1/ 1   7/  7    29 -    29 20389 - 20389      1 
+debugfs: ex /h26
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1365             40
+ 1/ 1   1/  7     0 -     9 20400 - 20409     10 Uninit
+ 1/ 1   2/  7    10 -    10 20410 - 20410      1 
+ 1/ 1   3/  7    11 -    12 20411 - 20412      2 Uninit
+ 1/ 1   4/  7    13 -    13 20413 - 20413      1 
+ 1/ 1   5/  7    14 -    25 20414 - 20425     12 Uninit
+ 1/ 1   6/  7    26 -    26 20426 - 20426      1 
+ 1/ 1   7/  7    29 -    29 20429 - 20429      1 
+debugfs: ex /h27
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1366             40
+ 1/ 1   1/  8     0 -     9 20440 - 20449     10 Uninit
+ 1/ 1   2/  8    10 -    10 20450 - 20450      1 
+ 1/ 1   3/  8    11 -    12 20451 - 20452      2 Uninit
+ 1/ 1   4/  8    13 -    13 20453 - 20453      1 
+ 1/ 1   5/  8    14 -    25 20454 - 20465     12 Uninit
+ 1/ 1   6/  8    26 -    26 20466 - 20466      1 
+ 1/ 1   7/  8    27 -    27 20467 - 20467      1 Uninit
+ 1/ 1   8/  8    29 -    29 20469 - 20469      1 
+debugfs: ex /h28
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1367             40
+ 1/ 1   1/  8     0 -     9 20480 - 20489     10 Uninit
+ 1/ 1   2/  8    10 -    10 20490 - 20490      1 
+ 1/ 1   3/  8    11 -    12 20491 - 20492      2 Uninit
+ 1/ 1   4/  8    13 -    13 20493 - 20493      1 
+ 1/ 1   5/  8    14 -    25 20494 - 20505     12 Uninit
+ 1/ 1   6/  8    26 -    26 20506 - 20506      1 
+ 1/ 1   7/  8    27 -    28 20507 - 20508      2 Uninit
+ 1/ 1   8/  8    29 -    29 20509 - 20509      1 
+debugfs: ex /h29
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1368             40
+ 1/ 1   1/  8     0 -     9 20520 - 20529     10 Uninit
+ 1/ 1   2/  8    10 -    10 20530 - 20530      1 
+ 1/ 1   3/  8    11 -    12 20531 - 20532      2 Uninit
+ 1/ 1   4/  8    13 -    13 20533 - 20533      1 
+ 1/ 1   5/  8    14 -    25 20534 - 20545     12 Uninit
+ 1/ 1   6/  8    26 -    26 20546 - 20546      1 
+ 1/ 1   7/  8    27 -    28 20547 - 20548      2 Uninit
+ 1/ 1   8/  8    29 -    29 20549 - 20549      1 
+debugfs: ex /h30
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1369             40
+ 1/ 1   1/  9     0 -     9 20560 - 20569     10 Uninit
+ 1/ 1   2/  9    10 -    10 20570 - 20570      1 
+ 1/ 1   3/  9    11 -    12 20571 - 20572      2 Uninit
+ 1/ 1   4/  9    13 -    13 20573 - 20573      1 
+ 1/ 1   5/  9    14 -    25 20574 - 20585     12 Uninit
+ 1/ 1   6/  9    26 -    26 20586 - 20586      1 
+ 1/ 1   7/  9    27 -    28 20587 - 20588      2 Uninit
+ 1/ 1   8/  9    29 -    29 20589 - 20589      1 
+ 1/ 1   9/  9    30 -    30 20590 - 20590      1 Uninit
+debugfs: ex /h31
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1370             40
+ 1/ 1   1/  9     0 -     9 20600 - 20609     10 Uninit
+ 1/ 1   2/  9    10 -    10 20610 - 20610      1 
+ 1/ 1   3/  9    11 -    12 20611 - 20612      2 Uninit
+ 1/ 1   4/  9    13 -    13 20613 - 20613      1 
+ 1/ 1   5/  9    14 -    25 20614 - 20625     12 Uninit
+ 1/ 1   6/  9    26 -    26 20626 - 20626      1 
+ 1/ 1   7/  9    27 -    28 20627 - 20628      2 Uninit
+ 1/ 1   8/  9    29 -    29 20629 - 20629      1 
+ 1/ 1   9/  9    30 -    31 20630 - 20631      2 Uninit
+debugfs: ex /i
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     4 -    39  1371             36
+ 1/ 1   1/  9     4 -     9 20644 - 20649      6 Uninit
+ 1/ 1   2/  9    10 -    10 20650 - 20650      1 
+ 1/ 1   3/  9    11 -    12 20651 - 20652      2 Uninit
+ 1/ 1   4/  9    13 -    13 20653 - 20653      1 
+ 1/ 1   5/  9    14 -    25 20654 - 20665     12 Uninit
+ 1/ 1   6/  9    26 -    26 20666 - 20666      1 
+ 1/ 1   7/  9    27 -    28 20667 - 20668      2 Uninit
+ 1/ 1   8/  9    29 -    29 20669 - 20669      1 
+ 1/ 1   9/  9    30 -    35 20670 - 20675      6 Uninit
+debugfs: ex /j
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1372             30
+ 1/ 1   1/  5    10 -    10 20690 - 20690      1 
+ 1/ 1   2/  5    13 -    13 20693 - 20693      1 
+ 1/ 1   3/  5    19 -    20 20699 - 20700      2 Uninit
+ 1/ 1   4/  5    26 -    26 20706 - 20706      1 
+ 1/ 1   5/  5    29 -    29 20709 - 20709      1 
+debugfs: ex /k
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -  8999  1373           9000
+ 1/ 1   1/ 34     0 -     0 19000 - 19000      1 
+ 1/ 1   2/ 34     1 -  1007 19001 - 20007   1007 Uninit
+ 1/ 1   3/ 34  1008 -  1016 20040 - 20048      9 Uninit
+ 1/ 1   4/ 34  1017 -  1026 20080 - 20089     10 Uninit
+ 1/ 1   5/ 34  1027 -  1036 20120 - 20129     10 Uninit
+ 1/ 1   6/ 34  1037 -  1046 20160 - 20169     10 Uninit
+ 1/ 1   7/ 34  1047 -  1047 20171 - 20171      1 Uninit
+ 1/ 1   8/ 34  1048 -  1057 20200 - 20209     10 Uninit
+ 1/ 1   9/ 34  1058 -  1059 20211 - 20212      2 Uninit
+ 1/ 1  10/ 34  1060 -  1069 20240 - 20249     10 Uninit
+ 1/ 1  11/ 34  1070 -  1071 20251 - 20252      2 Uninit
+ 1/ 1  12/ 34  1072 -  1081 20280 - 20289     10 Uninit
+ 1/ 1  13/ 34  1082 -  1083 20291 - 20292      2 Uninit
+ 1/ 1  14/ 34  1084 -  1084 20294 - 20294      1 Uninit
+ 1/ 1  15/ 34  1085 -  1085 20345 - 20345      1 Uninit
+ 1/ 1  16/ 34  1086 -  1087 20347 - 20348      2 Uninit
+ 1/ 1  17/ 34  1088 -  1097 20350 - 20359     10 Uninit
+ 1/ 1  18/ 34  1098 -  1099 20387 - 20388      2 Uninit
+ 1/ 1  19/ 34  1100 -  1109 20390 - 20399     10 Uninit
+ 1/ 1  20/ 34  1110 -  1111 20427 - 20428      2 Uninit
+ 1/ 1  21/ 34  1112 -  1121 20430 - 20439     10 Uninit
+ 1/ 1  22/ 34  1122 -  1122 20468 - 20468      1 Uninit
+ 1/ 1  23/ 34  1123 -  1132 20470 - 20479     10 Uninit
+ 1/ 1  24/ 34  1133 -  1142 20510 - 20519     10 Uninit
+ 1/ 1  25/ 34  1143 -  1152 20550 - 20559     10 Uninit
+ 1/ 1  26/ 34  1153 -  1161 20591 - 20599      9 Uninit
+ 1/ 1  27/ 34  1162 -  1173 20632 - 20643     12 Uninit
+ 1/ 1  28/ 34  1174 -  1187 20676 - 20689     14 Uninit
+ 1/ 1  29/ 34  1188 -  1189 20691 - 20692      2 Uninit
+ 1/ 1  30/ 34  1190 -  1194 20694 - 20698      5 Uninit
+ 1/ 1  31/ 34  1195 -  1199 20701 - 20705      5 Uninit
+ 1/ 1  32/ 34  1200 -  1201 20707 - 20708      2 Uninit
+ 1/ 1  33/ 34  1202 -  5068 20710 - 24576   3867 Uninit
+ 1/ 1  34/ 34  5069 -  8999 24835 - 28765   3931 Uninit
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (6819, counted=6815).
+Fix? yes
+
+Free blocks count wrong for group #1 (622, counted=549).
+Fix? yes
+
+Free blocks count wrong for group #2 (565, counted=492).
+Fix? yes
+
+Free blocks count wrong (44260, counted=44110).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 51/4096 files (37.3% non-contiguous), 21426/65536 blocks
+Exit status is 1
diff --git a/tests/f_fallocate/name b/tests/f_fallocate/name
new file mode 100644
index 0000000..72d0ed3
--- /dev/null
+++ b/tests/f_fallocate/name
@@ -0,0 +1 @@
+fallocate sparse files and big files
diff --git a/tests/f_fallocate/script b/tests/f_fallocate/script
new file mode 100644
index 0000000..7ea2b62
--- /dev/null
+++ b/tests/f_fallocate/script
@@ -0,0 +1,175 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O ^bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+make_file() {
+	name="$1"
+	start="$2"
+	flag="$3"
+
+	cat << ENDL
+write /dev/null $name
+sif /$name size 40960
+eo /$name
+set_bmap $flag 10 $((start + 10))
+set_bmap $flag 13 $((start + 13))
+set_bmap $flag 26 $((start + 26))
+set_bmap $flag 29 $((start + 29))
+ec
+sif /$name blocks 8
+setb $((start + 10))
+setb $((start + 13))
+setb $((start + 26))
+setb $((start + 29))
+ENDL
+}
+
+#Files we create:
+# a: fallocate a 40k file
+# b*: falloc sparse file starting at b*
+# c*: falloc spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+# g*: falloc sparse init file starting at g*
+# h*: falloc sparse init file ending at h*
+# i: midcluster to midcluster, surrounding sparse init
+# j: partial middle cluster alloc
+# k: one big init file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a size 40960
+fallocate /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "fallocate /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "fallocate /e 19 20" >> $TMPFILE.cmd
+echo "ex /e" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null f
+sif /f size 1024
+eo /f
+set_bmap --uninit 0 9000
+ec
+sif /f blocks 2
+setb 9000
+fallocate /f 0 8999
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
+
+# Now do it again, but with initialized blocks
+base=20000
+for i in 8 9 10 11 12 13 14 15; do
+	make_file g$i $(($base + (40 * ($i - 8)))) >> $TMPFILE.cmd
+	echo "fallocate /g$i $i 39" >> $TMPFILE.cmd
+	echo "ex /g$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file h$i $(($base + 320 + (40 * ($i - 24)))) >> $TMPFILE.cmd
+	echo "fallocate /h$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /h$i" >> $TMPFILE.cmd2
+done
+
+make_file i $(($base + 640)) >> $TMPFILE.cmd
+echo "fallocate /i 4 35" >> $TMPFILE.cmd
+echo "ex /i" >> $TMPFILE.cmd2
+
+make_file j $(($base + 680)) >> $TMPFILE.cmd
+echo "fallocate /j 19 20" >> $TMPFILE.cmd
+echo "ex /j" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null k
+sif /k size 1024
+eo /k
+set_bmap 0 19000
+ec
+sif /k blocks 2
+setb 19000
+fallocate /k 0 8999
+sif /k size 9216000
+ENDL
+echo "ex /k" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > /dev/null 2>&1
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd2 >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/f_fallocate_bigalloc/expect b/tests/f_fallocate_bigalloc/expect
new file mode 100644
index 0000000..30d577a
--- /dev/null
+++ b/tests/f_fallocate_bigalloc/expect
@@ -0,0 +1,364 @@
+
+Warning: the bigalloc feature is still under development
+See https://ext4.wiki.kernel.org/index.php/Bigalloc for more information
+
+Creating filesystem with 65536 1k blocks and 4096 inodes
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/4096 files (9.1% non-contiguous), 1144/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  1     0 -    39  1144 -  1183     40 Uninit
+debugfs: ex /sample
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10  5010 -  5010      1 Uninit
+ 0/ 0   2/  4    13 -    13  5013 -  5013      1 Uninit
+ 0/ 0   3/  4    26 -    26  5026 -  5026      1 Uninit
+ 0/ 0   4/  4    29 -    29  5029 -  5029      1 Uninit
+debugfs: ex /b8
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     8 -    12 10008 - 10012      5 Uninit
+ 0/ 0   2/  4    13 -    23 10013 - 10023     11 Uninit
+ 0/ 0   3/  4    24 -    28 10024 - 10028      5 Uninit
+ 0/ 0   4/  4    29 -    39 10029 - 10039     11 Uninit
+debugfs: ex /b9
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     9 -    12 10049 - 10052      4 Uninit
+ 0/ 0   2/  4    13 -    23 10053 - 10063     11 Uninit
+ 0/ 0   3/  4    24 -    28 10064 - 10068      5 Uninit
+ 0/ 0   4/  4    29 -    39 10069 - 10079     11 Uninit
+debugfs: ex /b10
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    12 10090 - 10092      3 Uninit
+ 0/ 0   2/  4    13 -    23 10093 - 10103     11 Uninit
+ 0/ 0   3/  4    24 -    28 10104 - 10108      5 Uninit
+ 0/ 0   4/  4    29 -    39 10109 - 10119     11 Uninit
+debugfs: ex /b11
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    12 10130 - 10132      3 Uninit
+ 0/ 0   2/  4    13 -    23 10133 - 10143     11 Uninit
+ 0/ 0   3/  4    24 -    28 10144 - 10148      5 Uninit
+ 0/ 0   4/  4    29 -    39 10149 - 10159     11 Uninit
+debugfs: ex /b12
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10170 - 10170      1 Uninit
+ 0/ 0   2/  4    12 -    23 10172 - 10183     12 Uninit
+ 0/ 0   3/  4    24 -    28 10184 - 10188      5 Uninit
+ 0/ 0   4/  4    29 -    39 10189 - 10199     11 Uninit
+debugfs: ex /b13
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10210 - 10210      1 Uninit
+ 0/ 0   2/  4    13 -    23 10213 - 10223     11 Uninit
+ 0/ 0   3/  4    24 -    28 10224 - 10228      5 Uninit
+ 0/ 0   4/  4    29 -    39 10229 - 10239     11 Uninit
+debugfs: ex /b14
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4    10 -    10 10250 - 10250      1 Uninit
+ 0/ 0   2/  4    13 -    23 10253 - 10263     11 Uninit
+ 0/ 0   3/  4    24 -    28 10264 - 10268      5 Uninit
+ 0/ 0   4/  4    29 -    39 10269 - 10279     11 Uninit
+debugfs: ex /b15
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1184             30
+ 1/ 1   1/  5    10 -    10 10290 - 10290      1 Uninit
+ 1/ 1   2/  5    13 -    13 10293 - 10293      1 Uninit
+ 1/ 1   3/  5    15 -    15 10295 - 10295      1 Uninit
+ 1/ 1   4/  5    16 -    28 10296 - 10308     13 Uninit
+ 1/ 1   5/  5    29 -    39 10309 - 10319     11 Uninit
+debugfs: ex /c24
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1192             40
+ 1/ 1   1/  5     0 -    12 10320 - 10332     13 Uninit
+ 1/ 1   2/  5    13 -    23 10333 - 10343     11 Uninit
+ 1/ 1   3/  5    24 -    24 10344 - 10344      1 Uninit
+ 1/ 1   4/  5    26 -    26 10346 - 10346      1 Uninit
+ 1/ 1   5/  5    29 -    29 10349 - 10349      1 Uninit
+debugfs: ex /c25
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10360 - 10372     13 Uninit
+ 0/ 0   2/  4    13 -    23 10373 - 10383     11 Uninit
+ 0/ 0   3/  4    24 -    26 10384 - 10386      3 Uninit
+ 0/ 0   4/  4    29 -    29 10389 - 10389      1 Uninit
+debugfs: ex /c26
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10400 - 10412     13 Uninit
+ 0/ 0   2/  4    13 -    23 10413 - 10423     11 Uninit
+ 0/ 0   3/  4    24 -    26 10424 - 10426      3 Uninit
+ 0/ 0   4/  4    29 -    29 10429 - 10429      1 Uninit
+debugfs: ex /c27
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10440 - 10452     13 Uninit
+ 0/ 0   2/  4    13 -    23 10453 - 10463     11 Uninit
+ 0/ 0   3/  4    24 -    27 10464 - 10467      4 Uninit
+ 0/ 0   4/  4    29 -    29 10469 - 10469      1 Uninit
+debugfs: ex /c28
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10480 - 10492     13 Uninit
+ 0/ 0   2/  4    13 -    23 10493 - 10503     11 Uninit
+ 0/ 0   3/  4    24 -    28 10504 - 10508      5 Uninit
+ 0/ 0   4/  4    29 -    29 10509 - 10509      1 Uninit
+debugfs: ex /c29
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10520 - 10532     13 Uninit
+ 0/ 0   2/  4    13 -    23 10533 - 10543     11 Uninit
+ 0/ 0   3/  4    24 -    28 10544 - 10548      5 Uninit
+ 0/ 0   4/  4    29 -    29 10549 - 10549      1 Uninit
+debugfs: ex /c30
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10560 - 10572     13 Uninit
+ 0/ 0   2/  4    13 -    23 10573 - 10583     11 Uninit
+ 0/ 0   3/  4    24 -    28 10584 - 10588      5 Uninit
+ 0/ 0   4/  4    29 -    30 10589 - 10590      2 Uninit
+debugfs: ex /c31
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     0 -    12 10600 - 10612     13 Uninit
+ 0/ 0   2/  4    13 -    23 10613 - 10623     11 Uninit
+ 0/ 0   3/  4    24 -    28 10624 - 10628      5 Uninit
+ 0/ 0   4/  4    29 -    31 10629 - 10631      3 Uninit
+debugfs: ex /d
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  4     4 -    12 10644 - 10652      9 Uninit
+ 0/ 0   2/  4    13 -    23 10653 - 10663     11 Uninit
+ 0/ 0   3/  4    24 -    28 10664 - 10668      5 Uninit
+ 0/ 0   4/  4    29 -    35 10669 - 10675      7 Uninit
+debugfs: ex /e
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1200             30
+ 1/ 1   1/  5    10 -    10 10690 - 10690      1 Uninit
+ 1/ 1   2/  5    13 -    13 10693 - 10693      1 Uninit
+ 1/ 1   3/  5    19 -    20 10699 - 10700      2 Uninit
+ 1/ 1   4/  5    26 -    26 10706 - 10706      1 Uninit
+ 1/ 1   5/  5    29 -    29 10709 - 10709      1 Uninit
+debugfs: ex /f
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -     0  1208              1
+ 1/ 1   1/ 19     0 -     7  9000 -  9007      8 Uninit
+ 1/ 1   2/ 19     8 -  1007  9008 - 10007   1000 Uninit
+ 1/ 1   3/ 19  1008 -  1015 10040 - 10047      8 Uninit
+ 1/ 1   4/ 19  1016 -  1023 10080 - 10087      8 Uninit
+ 1/ 1   5/ 19  1024 -  1031 10120 - 10127      8 Uninit
+ 1/ 1   6/ 19  1032 -  1039 10160 - 10167      8 Uninit
+ 1/ 1   7/ 19  1040 -  1047 10200 - 10207      8 Uninit
+ 1/ 1   8/ 19  1048 -  1055 10240 - 10247      8 Uninit
+ 1/ 1   9/ 19  1056 -  1063 10280 - 10287      8 Uninit
+ 1/ 1  10/ 19  1064 -  1071 10352 - 10359      8 Uninit
+ 1/ 1  11/ 19  1072 -  1079 10392 - 10399      8 Uninit
+ 1/ 1  12/ 19  1080 -  1087 10432 - 10439      8 Uninit
+ 1/ 1  13/ 19  1088 -  1095 10472 - 10479      8 Uninit
+ 1/ 1  14/ 19  1096 -  1103 10512 - 10519      8 Uninit
+ 1/ 1  15/ 19  1104 -  1111 10552 - 10559      8 Uninit
+ 1/ 1  16/ 19  1112 -  1119 10592 - 10599      8 Uninit
+ 1/ 1  17/ 19  1120 -  1127 10632 - 10639      8 Uninit
+ 1/ 1  18/ 19  1128 -  1135 10680 - 10687      8 Uninit
+ 1/ 1  19/ 19  1136 -  8999 10712 - 18575   7864 Uninit
+debugfs: ex /g8
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     8 -    39  1216             32
+ 1/ 1   1/  6     8 -    12 20008 - 20012      5 
+ 1/ 1   2/  6    13 -    15 20013 - 20015      3 
+ 1/ 1   3/  6    16 -    23 20016 - 20023      8 Uninit
+ 1/ 1   4/  6    24 -    28 20024 - 20028      5 
+ 1/ 1   5/  6    29 -    31 20029 - 20031      3 
+ 1/ 1   6/  6    32 -    39 20032 - 20039      8 Uninit
+debugfs: ex /g9
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     9 -    39  1224             31
+ 1/ 1   1/  6     9 -    12 20049 - 20052      4 
+ 1/ 1   2/  6    13 -    15 20053 - 20055      3 
+ 1/ 1   3/  6    16 -    23 20056 - 20063      8 Uninit
+ 1/ 1   4/  6    24 -    28 20064 - 20068      5 
+ 1/ 1   5/  6    29 -    31 20069 - 20071      3 
+ 1/ 1   6/  6    32 -    39 20072 - 20079      8 Uninit
+debugfs: ex /g10
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1232             30
+ 1/ 1   1/  6    10 -    12 20090 - 20092      3 
+ 1/ 1   2/  6    13 -    15 20093 - 20095      3 
+ 1/ 1   3/  6    16 -    23 20096 - 20103      8 Uninit
+ 1/ 1   4/  6    24 -    28 20104 - 20108      5 
+ 1/ 1   5/  6    29 -    31 20109 - 20111      3 
+ 1/ 1   6/  6    32 -    39 20112 - 20119      8 Uninit
+debugfs: ex /g11
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1240             30
+ 1/ 1   1/  6    10 -    12 20130 - 20132      3 
+ 1/ 1   2/  6    13 -    15 20133 - 20135      3 
+ 1/ 1   3/  6    16 -    23 20136 - 20143      8 Uninit
+ 1/ 1   4/  6    24 -    28 20144 - 20148      5 
+ 1/ 1   5/  6    29 -    31 20149 - 20151      3 
+ 1/ 1   6/  6    32 -    39 20152 - 20159      8 Uninit
+debugfs: ex /g12
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1248             30
+ 1/ 1   1/  6    10 -    10 20170 - 20170      1 
+ 1/ 1   2/  6    12 -    15 20172 - 20175      4 
+ 1/ 1   3/  6    16 -    23 20176 - 20183      8 Uninit
+ 1/ 1   4/  6    24 -    28 20184 - 20188      5 
+ 1/ 1   5/  6    29 -    31 20189 - 20191      3 
+ 1/ 1   6/  6    32 -    39 20192 - 20199      8 Uninit
+debugfs: ex /g13
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1256             30
+ 1/ 1   1/  6    10 -    10 20210 - 20210      1 
+ 1/ 1   2/  6    13 -    15 20213 - 20215      3 
+ 1/ 1   3/  6    16 -    23 20216 - 20223      8 Uninit
+ 1/ 1   4/  6    24 -    28 20224 - 20228      5 
+ 1/ 1   5/  6    29 -    31 20229 - 20231      3 
+ 1/ 1   6/  6    32 -    39 20232 - 20239      8 Uninit
+debugfs: ex /g14
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1264             30
+ 1/ 1   1/  6    10 -    10 20250 - 20250      1 
+ 1/ 1   2/  6    13 -    15 20253 - 20255      3 
+ 1/ 1   3/  6    16 -    23 20256 - 20263      8 Uninit
+ 1/ 1   4/  6    24 -    28 20264 - 20268      5 
+ 1/ 1   5/  6    29 -    31 20269 - 20271      3 
+ 1/ 1   6/  6    32 -    39 20272 - 20279      8 Uninit
+debugfs: ex /g15
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1272             30
+ 1/ 1   1/  7    10 -    10 20290 - 20290      1 
+ 1/ 1   2/  7    13 -    13 20293 - 20293      1 
+ 1/ 1   3/  7    15 -    15 20295 - 20295      1 Uninit
+ 1/ 1   4/  7    16 -    23 20296 - 20303      8 Uninit
+ 1/ 1   5/  7    24 -    28 20304 - 20308      5 
+ 1/ 1   6/  7    29 -    31 20309 - 20311      3 
+ 1/ 1   7/  7    32 -    39 20312 - 20319      8 Uninit
+debugfs: ex /h24
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1280             40
+ 1/ 1   1/  7     0 -     7 20320 - 20327      8 Uninit
+ 1/ 1   2/  7     8 -    12 20328 - 20332      5 
+ 1/ 1   3/  7    13 -    15 20333 - 20335      3 
+ 1/ 1   4/  7    16 -    23 20336 - 20343      8 Uninit
+ 1/ 1   5/  7    24 -    24 20344 - 20344      1 Uninit
+ 1/ 1   6/  7    26 -    26 20346 - 20346      1 
+ 1/ 1   7/  7    29 -    29 20349 - 20349      1 
+debugfs: ex /h25
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1288             40
+ 1/ 1   1/  6     0 -     7 20360 - 20367      8 Uninit
+ 1/ 1   2/  6     8 -    12 20368 - 20372      5 
+ 1/ 1   3/  6    13 -    15 20373 - 20375      3 
+ 1/ 1   4/  6    16 -    23 20376 - 20383      8 Uninit
+ 1/ 1   5/  6    24 -    26 20384 - 20386      3 
+ 1/ 1   6/  6    29 -    29 20389 - 20389      1 
+debugfs: ex /h26
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1296             40
+ 1/ 1   1/  6     0 -     7 20400 - 20407      8 Uninit
+ 1/ 1   2/  6     8 -    12 20408 - 20412      5 
+ 1/ 1   3/  6    13 -    15 20413 - 20415      3 
+ 1/ 1   4/  6    16 -    23 20416 - 20423      8 Uninit
+ 1/ 1   5/  6    24 -    26 20424 - 20426      3 
+ 1/ 1   6/  6    29 -    29 20429 - 20429      1 
+debugfs: ex /h27
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1304             40
+ 1/ 1   1/  6     0 -     7 20440 - 20447      8 Uninit
+ 1/ 1   2/  6     8 -    12 20448 - 20452      5 
+ 1/ 1   3/  6    13 -    15 20453 - 20455      3 
+ 1/ 1   4/  6    16 -    23 20456 - 20463      8 Uninit
+ 1/ 1   5/  6    24 -    27 20464 - 20467      4 
+ 1/ 1   6/  6    29 -    29 20469 - 20469      1 
+debugfs: ex /h28
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1312             40
+ 1/ 1   1/  6     0 -     7 20480 - 20487      8 Uninit
+ 1/ 1   2/  6     8 -    12 20488 - 20492      5 
+ 1/ 1   3/  6    13 -    15 20493 - 20495      3 
+ 1/ 1   4/  6    16 -    23 20496 - 20503      8 Uninit
+ 1/ 1   5/  6    24 -    28 20504 - 20508      5 
+ 1/ 1   6/  6    29 -    29 20509 - 20509      1 
+debugfs: ex /h29
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1320             40
+ 1/ 1   1/  6     0 -     7 20520 - 20527      8 Uninit
+ 1/ 1   2/  6     8 -    12 20528 - 20532      5 
+ 1/ 1   3/  6    13 -    15 20533 - 20535      3 
+ 1/ 1   4/  6    16 -    23 20536 - 20543      8 Uninit
+ 1/ 1   5/  6    24 -    28 20544 - 20548      5 
+ 1/ 1   6/  6    29 -    29 20549 - 20549      1 
+debugfs: ex /h30
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1328             40
+ 1/ 1   1/  6     0 -     7 20560 - 20567      8 Uninit
+ 1/ 1   2/  6     8 -    12 20568 - 20572      5 
+ 1/ 1   3/  6    13 -    15 20573 - 20575      3 
+ 1/ 1   4/  6    16 -    23 20576 - 20583      8 Uninit
+ 1/ 1   5/  6    24 -    28 20584 - 20588      5 
+ 1/ 1   6/  6    29 -    30 20589 - 20590      2 
+debugfs: ex /h31
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    39  1336             40
+ 1/ 1   1/  6     0 -     7 20600 - 20607      8 Uninit
+ 1/ 1   2/  6     8 -    12 20608 - 20612      5 
+ 1/ 1   3/  6    13 -    15 20613 - 20615      3 
+ 1/ 1   4/  6    16 -    23 20616 - 20623      8 Uninit
+ 1/ 1   5/  6    24 -    28 20624 - 20628      5 
+ 1/ 1   6/  6    29 -    31 20629 - 20631      3 
+debugfs: ex /i
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     4 -    39  1344             36
+ 1/ 1   1/  7     4 -     7 20644 - 20647      4 Uninit
+ 1/ 1   2/  7     8 -    12 20648 - 20652      5 
+ 1/ 1   3/  7    13 -    15 20653 - 20655      3 
+ 1/ 1   4/  7    16 -    23 20656 - 20663      8 Uninit
+ 1/ 1   5/  7    24 -    28 20664 - 20668      5 
+ 1/ 1   6/  7    29 -    31 20669 - 20671      3 
+ 1/ 1   7/  7    32 -    35 20672 - 20675      4 Uninit
+debugfs: ex /j
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    10 -    39  1352             30
+ 1/ 1   1/  5    10 -    10 20690 - 20690      1 
+ 1/ 1   2/  5    13 -    13 20693 - 20693      1 
+ 1/ 1   3/  5    19 -    20 20699 - 20700      2 Uninit
+ 1/ 1   4/  5    26 -    26 20706 - 20706      1 
+ 1/ 1   5/  5    29 -    29 20709 - 20709      1 
+debugfs: ex /k
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -  8999  1360           9000
+ 1/ 1   1/ 19     0 -     7 19000 - 19007      8 
+ 1/ 1   2/ 19     8 -  1007 19008 - 20007   1000 Uninit
+ 1/ 1   3/ 19  1008 -  1015 20040 - 20047      8 Uninit
+ 1/ 1   4/ 19  1016 -  1023 20080 - 20087      8 Uninit
+ 1/ 1   5/ 19  1024 -  1031 20120 - 20127      8 Uninit
+ 1/ 1   6/ 19  1032 -  1039 20160 - 20167      8 Uninit
+ 1/ 1   7/ 19  1040 -  1047 20200 - 20207      8 Uninit
+ 1/ 1   8/ 19  1048 -  1055 20240 - 20247      8 Uninit
+ 1/ 1   9/ 19  1056 -  1063 20280 - 20287      8 Uninit
+ 1/ 1  10/ 19  1064 -  1071 20352 - 20359      8 Uninit
+ 1/ 1  11/ 19  1072 -  1079 20392 - 20399      8 Uninit
+ 1/ 1  12/ 19  1080 -  1087 20432 - 20439      8 Uninit
+ 1/ 1  13/ 19  1088 -  1095 20472 - 20479      8 Uninit
+ 1/ 1  14/ 19  1096 -  1103 20512 - 20519      8 Uninit
+ 1/ 1  15/ 19  1104 -  1111 20552 - 20559      8 Uninit
+ 1/ 1  16/ 19  1112 -  1119 20592 - 20599      8 Uninit
+ 1/ 1  17/ 19  1120 -  1127 20632 - 20639      8 Uninit
+ 1/ 1  18/ 19  1128 -  1135 20680 - 20687      8 Uninit
+ 1/ 1  19/ 19  1136 -  8999 20712 - 28575   7864 Uninit
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (5701, counted=5625).
+Fix? yes
+
+Free blocks count wrong (45608, counted=45000).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 51/4096 files (43.1% non-contiguous), 20536/65536 blocks
+Exit status is 1
diff --git a/tests/f_fallocate_bigalloc/name b/tests/f_fallocate_bigalloc/name
new file mode 100644
index 0000000..915645c
--- /dev/null
+++ b/tests/f_fallocate_bigalloc/name
@@ -0,0 +1 @@
+fallocate sparse files and big files with bigalloc
diff --git a/tests/f_fallocate_bigalloc/script b/tests/f_fallocate_bigalloc/script
new file mode 100644
index 0000000..199ae43
--- /dev/null
+++ b/tests/f_fallocate_bigalloc/script
@@ -0,0 +1,176 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+	cluster_size = 8192
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+make_file() {
+	name="$1"
+	start="$2"
+	flag="$3"
+
+	cat << ENDL
+write /dev/null $name
+sif /$name size 40960
+eo /$name
+set_bmap $flag 10 $((start + 10))
+set_bmap $flag 13 $((start + 13))
+set_bmap $flag 26 $((start + 26))
+set_bmap $flag 29 $((start + 29))
+ec
+sif /$name blocks 32
+setb $((start + 10))
+setb $((start + 13))
+setb $((start + 26))
+setb $((start + 29))
+ENDL
+}
+
+#Files we create:
+# a: fallocate a 40k file
+# b*: falloc sparse file starting at b*
+# c*: falloc spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+# g*: falloc sparse init file starting at g*
+# h*: falloc sparse init file ending at h*
+# i: midcluster to midcluster, surrounding sparse init
+# j: partial middle cluster alloc
+# k: one big init file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a size 40960
+fallocate /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "fallocate /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "fallocate /e 19 20" >> $TMPFILE.cmd
+echo "ex /e" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null f
+sif /f size 1024
+eo /f
+set_bmap --uninit 0 9000
+ec
+sif /f blocks 16
+setb 9000
+fallocate /f 0 8999
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
+
+# Now do it again, but with initialized blocks
+base=20000
+for i in 8 9 10 11 12 13 14 15; do
+	make_file g$i $(($base + (40 * ($i - 8)))) >> $TMPFILE.cmd
+	echo "fallocate /g$i $i 39" >> $TMPFILE.cmd
+	echo "ex /g$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file h$i $(($base + 320 + (40 * ($i - 24)))) >> $TMPFILE.cmd
+	echo "fallocate /h$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /h$i" >> $TMPFILE.cmd2
+done
+
+make_file i $(($base + 640)) >> $TMPFILE.cmd
+echo "fallocate /i 4 35" >> $TMPFILE.cmd
+echo "ex /i" >> $TMPFILE.cmd2
+
+make_file j $(($base + 680)) >> $TMPFILE.cmd
+echo "fallocate /j 19 20" >> $TMPFILE.cmd
+echo "ex /j" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null k
+sif /k size 1024
+eo /k
+set_bmap 0 19000
+ec
+sif /k blocks 16
+setb 19000
+fallocate /k 0 8999
+sif /k size 9216000
+ENDL
+echo "ex /k" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > /dev/null 2>&1
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd2 >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/f_fallocate_blkmap/expect b/tests/f_fallocate_blkmap/expect
new file mode 100644
index 0000000..f7ae606
--- /dev/null
+++ b/tests/f_fallocate_blkmap/expect
@@ -0,0 +1,58 @@
+Creating filesystem with 65536 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/4096 files (0.0% non-contiguous), 2340/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: stat /a
+Inode: 12   Type: regular    Mode:  0666   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 40960
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 82
+Fragment:  Address: 0    Number: 0    Size: 0
+Size of extra inode fields: 28
+BLOCKS:
+(0-1):1312-1313, (2-11):8000-8009, (IND):8010, (12-39):8011-8038
+TOTAL: 41
+
+debugfs: stat /b
+Inode: 13   Type: regular    Mode:  0666   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 10240000
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 20082
+Fragment:  Address: 0    Number: 0    Size: 0
+Size of extra inode fields: 28
+BLOCKS:
+(0-11):10000-10011, (IND):10012, (12-267):10013-10268, (DIND):10269, (IND):10270, (268-523):10271-10526, (IND):10527, (524-779):10528-10783, (IND):10784, (780-1035):10785-11040, (IND):11041, (1036-1291):11042-11297, (IND):11298, (1292-1547):11299-11554, (IND):11555, (1548-1803):11556-11811, (IND):11812, (1804-2059):11813-12068, (IND):12069, (2060-2315):12070-12325, (IND):12326, (2316-2571):12327-12582, (IND):12583, (2572-2827):12584-12839, (IND):12840, (2828-3083):12841-13096, (IND):13097, (3084-3339):13098-13353, (IND):13354, (3340-3595):13355-13610, (IND):13611, (3596-3851):13612-13867, (IND):13868, (3852-4107):13869-14124, (IND):14125, (4108-4363):14126-14381, (IND):14382, (4364-4619):14383-14638, (IND):14639, (4620-4875):14640-14895, (IND):14896, (4876-5131):14897-15152, (IND):15153, 
 (5132-5387):15154-15409, (IND):15410, (5388-5643):15411-15666, (IND):15667, (5644-5899):15668-15923, (IND):15924, (5900-6155):15925-16180, (IND):16181, (6156-6411):16182-16437, (IND):16438,!
  (6412-6667):16439-16694, (IND):16695, (6668-6923):16696-16951, (IND):16952, (6924-7179):16953-17208, (IND):17209, (7180-7435):17210-17465, (IND):17466, (7436-7691):17467-17722, (IND):17723, (7692-7947):17724-17979, (IND):17980, (7948-8203):17981-18236, (IND):18237, (8204-8459):18238-18493, (IND):18494, (8460-8715):18495-18750, (IND):18751, (8716-8971):18752-19007, (IND):19008, (8972-9227):19009-19264, (IND):19265, (9228-9483):19266-19521, (IND):19522, (9484-9739):19523-19778, (IND):19779, (9740-9995):19780-20035, (IND):20036, (9996-9999):20037-20040
+TOTAL: 10041
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (6841, counted=6840).
+Fix? yes
+
+Free blocks count wrong for group #1 (1551, counted=1550).
+Fix? yes
+
+Free blocks count wrong (53116, counted=53114).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/4096 files (7.7% non-contiguous), 12422/65536 blocks
+Exit status is 1
diff --git a/tests/f_fallocate_blkmap/name b/tests/f_fallocate_blkmap/name
new file mode 100644
index 0000000..ba2b61d
--- /dev/null
+++ b/tests/f_fallocate_blkmap/name
@@ -0,0 +1 @@
+fallocate sparse files and big files on a blockmap fs
diff --git a/tests/f_fallocate_blkmap/script b/tests/f_fallocate_blkmap/script
new file mode 100644
index 0000000..da83cd1
--- /dev/null
+++ b/tests/f_fallocate_blkmap/script
@@ -0,0 +1,85 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,^extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O ^bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+
+#Files we create:
+# a: fallocate a 40k file
+# k: one big file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a bmap[2] 8000
+sif /a size 40960
+sif /a i_blocks 2
+setb 8000
+fallocate /a 0 39
+
+write /dev/null b
+sif /b size 10240000
+sif /b bmap[0] 10000
+sif /b i_blocks 2
+setb 10000
+fallocate /b 0 9999
+ENDL
+echo "stat /a" >> $TMPFILE.cmd2
+echo "stat /b" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > /dev/null 2>&1
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd2 >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed -e '/^.*time:.*$/d' < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

