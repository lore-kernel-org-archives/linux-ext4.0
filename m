Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45984 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeKUKeB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 05:34:01 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs v2 0/8]  Support encoding awareness and casefold
Date: Tue, 20 Nov 2018 19:01:58 -0500
Message-Id: <20181121000206.15496-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

This is the v2 for encoding support in e2fsprogs.  It includes the fixes
you requested and some other changes to deal with bad balues coming from
userspace and superblock.  I also moved the structure you commented on
into the e2p library.  The only user was mkefs, but now it accesses it
through a wrapper.

You can also pull this series from:

https://gitlab.collabora.com/krisman/e2fsprogs -b encoding-feature-merge_v2


----
Original cover letter message:


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

Gabriel Krisman Bertazi (8):
  libe2p: Helpers for configuring the encoding superblock fields
  mke2fs: Configure encoding during superblock initialization
  chattr/lsattr: Support casefold attribute
  lib/ext2fs: Implement NLS support
  lib/ext2fs: Support encoding when calculating dx hashes
  debugfs/htree: Support encoding when printing the file hash
  tune2fs: Prevent enabling encryption flag on encoding-aware fs
  ext2fs: nls: Support UTF-8 with NFKD normalization

 debugfs/htree.c            |   27 +-
 e2fsck/Makefile.in         |    3 +-
 e2fsck/dx_dirinfo.c        |    4 +-
 e2fsck/e2fsck.h            |    4 +-
 e2fsck/pass1.c             |    3 +-
 e2fsck/pass2.c             |    7 +-
 e2fsck/rehash.c            |   12 +-
 e2fsck/unix.c              |   18 +
 lib/e2p/Makefile.in        |    8 +-
 lib/e2p/e2p.h              |    5 +
 lib/e2p/encoding.c         |   97 +
 lib/e2p/pf.c               |    1 +
 lib/ext2fs/Makefile.in     |   16 +-
 lib/ext2fs/dirhash.c       |   49 +-
 lib/ext2fs/ext2_fs.h       |   10 +-
 lib/ext2fs/ext2fs.h        |    5 +-
 lib/ext2fs/initialize.c    |    4 +
 lib/ext2fs/nls.h           |   66 +
 lib/ext2fs/nls_ascii.c     |   48 +
 lib/ext2fs/nls_utf8-norm.c |  793 +++++
 lib/ext2fs/nls_utf8.c      |   85 +
 lib/ext2fs/utf8data.h      | 5985 ++++++++++++++++++++++++++++++++++++
 lib/ext2fs/utf8n.h         |  120 +
 misc/chattr.c              |    3 +-
 misc/mke2fs.c              |   42 +
 misc/tune2fs.c             |    6 +
 26 files changed, 7392 insertions(+), 29 deletions(-)
 create mode 100644 lib/e2p/encoding.c
 create mode 100644 lib/ext2fs/nls.h
 create mode 100644 lib/ext2fs/nls_ascii.c
 create mode 100644 lib/ext2fs/nls_utf8-norm.c
 create mode 100644 lib/ext2fs/nls_utf8.c
 create mode 100644 lib/ext2fs/utf8data.h
 create mode 100644 lib/ext2fs/utf8n.h

-- 
2.19.1
