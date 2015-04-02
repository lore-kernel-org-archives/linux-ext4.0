From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/22] ext4 encryption patches
Date: Thu,  2 Apr 2015 18:10:37 -0400
Message-ID: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48030 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbbDBWNF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:13:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Android userspace code to use ext4 encryption have been checked into
the public AOSP branch.  If all goes well, this feature will hopefully
(my fingers are crossed, but obviously nothing is guaranteed at this
point) be included in the 'M' release of Android.

Currently all of the changes are in fs/ext4 but I've been talking to
Jaegeuk about adopting the same same interfaces (which is essentially
just two ioctl's to set the encryption policy and to get the
per-file-system 'salt' for passwords) for f2fs.

As a result, it may be that some of the functions in
fs/ext4/crypto_*.c will end up getting refactored and moved into some
fs/*.c so that f2fs can use it as well.  But I'd like to get the basic
feature into the kernel tree (marked as experimental initially) and
then do more polishing from there.

There is a design document here.  It should hopefully be mostly up to
date, but there are a few things that we might end up changing (for
example, just using CTS all the time for protecting directory file
names).

https://docs.google.com/document/d/1IsyQ9DU1gA6NUqS0jF4ni_NTvv-b0HfCkRk47Zkd7W0

						- Ted

Michael Halcrow (13):
  ext4 crypto: export ext4_empty_dir()
  ext4 crypto: add encryption xattr support
  ext4 crypto: add encryption policy checking
  ext4 crypto: add ext4 encryption facilities
  ext4 crypto: add encryption key management facilities
  ext4 crypto: inherit encryption policies on inode and directory create
  ext4 crypto: implement the ext4 encryption write path
  ext4 crypto: implement the ext4 decryption read path
  ext4 crypto: filename encryption facilities
  ext4 crypto: insert encrypted filenames into a leaf directory block
  ext4 crypto: partial update to namei.c for fname crypto
  ext4 crypto: filename encryption modifications
  ext4 crypto: enable filename encryption

Theodore Ts'o (9):
  ext4: add ext4_mpage_readpages()
  ext4: reserve codepoints used by the ext4 encryption feature
  ext4 crypto: add ext4 encryption Kconfig
  ext4 crypto: add ioctl to set encryption policy
  ext4 crypto: validate context consistency on lookup
  ext4: teach ext4_htree_store_dirent() to store decrypted filenames
  ext4 crypto: Add symlink encryption
  ext4 crypto: enable encryption feature flag
  ext4 crypto: add password salt support

 fs/ext4/Kconfig         |  20 ++
 fs/ext4/Makefile        |   4 +-
 fs/ext4/crypto.c        | 601 ++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_fname.c  | 831 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_key.c    | 170 ++++++++++
 fs/ext4/crypto_policy.c | 186 +++++++++++
 fs/ext4/dir.c           |  98 +++++-
 fs/ext4/ext4.h          | 153 ++++++++-
 fs/ext4/ext4_crypto.h   | 140 ++++++++
 fs/ext4/extents.c       |   6 +
 fs/ext4/file.c          |  22 +-
 fs/ext4/ialloc.c        |  28 +-
 fs/ext4/inline.c        |  17 +-
 fs/ext4/inode.c         | 127 +++++++-
 fs/ext4/ioctl.c         |  69 ++++
 fs/ext4/namei.c         | 567 +++++++++++++++++++++++++++++----
 fs/ext4/page-io.c       |  46 ++-
 fs/ext4/readpage.c      | 321 +++++++++++++++++++
 fs/ext4/super.c         |  31 +-
 fs/ext4/symlink.c       | 104 +++++-
 fs/ext4/xattr.h         |   3 +
 21 files changed, 3431 insertions(+), 113 deletions(-)
 create mode 100644 fs/ext4/crypto.c
 create mode 100644 fs/ext4/crypto_fname.c
 create mode 100644 fs/ext4/crypto_key.c
 create mode 100644 fs/ext4/crypto_policy.c
 create mode 100644 fs/ext4/ext4_crypto.h
 create mode 100644 fs/ext4/readpage.c

-- 
2.3.0

