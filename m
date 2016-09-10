From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] fscrypto fixes for 4.8-rc6
Date: Sat, 10 Sep 2016 01:36:43 -0400
Message-ID: <20160910053643.3hkypkiuxfmra7yd@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit c6935931c1894ff857616ff8549b61236a19148f:

  Linux 4.8-rc5 (2016-09-04 14:31:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/for_linus_stable

for you to fetch changes up to ba63f23d69a3a10e7e527a02702023da68ef8a6d:

  fscrypto: require write access to mount to set encryption policy (2016-09-10 01:18:57 -0400)

----------------------------------------------------------------
Fix some brown-paper-bag bugs for fscrypto, including one one which
allows a malicious user to set an encryption policy on an empty
directory which they do not own.

----------------------------------------------------------------
Eric Biggers (3):
      fscrypto: add authorization check for setting encryption policy
      fscrypto: only allow setting encryption policy on directories
      fscrypto: require write access to mount to set encryption policy

 fs/crypto/policy.c       | 41 +++++++++++++++++++++++++++++------------
 fs/ext4/ioctl.c          |  2 +-
 fs/f2fs/file.c           |  9 +--------
 include/linux/fscrypto.h |  5 ++---
 4 files changed, 33 insertions(+), 24 deletions(-)
