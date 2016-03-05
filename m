From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/12] reflink: fix fragmentation tests to work on >4k block
	size filesystems
Date: Fri, 04 Mar 2016 16:37:37 -0800
Message-ID: <20160305003737.28738.35234.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

For tests that only overwrite part of a file, only consider the number
of extents in the *rewritten* blocks when deciding if the FS
fragmentation performance is satisfactory.

(Also slip in a fix for xfs/127 so that it formats correctly when we
specify big blocksizes via MKFS_OPTIONS.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/127 |    2 +-
 tests/xfs/215 |    2 +-
 tests/xfs/218 |    2 +-
 tests/xfs/219 |    2 +-
 tests/xfs/221 |    2 +-
 tests/xfs/223 |    2 +-
 tests/xfs/224 |    2 +-
 tests/xfs/225 |    2 +-
 tests/xfs/226 |    2 +-
 tests/xfs/228 |    2 +-
 tests/xfs/230 |    2 +-
 tests/xfs/231 |    2 +-
 tests/xfs/232 |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/tests/xfs/127 b/tests/xfs/127
index f44daae..6b768c9 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -48,7 +48,7 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > $seqres.full 2>&1
+_scratch_mkfs_sized $((2 * 4096 * 4096)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
diff --git a/tests/xfs/215 b/tests/xfs/215
index 5ae4d85..7a517d7 100755
--- a/tests/xfs/215
+++ b/tests/xfs/215
@@ -95,7 +95,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 2))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/218 b/tests/xfs/218
index ea464f2..0ab4102 100755
--- a/tests/xfs/218
+++ b/tests/xfs/218
@@ -94,7 +94,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 2))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/219 b/tests/xfs/219
index 012b07c..df57e07 100755
--- a/tests/xfs/219
+++ b/tests/xfs/219
@@ -95,7 +95,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 4))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/221 b/tests/xfs/221
index 8b860f2..03d81ac 100755
--- a/tests/xfs/221
+++ b/tests/xfs/221
@@ -94,7 +94,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 4))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/223 b/tests/xfs/223
index 1e6ba98..7c990a2 100755
--- a/tests/xfs/223
+++ b/tests/xfs/223
@@ -97,7 +97,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 2))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/224 b/tests/xfs/224
index 3d19f94..bf33d1f 100755
--- a/tests/xfs/224
+++ b/tests/xfs/224
@@ -96,7 +96,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 2))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/225 b/tests/xfs/225
index c2e5b82..749816f 100755
--- a/tests/xfs/225
+++ b/tests/xfs/225
@@ -95,7 +95,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 2))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/226 b/tests/xfs/226
index 3f035b4..bb94d24 100755
--- a/tests/xfs/226
+++ b/tests/xfs/226
@@ -94,7 +94,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr / 2))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/228 b/tests/xfs/228
index 52fbb75..df1fd7a 100755
--- a/tests/xfs/228
+++ b/tests/xfs/228
@@ -103,7 +103,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr * 4 / 10))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/230 b/tests/xfs/230
index 91e4d3f..73f599a 100755
--- a/tests/xfs/230
+++ b/tests/xfs/230
@@ -103,7 +103,7 @@ new_extents=$(_count_extents $testdir/file3)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+test $((new_extents - (nr * 4 / 10))) -lt $((internal_blks / 2)) || echo "file3 badly fragmented"
 
 # success, all done
 status=0
diff --git a/tests/xfs/231 b/tests/xfs/231
index 60f59a9..166f6b0 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -123,7 +123,7 @@ new_extents=$(_count_extents $testdir/file2)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 7)) || echo "file2 badly fragmented"
+test $new_extents -le $((3 * nr / bufnr)) || echo "file2 more fragmented than expected"
 
 # success, all done
 status=0
diff --git a/tests/xfs/232 b/tests/xfs/232
index 9a8403c..0008dbf 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -125,7 +125,7 @@ new_extents=$(_count_extents $testdir/file2)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks / 12)) || echo "file2 not sufficiently fragmented"
+test $new_extents -le $((2 * nr / bufnr)) || echo "file2 more fragmented than expected"
 
 # success, all done
 status=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
