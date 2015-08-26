From: Jan Kara <jack@suse.com>
Subject: [PATCH 08/21] tests: Convert tests for 64bit feature to use tune2fs
Date: Wed, 26 Aug 2015 18:22:23 +0200
Message-ID: <1440606156-5754-9-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbbHZQW4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:56 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert tests which test various functionality regarding 64bit feature
to use tune2fs to enable / disable it. We also update the expected
outputs since location of some group metadata is different.

Signed-off-by: Jan Kara <jack@suse.com>
---
 tests/r_32to64bit/expect                    |  94 -------------------
 tests/r_32to64bit/name                      |   1 -
 tests/r_32to64bit/script                    |  74 ---------------
 tests/r_32to64bit_expand_full/expect        | 139 ----------------------------
 tests/r_32to64bit_expand_full/name          |   1 -
 tests/r_32to64bit_expand_full/script        |  83 -----------------
 tests/r_32to64bit_meta/expect               |  80 ----------------
 tests/r_32to64bit_meta/name                 |   1 -
 tests/r_32to64bit_meta/script               |  74 ---------------
 tests/r_32to64bit_move_itable/expect        | 107 ---------------------
 tests/r_32to64bit_move_itable/name          |   1 -
 tests/r_32to64bit_move_itable/script        |  74 ---------------
 tests/r_64to32bit/expect                    |  98 --------------------
 tests/r_64to32bit/name                      |   1 -
 tests/r_64to32bit/script                    |  76 ---------------
 tests/r_64to32bit_meta/expect               |  80 ----------------
 tests/r_64to32bit_meta/name                 |   1 -
 tests/r_64to32bit_meta/script               |  76 ---------------
 tests/t_32to64bit/expect                    |  91 ++++++++++++++++++
 tests/t_32to64bit/name                      |   1 +
 tests/t_32to64bit/script                    |  74 +++++++++++++++
 tests/t_32to64bit_expand_full/expect        | 136 +++++++++++++++++++++++++++
 tests/t_32to64bit_expand_full/name          |   1 +
 tests/t_32to64bit_expand_full/script        |  83 +++++++++++++++++
 tests/t_32to64bit_meta/expect               |  77 +++++++++++++++
 tests/t_32to64bit_meta/name                 |   1 +
 tests/t_32to64bit_meta/script               |  74 +++++++++++++++
 tests/t_32to64bit_move_itable/expect        | 104 +++++++++++++++++++++
 tests/t_32to64bit_move_itable/name          |   1 +
 tests/t_32to64bit_move_itable/script        |  74 +++++++++++++++
 tests/t_64to32bit/expect                    |  95 +++++++++++++++++++
 tests/t_64to32bit/name                      |   1 +
 tests/t_64to32bit/script                    |  76 +++++++++++++++
 tests/t_64to32bit_meta/expect               |  80 ++++++++++++++++
 tests/t_64to32bit_meta/name                 |   1 +
 tests/t_64to32bit_meta/script               |  76 +++++++++++++++
 tests/u_onefile_bad/script                  |  10 +-
 tests/u_revert_64bitmcsum_onefile/script    |  10 +-
 tests/u_revert_all_onefile/script           |  10 +-
 tests/u_revert_upgrade_to_64bitmcsum/script |  14 +--
 40 files changed, 1068 insertions(+), 1083 deletions(-)
 delete mode 100644 tests/r_32to64bit/expect
 delete mode 100644 tests/r_32to64bit/name
 delete mode 100644 tests/r_32to64bit/script
 delete mode 100644 tests/r_32to64bit_expand_full/expect
 delete mode 100644 tests/r_32to64bit_expand_full/name
 delete mode 100644 tests/r_32to64bit_expand_full/script
 delete mode 100644 tests/r_32to64bit_meta/expect
 delete mode 100644 tests/r_32to64bit_meta/name
 delete mode 100644 tests/r_32to64bit_meta/script
 delete mode 100644 tests/r_32to64bit_move_itable/expect
 delete mode 100644 tests/r_32to64bit_move_itable/name
 delete mode 100644 tests/r_32to64bit_move_itable/script
 delete mode 100644 tests/r_64to32bit/expect
 delete mode 100644 tests/r_64to32bit/name
 delete mode 100644 tests/r_64to32bit/script
 delete mode 100644 tests/r_64to32bit_meta/expect
 delete mode 100644 tests/r_64to32bit_meta/name
 delete mode 100644 tests/r_64to32bit_meta/script
 create mode 100644 tests/t_32to64bit/expect
 create mode 100644 tests/t_32to64bit/name
 create mode 100644 tests/t_32to64bit/script
 create mode 100644 tests/t_32to64bit_expand_full/expect
 create mode 100644 tests/t_32to64bit_expand_full/name
 create mode 100644 tests/t_32to64bit_expand_full/script
 create mode 100644 tests/t_32to64bit_meta/expect
 create mode 100644 tests/t_32to64bit_meta/name
 create mode 100644 tests/t_32to64bit_meta/script
 create mode 100644 tests/t_32to64bit_move_itable/expect
 create mode 100644 tests/t_32to64bit_move_itable/name
 create mode 100644 tests/t_32to64bit_move_itable/script
 create mode 100644 tests/t_64to32bit/expect
 create mode 100644 tests/t_64to32bit/name
 create mode 100644 tests/t_64to32bit/script
 create mode 100644 tests/t_64to32bit_meta/expect
 create mode 100644 tests/t_64to32bit_meta/name
 create mode 100644 tests/t_64to32bit_meta/script

