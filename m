From: Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 0/5] fscrypt error code cleanup
Date: Mon,  5 Dec 2016 11:12:43 -0800
Message-ID: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33729 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbcLETNU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2016 14:13:20 -0500
Received: by mail-pg0-f54.google.com with SMTP id 3so139642282pgd.0
        for <linux-ext4@vger.kernel.org>; Mon, 05 Dec 2016 11:13:19 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As suggested by Richard Weinberger, we need to agree on and document a clear set
of fscrypt-related error codes.

I identified several cases where the error codes are not consistent between or
within filesystems, or are ambiguous with other errors.  This patchset proposes
several changes to resolve these problems.

I believe we do still have some flexibility to make changes to these error codes
since there are not many different users of filesystem-level encryption yet, and
depending on these specific errors would be unusual.  There have also already
been cases where some of these error codes have changed before.

Currently this patchset depends on the following patch being applied first:
"fscrypto: move ioctl processing more fully into common code"

Eric Biggers (5):
  fscrypt: use ENOKEY when file cannot be created w/o key
  fscrypt: use ENOTDIR when setting encryption policy on nondirectory
  fscrypt: use EEXIST when file already uses different policy
  fscrypt: remove user-triggerable warning messages
  fscrypt: pass up error codes from ->get_context()

 fs/crypto/fname.c  |  4 +--
 fs/crypto/policy.c | 73 ++++++++++++++++++++----------------------------------
 fs/ext4/ialloc.c   |  2 +-
 fs/ext4/namei.c    |  4 ++-
 fs/f2fs/dir.c      |  5 +++-
 fs/f2fs/namei.c    |  4 +--
 6 files changed, 39 insertions(+), 53 deletions(-)

-- 
2.8.0.rc3.226.g39d4020

