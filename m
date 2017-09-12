From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] .gitignore: ignore cscope files
Date: Mon, 11 Sep 2017 22:45:19 -0600
Message-ID: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-xfs@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitignore b/.gitignore
index 28fe84d..2accc37 100644
--- a/.gitignore
+++ b/.gitignore
@@ -238,3 +238,7 @@
 /tests/xfs/033.out
 /tests/xfs/071.out
 /tests/xfs/096.out
+
+# cscope files
+cscope.*
+ncscope.*
-- 
2.9.5
