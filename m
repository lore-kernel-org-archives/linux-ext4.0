From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH 1/2] shared/272: don't use data journaling with DAX
Date: Wed, 17 Jan 2018 16:23:50 -0700
Message-ID: <20180117232351.19286-1-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org,
        dave.jiang@intel.com
To: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51129 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752791AbeAQXX5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 Jan 2018 18:23:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

shared/272 fails with kernels v4.15-rc1 and beyond when you are mounted
with DAX:

shared/272	 [failed, exit status 1] - output mismatch (see
/root/project/xfstests/results//shared/272.out.bad)
    --- tests/shared/272.out	2015-12-05 13:12:17.038257578 -0700
    +++ /root/project/xfstests/results//shared/272.out.bad	2018-01-17
    15:37:18.581631116 -0700
    @@ -1,3 +1,3 @@
     QA output created by 272
     Switch data journalling mode. Silence is golden.
    -Check filesystem
    +/usr/bin/chattr: Device or resource busy while setting flags on
    /mnt/xfstests_scratch/file.1
    ...
    (Run 'diff -u tests/shared/272.out
    /root/project/xfstests/results//shared/272.out.bad'  to see the entire
    diff)

This is expected.  The following kernel commit:

commit e9072d859df3 ("ext4: prevent data corruption with journaling + DAX")

makes "chattr +j", which is attempting to turn on data journaling, return
-EBUSY if the ext4 DAX mount option is in use.  This was done to prevent
the data corruption shown in xfstest ext4/030, added by this xfstests
commit:

commit 750a24e99e48 ("ext4: test for DAX + journaling corruption")

So, just skip shared/272 if the DAX mount option is in use.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tests/shared/272 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/shared/272 b/tests/shared/272
index 7023b657..0c9763df 100755
--- a/tests/shared/272
+++ b/tests/shared/272
@@ -83,6 +83,7 @@ chattr_opt: $chattr_opt" >>$seqres.full
 _supported_fs ext3 ext4
 _supported_os Linux
 _require_scratch
+_exclude_scratch_mount_option dax
 
 rm -f $seqres.full
 _scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1
-- 
2.14.3