diff --git a/tests/r_32to64bit/expect b/tests/r_32to64bit/expect
deleted file mode 100644
index f5fa56bc39f7..000000000000
--- a/tests/r_32to64bit/expect
+++ /dev/null
@@ -1,94 +0,0 @@
-resize2fs test
-Creating filesystem with 524288 1k blocks and 65536 inodes
-Superblock backups stored on blocks: 
-	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
-
-Allocating group tables:      done                            
-Writing inode tables:      done                            
-Creating journal (16384 blocks): done
-Creating 477 huge file(s) with 1024 blocks each: done
-Writing superblocks and filesystem accounting information:      done
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
-resize2fs test.img -b
-Converting the filesystem to 64-bit.
-The filesystem on test.img is now 524288 (1k) blocks long.
-
-Exit status is 0
-Change in FS metadata:
-@@ -2,7 +2,7 @@
- Last mounted on:          <not available>
- Filesystem magic number:  0xEF53
- Filesystem revision #:    1 (dynamic)
--Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
-+Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
- Default mount options:    user_xattr acl
- Filesystem state:         clean
- Errors behavior:          Continue
-@@ -15,7 +15,8 @@
- First block:              1
- Block size:               1024
- Fragment size:            1024
--Reserved GDT blocks:      256
-+Group descriptor size:    64
-+Reserved GDT blocks:      254
- Blocks per group:         8192
- Fragments per group:      8192
- Inodes per group:         1024
-@@ -40,16 +41,16 @@
- 
- 
- group:block:super:gdt:bbitmap:ibitmap:itable
--0:1:1:2-3:260:276:292
--1:8193:8193:8194-8195:261:277:548
-+0:1:1:2-5:260:276:292
-+1:8193:8193:8194-8197:261:277:548
- 2:16385:-1:-1:262:278:804
--3:24577:24577:24578-24579:263:279:1060
-+3:24577:24577:24578-24581:263:279:1060
- 4:32769:-1:-1:264:280:1316
--5:40961:40961:40962-40963:265:281:1572
-+5:40961:40961:40962-40965:265:281:1572
- 6:49153:-1:-1:266:282:1828
--7:57345:57345:57346-57347:267:283:2084
-+7:57345:57345:57346-57349:267:283:2084
- 8:65537:-1:-1:268:284:2340
--9:73729:73729:73730-73731:269:285:2596
-+9:73729:73729:73730-73733:269:285:2596
- 10:81921:-1:-1:270:286:2852
- 11:90113:-1:-1:271:287:3108
- 12:98305:-1:-1:272:288:3364
-@@ -65,9 +66,9 @@
- 22:180225:-1:-1:131079:131095:132641
- 23:188417:-1:-1:131080:131096:132897
- 24:196609:-1:-1:131081:131097:133153
--25:204801:204801:204802-204803:131082:131098:133409
-+25:204801:204801:204802-204805:131082:131098:133409
- 26:212993:-1:-1:131083:131099:133665
--27:221185:221185:221186-221187:131084:131100:133921
-+27:221185:221185:221186-221189:131084:131100:133921
- 28:229377:-1:-1:131085:131101:134177
- 29:237569:-1:-1:131086:131102:134433
- 30:245761:-1:-1:131087:131103:134689
-@@ -89,7 +90,7 @@
- 46:376833:-1:-1:262159:262175:265761
- 47:385025:-1:-1:262160:262176:266017
- 48:393217:-1:-1:393217:393233:393249
--49:401409:401409:401410-401411:393218:393234:393505
-+49:401409:401409:401410-401413:393218:393234:393505
- 50:409601:-1:-1:393219:393235:393761
- 51:417793:-1:-1:393220:393236:394017
- 52:425985:-1:-1:393221:393237:394273
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
diff --git a/tests/r_32to64bit/name b/tests/r_32to64bit/name
deleted file mode 100644
index fb45faba6468..000000000000
--- a/tests/r_32to64bit/name
+++ /dev/null
@@ -1 +0,0 @@
-convert flex_bg 32bit fs to 64bit fs
diff --git a/tests/r_32to64bit/script b/tests/r_32to64bit/script
deleted file mode 100644
index de08bfb6422a..000000000000
--- a/tests/r_32to64bit/script
+++ /dev/null
@@ -1,74 +0,0 @@
-if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-
-FSCK_OPT=-fn
-OUT=$test_name.log
-EXP=$test_dir/expect
-CONF=$TMPFILE.conf
-
-cat > $CONF << ENDL
-[fs_types]
-	ext4h = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
-		blocksize = 1024
-		inode_size = 256
-		make_hugefiles = true
-		hugefiles_dir = /
-		hugefiles_slack = 0
-		hugefiles_name = aaaaa
-		hugefiles_digits = 4
-		hugefiles_size = 1M
-		zero_hugefiles = false
-	}
-ENDL
-
-echo "resize2fs test" > $OUT
-
-MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
-rm -rf $CONF
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# resize it
-echo "resize2fs test.img -b" >> $OUT
-$RESIZE2FS -b -f $TMPFILE 2>&1 >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
-echo "Change in FS metadata:" >> $OUT
-diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-rm $TMPFILE $OUT.before $OUT.after
-
-#
-# Do the verification
-#
-
-sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
-mv $OUT.new $OUT
-
-cmp -s $OUT $EXP
-status=$?
-
-if [ "$status" = 0 ] ; then
-	echo "$test_name: $test_description: ok"
-	touch $test_name.ok
-else
-	echo "$test_name: $test_description: failed"
-	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-fi
-
-unset IMAGE FSCK_OPT OUT EXP CONF
-
-else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	echo "$test_name: $test_description: skipped"
-fi
-
diff --git a/tests/r_32to64bit_expand_full/expect b/tests/r_32to64bit_expand_full/expect
deleted file mode 100644
index f9e30f34b8e7..000000000000
--- a/tests/r_32to64bit_expand_full/expect
+++ /dev/null
@@ -1,139 +0,0 @@
-resize2fs test
-Creating filesystem with 786432 1k blocks and 98304 inodes
-Superblock backups stored on blocks: 
-	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
-
-Allocating group tables:      done                            
-Writing inode tables:      done                            
-Creating journal (16384 blocks): done
-Creating 727 huge file(s) with 1024 blocks each: done
-Writing superblocks and filesystem accounting information:      done
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
-resize2fs -b test.img
-Converting the filesystem to 64-bit.
-The filesystem on test.img is now 786432 (1k) blocks long.
-
-resize2fs test.img
-Resizing the filesystem on test.img to 1179648 (1k) blocks.
-The filesystem on test.img is now 1179648 (1k) blocks long.
-
-Exit status is 0
-Change in FS metadata:
-@@ -1,15 +1,15 @@
- 
- group:block:super:gdt:bbitmap:ibitmap:itable
--0:1:1:2-7:8:9:10
--1:8193:8193:8194-8199:8200:8201:8202
-+0:1:1:2-10:266:267:268
-+1:8193:8193:8194-8202:8458:8459:8460
- 2:16385:-1:-1:16385:16386:16387
--3:24577:24577:24578-24583:24584:24585:24586
-+3:24577:24577:24578-24586:24842:24843:24844
- 4:32769:-1:-1:32769:32770:32771
--5:40961:40961:40962-40967:40968:40969:40970
-+5:40961:40961:40962-40970:41226:41227:41228
- 6:49153:-1:-1:49153:49154:49155
--7:57345:57345:57346-57351:57352:57353:57354
-+7:57345:57345:57346-57354:57610:57611:57612
- 8:65537:-1:-1:65537:65538:65539
--9:73729:73729:73730-73735:73736:73737:73738
-+9:73729:73729:73730-73738:73994:73995:73996
- 10:81921:-1:-1:81921:81922:81923
- 11:90113:-1:-1:90113:90114:90115
- 12:98305:-1:-1:98305:98306:98307
-@@ -25,9 +25,9 @@
- 22:180225:-1:-1:180225:180226:180227
- 23:188417:-1:-1:188417:188418:188419
- 24:196609:-1:-1:196609:196610:196611
--25:204801:204801:204802-204807:204808:204809:204810
-+25:204801:204801:204802-204810:205066:205067:205068
- 26:212993:-1:-1:212993:212994:212995
--27:221185:221185:221186-221191:221192:221193:221194
-+27:221185:221185:221186-221194:221450:221451:221452
- 28:229377:-1:-1:229377:229378:229379
- 29:237569:-1:-1:237569:237570:237571
- 30:245761:-1:-1:245761:245762:245763
-@@ -49,7 +49,7 @@
- 46:376833:-1:-1:376833:376834:376835
- 47:385025:-1:-1:385025:385026:385027
- 48:393217:-1:-1:393217:393218:393219
--49:401409:401409:401410-401415:401416:401417:401418
-+49:401409:401409:401410-401418:401674:401675:401676
- 50:409601:-1:-1:409601:409602:409603
- 51:417793:-1:-1:417793:417794:417795
- 52:425985:-1:-1:425985:425986:425987
-@@ -81,7 +81,7 @@
- 78:638977:-1:-1:638977:638978:638979
- 79:647169:-1:-1:647169:647170:647171
- 80:655361:-1:-1:655361:655362:655363
--81:663553:663553:663554-663559:663560:663561:663562
-+81:663553:663553:663554-663562:663818:663819:663820
- 82:671745:-1:-1:671745:671746:671747
- 83:679937:-1:-1:679937:679938:679939
- 84:688129:-1:-1:688129:688130:688131
-@@ -96,3 +96,51 @@
- 93:761857:-1:-1:761857:761858:761859
- 94:770049:-1:-1:770049:770050:770051
- 95:778241:-1:-1:778241:778242:778243
-+96:786433:-1:-1:786433:786434:786435
-+97:794625:-1:-1:794625:794626:794627
-+98:802817:-1:-1:802817:802818:802819
-+99:811009:-1:-1:811009:811010:811011
-+100:819201:-1:-1:819201:819202:819203
-+101:827393:-1:-1:827393:827394:827395
-+102:835585:-1:-1:835585:835586:835587
-+103:843777:-1:-1:843777:843778:843779
-+104:851969:-1:-1:851969:851970:851971
-+105:860161:-1:-1:860161:860162:860163
-+106:868353:-1:-1:868353:868354:868355
-+107:876545:-1:-1:876545:876546:876547
-+108:884737:-1:-1:884737:884738:884739
-+109:892929:-1:-1:892929:892930:892931
-+110:901121:-1:-1:901121:901122:901123
-+111:909313:-1:-1:909313:909314:909315
-+112:917505:-1:-1:917505:917506:917507
-+113:925697:-1:-1:925697:925698:925699
-+114:933889:-1:-1:933889:933890:933891
-+115:942081:-1:-1:942081:942082:942083
-+116:950273:-1:-1:950273:950274:950275
-+117:958465:-1:-1:958465:958466:958467
-+118:966657:-1:-1:966657:966658:966659
-+119:974849:-1:-1:974849:974850:974851
-+120:983041:-1:-1:983041:983042:983043
-+121:991233:-1:-1:991233:991234:991235
-+122:999425:-1:-1:999425:999426:999427
-+123:1007617:-1:-1:1007617:1007618:1007619
-+124:1015809:-1:-1:1015809:1015810:1015811
-+125:1024001:1024001:1024002-1024010:1024011:1024012:1024013
-+126:1032193:-1:-1:1032193:1032194:1032195
-+127:1040385:-1:-1:1040385:1040386:1040387
-+128:1048577:-1:-1:1048577:1048578:1048579
-+129:1056769:-1:-1:1056769:1056770:1056771
-+130:1064961:-1:-1:1064961:1064962:1064963
-+131:1073153:-1:-1:1073153:1073154:1073155
-+132:1081345:-1:-1:1081345:1081346:1081347
-+133:1089537:-1:-1:1089537:1089538:1089539
-+134:1097729:-1:-1:1097729:1097730:1097731
-+135:1105921:-1:-1:1105921:1105922:1105923
-+136:1114113:-1:-1:1114113:1114114:1114115
-+137:1122305:-1:-1:1122305:1122306:1122307
-+138:1130497:-1:-1:1130497:1130498:1130499
-+139:1138689:-1:-1:1138689:1138690:1138691
-+140:1146881:-1:-1:1146881:1146882:1146883
-+141:1155073:-1:-1:1155073:1155074:1155075
-+142:1163265:-1:-1:1163265:1163266:1163267
-+143:1171457:-1:-1:1171457:1171458:1171459
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
diff --git a/tests/r_32to64bit_expand_full/name b/tests/r_32to64bit_expand_full/name
deleted file mode 100644
index 2f046011bcf8..000000000000
--- a/tests/r_32to64bit_expand_full/name
+++ /dev/null
@@ -1 +0,0 @@
-convert a totally full filesystem to 64bit, then expand
diff --git a/tests/r_32to64bit_expand_full/script b/tests/r_32to64bit_expand_full/script
deleted file mode 100644
index 7a570841a350..000000000000
--- a/tests/r_32to64bit_expand_full/script
+++ /dev/null
@@ -1,83 +0,0 @@
-if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-
-FSCK_OPT=-fn
-OUT=$test_name.log
-EXP=$test_dir/expect
-CONF=$TMPFILE.conf
-
-#gzip -d < $EXP.gz > $EXP
-
-cat > $CONF << ENDL
-[fs_types]
-	ext4h = {
-		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg
-		blocksize = 1024
-		inode_size = 256
-		make_hugefiles = true
-		hugefiles_dir = /
-		hugefiles_slack = 0
-		hugefiles_name = aaaaa
-		hugefiles_digits = 4
-		hugefiles_size = 1M
-		zero_hugefiles = false
-	}
-ENDL
-
-echo "resize2fs test" > $OUT
-
-MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 786432 >> $OUT 2>&1
-rm -rf $CONF
-
-# check
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# convert it
-echo "resize2fs -b test.img" >> $OUT
-$RESIZE2FS -b -f $TMPFILE 2>&1 >> $OUT 2>&1
-$DUMPE2FS -g $TMPFILE 2>&1 >> $OUT.before 2> /dev/null
-
-# grow it
-echo "resize2fs test.img" >> $OUT
-dd if=/dev/zero of=$TMPFILE conv=notrunc bs=1 count=1 seek=1207959552 2> /dev/null
-$RESIZE2FS -f $TMPFILE 2>&1 >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# dump and check
-$DUMPE2FS -g $TMPFILE 2>&1 >> $OUT.after 2> /dev/null
-echo "Change in FS metadata:" >> $OUT
-diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-rm $TMPFILE
-
-#
-# Do the verification
-#
-
-sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
-mv $OUT.new $OUT
-
-cmp -s $OUT $EXP
-status=$?
-
-if [ "$status" = 0 ] ; then
-	echo "$test_name: $test_description: ok"
-	touch $test_name.ok
-else
-	echo "$test_name: $test_description: failed"
-	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-fi
-
-rm $OUT.before $OUT.after
-
-unset IMAGE FSCK_OPT OUT EXP CONF
-
-else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	echo "$test_name: $test_description: skipped"
-fi
-
diff --git a/tests/r_32to64bit_meta/expect b/tests/r_32to64bit_meta/expect
deleted file mode 100644
index 0eacd45037e4..000000000000
--- a/tests/r_32to64bit_meta/expect
+++ /dev/null
@@ -1,80 +0,0 @@
-resize2fs test
-Creating filesystem with 524288 1k blocks and 65536 inodes
-Superblock backups stored on blocks: 
-	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
-
-Allocating group tables:      done                            
-Writing inode tables:      done                            
-Creating journal (16384 blocks): done
-Creating 479 huge file(s) with 1024 blocks each: done
-Writing superblocks and filesystem accounting information:      done
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
-resize2fs test.img -b
-Converting the filesystem to 64-bit.
-The filesystem on test.img is now 524288 (1k) blocks long.
-
-Exit status is 0
-Change in FS metadata:
-@@ -2,7 +2,7 @@
- Last mounted on:          <not available>
- Filesystem magic number:  0xEF53
- Filesystem revision #:    1 (dynamic)
--Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
-+Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
- Default mount options:    user_xattr acl
- Filesystem state:         clean
- Errors behavior:          Continue
-@@ -10,11 +10,12 @@
- Inode count:              65536
- Block count:              524288
- Reserved block count:     26214
--Free blocks:              858
-+Free blocks:              852
- Free inodes:              65046
- First block:              1
- Block size:               1024
- Fragment size:            1024
-+Group descriptor size:    64
- Blocks per group:         8192
- Fragments per group:      8192
- Inodes per group:         1024
-@@ -54,9 +55,9 @@
- 12:98305:-1:-1:15:31:3107
- 13:106497:-1:-1:16:32:3363
- 14:114689:-1:-1:17:33:3619
--15:122881:-1:-1:18:34:3875
--16:131073:-1:-1:131073:131089:131105
--17:139265:-1:-1:131074:131090:131361
-+15:122881:-1:122881:18:34:3875
-+16:131073:-1:131073:135201:131089:131105
-+17:139265:-1:139265:131074:131090:131361
- 18:147457:-1:-1:131075:131091:131617
- 19:155649:-1:-1:131076:131092:131873
- 20:163841:-1:-1:131077:131093:132129
-@@ -86,9 +87,9 @@
- 44:360449:-1:-1:262158:262174:265250
- 45:368641:-1:-1:262159:262175:265506
- 46:376833:-1:-1:262160:262176:265762
--47:385025:-1:-1:262161:262177:266018
--48:393217:-1:-1:393217:393233:393249
--49:401409:401409:-1:393218:393234:393505
-+47:385025:-1:385025:262161:262177:266018
-+48:393217:-1:393217:397345:393233:393249
-+49:401409:401409:401410:393218:393234:393505
- 50:409601:-1:-1:393219:393235:393761
- 51:417793:-1:-1:393220:393236:394017
- 52:425985:-1:-1:393221:393237:394273
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
diff --git a/tests/r_32to64bit_meta/name b/tests/r_32to64bit_meta/name
deleted file mode 100644
index d83492eae8cf..000000000000
--- a/tests/r_32to64bit_meta/name
+++ /dev/null
@@ -1 +0,0 @@
-convert meta_bg 32bit fs to 64bit fs
diff --git a/tests/r_32to64bit_meta/script b/tests/r_32to64bit_meta/script
deleted file mode 100644
index 25872c4d4c45..000000000000
--- a/tests/r_32to64bit_meta/script
+++ /dev/null
@@ -1,74 +0,0 @@
-if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-
-FSCK_OPT=-fn
-OUT=$test_name.log
-EXP=$test_dir/expect
-CONF=$TMPFILE.conf
-
-cat > $CONF << ENDL
-[fs_types]
-	ext4h = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode
-		blocksize = 1024
-		inode_size = 256
-		make_hugefiles = true
-		hugefiles_dir = /
-		hugefiles_slack = 0
-		hugefiles_name = aaaaa
-		hugefiles_digits = 4
-		hugefiles_size = 1M
-		zero_hugefiles = false
-	}
-ENDL
-
-echo "resize2fs test" > $OUT
-
-MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
-rm -rf $CONF
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# resize it
-echo "resize2fs test.img -b" >> $OUT
-$RESIZE2FS -b -f $TMPFILE 2>&1 >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
-echo "Change in FS metadata:" >> $OUT
-diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-rm $TMPFILE $OUT.before $OUT.after
-
-#
-# Do the verification
-#
-
-sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
-mv $OUT.new $OUT
-
-cmp -s $OUT $EXP
-status=$?
-
-if [ "$status" = 0 ] ; then
-	echo "$test_name: $test_description: ok"
-	touch $test_name.ok
-else
-	echo "$test_name: $test_description: failed"
-	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-fi
-
-unset IMAGE FSCK_OPT OUT EXP CONF
-
-else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	echo "$test_name: $test_description: skipped"
-fi
-
diff --git a/tests/r_32to64bit_move_itable/expect b/tests/r_32to64bit_move_itable/expect
deleted file mode 100644
index b51663d5f86d..000000000000
--- a/tests/r_32to64bit_move_itable/expect
+++ /dev/null
@@ -1,107 +0,0 @@
-resize2fs test
-Creating filesystem with 786432 1k blocks and 98304 inodes
-Superblock backups stored on blocks: 
-	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
-
-Allocating group tables:      done                            
-Writing inode tables:      done                            
-Creating journal (16384 blocks): done
-Creating 727 huge file(s) with 1024 blocks each: done
-Writing superblocks and filesystem accounting information:      done
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
-resize2fs test.img -b
-Converting the filesystem to 64-bit.
-The filesystem on test.img is now 786432 (1k) blocks long.
-
-Exit status is 0
-Change in FS metadata:
-@@ -2,7 +2,7 @@
- Last mounted on:          <not available>
- Filesystem magic number:  0xEF53
- Filesystem revision #:    1 (dynamic)
--Filesystem features:      has_journal ext_attr dir_index filetype extent sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
-+Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
- Default mount options:    user_xattr acl
- Filesystem state:         clean
- Errors behavior:          Continue
-@@ -10,11 +10,12 @@
- Inode count:              98304
- Block count:              786432
- Reserved block count:     39321
--Free blocks:              764
-+Free blocks:              734
- Free inodes:              97566
- First block:              1
- Block size:               1024
- Fragment size:            1024
-+Group descriptor size:    64
- Blocks per group:         8192
- Fragments per group:      8192
- Inodes per group:         1024
-@@ -38,16 +39,16 @@
- 
- 
- group:block:super:gdt:bbitmap:ibitmap:itable
--0:1:1:2-4:5:6:7
--1:8193:8193:8194-8196:8197:8198:8199
-+0:1:1:2-7:8:9:10
-+1:8193:8193:8194-8199:8200:8201:8202
- 2:16385:-1:-1:16385:16386:16387
--3:24577:24577:24578-24580:24581:24582:24583
-+3:24577:24577:24578-24583:24584:24585:24586
- 4:32769:-1:-1:32769:32770:32771
--5:40961:40961:40962-40964:40965:40966:40967
-+5:40961:40961:40962-40967:40968:40969:40970
- 6:49153:-1:-1:49153:49154:49155
--7:57345:57345:57346-57348:57349:57350:57351
-+7:57345:57345:57346-57351:57352:57353:57354
- 8:65537:-1:-1:65537:65538:65539
--9:73729:73729:73730-73732:73733:73734:73735
-+9:73729:73729:73730-73735:73736:73737:73738
- 10:81921:-1:-1:81921:81922:81923
- 11:90113:-1:-1:90113:90114:90115
- 12:98305:-1:-1:98305:98306:98307
-@@ -63,9 +64,9 @@
- 22:180225:-1:-1:180225:180226:180227
- 23:188417:-1:-1:188417:188418:188419
- 24:196609:-1:-1:196609:196610:196611
--25:204801:204801:204802-204804:204805:204806:204807
-+25:204801:204801:204802-204807:204808:204809:204810
- 26:212993:-1:-1:212993:212994:212995
--27:221185:221185:221186-221188:221189:221190:221191
-+27:221185:221185:221186-221191:221192:221193:221194
- 28:229377:-1:-1:229377:229378:229379
- 29:237569:-1:-1:237569:237570:237571
- 30:245761:-1:-1:245761:245762:245763
-@@ -87,7 +88,7 @@
- 46:376833:-1:-1:376833:376834:376835
- 47:385025:-1:-1:385025:385026:385027
- 48:393217:-1:-1:393217:393218:393219
--49:401409:401409:401410-401412:401413:401414:401415
-+49:401409:401409:401410-401415:401416:401417:401418
- 50:409601:-1:-1:409601:409602:409603
- 51:417793:-1:-1:417793:417794:417795
- 52:425985:-1:-1:425985:425986:425987
-@@ -119,7 +120,7 @@
- 78:638977:-1:-1:638977:638978:638979
- 79:647169:-1:-1:647169:647170:647171
- 80:655361:-1:-1:655361:655362:655363
--81:663553:663553:663554-663556:663557:663558:663559
-+81:663553:663553:663554-663559:663560:663561:663562
- 82:671745:-1:-1:671745:671746:671747
- 83:679937:-1:-1:679937:679938:679939
- 84:688129:-1:-1:688129:688130:688131
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
diff --git a/tests/r_32to64bit_move_itable/name b/tests/r_32to64bit_move_itable/name
deleted file mode 100644
index 7e6bb254831a..000000000000
--- a/tests/r_32to64bit_move_itable/name
+++ /dev/null
@@ -1 +0,0 @@
-convert 32bit fs to 64bit fs, forcing inode table move
diff --git a/tests/r_32to64bit_move_itable/script b/tests/r_32to64bit_move_itable/script
deleted file mode 100644
index c188acdc31aa..000000000000
--- a/tests/r_32to64bit_move_itable/script
+++ /dev/null
@@ -1,74 +0,0 @@
-if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-
-FSCK_OPT=-fn
-OUT=$test_name.log
-EXP=$test_dir/expect
-CONF=$TMPFILE.conf
-
-cat > $CONF << ENDL
-[fs_types]
-	ext4h = {
-		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg
-		blocksize = 1024
-		inode_size = 256
-		make_hugefiles = true
-		hugefiles_dir = /
-		hugefiles_slack = 0
-		hugefiles_name = aaaaa
-		hugefiles_digits = 4
-		hugefiles_size = 1M
-		zero_hugefiles = false
-	}
-ENDL
-
-echo "resize2fs test" > $OUT
-
-MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 786432 >> $OUT 2>&1
-rm -rf $CONF
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# convert it
-echo "resize2fs test.img -b" >> $OUT
-$RESIZE2FS -b -f $TMPFILE 2>&1 >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
-echo "Change in FS metadata:" >> $OUT
-diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-rm $TMPFILE $OUT.before $OUT.after
-
-#
-# Do the verification
-#
-
-sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
-mv $OUT.new $OUT
-
-cmp -s $OUT $EXP
-status=$?
-
-if [ "$status" = 0 ] ; then
-	echo "$test_name: $test_description: ok"
-	touch $test_name.ok
-else
-	echo "$test_name: $test_description: failed"
-	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-fi
-
-unset IMAGE FSCK_OPT OUT EXP CONF
-
-else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	echo "$test_name: $test_description: skipped"
-fi
-
diff --git a/tests/r_64to32bit/expect b/tests/r_64to32bit/expect
deleted file mode 100644
index 13e94a2d2894..000000000000
--- a/tests/r_64to32bit/expect
+++ /dev/null
@@ -1,98 +0,0 @@
-resize2fs test
-Creating filesystem with 524288 1k blocks and 65536 inodes
-Superblock backups stored on blocks: 
-	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
-
-Allocating group tables:      done                            
-Writing inode tables:      done                            
-Creating journal (16384 blocks): done
-Creating 477 huge file(s) with 1024 blocks each: done
-Writing superblocks and filesystem accounting information:      done
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
-resize2fs test.img -s
-Converting the filesystem to 32-bit.
-The filesystem on test.img is now 524288 (1k) blocks long.
-
-Exit status is 0
-Change in FS metadata:
-@@ -2,7 +2,7 @@
- Last mounted on:          <not available>
- Filesystem magic number:  0xEF53
- Filesystem revision #:    1 (dynamic)
--Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
-+Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
- Default mount options:    user_xattr acl
- Filesystem state:         clean
- Errors behavior:          Continue
-@@ -10,12 +10,11 @@
- Inode count:              65536
- Block count:              524288
- Reserved block count:     26214
--Free blocks:              571
-+Free blocks:              589
- Free inodes:              65048
- First block:              1
- Block size:               1024
- Fragment size:            1024
--Group descriptor size:    64
- Reserved GDT blocks:      256
- Blocks per group:         8192
- Fragments per group:      8192
-@@ -41,16 +40,16 @@
- 
- 
- group:block:super:gdt:bbitmap:ibitmap:itable
--0:1:1:2-5:262:278:294
--1:8193:8193:8194-8197:263:279:550
-+0:1:1:2-3:262:278:294
-+1:8193:8193:8194-8195:263:279:550
- 2:16385:-1:-1:264:280:806
--3:24577:24577:24578-24581:265:281:1062
-+3:24577:24577:24578-24579:265:281:1062
- 4:32769:-1:-1:266:282:1318
--5:40961:40961:40962-40965:267:283:1574
-+5:40961:40961:40962-40963:267:283:1574
- 6:49153:-1:-1:268:284:1830
--7:57345:57345:57346-57349:269:285:2086
-+7:57345:57345:57346-57347:269:285:2086
- 8:65537:-1:-1:270:286:2342
--9:73729:73729:73730-73733:271:287:2598
-+9:73729:73729:73730-73731:271:287:2598
- 10:81921:-1:-1:272:288:2854
- 11:90113:-1:-1:273:289:3110
- 12:98305:-1:-1:274:290:3366
-@@ -66,9 +65,9 @@
- 22:180225:-1:-1:131079:131095:132641
- 23:188417:-1:-1:131080:131096:132897
- 24:196609:-1:-1:131081:131097:133153
--25:204801:204801:204802-204805:131082:131098:133409
-+25:204801:204801:204802-204803:131082:131098:133409
- 26:212993:-1:-1:131083:131099:133665
--27:221185:221185:221186-221189:131084:131100:133921
-+27:221185:221185:221186-221187:131084:131100:133921
- 28:229377:-1:-1:131085:131101:134177
- 29:237569:-1:-1:131086:131102:134433
- 30:245761:-1:-1:131087:131103:134689
-@@ -90,7 +89,7 @@
- 46:376833:-1:-1:262159:262175:265761
- 47:385025:-1:-1:262160:262176:266017
- 48:393217:-1:-1:393217:393233:393249
--49:401409:401409:401410-401413:393218:393234:393505
-+49:401409:401409:401410-401411:393218:393234:393505
- 50:409601:-1:-1:393219:393235:393761
- 51:417793:-1:-1:393220:393236:394017
- 52:425985:-1:-1:393221:393237:394273
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
diff --git a/tests/r_64to32bit/name b/tests/r_64to32bit/name
deleted file mode 100644
index 4c8237111295..000000000000
--- a/tests/r_64to32bit/name
+++ /dev/null
@@ -1 +0,0 @@
-convert flex_bg 64bit fs to 32bit fs
diff --git a/tests/r_64to32bit/script b/tests/r_64to32bit/script
deleted file mode 100644
index 5d959f03a6d9..000000000000
--- a/tests/r_64to32bit/script
+++ /dev/null
@@ -1,76 +0,0 @@
-if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-
-FSCK_OPT=-fn
-OUT=$test_name.log
-EXP=$test_dir/expect
-CONF=$TMPFILE.conf
-
-cat > $CONF << ENDL
-[fs_types]
-	ext4h = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
-		blocksize = 1024
-		inode_size = 256
-		make_hugefiles = true
-		hugefiles_dir = /
-		hugefiles_slack = 0
-		hugefiles_name = aaaaa
-		hugefiles_digits = 4
-		hugefiles_size = 1M
-		zero_hugefiles = false
-	}
-ENDL
-
-echo "resize2fs test" > $OUT
-
-MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
-rm -rf $CONF
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# resize it
-echo "resize2fs test.img -s" >> $OUT
-$RESIZE2FS -s -f $TMPFILE 2>&1 >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
-echo "Change in FS metadata:" >> $OUT
-diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-rm $TMPFILE
-
-#
-# Do the verification
-#
-
-sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
-mv $OUT.new $OUT
-
-cmp -s $OUT $EXP
-status=$?
-
-if [ "$status" = 0 ] ; then
-	echo "$test_name: $test_description: ok"
-	touch $test_name.ok
-else
-	echo "$test_name: $test_description: failed"
-	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-fi
-
-rm $OUT.before $OUT.after
-
-unset IMAGE FSCK_OPT OUT EXP CONF
-
-else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	echo "$test_name: $test_description: skipped"
-fi
-
diff --git a/tests/r_64to32bit_meta/expect b/tests/r_64to32bit_meta/expect
deleted file mode 100644
index d6e2dccc894b..000000000000
--- a/tests/r_64to32bit_meta/expect
+++ /dev/null
@@ -1,80 +0,0 @@
-resize2fs test
-Creating filesystem with 524288 1k blocks and 65536 inodes
-Superblock backups stored on blocks: 
-	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
-
-Allocating group tables:      done                            
-Writing inode tables:      done                            
-Creating journal (16384 blocks): done
-Creating 479 huge file(s) with 1024 blocks each: done
-Writing superblocks and filesystem accounting information:      done
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
-resize2fs test.img -s
-Converting the filesystem to 32-bit.
-The filesystem on test.img is now 524288 (1k) blocks long.
-
-Exit status is 0
-Change in FS metadata:
-@@ -2,7 +2,7 @@
- Last mounted on:          <not available>
- Filesystem magic number:  0xEF53
- Filesystem revision #:    1 (dynamic)
--Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
-+Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
- Default mount options:    user_xattr acl
- Filesystem state:         clean
- Errors behavior:          Continue
-@@ -10,12 +10,11 @@
- Inode count:              65536
- Block count:              524288
- Reserved block count:     26214
--Free blocks:              852
-+Free blocks:              858
- Free inodes:              65046
- First block:              1
- Block size:               1024
- Fragment size:            1024
--Group descriptor size:    64
- Blocks per group:         8192
- Fragments per group:      8192
- Inodes per group:         1024
-@@ -55,9 +54,9 @@
- 12:98305:-1:-1:15:31:3107
- 13:106497:-1:-1:16:32:3363
- 14:114689:-1:-1:17:33:3619
--15:122881:-1:122881:18:34:3875
--16:131073:-1:131073:131074:131090:131106
--17:139265:-1:139265:131075:131091:131362
-+15:122881:-1:-1:18:34:3875
-+16:131073:-1:-1:131074:131090:131106
-+17:139265:-1:-1:131075:131091:131362
- 18:147457:-1:-1:131076:131092:131618
- 19:155649:-1:-1:131077:131093:131874
- 20:163841:-1:-1:131078:131094:132130
-@@ -87,9 +86,9 @@
- 44:360449:-1:-1:262158:262174:265250
- 45:368641:-1:-1:262159:262175:265506
- 46:376833:-1:-1:262160:262176:265762
--47:385025:-1:385025:262161:262177:266018
--48:393217:-1:393217:393218:393234:393250
--49:401409:401409:401410:393219:393235:393506
-+47:385025:-1:-1:262161:262177:266018
-+48:393217:-1:-1:393218:393234:393250
-+49:401409:401409:-1:393219:393235:393506
- 50:409601:-1:-1:393220:393236:393762
- 51:417793:-1:-1:393221:393237:394018
- 52:425985:-1:-1:393222:393238:394274
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-Exit status is 0
diff --git a/tests/r_64to32bit_meta/name b/tests/r_64to32bit_meta/name
deleted file mode 100644
index e99ed8b8d1b2..000000000000
--- a/tests/r_64to32bit_meta/name
+++ /dev/null
@@ -1 +0,0 @@
-convert meta_bg 64bit fs to 32bit fs
diff --git a/tests/r_64to32bit_meta/script b/tests/r_64to32bit_meta/script
deleted file mode 100644
index 5a02e2664393..000000000000
--- a/tests/r_64to32bit_meta/script
+++ /dev/null
@@ -1,76 +0,0 @@
-if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-
-FSCK_OPT=-fn
-OUT=$test_name.log
-EXP=$test_dir/expect
-CONF=$TMPFILE.conf
-
-cat > $CONF << ENDL
-[fs_types]
-	ext4h = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode,64bit
-		blocksize = 1024
-		inode_size = 256
-		make_hugefiles = true
-		hugefiles_dir = /
-		hugefiles_slack = 0
-		hugefiles_name = aaaaa
-		hugefiles_digits = 4
-		hugefiles_size = 1M
-		zero_hugefiles = false
-	}
-ENDL
-
-echo "resize2fs test" > $OUT
-
-MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
-rm -rf $CONF
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# resize it
-echo "resize2fs test.img -s" >> $OUT
-$RESIZE2FS -s -f $TMPFILE 2>&1 >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-# dump and check
-($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
-echo "Change in FS metadata:" >> $OUT
-diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
-$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
-status=$?
-echo Exit status is $status >> $OUT
-
-rm $TMPFILE
-
-#
-# Do the verification
-#
-
-sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
-mv $OUT.new $OUT
-
-cmp -s $OUT $EXP
-status=$?
-
-if [ "$status" = 0 ] ; then
-	echo "$test_name: $test_description: ok"
-	touch $test_name.ok
-else
-	echo "$test_name: $test_description: failed"
-	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-fi
-
-rm $OUT.before $OUT.after
-
-unset IMAGE FSCK_OPT OUT EXP CONF
-
-else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	echo "$test_name: $test_description: skipped"
-fi
-
diff --git a/tests/t_32to64bit/expect b/tests/t_32to64bit/expect
new file mode 100644
index 000000000000..4b030e4b22cd
--- /dev/null
+++ b/tests/t_32to64bit/expect
@@ -0,0 +1,91 @@
+tune2fs test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O 64bit test.img
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -15,7 +15,8 @@
+ First block:              1
+ Block size:               1024
+ Fragment size:            1024
+-Reserved GDT blocks:      256
++Group descriptor size:    64
++Reserved GDT blocks:      254
+ Blocks per group:         8192
+ Fragments per group:      8192
+ Inodes per group:         1024
+@@ -40,16 +41,16 @@
+ 
+ 
+ group:block:super:gdt:bbitmap:ibitmap:itable
+-0:1:1:2-3:260:276:292
+-1:8193:8193:8194-8195:261:277:548
++0:1:1:2-5:260:276:292
++1:8193:8193:8194-8197:261:277:548
+ 2:16385:-1:-1:262:278:804
+-3:24577:24577:24578-24579:263:279:1060
++3:24577:24577:24578-24581:263:279:1060
+ 4:32769:-1:-1:264:280:1316
+-5:40961:40961:40962-40963:265:281:1572
++5:40961:40961:40962-40965:265:281:1572
+ 6:49153:-1:-1:266:282:1828
+-7:57345:57345:57346-57347:267:283:2084
++7:57345:57345:57346-57349:267:283:2084
+ 8:65537:-1:-1:268:284:2340
+-9:73729:73729:73730-73731:269:285:2596
++9:73729:73729:73730-73733:269:285:2596
+ 10:81921:-1:-1:270:286:2852
+ 11:90113:-1:-1:271:287:3108
+ 12:98305:-1:-1:272:288:3364
+@@ -65,9 +66,9 @@
+ 22:180225:-1:-1:131079:131095:132641
+ 23:188417:-1:-1:131080:131096:132897
+ 24:196609:-1:-1:131081:131097:133153
+-25:204801:204801:204802-204803:131082:131098:133409
++25:204801:204801:204802-204805:131082:131098:133409
+ 26:212993:-1:-1:131083:131099:133665
+-27:221185:221185:221186-221187:131084:131100:133921
++27:221185:221185:221186-221189:131084:131100:133921
+ 28:229377:-1:-1:131085:131101:134177
+ 29:237569:-1:-1:131086:131102:134433
+ 30:245761:-1:-1:131087:131103:134689
+@@ -89,7 +90,7 @@
+ 46:376833:-1:-1:262159:262175:265761
+ 47:385025:-1:-1:262160:262176:266017
+ 48:393217:-1:-1:393217:393233:393249
+-49:401409:401409:401410-401411:393218:393234:393505
++49:401409:401409:401410-401413:393218:393234:393505
+ 50:409601:-1:-1:393219:393235:393761
+ 51:417793:-1:-1:393220:393236:394017
+ 52:425985:-1:-1:393221:393237:394273
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_32to64bit/name b/tests/t_32to64bit/name
new file mode 100644
index 000000000000..fb45faba6468
--- /dev/null
+++ b/tests/t_32to64bit/name
@@ -0,0 +1 @@
+convert flex_bg 32bit fs to 64bit fs
diff --git a/tests/t_32to64bit/script b/tests/t_32to64bit/script
new file mode 100644
index 000000000000..695208cc7ec3
--- /dev/null
+++ b/tests/t_32to64bit/script
@@ -0,0 +1,74 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "tune2fs -O 64bit test.img" >> $OUT
+$TUNE2FS -O 64bit $TMPFILE 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else # if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/t_32to64bit_expand_full/expect b/tests/t_32to64bit_expand_full/expect
new file mode 100644
index 000000000000..2093c1df2e46
--- /dev/null
+++ b/tests/t_32to64bit_expand_full/expect
@@ -0,0 +1,136 @@
+tune2fs test
+Creating filesystem with 786432 1k blocks and 98304 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 727 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O 64bit test.img
+resize2fs test.img
+Resizing the filesystem on test.img to 1179648 (1k) blocks.
+The filesystem on test.img is now 1179648 (1k) blocks long.
+
+Exit status is 0
+Change in FS metadata:
+@@ -1,15 +1,15 @@
+ 
+ group:block:super:gdt:bbitmap:ibitmap:itable
+-0:1:1:2-7:8:9:10
+-1:8193:8193:8194-8199:8200:8201:8202
++0:1:1:2-10:266:267:268
++1:8193:8193:8194-8202:8458:8459:8460
+ 2:16385:-1:-1:16385:16386:16387
+-3:24577:24577:24578-24583:24584:24585:24586
++3:24577:24577:24578-24586:24842:24843:24844
+ 4:32769:-1:-1:32769:32770:32771
+-5:40961:40961:40962-40967:40968:40969:40970
++5:40961:40961:40962-40970:41226:41227:41228
+ 6:49153:-1:-1:49153:49154:49155
+-7:57345:57345:57346-57351:57352:57353:57354
++7:57345:57345:57346-57354:57610:57611:57612
+ 8:65537:-1:-1:65537:65538:65539
+-9:73729:73729:73730-73735:73736:73737:73738
++9:73729:73729:73730-73738:73994:73995:73996
+ 10:81921:-1:-1:81921:81922:81923
+ 11:90113:-1:-1:90113:90114:90115
+ 12:98305:-1:-1:98305:98306:98307
+@@ -25,9 +25,9 @@
+ 22:180225:-1:-1:180225:180226:180227
+ 23:188417:-1:-1:188417:188418:188419
+ 24:196609:-1:-1:196609:196610:196611
+-25:204801:204801:204802-204807:204808:204809:204810
++25:204801:204801:204802-204810:205066:205067:205068
+ 26:212993:-1:-1:212993:212994:212995
+-27:221185:221185:221186-221191:221192:221193:221194
++27:221185:221185:221186-221194:221450:221451:221452
+ 28:229377:-1:-1:229377:229378:229379
+ 29:237569:-1:-1:237569:237570:237571
+ 30:245761:-1:-1:245761:245762:245763
+@@ -49,7 +49,7 @@
+ 46:376833:-1:-1:376833:376834:376835
+ 47:385025:-1:-1:385025:385026:385027
+ 48:393217:-1:-1:393217:393218:393219
+-49:401409:401409:401410-401415:401416:401417:401418
++49:401409:401409:401410-401418:401674:401675:401676
+ 50:409601:-1:-1:409601:409602:409603
+ 51:417793:-1:-1:417793:417794:417795
+ 52:425985:-1:-1:425985:425986:425987
+@@ -81,7 +81,7 @@
+ 78:638977:-1:-1:638977:638978:638979
+ 79:647169:-1:-1:647169:647170:647171
+ 80:655361:-1:-1:655361:655362:655363
+-81:663553:663553:663554-663559:663560:663561:663562
++81:663553:663553:663554-663562:663818:663819:663820
+ 82:671745:-1:-1:671745:671746:671747
+ 83:679937:-1:-1:679937:679938:679939
+ 84:688129:-1:-1:688129:688130:688131
+@@ -96,3 +96,51 @@
+ 93:761857:-1:-1:761857:761858:761859
+ 94:770049:-1:-1:770049:770050:770051
+ 95:778241:-1:-1:778241:778242:778243
++96:786433:-1:-1:786433:786434:786435
++97:794625:-1:-1:794625:794626:794627
++98:802817:-1:-1:802817:802818:802819
++99:811009:-1:-1:811009:811010:811011
++100:819201:-1:-1:819201:819202:819203
++101:827393:-1:-1:827393:827394:827395
++102:835585:-1:-1:835585:835586:835587
++103:843777:-1:-1:843777:843778:843779
++104:851969:-1:-1:851969:851970:851971
++105:860161:-1:-1:860161:860162:860163
++106:868353:-1:-1:868353:868354:868355
++107:876545:-1:-1:876545:876546:876547
++108:884737:-1:-1:884737:884738:884739
++109:892929:-1:-1:892929:892930:892931
++110:901121:-1:-1:901121:901122:901123
++111:909313:-1:-1:909313:909314:909315
++112:917505:-1:-1:917505:917506:917507
++113:925697:-1:-1:925697:925698:925699
++114:933889:-1:-1:933889:933890:933891
++115:942081:-1:-1:942081:942082:942083
++116:950273:-1:-1:950273:950274:950275
++117:958465:-1:-1:958465:958466:958467
++118:966657:-1:-1:966657:966658:966659
++119:974849:-1:-1:974849:974850:974851
++120:983041:-1:-1:983041:983042:983043
++121:991233:-1:-1:991233:991234:991235
++122:999425:-1:-1:999425:999426:999427
++123:1007617:-1:-1:1007617:1007618:1007619
++124:1015809:-1:-1:1015809:1015810:1015811
++125:1024001:1024001:1024002-1024010:1024011:1024012:1024013
++126:1032193:-1:-1:1032193:1032194:1032195
++127:1040385:-1:-1:1040385:1040386:1040387
++128:1048577:-1:-1:1048577:1048578:1048579
++129:1056769:-1:-1:1056769:1056770:1056771
++130:1064961:-1:-1:1064961:1064962:1064963
++131:1073153:-1:-1:1073153:1073154:1073155
++132:1081345:-1:-1:1081345:1081346:1081347
++133:1089537:-1:-1:1089537:1089538:1089539
++134:1097729:-1:-1:1097729:1097730:1097731
++135:1105921:-1:-1:1105921:1105922:1105923
++136:1114113:-1:-1:1114113:1114114:1114115
++137:1122305:-1:-1:1122305:1122306:1122307
++138:1130497:-1:-1:1130497:1130498:1130499
++139:1138689:-1:-1:1138689:1138690:1138691
++140:1146881:-1:-1:1146881:1146882:1146883
++141:1155073:-1:-1:1155073:1155074:1155075
++142:1163265:-1:-1:1163265:1163266:1163267
++143:1171457:-1:-1:1171457:1171458:1171459
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_32to64bit_expand_full/name b/tests/t_32to64bit_expand_full/name
new file mode 100644
index 000000000000..2f046011bcf8
--- /dev/null
+++ b/tests/t_32to64bit_expand_full/name
@@ -0,0 +1 @@
+convert a totally full filesystem to 64bit, then expand
diff --git a/tests/t_32to64bit_expand_full/script b/tests/t_32to64bit_expand_full/script
new file mode 100644
index 000000000000..603c5818c1c3
--- /dev/null
+++ b/tests/t_32to64bit_expand_full/script
@@ -0,0 +1,83 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+#gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 786432 >> $OUT 2>&1
+rm -rf $CONF
+
+# check
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# convert it
+echo "tune2fs -O 64bit test.img" >> $OUT
+$TUNE2FS -O 64bit $TMPFILE 2>&1 >> $OUT 2>&1
+$DUMPE2FS -g $TMPFILE 2>&1 >> $OUT.before 2> /dev/null
+
+# grow it
+echo "resize2fs test.img" >> $OUT
+dd if=/dev/zero of=$TMPFILE conv=notrunc bs=1 count=1 seek=1207959552 2> /dev/null
+$RESIZE2FS -f $TMPFILE 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS -g $TMPFILE 2>&1 >> $OUT.after 2> /dev/null
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+rm $OUT.before $OUT.after
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/t_32to64bit_meta/expect b/tests/t_32to64bit_meta/expect
new file mode 100644
index 000000000000..28e328c524a8
--- /dev/null
+++ b/tests/t_32to64bit_meta/expect
@@ -0,0 +1,77 @@
+tune2fs test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 479 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O 64bit test.img
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -10,11 +10,12 @@
+ Inode count:              65536
+ Block count:              524288
+ Reserved block count:     26214
+-Free blocks:              858
++Free blocks:              852
+ Free inodes:              65046
+ First block:              1
+ Block size:               1024
+ Fragment size:            1024
++Group descriptor size:    64
+ Blocks per group:         8192
+ Fragments per group:      8192
+ Inodes per group:         1024
+@@ -54,9 +55,9 @@
+ 12:98305:-1:-1:15:31:3107
+ 13:106497:-1:-1:16:32:3363
+ 14:114689:-1:-1:17:33:3619
+-15:122881:-1:-1:18:34:3875
+-16:131073:-1:-1:131073:131089:131105
+-17:139265:-1:-1:131074:131090:131361
++15:122881:-1:122881:18:34:3875
++16:131073:-1:131073:135201:131089:131105
++17:139265:-1:139265:131074:131090:131361
+ 18:147457:-1:-1:131075:131091:131617
+ 19:155649:-1:-1:131076:131092:131873
+ 20:163841:-1:-1:131077:131093:132129
+@@ -86,9 +87,9 @@
+ 44:360449:-1:-1:262158:262174:265250
+ 45:368641:-1:-1:262159:262175:265506
+ 46:376833:-1:-1:262160:262176:265762
+-47:385025:-1:-1:262161:262177:266018
+-48:393217:-1:-1:393217:393233:393249
+-49:401409:401409:-1:393218:393234:393505
++47:385025:-1:385025:262161:262177:266018
++48:393217:-1:393217:397345:393233:393249
++49:401409:401409:401410:393218:393234:393505
+ 50:409601:-1:-1:393219:393235:393761
+ 51:417793:-1:-1:393220:393236:394017
+ 52:425985:-1:-1:393221:393237:394273
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_32to64bit_meta/name b/tests/t_32to64bit_meta/name
new file mode 100644
index 000000000000..d83492eae8cf
--- /dev/null
+++ b/tests/t_32to64bit_meta/name
@@ -0,0 +1 @@
+convert meta_bg 32bit fs to 64bit fs
diff --git a/tests/t_32to64bit_meta/script b/tests/t_32to64bit_meta/script
new file mode 100644
index 000000000000..9b02266e64c6
--- /dev/null
+++ b/tests/t_32to64bit_meta/script
@@ -0,0 +1,74 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "tune2fs -O 64bit test.img" >> $OUT
+$TUNE2FS -O 64bit $TMPFILE 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/t_32to64bit_move_itable/expect b/tests/t_32to64bit_move_itable/expect
new file mode 100644
index 000000000000..e4fa55432bb3
--- /dev/null
+++ b/tests/t_32to64bit_move_itable/expect
@@ -0,0 +1,104 @@
+tune2fs test
+Creating filesystem with 786432 1k blocks and 98304 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 727 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O 64bit test.img
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr dir_index filetype extent sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -10,11 +10,12 @@
+ Inode count:              98304
+ Block count:              786432
+ Reserved block count:     39321
+-Free blocks:              764
++Free blocks:              734
+ Free inodes:              97566
+ First block:              1
+ Block size:               1024
+ Fragment size:            1024
++Group descriptor size:    64
+ Blocks per group:         8192
+ Fragments per group:      8192
+ Inodes per group:         1024
+@@ -38,16 +39,16 @@
+ 
+ 
+ group:block:super:gdt:bbitmap:ibitmap:itable
+-0:1:1:2-4:5:6:7
+-1:8193:8193:8194-8196:8197:8198:8199
++0:1:1:2-7:8:9:10
++1:8193:8193:8194-8199:8200:8201:8202
+ 2:16385:-1:-1:16385:16386:16387
+-3:24577:24577:24578-24580:24581:24582:24583
++3:24577:24577:24578-24583:24584:24585:24586
+ 4:32769:-1:-1:32769:32770:32771
+-5:40961:40961:40962-40964:40965:40966:40967
++5:40961:40961:40962-40967:40968:40969:40970
+ 6:49153:-1:-1:49153:49154:49155
+-7:57345:57345:57346-57348:57349:57350:57351
++7:57345:57345:57346-57351:57352:57353:57354
+ 8:65537:-1:-1:65537:65538:65539
+-9:73729:73729:73730-73732:73733:73734:73735
++9:73729:73729:73730-73735:73736:73737:73738
+ 10:81921:-1:-1:81921:81922:81923
+ 11:90113:-1:-1:90113:90114:90115
+ 12:98305:-1:-1:98305:98306:98307
+@@ -63,9 +64,9 @@
+ 22:180225:-1:-1:180225:180226:180227
+ 23:188417:-1:-1:188417:188418:188419
+ 24:196609:-1:-1:196609:196610:196611
+-25:204801:204801:204802-204804:204805:204806:204807
++25:204801:204801:204802-204807:204808:204809:204810
+ 26:212993:-1:-1:212993:212994:212995
+-27:221185:221185:221186-221188:221189:221190:221191
++27:221185:221185:221186-221191:221192:221193:221194
+ 28:229377:-1:-1:229377:229378:229379
+ 29:237569:-1:-1:237569:237570:237571
+ 30:245761:-1:-1:245761:245762:245763
+@@ -87,7 +88,7 @@
+ 46:376833:-1:-1:376833:376834:376835
+ 47:385025:-1:-1:385025:385026:385027
+ 48:393217:-1:-1:393217:393218:393219
+-49:401409:401409:401410-401412:401413:401414:401415
++49:401409:401409:401410-401415:401416:401417:401418
+ 50:409601:-1:-1:409601:409602:409603
+ 51:417793:-1:-1:417793:417794:417795
+ 52:425985:-1:-1:425985:425986:425987
+@@ -119,7 +120,7 @@
+ 78:638977:-1:-1:638977:638978:638979
+ 79:647169:-1:-1:647169:647170:647171
+ 80:655361:-1:-1:655361:655362:655363
+-81:663553:663553:663554-663556:663557:663558:663559
++81:663553:663553:663554-663559:663560:663561:663562
+ 82:671745:-1:-1:671745:671746:671747
+ 83:679937:-1:-1:679937:679938:679939
+ 84:688129:-1:-1:688129:688130:688131
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_32to64bit_move_itable/name b/tests/t_32to64bit_move_itable/name
new file mode 100644
index 000000000000..7e6bb254831a
--- /dev/null
+++ b/tests/t_32to64bit_move_itable/name
@@ -0,0 +1 @@
+convert 32bit fs to 64bit fs, forcing inode table move
diff --git a/tests/t_32to64bit_move_itable/script b/tests/t_32to64bit_move_itable/script
new file mode 100644
index 000000000000..b0ac6e1d375d
--- /dev/null
+++ b/tests/t_32to64bit_move_itable/script
@@ -0,0 +1,74 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 786432 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# convert it
+echo "tune2fs -O 64bit test.img" >> $OUT
+$TUNE2FS -O 64bit $TMPFILE 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/t_64to32bit/expect b/tests/t_64to32bit/expect
new file mode 100644
index 000000000000..6d8ff8011a7c
--- /dev/null
+++ b/tests/t_64to32bit/expect
@@ -0,0 +1,95 @@
+tune2fs test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs test.img -s
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -10,12 +10,11 @@
+ Inode count:              65536
+ Block count:              524288
+ Reserved block count:     26214
+-Free blocks:              571
++Free blocks:              589
+ Free inodes:              65048
+ First block:              1
+ Block size:               1024
+ Fragment size:            1024
+-Group descriptor size:    64
+ Reserved GDT blocks:      256
+ Blocks per group:         8192
+ Fragments per group:      8192
+@@ -41,16 +40,16 @@
+ 
+ 
+ group:block:super:gdt:bbitmap:ibitmap:itable
+-0:1:1:2-5:262:278:294
+-1:8193:8193:8194-8197:263:279:550
++0:1:1:2-3:262:278:294
++1:8193:8193:8194-8195:263:279:550
+ 2:16385:-1:-1:264:280:806
+-3:24577:24577:24578-24581:265:281:1062
++3:24577:24577:24578-24579:265:281:1062
+ 4:32769:-1:-1:266:282:1318
+-5:40961:40961:40962-40965:267:283:1574
++5:40961:40961:40962-40963:267:283:1574
+ 6:49153:-1:-1:268:284:1830
+-7:57345:57345:57346-57349:269:285:2086
++7:57345:57345:57346-57347:269:285:2086
+ 8:65537:-1:-1:270:286:2342
+-9:73729:73729:73730-73733:271:287:2598
++9:73729:73729:73730-73731:271:287:2598
+ 10:81921:-1:-1:272:288:2854
+ 11:90113:-1:-1:273:289:3110
+ 12:98305:-1:-1:274:290:3366
+@@ -66,9 +65,9 @@
+ 22:180225:-1:-1:131079:131095:132641
+ 23:188417:-1:-1:131080:131096:132897
+ 24:196609:-1:-1:131081:131097:133153
+-25:204801:204801:204802-204805:131082:131098:133409
++25:204801:204801:204802-204803:131082:131098:133409
+ 26:212993:-1:-1:131083:131099:133665
+-27:221185:221185:221186-221189:131084:131100:133921
++27:221185:221185:221186-221187:131084:131100:133921
+ 28:229377:-1:-1:131085:131101:134177
+ 29:237569:-1:-1:131086:131102:134433
+ 30:245761:-1:-1:131087:131103:134689
+@@ -90,7 +89,7 @@
+ 46:376833:-1:-1:262159:262175:265761
+ 47:385025:-1:-1:262160:262176:266017
+ 48:393217:-1:-1:393217:393233:393249
+-49:401409:401409:401410-401413:393218:393234:393505
++49:401409:401409:401410-401411:393218:393234:393505
+ 50:409601:-1:-1:393219:393235:393761
+ 51:417793:-1:-1:393220:393236:394017
+ 52:425985:-1:-1:393221:393237:394273
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_64to32bit/name b/tests/t_64to32bit/name
new file mode 100644
index 000000000000..4c8237111295
--- /dev/null
+++ b/tests/t_64to32bit/name
@@ -0,0 +1 @@
+convert flex_bg 64bit fs to 32bit fs
diff --git a/tests/t_64to32bit/script b/tests/t_64to32bit/script
new file mode 100644
index 000000000000..dd01a9c1cfd8
--- /dev/null
+++ b/tests/t_64to32bit/script
@@ -0,0 +1,76 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "tune2fs test.img -s" >> $OUT
+$TUNE2FS -O ^64bit $TMPFILE 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+rm $OUT.before $OUT.after
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/t_64to32bit_meta/expect b/tests/t_64to32bit_meta/expect
new file mode 100644
index 000000000000..d6e2dccc894b
--- /dev/null
+++ b/tests/t_64to32bit_meta/expect
@@ -0,0 +1,80 @@
+resize2fs test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 479 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+resize2fs test.img -s
+Converting the filesystem to 32-bit.
+The filesystem on test.img is now 524288 (1k) blocks long.
+
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr dir_index filetype meta_bg extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -10,12 +10,11 @@
+ Inode count:              65536
+ Block count:              524288
+ Reserved block count:     26214
+-Free blocks:              852
++Free blocks:              858
+ Free inodes:              65046
+ First block:              1
+ Block size:               1024
+ Fragment size:            1024
+-Group descriptor size:    64
+ Blocks per group:         8192
+ Fragments per group:      8192
+ Inodes per group:         1024
+@@ -55,9 +54,9 @@
+ 12:98305:-1:-1:15:31:3107
+ 13:106497:-1:-1:16:32:3363
+ 14:114689:-1:-1:17:33:3619
+-15:122881:-1:122881:18:34:3875
+-16:131073:-1:131073:131074:131090:131106
+-17:139265:-1:139265:131075:131091:131362
++15:122881:-1:-1:18:34:3875
++16:131073:-1:-1:131074:131090:131106
++17:139265:-1:-1:131075:131091:131362
+ 18:147457:-1:-1:131076:131092:131618
+ 19:155649:-1:-1:131077:131093:131874
+ 20:163841:-1:-1:131078:131094:132130
+@@ -87,9 +86,9 @@
+ 44:360449:-1:-1:262158:262174:265250
+ 45:368641:-1:-1:262159:262175:265506
+ 46:376833:-1:-1:262160:262176:265762
+-47:385025:-1:385025:262161:262177:266018
+-48:393217:-1:393217:393218:393234:393250
+-49:401409:401409:401410:393219:393235:393506
++47:385025:-1:-1:262161:262177:266018
++48:393217:-1:-1:393218:393234:393250
++49:401409:401409:-1:393219:393235:393506
+ 50:409601:-1:-1:393220:393236:393762
+ 51:417793:-1:-1:393221:393237:394018
+ 52:425985:-1:-1:393222:393238:394274
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_64to32bit_meta/name b/tests/t_64to32bit_meta/name
new file mode 100644
index 000000000000..e99ed8b8d1b2
--- /dev/null
+++ b/tests/t_64to32bit_meta/name
@@ -0,0 +1 @@
+convert meta_bg 64bit fs to 32bit fs
diff --git a/tests/t_64to32bit_meta/script b/tests/t_64to32bit_meta/script
new file mode 100644
index 000000000000..478709e0c3c1
--- /dev/null
+++ b/tests/t_64to32bit_meta/script
@@ -0,0 +1,76 @@
+if -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "tune2fs test.img -s" >> $OUT
+$TUNE2FS -O ^64bit $TMPFILE 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2> /dev/null | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+rm $OUT.before $OUT.after
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/u_onefile_bad/script b/tests/u_onefile_bad/script
index 60c9a2e64a26..090deb619e6f 100644
--- a/tests/u_onefile_bad/script
+++ b/tests/u_onefile_bad/script
@@ -1,7 +1,7 @@
 test_description="check that we cant append a bad undo file"
-if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+if -x $E2UNDO_EXE; then
 
-TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
 OUT=$test_name.log
 rm -f $TDB_FILE >/dev/null 2>&1
 fail=0
@@ -41,10 +41,10 @@ if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${f
 fi
 $FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
 
-echo using resize2fs to test e2undo >> $OUT
-$RESIZE2FS -z $TDB_FILE.1 -b $TMPFILE >> $OUT 2>&1
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -z $TDB_FILE.1 -O 64bit $TMPFILE >> $OUT 2>&1
 crc2=`$CRCSUM $TMPFILE`
-echo $CRCSUM after resize2fs $crc2 >> $OUT
+echo $CRCSUM after tune2fs $crc2 >> $OUT
 features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
 if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
 	echo "FS features: ${features}" >> $OUT
diff --git a/tests/u_revert_64bitmcsum_onefile/script b/tests/u_revert_64bitmcsum_onefile/script
index f1d7c2bc9d3f..ae80ecd5c3c6 100644
--- a/tests/u_revert_64bitmcsum_onefile/script
+++ b/tests/u_revert_64bitmcsum_onefile/script
@@ -1,7 +1,7 @@
 test_description="convert fs to 64bit,metadata_csum and revert as one undo file"
-if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+if test -x $E2UNDO_EXE; then
 
-TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
 OUT=$test_name.log
 rm -f $TDB_FILE >/dev/null 2>&1
 fail=0
@@ -41,10 +41,10 @@ if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${f
 fi
 $FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
 
-echo using resize2fs to test e2undo >> $OUT
-$RESIZE2FS -z $TDB_FILE.1 -b $TMPFILE >> $OUT 2>&1
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -z $TDB_FILE.1 -O 64bit $TMPFILE >> $OUT 2>&1
 crc2=`$CRCSUM $TMPFILE`
-echo $CRCSUM after resize2fs $crc2 >> $OUT
+echo $CRCSUM after tune2fs $crc2 >> $OUT
 features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
 if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
 	echo "FS features: ${features}" >> $OUT
diff --git a/tests/u_revert_all_onefile/script b/tests/u_revert_all_onefile/script
index 27b3b23557fa..c748b81ee275 100644
--- a/tests/u_revert_all_onefile/script
+++ b/tests/u_revert_all_onefile/script
@@ -1,7 +1,7 @@
 test_description="convert fs to 64bit,metadata_csum and revert as one undo file"
-if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+if test -x $E2UNDO_EXE; then
 
-TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
 OUT=$test_name.log
 rm -f $TDB_FILE >/dev/null 2>&1
 fail=0
@@ -41,10 +41,10 @@ if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${f
 fi
 $FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
 
-echo using resize2fs to test e2undo >> $OUT
-$RESIZE2FS -z $TDB_FILE.0 -b $TMPFILE >> $OUT 2>&1
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -z $TDB_FILE.0 -O 64bit $TMPFILE >> $OUT 2>&1
 crc2=`$CRCSUM $TMPFILE`
-echo $CRCSUM after resize2fs $crc2 >> $OUT
+echo $CRCSUM after tune2fs $crc2 >> $OUT
 features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
 if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
 	echo "FS features: ${features}" >> $OUT
diff --git a/tests/u_revert_upgrade_to_64bitmcsum/script b/tests/u_revert_upgrade_to_64bitmcsum/script
index 6120d00f6386..3e1817e32eb5 100644
--- a/tests/u_revert_upgrade_to_64bitmcsum/script
+++ b/tests/u_revert_upgrade_to_64bitmcsum/script
@@ -1,7 +1,7 @@
 test_description="convert fs to 64bit,metadata_csum and revert both changes"
-if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+if test -x $E2UNDO_EXE; then
 
-TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
 OUT=$test_name.log
 rm -f $TDB_FILE >/dev/null 2>&1
 fail=0
@@ -41,10 +41,10 @@ if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${f
 fi
 $FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
 
-echo using resize2fs to test e2undo >> $OUT
-$RESIZE2FS -z $TDB_FILE.1 -b $TMPFILE >> $OUT 2>&1
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -z $TDB_FILE.1 -O 64bit $TMPFILE >> $OUT 2>&1
 crc2=`$CRCSUM $TMPFILE`
-echo $CRCSUM after resize2fs $crc2 >> $OUT
+echo $CRCSUM after tune2fs $crc2 >> $OUT
 features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
 if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
 	echo "FS features: ${features}" >> $OUT
@@ -101,10 +101,10 @@ if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${f
 fi
 $FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
 
-echo roll back resize2fs >> $OUT
+echo roll back tune2fs >> $OUT
 $E2UNDO $TDB_FILE.1 $TMPFILE  >> $OUT 2>&1
 crc1_2=`$CRCSUM $TMPFILE`
-echo $CRCSUM after e2undo resize2fs $crc1_2 >> $OUT
+echo $CRCSUM after e2undo tune2fs $crc1_2 >> $OUT
 features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
 if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -gt 0 ]; then
 	echo "FS features: ${features}" >> $OUT
-- 
2.1.4

