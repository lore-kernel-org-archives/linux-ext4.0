From: Michael Halcrow <mhalcrow@google.com>
Subject: [PATCH 0/3] fscrypto: Return -EXDEV for link, rename, and cross-rename between incompat contexts
Date: Thu,  7 Sep 2017 17:12:01 -0700
Message-ID: <20170908001204.18174-1-mhalcrow@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        tytso@mit.edu, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently file systems support fscrypto will return -EPERM when the
user attempts to link, rename, or cross-rename between two directories
that have incompatible encryption policy contexts.  User space tools
will fail the operation when receiving this errno.  With -EXDEV, user
space tools will typically fall back to copy-and-delete instead.

Our original motivation for returning -EPERM was to force users to try
harder when doing these operations, hopefully making them think more
carefully about whether what they're doing is secure.  One security
concern is that when moving files between unencrypted locations into
encrypted locations, the data in the unencrypted location will remain
in the clear on the storage device until the freed blocks are
overwritten at some arbitrary point in the future (if ever).  Moving
files from encrypted locations into unencrypted locations is also
(perhaps more obviously) problematic.

Whether making things fail will have the intended effect on users is
up for debate.  Meanwhile I've had at least one person tell me their
userspace tools are failing and that they would prefer seeing the same
sort of behavior that they see when (for example) moving files from
one project quota hierarchy to another (ext4 returns -EXDEV).

Note that xfstests generic/398 will require an update with this
change.

Michael Halcrow (3):
  ext4 crypto: Return -EXDEV for link, rename, and cross-rename between
    incompat contexts
  F2FS crypto: Return -EXDEV for link, rename, and cross-rename between
    incompat contexts
  UBIFS crypto: Return -EXDEV for link, rename, and cross-rename between
    incompat contexts

 fs/ext4/namei.c | 6 +++---
 fs/f2fs/namei.c | 6 +++---
 fs/ubifs/dir.c  | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.14.1.581.gf28d330327-goog
