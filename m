From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Random corruption test for e2fsck
Date: Wed, 11 Jul 2007 10:03:43 -0600
Message-ID: <20070711160343.GA13027@schatzie.adilger.int>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <4693A9FA.7040106@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:55972 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbXGKQDq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 12:03:46 -0400
Content-Disposition: inline
In-Reply-To: <4693A9FA.7040106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Jul 10, 2007  10:47 -0500, Eric Sandeen wrote:
> Seems like a pretty good idea.  I had played with such a thing using
> fsfuzzer... fsfuzzer always seemed at least as useful useful as a fsck
> tester than a kernel code tester anyway.  (OOC, did you look at fsfuzzer
> when you did this?)

The person who originally started it had looked at fsfuzzer, but I haven't
myself.

> My only concern is that since it's introducing random corruption, new
> things will probably pop up from time to time; when we do an rpm build
> for Fedora/RHEL, it automatically runs make check:
> 
> %check
> make check

Yes, we added this to our .spec file also, though I didn't realize rpm
had a %check stanza in it.  We just added it into the %build stanza,
but this is something that should be pushed upstream, since it really
makes sense to ensure e2fsprogs is built & running correctly.

> which seems like a reasonably good idea to me.  However, I'd rather not
> have last-minute build failures introduced by new random collection of
> bits that have never been seen before.  Maybe "make RANDOM=0 check" as
> an option would be a good idea for automated builds...?

I've added this to the updated version:
$ f_random_corruption=skip ./test_script f_random_corruption
f_random_corruption: skipped

I wonder if it makes sense to add this as a generic functionality to
test_script, something like:

	[ `eval \$$test_name` = "skip" ] && echo "skipped"

Latest version of the script is attached.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-tests-f_random_corruption.patch"

