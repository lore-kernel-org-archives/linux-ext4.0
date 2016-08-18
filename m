From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic/135: redirect stderr from _scratch_mkfs
Date: Thu, 18 Aug 2016 11:04:56 -0400
Message-ID: <20160818150456.GB14069@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In generic/135, benign warning message output from _scratch_mkfs on
stderr can cause a golden output mismatch, as can occur when testing
an ext4 bigalloc file system.  It's the only generic test that does not
also redirect stderr when directing _scratch_mkfs' stdout to /dev/null.
Since error output from _scratch_mkfs doesn't seem important to the
overall intent of the test, there should be no harm in making its
stderr handling consistent.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/135 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/135 b/tests/generic/135
index 52418f6..14b8132 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -41,7 +41,7 @@ _supported_os Linux IRIX
 
 _require_odirect
 _require_scratch
-_scratch_mkfs >/dev/null
+_scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
 cd $SCRATCH_MNT
-- 
2.1.4
