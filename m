From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/5] ext4: DAX data corruption fixes
Date: Mon, 11 Sep 2017 23:05:21 -0600
Message-ID: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        linux-nvdimm@lists.01.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This series prevents a pair of data corruptions with ext4 + DAX.  The first
such corruption happens when combining the inline data feature with DAX,
and the second happens when combining data journaling with DAX.

Both can be reliably reproduced with the fstests that I have posted here:

https://patchwork.kernel.org/patch/9948377/
https://patchwork.kernel.org/patch/9948381/

My opinion is that the first three patches in this series should be applied
to the v4.14 RC series and backported to stable.  The last two patches in
this series are just cleanup and can probably wait until v4.15.

Ross Zwisler (5):
  ext4: prevent data corruption with inline data + DAX
  ext4: prevent data corruption with journaling + DAX
  ext4: add sanity check for encryption + DAX
  ext4: add ext4_should_use_dax()
  ext4: remove duplicate extended attributes defs

 fs/ext4/ext4.h   | 37 -------------------------------------
 fs/ext4/inline.c | 10 ----------
 fs/ext4/inode.c  | 24 ++++++++++++++++--------
 fs/ext4/ioctl.c  | 16 +++++++++++++---
 fs/ext4/super.c  |  8 ++++++++
 5 files changed, 37 insertions(+), 58 deletions(-)

-- 
2.9.5
