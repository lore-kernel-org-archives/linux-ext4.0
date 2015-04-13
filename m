From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 00/20] ext4 encryption patches
Date: Sun, 12 Apr 2015 23:16:16 -0400
Message-ID: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35612 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbbDMDRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 23:17:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changes since the last version of the patches

* Filename encryption now uses ciphertext stealing mode, which is more
  space efficient
* Fixed a bug when deleting encrypted htree directories w/o the key available
* Cleaned up comments, copyrights, and whitespace
* The encryption feature is not advertised via /sys/fs/ext4/features
* Remove unneeded Kconfig dependencies (CTR, SHA1, SHA512, and HMAC)
* Cleaned up and refactored the file name and data path crypto code
* Support encrypted fast symlinks
* Lots of other cleanups suggested by reviewers (thanks, all!)

Note: this version of the patches requires e2fsprogs commit
v1.42.12-522-ga672190 or newer.

Michael Halcrow (13):
  ext4 crypto: export ext4_empty_dir()
  ext4 crypto: add encryption xattr support
  ext4 crypto: add encryption policy and password salt support
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

Theodore Ts'o (7):
  ext4 crypto: add ext4_mpage_readpages()
  ext4 crypto: reserve codepoints used by the ext4 encryption feature
  ext4 crypto: add ext4 encryption Kconfig
  ext4 crypto: validate context consistency on lookup
  ext4 crypto: teach ext4_htree_store_dirent() to store decrypted
    filenames
  ext4 crypto: Add symlink encryption
  ext4 crypto: enable encryption feature flag

 fs/ext4/Kconfig         |  17 ++
 fs/ext4/Makefile        |   4 +-
 fs/ext4/crypto.c        | 500 ++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_fname.c  | 709 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_key.c    | 165 +++++++++++
 fs/ext4/crypto_policy.c | 183 +++++++++++++
 fs/ext4/dir.c           |  79 ++++--
 fs/ext4/ext4.h          | 177 +++++++++++-
 fs/ext4/ext4_crypto.h   | 147 ++++++++++
 fs/ext4/extents.c       |   6 +
 fs/ext4/file.c          |  19 +-
 fs/ext4/ialloc.c        |  27 +-
 fs/ext4/inline.c        |  14 +-
 fs/ext4/inode.c         | 130 ++++++++-
 fs/ext4/ioctl.c         |  85 ++++++
 fs/ext4/namei.c         | 563 ++++++++++++++++++++++++++++++++------
 fs/ext4/page-io.c       |  46 +++-
 fs/ext4/readpage.c      | 328 ++++++++++++++++++++++
 fs/ext4/super.c         |  37 ++-
 fs/ext4/symlink.c       | 109 +++++++-
 fs/ext4/xattr.h         |   3 +
 21 files changed, 3211 insertions(+), 137 deletions(-)
 create mode 100644 fs/ext4/crypto.c
 create mode 100644 fs/ext4/crypto_fname.c
 create mode 100644 fs/ext4/crypto_key.c
 create mode 100644 fs/ext4/crypto_policy.c
 create mode 100644 fs/ext4/ext4_crypto.h
 create mode 100644 fs/ext4/readpage.c

-- 
2.3.0