Index: e2fsprogs-cfs/tests/f_random_corruption/script
===================================================================
--- /dev/null
+++ e2fsprogs-cfs/tests/f_random_corruption/script
@@ -0,0 +1,268 @@
+# This is to make sure that if this test fails other tests can still be run
+# instead of doing an exit. We break before the end of the loop.
+while (( 1 )); do
+[ "$f_random_corruption" = "skip" ] && echo "skipped" && break
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
+OUT=$test_name.log
+FAILED=$test_name.failed
+OKFILE=$test_name.ok
+
+# Do you want to try and mount the filesystem?
+MOUNT_AFTER_CORRUPTION=${MOUNT_AFTER_CORRUPTION:-"no"}
+# Do you want to remove the files from the mounted filesystem?
+# Ideally use it only in test environment.
+REMOVE_FILES=${REMOVE_FILES:-"no"}
+
+# In KB
+CORRUPTION_SIZE=${CORRUPTION_SIZE:-64}
+CORRUPTION_ITERATIONS=${CORRUPTION_ITERATIONS:-5}
+
+MKFS=../misc/mke2fs
+E2FSCK=../e2fsck/e2fsck
+FIRST_FSCK_OPTS="-fyv"
+SECOND_FSCK_OPTS="-fyv"
+
+# Lets check if the image can fit in the current filesystem.
+BASE_DIR=`dirname $IMAGE`
+BASE_AVAIL_BLOCKS=`df -P -k $BASE_DIR  | awk '/%/ { print $4 }'`
+
+if (( BASE_AVAIL_BLOCKS < NUM_BLKS * (BLK_SIZE / 1024) )); then
+	echo "$BASE_DIR does not have enough space to accomodate test image."
+	echo "Skipping test...."
+	break;
+fi
+
+# Lets have a journal more times than not.
+HAVE_JOURNAL=$((RANDOM % 12 ))
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
+	USE_EXT4=$((RANDOM % 2 ))
+	if (( USE_EXT4 == 1 )); then
+		FS_TYPE="ext4dev"
+	fi
+fi
+
+if [ "$FS_TYPE" = "ext4dev" ]; then
+	UNINIT_GROUPS=$((RANDOM % 12 ))
+	if (( UNINIT_GROUPS == 0 )); then
+		FEATURES=$FEATURES,uninit_groups
+	fi
+	EXPAND_ESIZE=$((RANDOM % 12 ))
+	if (( EXPAND_EISIZE == 0 )); then
+		FIRST_FSCK_OPTS=$FIRST_FSCK_OPTS," -E expand_extra_isize"
+	fi
+fi
+
+MKFS_OPTS=" $HAVE_JOURNAL -b $BLK_SIZE -I $INODE_SIZE -O $FEATURES"
+
+NUM_BLKS=$(( (SIZE * 1024) / BLK_SIZE ))
+
+log()
+{
+	[ "$VERBOSE" ] && echo "$*"
+	echo "$*" >> $OUT
+}
+
+error()
+{
+	log "$*"
+	echo "$*" >> $FAILED
+}
+
+unset_vars()
+{
+	unset IMAGE DATE ARCHIVE FS_TYPE SIZE BLK_SIZE MKFS_OPTS MOUNT_OPTS
+	unset E2FSCK FIRST_FSCK_OPTS SECOND_FSCK_OPTS OUT FAILED OKFILE
+}
+
+cleanup()
+{
+	[ "$1" ] && error "$*" || error "Error occured..."
+        umount -f $MNTPT > /dev/null 2>&1 | tee -a $OUT
+	cp $OUT $OUT.$DATE
+	echo " failed"
+	echo "*** This appears to be a bug in e2fsprogs ***"
+	echo "Please contact linux-ext4@vger.kernel.org for further assistance."
+	echo "Include $OUT.$DATE, and save $ARCHIVE locally for reference."
+	unset_vars
+	break;
+}
+
+echo -n "Random corruption test for e2fsck:"
+# Truncate the output log file
+rm -f $FAILED $OKFILE
+> $OUT
+
+get_random_location()
+{
+	total=$1
+
+	tmp=$(((RANDOM * 32768) % total))
+
+	# Try and have more corruption in metadata at the start of the
+	# filesystem.
+	if ((tmp % 3 == 0 || tmp % 5 == 0 || tmp % 7 == 0)); then
+		tmp=$((tmp % 32768))
+	fi
+
+	echo $tmp
+}
+
+make_fs_dirty()
+{
+        from=`get_random_location $NUM_BLKS`
+
+        # Number of blocks to write garbage into should be within fs and should
+        # not be too many.
+        num_blks_to_dirty=$((RANDOM % $1))
+
+        # write garbage into the selected blocks
+	[ ! -c /dev/urandom ] && return
+	log "writing ${num_blks_to_dirty}kB random garbage at offset ${from}kB"
+        dd if=/dev/urandom of=$IMAGE bs=1kB seek=$from conv=notrunc \
+		count=$num_blks_to_dirty bs=$BLK_SIZE >> $OUT 2>&1
+}
+
+
+touch $IMAGE
+log "Format the filesystem image..."
+log
+# Write some garbage blocks into the filesystem to make sure e2fsck has to do
+# a more difficult job than checking blocks of zeroes.
+log "Copy some random data into filesystem image...."
+make_fs_dirty 32768
+log "$MKFS $MKFS_OPTS -F $IMAGE  >> $OUT"
+$MKFS $MKFS_OPTS -F $IMAGE $NUM_BLKS >> $OUT 2>&1
+if [ $? -ne 0 ]
+then
+	zero_size=`grep "Device size reported to be zero" $OUT`
+	short_write=`grep "Attempt to write block from filesystem resulted in short write" $OUT`
+
+	if (( zero_size != 0 || short_write != 0 )); then
+		echo "mkfs failed due to device size of 0 or a short write. This is harmless and need not be reported."
+	else
+		cleanup "mkfs failed - internal error during operation. Aborting random regression test..."
+	fi
+fi
+
+mkdir -p $MNTPT
+if [ $? -ne 0 ]; then
+	log "Failed to create or find mountpoint...."
+else
+	mount -t $FS_TYPE $MOUNT_OPTS $IMAGE $MNTPT 2>&1 | tee -a $OUT |\
+		grep -v "only root can do that"
+	if [ $? -ne 0 ]; then
+		log "Unable to mount file system - skipped"
+	else
+		df -h $MNTPT >> $OUT
+		df -i $MNTPT >> $OUT
+		log "Copying data into the test filesystem..."
+
+		cp -r ../ $MNTPT >> $OUT 2>&1
+		sync
+		umount -f $MNTPT > /dev/null 2>&1 | tee -a $OUT
+	fi
+fi
+
+log "Corrupt the image by moving around blocks of data..."
+log
+for (( i = 0; i < $CORRUPTION_ITERATIONS; i++ )); do
+	from=`get_random_location $NUM_BLKS`
+	to=`get_random_location $NUM_BLKS`
+
+	log "Moving ${CORRUPTION_SIZE}kB from block ${from}kB to ${to}kB"
+	dd if=$IMAGE of=$IMAGE bs=1k count=$CORRUPTION_SIZE conv=notrunc skip=$from seek=$to >> $OUT 2>&1
+
+	# more corruption by overwriting blocks from within the filesystem.
+	make_fs_dirty $CORRUPTION_SIZE
+done
+
+# Copy the image for reproducing the bug.
+cp --sparse=always $IMAGE $ARCHIVE >> $OUT 2>&1
+
+log "First pass of fsck..."
+$E2FSCK $FIRST_FSCK_OPTS $IMAGE >> $OUT 2>&1
+RET=$?
+
+# Run e2fsck for the second time and check if the problem gets solved.
+# After we can report error with pass1.
+[ $((RET & 1)) == 0 ] || log "The first fsck corrected errors"
+[ $((RET & 2)) == 0 ] || error "The first fsck wants a reboot"
+[ $((RET & 4)) == 0 ] || error "The first fsck left uncorrected errors"
+[ $((RET & 8)) == 0 ] || error "The first fsck reports an operational error"
+[ $((RET & 16)) == 0 ] || error "The first fsck reports there was a usage error"
+[ $((RET & 32)) == 0 ] || error "The first fsck reports it was cancelled"
+[ $((RET & 128)) == 0 ] || error "The first fsck reports a library error"
+
+log "---------------------------------------------------------"
+
+log "Second pass of fsck..."
+$E2FSCK $SECOND_FSCK_OPTS $IMAGE >> $OUT 2>&1
+RET=$?
+[ $((RET & 1)) == 0 ] || cleanup "The second fsck corrected errors!"
+[ $((RET & 2)) == 0 ] || cleanup "The second fsck wants a reboot"
+[ $((RET & 4)) == 0 ] || cleanup "The second fsck left uncorrected errors"
+[ $((RET & 8)) == 0 ] || cleanup "The second fsck reports an operational error"
+[ $((RET & 16)) == 0 ] || cleanup "The second fsck reports a usage error"
+[ $((RET & 32)) == 0 ] || cleanup "The second fsck reports it was cancelled"
+[ $((RET & 128)) == 0 ] || cleanup "The second fsck reports a library error"
+
+[ -f $FAILED ] && cleanup
+
+if [ "$MOUNT_AFTER_CORRUPTION" = "yes" ]; then
+	mount -t $FS_TYPE $MOUNT_OPTS $IMAGE $MNTPT 2>&1 | tee -a $OUT
+	[ $? -ne 0 ] && log "Unable to mount file system - skipped"
+
+	[ "$REMOVE_FILES" = "yes" ] && rm -rf $MNTPT/* >> $OUT
+	umount -f $MNTPT > /dev/null 2>&1 | tee -a $OUT
+fi
+
+rm -f $ARCHIVE
+
+# Report success
+echo "ok"
+echo "Succeeded..." > $OKFILE
+
+unset_vars
+
+break; # this breaks out of the while(1) wrapping this test
+done
Index: e2fsprogs-cfs/tests/Makefile.in
===================================================================
--- e2fsprogs-cfs.orig/tests/Makefile.in
+++ e2fsprogs-cfs/tests/Makefile.in
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

--oyUTqETQ0mS9luUI--
