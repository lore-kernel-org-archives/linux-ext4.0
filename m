From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] common/defrag: rework _require_defrag for ext4
Date: Thu, 4 Aug 2016 16:02:46 -0400
Message-ID: <20160804200246.GA2208@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The existing _require_defrag function rejects ext4 file systems
mounted with the dax option or constructed without extents.  However,
there are also a number of other ext4 file system configuration cases
that do not currently support online defrag, including encryption, data
journaling, and bigalloc.  In the future, online defrag functionality
may be implemented for some of these, and new configuration cases
could be added that don't support it.

Rather than add a laundry list of mount and file system configuration
options to the existing _require_defrag function that will need ongoing
maintenance, use the available src/e4compact program to directly
determine whether the kernel supports ext4's move extent ioctl on the
test file system.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common/defrag | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/common/defrag b/common/defrag
index 7db0cb4..986b4bf 100644
--- a/common/defrag
+++ b/common/defrag
@@ -27,14 +27,19 @@ _require_defrag()
         DEFRAG_PROG="$XFS_FSR_PROG"
 	;;
     ext4|ext4dev)
-	echo $MOUNT_OPTIONS | grep -q dax
+	testfile="$TEST_DIR/$$-test.defrag"
+	donorfile="$TEST_DIR/$$-donor.defrag"
+	bsize=`get_block_size $TEST_DIR`
+	$XFS_IO_PROG -f -c "pwrite -b $bsize 0 $bsize" $testfile > /dev/null
+	cp $testfile $donorfile
+	echo $testfile | $here/src/e4compact -v -f $donorfile | \
+		grep -q "err:95"
 	if [ $? -eq 0 ]; then
-		_notrun "$FSTYP defragmentation not supported with DAX"
-	else
-		DEFRAG_PROG="$E4DEFRAG_PROG"
+		rm -f $testfile $donorfile 2>&1 > /dev/null
+		_notrun "$FSTYP test filesystem doesn't support online defrag"
 	fi
-	dumpe2fs -h $TEST_DEV 2> /dev/null | grep -wq extent || \
-		_notrun "file system does not have extents, needed for defrag"
+	rm -f $testfile $donorfile 2>&1 > /dev/null
+	DEFRAG_PROG="$E4DEFRAG_PROG"
 	;;
     btrfs)
 	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
-- 
2.1.4
