From: Theodore Tso <tytso@mit.edu>
Subject: Re: Rare xfsqa test failure
Date: Tue, 18 Aug 2009 10:56:33 -0400
Message-ID: <20090818145633.GB28560@mit.edu>
References: <E1MdNJu-0006uc-GX@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49649 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZHRO4h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2009 10:56:37 -0400
Content-Disposition: inline
In-Reply-To: <E1MdNJu-0006uc-GX@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 18, 2009 at 07:57:42AM -0400, Theodore Ts'o wrote:
> 
> As a heads up, I'm seeing a rare xfsqa test failure with the stable
> portion of the ext4 patch queue; it doesn't hit all the time, but when
> it does, i_size is corrupted:

The problem shows up with stock 2.6.31-rc4.

I just noticed I'm running with a patch to xfsqa that I had forgotten
to push upstream.  xfsqa's check_generic_filesystem doesn't force a
filesystem check, so people running the tests wouldn't have noticed
the problem.

Here's the patch; I'll send it to the XFS folks.

						- Ted

commit fbbeb08db507e26f61f44451ce52f9bac24cd8fa
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Aug 18 10:51:37 2009 -0400

    Add ext2/3/4-specific _check_extN_filesystem function
    
    The _check_generic_filesystem function doesn't force a full filesystem
    check, so filesystem inconsistencies after a test wouldn't be noticed.
    To fix this, I added an extN specific check filesystem function.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/common.rc b/common.rc
index 82b0d51..da5f99e 100644
--- a/common.rc
+++ b/common.rc
@@ -865,6 +865,52 @@ _check_generic_filesystem()
     return 0
 }
 
+# Check an ext2/3/4 filesystem
+#
+_check_extN_filesystem()
+{
+    device=$1
+
+    # If type is set, we're mounted
+    type=`_fs_type $device`
+    ok=1
+
+    if [ "$type" = "$FSTYP" ]
+    then
+        # mounted ...
+        mountpoint=`_umount_or_remount_ro $device`
+    fi
+
+    e2fsck -nf $device >$tmp.fsck 2>&1
+    if [ $? -ne 0 ]
+    then
+        echo "_check_extN_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+
+        echo "_check_extN filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
+        echo "*** e2fsck output ***"                          >>$here/$seq.full
+        cat $tmp.fsck                                         >>$here/$seq.full
+        echo "*** end e2fsck output"                          >>$here/$seq.full
+
+        ok=0
+    fi
+    rm -f $tmp.fsck
+
+    if [ $ok -eq 0 ]
+    then
+        echo "*** mount output ***"                           >>$here/$seq.full
+        _mount                                                >>$here/$seq.full
+        echo "*** end mount output"                           >>$here/$seq.full
+    elif [ "$type" = "$FSTYP" ]
+    then
+	# was mounted ...
+	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint
+	ok=$?
+    fi
+
+    [ $ok -eq 0 ] && exit 1
+    return 0
+}
+
 # run xfs_check and friends on a FS.
 
 _check_xfs_filesystem()
@@ -1033,6 +1079,9 @@ _check_test_fs()
     udf)
 	# do nothing for now
 	;;
+    ext2|ext3|ext4)
+	_check_extN_filesystem $TEST_DEV
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1059,6 +1108,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    ext2|ext3|ext4)
+	_check_extN_filesystem $SCRATCH_DEV
+	;;
     *)
 	_check_generic_filesystem $SCRATCH_DEV
 	;;
