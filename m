From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] e2fsck: don't flush the FS unless it's actually dirty
Date: Tue, 12 Aug 2014 10:17:07 -0700
Message-ID: <20140812171707.GI2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dan Jacobson <jidanni@jidanni.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21589 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbaHLRRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Aug 2014 13:17:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_flush2() unconditionally writes the block group descriptors to
disk even if the underlying FS isn't marked dirty.  This causes the
following error message on a fsck -n run:

# e2fsck -fn /tmp/a
e2fsck 1.43-WIP (09-Jul-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Error writing block 2 (Attempt to write block to filesystem resulted in short write).  Ignore error? no

Error writing block 2 (Attempt to write block to filesystem resulted in short write).  Ignore error? no

Error writing file system info: Attempt to write block to filesystem resulted in short write

Since ext2fs_close2() only calls flush if the dirty flag is set,
modify e2fsck to exhibit the same behavior so that we don't spit out
write errors for a read only check.

v2: Fix test to use $CRCSUM instead of md5sum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c                  |    8 ++++---
 tests/f_readonly_fsck/expect   |   11 ++++++++++
 tests/f_readonly_fsck/image.gz |  Bin
 tests/f_readonly_fsck/name     |    1 +
 tests/f_readonly_fsck/script   |   46 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 3 deletions(-)
 create mode 100644 tests/f_readonly_fsck/expect
 create mode 100644 tests/f_readonly_fsck/image.gz
 create mode 100644 tests/f_readonly_fsck/name
 create mode 100644 tests/f_readonly_fsck/script

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 78bf3f4..6b0ca96 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1762,9 +1762,11 @@ no_journal:
 	}
 
 	e2fsck_write_bitmaps(ctx);
-	pctx.errcode = ext2fs_flush(ctx->fs);
-	if (pctx.errcode)
-		fix_problem(ctx, PR_6_FLUSH_FILESYSTEM, &pctx);
+	if (fs->flags & EXT2_FLAG_DIRTY) {
+		pctx.errcode = ext2fs_flush(ctx->fs);
+		if (pctx.errcode)
+			fix_problem(ctx, PR_6_FLUSH_FILESYSTEM, &pctx);
+	}
 	pctx.errcode = io_channel_flush(ctx->fs->io);
 	if (pctx.errcode)
 		fix_problem(ctx, PR_6_IO_FLUSH, &pctx);
diff --git a/tests/f_readonly_fsck/expect b/tests/f_readonly_fsck/expect
new file mode 100644
index 0000000..994dfa4
--- /dev/null
+++ b/tests/f_readonly_fsck/expect
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong (4294968254, counted=958).
+Fix? no
+
+test_filesys: 11/256 files (9.1% non-contiguous), 18446744069414585410/2048 blocks
+Exit status is 0
+crc did not change.  2466215161
diff --git a/tests/f_readonly_fsck/image.gz b/tests/f_readonly_fsck/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..59f9cd91144b4b1978a59551f49e17f8740763e3
GIT binary patch
literal 2538
zcmb2|=3uD${UVr&`R!fXY!OEZ_7Cah{=)j5o>vaJaV!&T5nvKq)EX5LS$W?<CBlPg
zpUAQ<d55EJE^D@SO#LR5bJXdN(8dcKo~uNj-+6oV^y!6-0+VCv?0>w!_g2>W%^REG
zb1n?+Vbd;28_x8T@9vm-ZK=ImRA%g)$k-LGS6**Dx~6jFpL_d4o#RjCoO(LNzw*f9
zl79vtzux&ReSP2l+0r|{emVKseD`OA=IC`_*8TpI_3rei^Xb>^_x~$<_O`oPe3Q;@
zp}&>Ccdqhw4Y~H$KHs+L-mcFXrwUFby;>f1{9AicaeRvGzpELK{f=Hpem~d4a<<XM
zHUFoYT)WL&th%i3r6L0=xKaDHR_XTa<MY=ZR=gH*dzt;F8l6+6dB2p;A3t`=v_`Be
ztFHXlzvj=AFY_<Yo2|X@_LtmM|DP^eQ~zMX1~J(c^$vfTU&#mjZ}`Q2#eTs*#;^Qf
zA@)OmmUipkHg-sTn=CeW`?_~q`pcJzGd@UI`Tfu1@&(y585vQWk??;eFnrcNt>5<h
zahAz+nOnE&F5c<4ShT%zjb5tsG|g-stCCCE$?a+K%MVv9-BkJ~)o|0{>ic){ejAF+
zy`|s&@751}v!4HMxjkFXHES-`JgnL6>T)*w?zW%D{utlO{CD#4m-uJ%|4j+r#gAey
zI%k2lsAlipwf#$Ed|!4JU4Nadd3DM@jqkhVJS^p&);)F(d}q#wu4j}#8UmvsFd71*
ZAut*OqaiTRA#nGJx!?1P-xwGa7yyTBAU6O2

literal 0
HcmV?d00001

diff --git a/tests/f_readonly_fsck/name b/tests/f_readonly_fsck/name
new file mode 100644
index 0000000..97ab428
--- /dev/null
+++ b/tests/f_readonly_fsck/name
@@ -0,0 +1 @@
+ensure that a readonly check doesn't modify the fs
diff --git a/tests/f_readonly_fsck/script b/tests/f_readonly_fsck/script
new file mode 100644
index 0000000..d46c5a8
--- /dev/null
+++ b/tests/f_readonly_fsck/script
@@ -0,0 +1,46 @@
+FSCK_OPT=-fn
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
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+gzip -d < $test_dir/image.gz > $TMPFILE
+
+old="$($CRCSUM < $TMPFILE)"
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+new="$($CRCSUM < $TMPFILE)"
+
+if [ "${old}" != "${new}" ]; then
+	echo "ERROR: crc mismatch!  ${old} ${new}" >> $OUT
+else
+	echo "crc did not change.  ${old}" >> $OUT
+fi
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
+unset IMAGE FSCK_OPT OUT EXP old new
