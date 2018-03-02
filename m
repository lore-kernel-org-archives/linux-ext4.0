From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4.1 0/3] ext4 encryption fixes for 4.1-stable
Date: Fri,  2 Mar 2018 14:21:10 -0800
Message-ID: <20180302222113.85389-1-ebiggers3@gmail.com>
Cc: linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: stable@vger.kernel.org, Sasha Levin <Alexander.Levin@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Hi Sasha, can you please apply these backports of ext4 encryption fixes
to 4.1-stable?  They all have equivalent fixes in 4.4-stable.  Most
important is patch 1 which prevents unprivileged users from using (or
abusing) ext4 encryption when it hasn't been enabled on the filesystem
by a system administrator.  Patch 2 adds a missing permission check
(CVE-2016-10318), and patch 3 is a backport that Ted sent out some
months ago that seems to have been missed, for a bug in 4.1 that is very
similar to the bug in 4.2+ that was assigned CVE-2017-7374.

Note that ext4 encryption in 4.1 is still pretty broken and should not
be used (even just 4.4-stable is much better); these are just the most
important fixes that really ought to be in 4.1-stable.

Eric Biggers (1):
  fscrypto: add authorization check for setting encryption policy

Richard Weinberger (1):
  ext4: require encryption feature for EXT4_IOC_SET_ENCRYPTION_POLICY

Theodore Ts'o (1):
  ext4 crypto: don't regenerate the per-inode encryption key
    unnecessarily

 fs/ext4/crypto_fname.c  |  5 +++--
 fs/ext4/crypto_key.c    | 15 ++++++++++++---
 fs/ext4/crypto_policy.c |  3 +++
 fs/ext4/ext4.h          |  1 +
 fs/ext4/ioctl.c         |  3 +++
 fs/ext4/super.c         |  3 +++
 6 files changed, 25 insertions(+), 5 deletions(-)

-- 
2.16.2.395.g2e18187dfd-goog
