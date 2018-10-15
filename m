Return-Path: <SRS0=/GAa=M3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37476 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeJPE7X (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2018 00:59:23 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH e2fsprogs 0/9] Support encoding awareness and casefold
Date: Mon, 15 Oct 2018 17:12:11 -0400
Message-Id: <20181015211220.27370-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

These are the modifications to e2fsprogs in order to support encoding
awareness and case folding.  This patch series is divided in 3 parts:

Patch 1 & 2 work on reserving superblock fields.  Patch 1 is actually
unrelated, just updating the super_block to resynchronize with the
kernel.  Patch 2 reserves the feature bit and superblock fields for this
feature.

Patch 3 through 5 implements the changes the changes to mke2fs and
chattr/lsattr to enable the encoding feature at mkfs time and flipping
the casefold flag on demand for specific directories.

Patch 6 through 9 is where things get a bit ugly.  fsck needs to become
encoding aware, in order to calculate directory hashes correctly and
verify/fix inconsistencies.  This requires a tiny bit of plumbing to
pass the encoding information up to the point where we calculate the
hash, as well as implementing a simple nls-like interface in e2fsprogs
to do normalization/casefolding.  You'll see that in this series I've
actually dropped the utf8 part because that patch is huge and I'd rather
discuss it separately.  I did it in a hacky way now, where we import the
utf8n code from linux.  I thought about using libunistring but it
doesn't seem to support versioning and we risk being incompatible with
the kernel hashes.  I think we could follow the kernel approach and make
ucd files available in e2fsprogs and generate the data at
compilation. What do you think?

If you want to see a full utf8 capable version of this series, please
clone from:

https://gitlab.collabora.com/krisman/e2fsprogs -b encoding-feature-merge

If you don't object to patch 1 & 2, can we get them merged before the
rest of the series is ready, so I can reserve the bits in the super
block for this feature (patch 2) and avoid more rebasing on my side?

Thanks,

Gabriel Krisman Bertazi (9):
  e2fsprogs: Add timestamp extension bits to superblock
  e2fsprogs: Reserve feature bit and SB field bit for filename encoding
  libe2p: Helpers for configuring the encoding superblock fields
  mke2fs: Configure encoding during superblock initialization
  chattr/lsattr: Support casefold attribute
  lib/ext2fs: Implement NLS support
  lib/ext2fs: Support encoding when calculating dx hashes
  debugfs/htree: Support encoding when printing the file hash
  tune2fs: Prevent enabling encryption flag on encoding-aware fs

 debugfs/htree.c         | 27 +++++++++++----
 e2fsck/dx_dirinfo.c     |  4 ++-
 e2fsck/e2fsck.h         |  4 ++-
 e2fsck/pass1.c          | 11 ++++--
 e2fsck/pass2.c          |  7 +++-
 e2fsck/rehash.c         | 12 ++++---
 lib/e2p/Makefile.in     |  8 +++--
 lib/e2p/e2p.h           |  4 +++
 lib/e2p/encoding.c      | 76 +++++++++++++++++++++++++++++++++++++++++
 lib/e2p/feature.c       |  2 ++
 lib/e2p/pf.c            |  1 +
 lib/ext2fs/Makefile.in  | 10 ++++--
 lib/ext2fs/dirhash.c    | 49 +++++++++++++++++++++++---
 lib/ext2fs/ext2_fs.h    | 31 +++++++++++++++--
 lib/ext2fs/ext2fs.h     |  6 +++-
 lib/ext2fs/initialize.c |  4 +++
 lib/ext2fs/nls.h        | 65 +++++++++++++++++++++++++++++++++++
 lib/ext2fs/nls_ascii.c  | 48 ++++++++++++++++++++++++++
 misc/chattr.c           |  3 +-
 misc/mke2fs.c           | 43 +++++++++++++++++++++++
 misc/tune2fs.c          |  6 ++++
 21 files changed, 393 insertions(+), 28 deletions(-)
 create mode 100644 lib/e2p/encoding.c
 create mode 100644 lib/ext2fs/nls.h
 create mode 100644 lib/ext2fs/nls_ascii.c

-- 
2.19.1
