From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v6 0/4]
Date: Sun, 21 Jan 2018 18:04:22 -0800
Message-ID: <20180122020426.2988-1-deepa.kernel@gmail.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The series is aimed at adding support to maintain individual
timestamp ranges for filesystems. This helps futimens, utimensat
and utimes syscalls to conform to POSIX defined behavior when
the time being set is outside of the corresponding filesystem's
supported limits.

The series was developed with discussions and guidance from
Arnd Bergmann.

The original thread is at https://lkml.org/lkml/2016/11/2/294

I will be submitting follow up kernel patches to update all
filesystems.
Currently ext4 is the only filesystem that reflects correct limits.

The branch is available at
https://github.com/deepa-hub/vfs.git refs/heads/range

Changes since v5:
* Dropped y2038-specific changes
Changes since v4:
* Added documentation for boot param
Changes since v3:
* Remove redundant initializations in libfs.c
* Change early_param to __setup similar to other root mount options.
* Fix documentation warning
Changes since v2:
* Introduce early boot param override for checks.
* Drop afs patch for timestamp limits.
Changes since v1:
* return EROFS on mount errors
* fix mtime copy/paste error in utimes

Deepa Dinamani (4):
  vfs: Add file timestamp range support
  ext4: Initialize timestamps limits
  vfs: Add timestamp_truncate() api
  utimes: Clamp the timestamps before update

 fs/ext4/ext4.h         |  4 ++++
 fs/ext4/super.c        |  7 ++++++-
 fs/inode.c             | 32 +++++++++++++++++++++++++++++++-
 fs/super.c             |  2 ++
 fs/utimes.c            | 17 +++++++++++++----
 include/linux/fs.h     |  3 +++
 include/linux/time64.h |  2 ++
 7 files changed, 61 insertions(+), 6 deletions(-)

-- 
2.14.1

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
