From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 00/13] NLS/UTF-8 Case-Insensitive lookups for ext4 and VFS proposal
Date: Thu, 25 Jan 2018 00:53:36 -0200
Message-ID: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52000 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbeAYCye (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 21:54:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Along with the patch series, I am very interested in getting feedback on
the two items below, regarding VFS and NLS changes.

This is a v2 of the unicode + ext4 case-insensitive support which
extends support to Unicode 10.0.0, and applies the fixes suggested by
Olaf in the previous iteration.  For the same reason as mentioned
before, the ucd files are not included in the RFC, but the relevant
patch file explains how to fetch them.

If you'd rather pull everything in this RFC at once, including the UCD
files, you can clone from:

https://gitlab.collabora.com/krisman/linux.git -b charset-lib

The original cover letter, with explanations on some of the design
decisions made in this RFC, is documented in the archive below:

  https://www.spinics.net/lists/linux-ext4/msg59457.html

In addition to this RFC, I am making two new proposals (no code in this
RFC) for VFS and NLS, which I would like to hear feedback from you
before turning this from an RFC into a final patch submission:

(1) integrate the charset lib into the NLS system.

Basically, this requires introducing new higher-level hooks for string
comparison, like the ones we have in the charset patch, into the NLS
subsystem.

NLS also has to support versions of the same encoding, my idea is to
separate the information to register the encoding with the NLS system
into a separate structure, which is restricted to the NLS system.  The
nls_table or a similar structure, which is then passed to users of the
library, will then be specific to a given version of the charset and
carry pointers to the functions specific to that version.

One final important point for NLS is that we need to prevent users from
mounting CI filesystems with encodings that don't support
normalization/comparison functions and try not the break compatibility
of filesystems that already do toupper/tolower without normalization.
These points are important to keep in mind but are quite trivial to
implement.

The second proposal is related to the VFS layer:

(2) Enable Insensitive lookup support on a per-mountpoint basis,
via a MS_CASEFOLD flag, with the ultimate goal of supporting a
case-insensitive bind mount of a subtree, side-by-side with a
sensitive version of the filesystem.

I have a prototype code at

https://gitlab.collabora.com/krisman/linux.git -b vfs-ms_casefold

Which is *not fully functional*, since it confuses the dentry cache when
multiple mountpoints are installed, but it gives an idea of the design,
if anyone wants to review it.  Basically, I want to:

  - Add a new MS_CASEFOLD mount option, which flips a flag in struct
    vfsmount

  - When this flag is enabled, a LOOKUP_CASEFOLD flag is submitted to
  the fs .lookup() hook, asking it to perform a case-folded lookup.

  - LOOKUP_CASEFOLD also replaces .d_hash() and d_compare() with
    insensitive versions, provided by filesystems.

  - Allow "mount -o remount,bind" to flip the MNT_CASEFOLD flag, similar
    to what is done with the read-only setting.

  - filesystems that support the MS_CASEFOLD flag need to advertise
    support in struct file_system_type.  There will be no generic
    implementation of casefolding in the VFS layer for now.  Either the
    FS acknowledges support for it, or MS_CASEFOLD fails the mount
    operation.

This is implemented in the branch above (along with the required
modifications for EXT4) except for the issue in the dentry cache, that I
am still working on.

Do these changes to VFS seem acceptable?

Thanks,

Gabriel Krisman Bertazi (9):
  charsets: Introduce middle-layer for character encoding
  charsets: ascii: Wrap ascii functions to charsets library
  charsets: utf8: Hook-up utf-8 code to charsets library
  charsets: utf8: Introduce test module for kernel UTF-8 implementation
  ext4: Add ignorecase mount option
  ext4: Include encoding information on the superblock
  fscrypt: Introduce charset-based matching functions
  ext4: Support charset name matching
  ext4: Implement ext4 dcache hooks for custom charsets

Olaf Weber (4):
  charsets: utf8: Add unicode character database files
  scripts: add trie generator for UTF-8
  charsets: utf8: Introduce code for UTF-8 normalization
  charsets: utf8: reduce the size of utf8data[]

 fs/ext4/dir.c                   |   63 +
 fs/ext4/ext4.h                  |    6 +
 fs/ext4/namei.c                 |   27 +-
 fs/ext4/super.c                 |   35 +
 include/linux/charsets.h        |   73 +
 include/linux/fscrypt.h         |    1 +
 include/linux/fscrypt_notsupp.h |   16 +
 include/linux/fscrypt_supp.h    |   27 +
 include/linux/utf8norm.h        |  116 ++
 lib/Kconfig                     |   16 +
 lib/Makefile                    |    2 +
 lib/charsets/Makefile           |   24 +
 lib/charsets/ascii.c            |   98 ++
 lib/charsets/core.c             |   68 +
 lib/charsets/test_ucd.c         |  186 +++
 lib/charsets/ucd/README         |   33 +
 lib/charsets/utf8_core.c        |  178 ++
 lib/charsets/utf8norm.c         |  794 +++++++++
 scripts/Makefile                |    1 +
 scripts/mkutf8data.c            | 3464 +++++++++++++++++++++++++++++++++++++++
 20 files changed, 5219 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/charsets.h
 create mode 100644 include/linux/utf8norm.h
 create mode 100644 lib/charsets/Makefile
 create mode 100644 lib/charsets/ascii.c
 create mode 100644 lib/charsets/core.c
 create mode 100644 lib/charsets/test_ucd.c
 create mode 100644 lib/charsets/ucd/README
 create mode 100644 lib/charsets/utf8_core.c
 create mode 100644 lib/charsets/utf8norm.c
 create mode 100644 scripts/mkutf8data.c

-- 
2.15.1
