Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32950 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeLALvF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 06:51:05 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs v4 0/9] Support encoding awareness and casefold
Date: Fri, 30 Nov 2018 19:39:01 -0500
Message-Id: <20181201003910.18982-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey,

This version introduces the changes you requested on your review of my
v3.  It doesn't implement the fsck trick I suggested because that is not
trivial and it can go in a different series (it won't matter until we
have another unicode version to update to).

e2fsprogs:
  https://gitlab.collabora.com/krisman/e2fsprogs -b encoding-feature-merge_v4
linux:
  https://gitlab.collabora.com/krisman/e2fsprogs -b ext4-ci-directory_v3
xfstests
  https://gitlab.collabora.com/krisman/xfstests -b encoding_v4

Please, let me know your thoughts.


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

  ...

If you don't object to patch 1 & 2, can we get them merged before the
rest of the series is ready, so I can reserve the bits in the super
block for this feature (patch 2) and avoid more rebasing on my side?


Gabriel Krisman Bertazi (9):
  libe2p: Helpers for configuring the encoding superblock fields
  mke2fs: Configure encoding during superblock initialization
  chattr/lsattr: Support casefold attribute
  lib/ext2fs: Implement NLS support
  lib/ext2fs: Support encoding when calculating dx hashes
  debugfs/htree: Support encoding when printing the file hash
  tune2fs: Prevent enabling encryption flag on encoding-aware fs
  ext2fs: nls: Support UTF-8 11.0 with NFKD normalization
  ext4.5: Add fname_encoding feature to ext4 man page

 debugfs/Makefile.in        |    1 +
 debugfs/htree.c            |   30 +-
 e2fsck/Makefile.in         |    7 +-
 e2fsck/dx_dirinfo.c        |    4 +-
 e2fsck/e2fsck.h            |    4 +-
 e2fsck/pass1.c             |    3 +-
 e2fsck/pass2.c             |   11 +-
 e2fsck/rehash.c            |   20 +-
 e2fsck/unix.c              |   10 +
 lib/e2p/Makefile.in        |    8 +-
 lib/e2p/e2p.h              |    4 +
 lib/e2p/encoding.c         |  104 +
 lib/e2p/feature.c          |    2 +-
 lib/e2p/pf.c               |    1 +
 lib/ext2fs/Makefile.in     |   16 +-
 lib/ext2fs/dirhash.c       |   55 +
 lib/ext2fs/ext2_fs.h       |   12 +-
 lib/ext2fs/ext2fs.h        |    8 +
 lib/ext2fs/initialize.c    |    4 +
 lib/ext2fs/nls.h           |   72 +
 lib/ext2fs/nls_ascii.c     |   68 +
 lib/ext2fs/nls_utf8-norm.c |  793 +++++
 lib/ext2fs/nls_utf8.c      |   95 +
 lib/ext2fs/utf8data.h      | 6079 ++++++++++++++++++++++++++++++++++++
 lib/ext2fs/utf8n.h         |  120 +
 misc/chattr.1.in           |    8 +-
 misc/chattr.c              |    3 +-
 misc/ext4.5.in             |   10 +
 misc/mke2fs.8.in           |   25 +
 misc/mke2fs.c              |   81 +
 misc/mke2fs.conf.5.in      |    4 +
 misc/mke2fs.conf.in        |    3 +
 misc/tune2fs.c             |    6 +
 33 files changed, 7636 insertions(+), 35 deletions(-)
 create mode 100644 lib/e2p/encoding.c
 create mode 100644 lib/ext2fs/nls.h
 create mode 100644 lib/ext2fs/nls_ascii.c
 create mode 100644 lib/ext2fs/nls_utf8-norm.c
 create mode 100644 lib/ext2fs/nls_utf8.c
 create mode 100644 lib/ext2fs/utf8data.h
 create mode 100644 lib/ext2fs/utf8n.h

-- 
2.20.0.rc1
