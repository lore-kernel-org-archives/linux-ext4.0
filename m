From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/3] fscrypt: forbid truncate(2) without key
Date: Tue, 13 Jun 2017 16:47:52 -0700
Message-ID: <20170613234755.111167-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33943 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbdFMXtD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jun 2017 19:49:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

These patches update the various filesystems to forbid userspace from
truncating encrypted files without the encryption key, as it's not
possible to handle this correctly in general.  I believe this may have
been missed because truncate() doesn't require opening the file first,
and therefore it's not prevented by the existing requirement that open()
is only allowed with the encryption key.

It probably makes sense to take this series through the fscrypt tree, as
the changes for each filesystem are basically identical.  (Eventually it
might make sense to add an S_ENCRYPTED flag to struct inode and move
some of these "hooks" up into the VFS; this one might fit nicely into
setattr_prepare(), for example.)

Eric Biggers (3):
  ext4: require key for truncate(2) of encrypted file
  f2fs: require key for truncate(2) of encrypted file
  ubifs: require key for truncate(2) of encrypted file

 fs/ext4/inode.c |  8 ++++++++
 fs/f2fs/file.c  | 10 +++++++---
 fs/ubifs/file.c |  8 ++++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

-- 
2.13.1.508.gb3defc5cc-goog
