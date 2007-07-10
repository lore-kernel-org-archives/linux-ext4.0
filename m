From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Random corruption test for e2fsck
Date: Tue, 10 Jul 2007 18:37:40 +0530
Message-ID: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6Li0RNTpFKN640kQMOAj"
Cc: TheodoreTso <tytso@mit.edu>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:56115 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbXGJNGv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 09:06:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-6Li0RNTpFKN640kQMOAj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This is a random corruption test which can be included in the e2fsprogs
regression tests. It does the following:
1) Create an test fs and format it with ext2/3/4 and random selection of
features.
2) Mount it and copy data into it.
3) Move around the blocks of the filesystem randomly causing corruption.
Also overwrite some random blocks with garbage from /dev/urandom. Create
a copy of this corrupted filesystem.
4) Unmount and run e2fsck. If the first run of e2fsck produces any
errors like uncorrected errors, library error, segfault, usage error,
etc. then it is deemed a bug. But in any case, a second run of e2fsck is
done to check if it renders the filesystem clean. 
5) If the test went by without any errors the test image is deleted and
in case of any errors the user is notified that the log of this test run
should be mailed to linux-ext4@ and the image should be preserved.

Any comments are welcome.

---
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>


Thanks,
Kalpak.


--=-6Li0RNTpFKN640kQMOAj
Content-Disposition: attachment; filename=e2fsprogs-tests-f_random_corruption.patch
Content-Type: text/x-patch; name=e2fsprogs-tests-f_random_corruption.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: e2fsprogs-regression/tests/f_random_corruption/script
===================================================================
--- /dev/null
+++ e2fsprogs-regression/tests/f_random_corruption/script
@@ -0,0 +1,277 @@
+# This is to make sure that if this test fails other tests can still be run
+# instead of doing an exit. We break before the end of the loop.
+while (( 1 )); do
+
+# choose block and inode sizes randomly
+BLK_SIZES=(1024 2048 4096)
+INODE_SIZES=(128 256 512 1024)
+
+SEED=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }')
+RANDOM=$SEED
+
+IMAGE=${IMAGE:-$TMPFILE}
+DATE=`date '+%Y%m%d%H%M%S'`
+ARCHIVE=$IMAGE.$DATE
+SIZE=${SIZE:-$(( 192000 + RANDOM + RANDOM )) }
+FS_TYPE=${FS_TYPE:-ext3}
+BLK_SIZE=${BLK_SIZES[(( $RANDOM % ${#BLK_SIZES[*]} ))]}
+INODE_SIZE=${INODE_SIZES[(( $RANDOM % ${#INODE_SIZES[*]} ))]}
+DEF_FEATURES="sparse_super,filetype,resize_inode,dir_index"
+FEATURES=${FEATURES:-$DEF_FEATURES}
+MOUNT_OPTS="-o loop"
+MNTPT=$test_dir/temp
+OUT=$test_name.$DATE.log
+
+# Do you want to try and mount the filesystem?
+MOUNT_AFTER_CORRUPTION=${MOUNT_AFTER_CORRUPTION:-"no"}
+# Do you want to remove the files from the mounted filesystem? Ideally use it
+# only in test environment.
+REMOVE_FILES=${REMOVE_FILES:-"no"}
+
+# In KB
+CORRUPTION_SIZE=${CORRUPTION_SIZE:-16}
+CORRUPTION_ITERATIONS=${CORRUPTION_ITERATIONS:-5}
+
+MKFS=../misc/mke2fs
+E2FSCK=../e2fsck/e2fsck
+FIRST_FSCK_OPTS="-fyv"
+SECOND_FSCK_OPTS="-fyv"
+
+# Lets check if the image can fit in the current filesystem.
+BASE_BS=`stat -f . | grep "Block size:" | cut -d " " -f3`
+BASE_AVAIL_BLOCKS=`stat -f . | grep "Available:" | cut -d ":" -f5`
+
+if (( BASE_BS * BASE_AVAIL_BLOCKS < NUM_BLKS * BLK_SIZE )); then
+	echo "The base filesystem does not have enough space to accomodate the"
+	echo "test image. Aborting test...."
+	break;
+fi
+
+# Lets have a journal more times than not.
+HAVE_JOURNAL=$(( $RANDOM % 12 ))
+if (( HAVE_JOURNAL == 0 )); then
+	FS_TYPE="ext2"
+	HAVE_JOURNAL=""
+else
+	HAVE_JOURNAL="-j"
+fi
+
+# Experimental features should not be used too often.
+LAZY_BG=$(( $RANDOM % 12 ))
+if (( LAZY_BG == 0 )); then
+       	FEATURES=$FEATURES,lazy_bg
+fi
+META_BG=$(( $RANDOM % 12 ))
+if (( META_BG == 0 )); then
+       	FEATURES=$FEATURES,meta_bg
+fi
+
+modprobe ext4 2> /dev/null
+modprobe ext4dev 2> /dev/null
+
+# If ext4 is present in the kernel then we can play with ext4 options
+EXT4=`grep ext4 /proc/filesystems`
+if [ -n "$EXT4" ]; then
+	USE_EXT4=$(( $RANDOM % 2 ))
+	if (( USE_EXT4 == 1 )); then
+		FS_TYPE="ext4dev"
+	fi
+fi
+
+if [ "$FS_TYPE" = "ext4dev" ]; then
+	UNINIT_GROUPS=$(( $RANDOM % 12 ))
+	if (( UNINIT_GROUPS == 0 )); then
+		FEATURES=$FEATURES,uninit_groups
+	fi
+	EXPAND_ESIZE=$(( $RANDOM % 12 ))
+	if (( EXPAND_EISIZE == 0 )); then
+		FIRST_FSCK_OPTS=$FIRST_FSCK_OPTS," -E expand_extra_isize"
+	fi
+fi
+
+MKFS_OPTS=" $HAVE_JOURNAL -b $BLK_SIZE -I $INODE_SIZE -O $FEATURES"
+
+NUM_BLKS=$(( (SIZE * 1024) / BLK_SIZE ))
+
+unset_vars()
+{
+	unset IMAGE DATE ARCHIVE FS_TYPE SIZE BLK_SIZE MKFS_OPTS MOUNT_OPTS
+	unset E2FSCK FIRST_FSCK_OPTS SECOND_FSCK_OPTS OUT
+}
+
+cleanup()
+{
+	echo "Error occured..." >> $OUT.failed
+        umount -f $MNTPT > /dev/null 2>&1 | tee -a $OUT
+	echo " failed"
+	echo "*** This appears to be a bug in e2fsprogs ***"
+	echo "Please contact linux-ext4 for further assistance."
+	echo "Include $OUT as an attachment, and save $ARCHIVE locally for future reference."
+	unset_vars
+	break;
+}
+
+echo -n "Random corruption test for e2fsck:"
+# Truncate the output log file
+> $OUT
+
+get_random_location()
+{
+	total=$1
+
+	tmp=$(( (RANDOM * 32768) % total ))
+
+	# Try and have more corruption in metadata at the start of the
+	# filesystem.
+	if (( tmp % 3 == 0 || tmp % 5 == 0 || tmp % 7 == 0 )); then
+		tmp=$(( $tmp % 32768 ))
+	fi
+
+	echo $tmp
+}
+
+make_fs_dirty()
+{
+        MAX_BLKS_TO_DIRTY=${1:-NUM_BLKS}
+        from=$(( (RANDOM * RANDOM) % NUM_BLKS ))
+
+        # Number of blocks to write garbage into should be within fs and should
+        # not be too many.
+        num_blks_to_dirty=$(( RANDOM % MAX_BLKS_TO_DIRTY ))
+
+        # write garbage into the selected blocks
+        dd if=/dev/urandom of=$IMAGE seek=$from conv=notrunc count=$num_blks_to_dirty bs=$BLK_SIZE >> $OUT 2>&1
+}
+
+
+touch $IMAGE
+echo "Format the filesystem image..." >> $OUT
+echo >> $OUT
+# Write some garbage blocks into the filesystem to make sure e2fsck has to do
+# a more difficult job than checking blocks of zeroes.
+echo "Copy some random data into filesystem image...." >> $OUT
+make_fs_dirty
+echo "$MKFS $MKFS_OPTS -F $IMAGE  >> $OUT" >> $OUT
+$MKFS $MKFS_OPTS -F $IMAGE $NUM_BLKS >> $OUT 2>&1
+if [ $? -ne 0 ]
+then
+	zero_size=`grep "Device size reported to be zero" $OUT`
+	short_write=`grep "Attempt to write block from filesystem resulted in short write" $OUT`
+
+	if (( zero_size != 0 || short_write != 0 )); then
+		echo "mkfs failed due to device size of 0 or a short write. This is harmless and need not be reported."
+	else
+		echo "mkfs failed - internal error during operation. Aborting random regression test..."
+		cleanup;
+	fi
+fi
+
+mkdir -p $MNTPT
+if [ $? -ne 0 ]
+then
+	echo "Failed to create or find mountpoint...." >> $OUT
+fi
+
+mount -t $FS_TYPE $MOUNT_OPTS $IMAGE $MNTPT > /dev/null 2>&1 | tee -a $OUT
+if [ $? -ne 0 ]
+then
+	echo "Unable to mount file system - skipped" >> $OUT
+else
+	df -h >> $OUT
+	echo "Copying data into the test filesystem..." >> $OUT
+
+	cp -r ../ $MNTPT >> $OUT 2>&1
+	sync
+	umount -f $MNTPT > /dev/null 2>&1 | tee -a $OUT
+fi
+
+echo "Corrupt the image by moving around blocks of data..." >> $OUT
+echo >> $OUT
+for (( i = 0; i < $CORRUPTION_ITERATIONS; i++ ))
+do
+	from=`get_random_location $NUM_BLKS`
+	to=`get_random_location $NUM_BLKS`
+
+	echo "Moving $CORRUPTION_SIZE KB data from $(($from * $BLK_SIZE)) " >> $OUT
+	echo " to $(($to * $BLK_SIZE))." >> $OUT
+	dd if=$IMAGE of=$IMAGE bs=1k count=$CORRUPTION_SIZE conv=notrunc skip=$from seek=$to >> $OUT 2>&1
+
+	# more corruption by overwriting blocks from within the filesystem.
+	make_fs_dirty $(( NUM_BLKS / 256 ))
+done
+
+# Copy the image for reproducing the bug.
+cp --sparse=auto $IMAGE $ARCHIVE >> $OUT 2>&1
+
+echo "First pass of fsck..." >> $OUT
+$E2FSCK $FIRST_FSCK_OPTS $IMAGE >> $OUT 2>&1
+RET=$?
+CORRECTED=$(( $RET & 1 ))
+REBOOT=$(( $RET & 2 ))
+UNCORRECTED=$(( $RET & 4 ))
+OPERROR=$(( $RET & 8 ))
+USEERROR=$(( $RET & 16 ))
+CANCELED=$(( $RET & 32 ))
+LIBERROR=$(( $RET & 128 ))
+
+# Run e2fsck for the second time and check if the problem gets solved. After
+# we can report error with pass1.
+export PASS1_ERROR
+PASS1_ERROR="no"
+[ $CORRECTED == 0 ] || { echo "The first fsck corrected errors" >> $OUT; }
+[ $REBOOT == 0 ] || { echo "The first fsck wants a reboot" >> $OUT.failed; PASS1_ERROR="yes"; }
+[ $UNCORRECTED == 0 ] || { echo "The first fsck left uncorrected errors" >> $OUT.failed; PASS1_ERROR="yes"; }
+[ $OPERROR == 0 ] || { echo "The first fsck claims there was an operational error" >> $OUT.failed; PASS1_ERROR="yes"; }
+[ $USEERROR == 0 ] || { echo "The first fsck claims there was a usage error" >> $OUT.failed; PASS1_ERROR="yes"; }
+[ $CANCELED == 0 ] || { echo "The first fsck claims it was canceled" >> $OUT.failed; PASS1_ERROR="yes"; }
+[ $LIBERROR == 0 ] || { echo "The first fsck claims there was a library error" >> $OUT.failed; PASS1_ERROR="yes"; }
+
+echo --------------------------------------------------------- >> $OUT
+
+echo "Second pass of fsck..." >> $OUT
+$E2FSCK $SECOND_FSCK_OPTS $IMAGE >> $OUT 2>&1
+RET=$?
+CORRECTED=$(( $RET & 1 ))
+REBOOT=$(( $RET & 2 ))
+UNCORRECTED=$(( $RET & 4 ))
+OPERROR=$(( $RET & 8 ))
+USEERROR=$(( $RET & 16 ))
+CANCELED=$(( $RET & 32 ))
+LIBERROR=$(( $RET & 128 ))
+[ $CORRECTED == 0 ] || { echo "The second fsck claimed to correct errors!" >> $OUT.failed; cleanup; }
+[ $REBOOT == 0 ] || { echo "The second fsck wants a reboot" >> $OUT.failed; cleanup; }
+[ $UNCORRECTED == 0 ] || { echo "The second fsck left uncorrected errors" >> $OUT.failed; cleanup; }
+[ $OPERROR == 0 ] || { echo "The second fsck claims there was an operational error" >> $OUT.failed; cleanup; }
+[ $USEERROR == 0 ] || { echo "The second fsck claims there was a usage error" >> $OUT.failed;  cleanup; }
+[ $CANCELED == 0 ] || { echo "The second fsck claims it was canceled" >> $OUT.failed;  cleanup; }
+[ $LIBERROR == 0 ] || { echo "The second fsck claims there was a library error" >> $OUT.failed; cleanup; }
+
+if [ "PASS1_ERROR" = "yes" ]; then
+	cleanup;
+fi
+
+if [ "$MOUNT_AFTER_CORRUPTION" = "yes" ]; then
+	mount -t $FS_TYPE $MOUNT_OPTS $IMAGE $MNTPT 2>&1 | tee -a $OUT
+	if [ $? -ne 0 ]
+	then
+		echo "Unable to mount file system - skipped" >> $OUT
+	fi
+
+	if [ "$REMOVE_FILES" = "yes" ]; then
+		rm -rf $MNTPT/* >> $OUT
+	fi
+	umount -f $MNTPT > /dev/null 2>&1 | tee -a $OUT
+fi
+
+rm -f	$ARCHIVE
+rm -f	$OUT.failed
+
+# Report success
+echo "ok"
+echo "Succeeded..." > $OUT.ok
+
+unset_vars
+
+break;
+
+done
Index: e2fsprogs-regression/tests/Makefile.in
===================================================================
--- e2fsprogs-regression.orig/tests/Makefile.in
+++ e2fsprogs-regression/tests/Makefile.in
@@ -24,6 +24,8 @@ test_script: test_script.in Makefile
 	@chmod +x test_script
 
 check:: test_script
+	@echo "Removing remnants of earlier tests..."
+	$(RM) -f *~ *.log *.new *.failed *.ok test.img2*
 	@echo "Running e2fsprogs test suite..."
 	@echo " "
 	@./test_script
@@ -63,7 +65,7 @@ testend: test_script ${TDIR}/image
 	@echo "If all is well, edit ${TDIR}/name and rename ${TDIR}."
 
 clean::
-	$(RM) -f *~ *.log *.new *.failed *.ok test.img test_script
+	$(RM) -f *~ *.log *.new *.failed *.ok test.img* test_script
 
 distclean:: clean
 	$(RM) -f Makefile

--=-6Li0RNTpFKN640kQMOAj--
