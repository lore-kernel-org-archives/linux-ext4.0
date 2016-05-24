From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] generic/250: ignore xfs_io IO errors when writing to dmerror device
Date: Tue, 24 May 2016 21:24:36 +0800
Message-ID: <1464096276-28407-1-git-send-email-eguan@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When testing with data=journal ext4, direct write to dmerror device
doesn't return EIO, because ext4 turns direct write to buffered write in
data=journal mode and all data is written to journal buffer. The write
only fails later when commiting journal and error messages can be seen
in dmesg.

As the test is checking on the md5 checksum of the test file, it's ok to
ignore the IO error returned by xfs_io, as long as the checksums match
the golden image.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

Not returning errors to userspace properly is kind of an ext4 bug in journal
mode, but ext4 always behaves this way. So I think instead of fixing ext4, this
is the easiest way to make generic/250 work with journal mode ext4.

 tests/generic/250     | 3 ++-
 tests/generic/250.out | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/250 b/tests/generic/250
index 6d15de2..891b8b0 100755
--- a/tests/generic/250
+++ b/tests/generic/250
@@ -83,7 +83,8 @@ echo "CoW and unmount"
 $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 sync
 _dmerror_load_error_table
-$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 \
+	>> $seqres.full 2>&1
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/generic/250.out b/tests/generic/250.out
index 710c80e..0ff87d0 100644
--- a/tests/generic/250.out
+++ b/tests/generic/250.out
@@ -4,7 +4,6 @@ Create the original files
 Compare files
 ec8bb3b24d5b0f1b5bdf8c8f0f541ee6  SCRATCH_MNT/test-250/file2
 CoW and unmount
-pwrite64: Input/output error
 Compare files
 3ed86318f4ff8da26c1c2a6e3041f9be  SCRATCH_MNT/test-250/file2
 Check for damage
-- 
2.5.5
