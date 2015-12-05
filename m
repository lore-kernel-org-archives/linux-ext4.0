From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 8/8] tune2fs: recover the journal
Date: Fri, 04 Dec 2015 18:45:07 -0800
Message-ID: <20151205024507.31087.42777.stgit@birch.djwong.org>
References: <20151205024416.31087.14808.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbbLECpL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 21:45:11 -0500
In-Reply-To: <20151205024416.31087.14808.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the journal needs to be recovered to avoid clobbering whatever
changes tune2fs makes, do so.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/Makefile.in              |    2 +
 misc/tune2fs.c                |   22 ++++++++++-----
 tests/t_replay_and_set/expect |   36 +++++++++++++++++++++++++
 tests/t_replay_and_set/name   |    1 +
 tests/t_replay_and_set/script |   60 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+), 9 deletions(-)
 create mode 100644 tests/t_replay_and_set/expect
 create mode 100644 tests/t_replay_and_set/name
 create mode 100644 tests/t_replay_and_set/script


diff --git a/misc/Makefile.in b/misc/Makefile.in
index 52cd5bb..98872df 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -47,7 +47,7 @@ UMANPAGES=	chattr.1 lsattr.1 @UUID_CMT@ uuidgen.1
 
 LPROGS=		@E2INITRD_PROG@
 
-TUNE2FS_OBJS=	tune2fs.o util.o
+TUNE2FS_OBJS=	tune2fs.o util.o journal.o recovery.o revoke.o
 MKLPF_OBJS=	mklost+found.o
 MKE2FS_OBJS=	mke2fs.o util.o default_profile.o mk_hugefiles.o \
 			create_inode.o
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 457e9e5..657349a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -113,6 +113,7 @@ struct blk_move {
 	blk64_t new_loc;
 };
 
+errcode_t ext2fs_run_ext3_journal(ext2_filsys *fs);
 
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
 static const char *please_dir_fsck =
@@ -3139,15 +3140,20 @@ retry_open:
 		free(ext_mount_opts);
 	}
 
-	/* Warn if file system needs recovery and it is opened for writing. */
+	/* Recover the journal if possible. */
 	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & EXT2_MF_MOUNTED) &&
-	    (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
-	    (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER)) {
-		fprintf(stderr,
-_("Warning: The journal is dirty. You may wish to replay the journal like:\n\n"
-  "\te2fsck -E journal_only %s\n\n"
-  "then rerun this command.  Otherwise, any changes made may be overwritten\n"
-  "by journal recovery.\n"), device_name);
+	    ext2fs_has_feature_journal_needs_recovery(fs->super)) {
+		errcode_t err;
+
+		printf(_("Recovering journal.\n"));
+		err = ext2fs_run_ext3_journal(&fs);
+		if (err) {
+			com_err("tune2fs", err, "while recovering journal.\n");
+			printf(_("Please run e2fsck -fy %s.\n"), argv[1]);
+			goto closefs;
+		}
+		ext2fs_clear_feature_journal_needs_recovery(fs->super);
+		ext2fs_mark_super_dirty(fs);
 	}
 
 	free(device_name);
diff --git a/tests/t_replay_and_set/expect b/tests/t_replay_and_set/expect
new file mode 100644
index 0000000..f491937
--- /dev/null
+++ b/tests/t_replay_and_set/expect
@@ -0,0 +1,36 @@
+64-bit filesystem support is not enabled.  The larger fields afforded by this feature enable full-strength checksumming.  Pass -O 64bit to rectify.
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
+debugfs write journal
+disable metadata_csum on a dirty-journal fs
+Recovering journal.
+fsck the whole mess
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(0--1050) +(32768--36880)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 1
diff --git a/tests/t_replay_and_set/name b/tests/t_replay_and_set/name
new file mode 100644
index 0000000..4e4759e
--- /dev/null
+++ b/tests/t_replay_and_set/name
@@ -0,0 +1 @@
+recover journal and clear features
diff --git a/tests/t_replay_and_set/script b/tests/t_replay_and_set/script
new file mode 100644
index 0000000..1253099
--- /dev/null
+++ b/tests/t_replay_and_set/script
@@ -0,0 +1,60 @@
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
+$MKE2FS -F -o Linux -b 4096 -O has_journal,metadata_csum -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*bitmap at \([0-9]*\).*$/\1/g' | tr '\n' ',')"
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+echo "disable metadata_csum on a dirty-journal fs" >> $OUT
+$TUNE2FS -O ^metadata_csum $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+echo "fsck the whole mess" >> $OUT
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

