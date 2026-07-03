Received: from omta004.cacentral1.a.cloudfilter.net (omta002.cacentral1.a.cloudfilter.net [3.97.99.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B956E17736
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 23:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.97.99.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783121524; cv=none; b=OyZomKnptBdj3n4TrEt5l/znxtS8jVdBiBEU+fWAgKEWNeCMs/HiIt51zTP2RAJHC+dI2gKkYScUXYAzqhMxrNrqosUl03RIsRWimOjuBZn8stEC4XrDjRajWbUwspRol9H0vrK/Qkla2eVECZgIPWBuVP8nNx9s6ESRY2G+fxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783121524; c=relaxed/simple;
	bh=EHRNgsTSOWIhcY2kfe2HHhS/an+qm5bhrOAkYRaqwrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDegtPyEGqh0hGm0eLEJX7/Scv8LL17IbFCiD/0GgFKsmOY0g8CC8a2ED2XlqjnIXIWzkDb0CxSnf1FsoPfmUFQtSooHxDyB6lR2x7FOPeJvEeT7Qvh9IQOFHHVcg5l2BV4vycSujtLIuhJVbjBg3EzVYH5YT5KwQ4vt+SJeMc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; arc=none smtp.client-ip=3.97.99.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Received: from shw-obgw-4002b.ext.cloudfilter.net ([10.228.9.233])
	by cmsmtp with ESMTPS
	id fdeVwWDbI2ZUlfnKyweSke; Fri, 03 Jul 2026 23:30:24 +0000
Received: from cabot.adilger.int ([70.77.200.158])
	by cmsmtp with ESMTP
	id fnKxw5uqbDkZufnKyweBzh; Fri, 03 Jul 2026 23:30:24 +0000
X-Authority-Analysis: v=2.4 cv=IP4PywvG c=1 sm=1 tr=0 ts=6a484610
 a=0Thh8+fbYSyN3T2vM72L7A==:117 a=0Thh8+fbYSyN3T2vM72L7A==:17 a=UqCG9HQmAAAA:8
 a=RPJ6JBhKAAAA:8 a=nkeG-6mv0YwDr5m2u2MA:9 a=3ZKOabzyN94A:10
 a=fa_un-3J20JGBB2Tu-mn:22
From: Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>,
	Feng Xue <feng.xue@outlook.com>
Subject: [PATCH v2 2/2] libext2fs: fix inode_blocks overflow in ext2fs_open()
Date: Fri,  3 Jul 2026 17:29:33 -0600
Message-ID: <20260703233023.666459-2-adilger@dilger.ca>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260703233023.666459-1-adilger@dilger.ca>
References: <20260703233023.666459-1-adilger@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDVWDEuGwbTGDYL8/RqToP3l41BQ6JPfl7RIONu9YjZFZlgSOBBLCxOm1mnmff1JRXkQV+uOjqonRN5i7g+/RPi7dWJygazCoFbOX9ftxnjRIYCHhzDO
 IgEeYorVhd/+bUdTO3n/O0cKA9NUlykFI6v/GObKwfD3JdyTl51IY6qkCNTo7LKVQVnKCXQ9ODRz2mAFwkLrm86OVjDExV87GpgZW0wvi1ifK26EFxEWCHvy
 KcXIvi13hMI22Jun8yBbbseXQJLj/joeLza4M+OK1K7XOiBId+UEhFDofBdOBUZM

Fix an overflow when calculating inode_blocks_per_group with an
intermediate 32-bit variable for an invalid s_inodes_per_group value.
With blocksize=65536, inodes_per_group=262145 * inodesize=16384
intermediate product overflows 2^32 temporarily before being reduced
again by the blocksize.

Check inodes_per_group validity before using it in the calculation,
to avoid intermediate overflow, but also use a 64-bit variable in
the inode_blocks_per_group calculation just in case.

Add the f_64kblock test case to verify that debugfs does not consider
this a valid filesystem, and e2fsck will flag that superblock as bad
and load a backup superblock to get a valid s_inodes_per_group value.

Filter out the mke2fs warnings about large blocksize from test output
since these will be different/absent depending on the host page size.

Reported-by: Feng Xue <feng.xue@outlook.com>
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/openfs.c     | 11 +++++---
 tests/f_64kblock/expect | 37 +++++++++++++++++++++++++
 tests/f_64kblock/name   |  1 +
 tests/f_64kblock/script | 60 +++++++++++++++++++++++++++++++++++++++++
 tests/filter.sed        |  2 ++
 5 files changed, 107 insertions(+), 4 deletions(-)
 create mode 100644 tests/f_64kblock/expect
 create mode 100644 tests/f_64kblock/name
 create mode 100755 tests/f_64kblock/script

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 2b8e0e753c..da4b3d9cec 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -356,10 +356,14 @@ retry:
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-	fs->inode_blocks_per_group = ((EXT2_INODES_PER_GROUP(fs->super) *
+	if (EXT2_INODES_PER_GROUP(fs->super) >
+	    EXT2_MAX_INODES_PER_GROUP(fs->super)) {
+		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
+		goto cleanup;
+	}
+	fs->inode_blocks_per_group = (((__u64)EXT2_INODES_PER_GROUP(fs->super) *
 				       EXT2_INODE_SIZE(fs->super) +
-				       EXT2_BLOCK_SIZE(fs->super) - 1) /
-				      EXT2_BLOCK_SIZE(fs->super));
+				       fs->blocksize - 1) / fs->blocksize);
 	if (block_size) {
 		if (block_size != fs->blocksize) {
 			retval = EXT2_ET_UNEXPECTED_BLOCK_SIZE;
@@ -394,7 +398,6 @@ retry:
 	blocks_per_group = EXT2_BLOCKS_PER_GROUP(fs->super);
 	if (blocks_per_group < 8 ||
 	    blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(fs->super) ||
-	    fs->inode_blocks_per_group > EXT2_MAX_INODES_PER_GROUP(fs->super) ||
            EXT2_DESC_PER_BLOCK(fs->super) == 0 ||
            fs->super->s_first_data_block >= ext2fs_blocks_count(fs->super)) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
diff --git a/tests/f_64kblock/expect b/tests/f_64kblock/expect
new file mode 100644
index 0000000000..59814959bc
--- /dev/null
+++ b/tests/f_64kblock/expect
@@ -0,0 +1,37 @@
+mke2fs -F -o Linux -b 65536 -I 16384 -N 24 test.img 262144
+Creating filesystem with 262112 64k blocks and 32 inodes
+Superblock backups stored on blocks: 
+	65528, 196584
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+../e2fsck/e2fsck -yf -N test_filesys f_64kblock/test_img
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (0.0% non-contiguous), 29/262112 blocks
+Exit status is 0
+-----------------------------------------------
+ 
+debugfs -R 'set_super_value inodes_per_group 262145' -w test.img
+Exit status is 0
+debugfs -R 'lsdel' test.img
+debugfs: The ext2 superblock is corrupt while trying to open test.img
+lsdel: Filesystem not open
+Exit status is 0
+../e2fsck/e2fsck -yf -N test_filesys f_64kblock/test_img
+ext2fs_open2: The ext2 superblock is corrupt
+../e2fsck/e2fsck: Superblock invalid, trying backup blocks...
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/32 files (0.0% non-contiguous), 29/262112 blocks
+Exit status is 1
diff --git a/tests/f_64kblock/name b/tests/f_64kblock/name
new file mode 100644
index 0000000000..f737e26fd7
--- /dev/null
+++ b/tests/f_64kblock/name
@@ -0,0 +1 @@
+calculate inode_blocks_per_group for large-block fs
diff --git a/tests/f_64kblock/script b/tests/f_64kblock/script
new file mode 100755
index 0000000000..6907d393fa
--- /dev/null
+++ b/tests/f_64kblock/script
@@ -0,0 +1,60 @@
+test_description="debugfs inode_overflow check"
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs)"
+	return 0
+fi
+
+FSCK_OPT=-yf
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP
+else
+	EXP=$test_dir/expect
+fi
+
+TMPFILE=$test_dir/test_img
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -F -o Linux -b 65536 -I 16384 -N 24 test.img 262144 > $OUT.new
+$MKE2FS -F -o Linux -b 65536 -I 16384 -N 24 $TMPFILE 262144 >> $OUT.new 2>&1
+
+echo $FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+
+echo ----------------------------------------------- >> $OUT.new
+
+echo " " >> $OUT.new
+echo "debugfs -R 'set_super_value inodes_per_group 262145' -w test.img" >> $OUT.new
+$DEBUGFS -R "set_super_value inodes_per_group 262145" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+
+echo "debugfs -R 'lsdel' test.img" >> $OUT.new
+$DEBUGFS  -R "lsdel" $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+
+echo $FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+
+sed -f $cmd_dir/filter.sed $OUT.new > $OUT
+rm -f $OUT.new
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
+	rm -f tmp_expect
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
diff --git a/tests/filter.sed b/tests/filter.sed
index 265f458ca2..eb2ed7b842 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -40,3 +40,5 @@ s/mmp_update_date: .*/mmp_update_date: test date/
 s/mmp_update_time: .*/mmp_update_time: test_time/
 s/MMP last updated by '.*' on .*/MMP last updated by 'test_node' on test date/
 s/MMP update by '.*' at .*/MMP last updated by 'test_node' on test date/
+/Warning: blocksize 65536 not usable on most systems/d
+/Warning: 65536-byte blocks too big for system/d
-- 
2.52.0

