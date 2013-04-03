From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.9-rc6
Date: Wed, 03 Apr 2013 14:19:20 -0400
Message-ID: <nsxd2ub79zr.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 8cde7ad17e4f4ff8d12ff60dd09c0a291cb0b61c:

  ext4: fix big-endian bugs which could cause fs corruptions (2013-04-03 12:37:17 -0400)

----------------------------------------------------------------
Unfortunately, we introduced some big-endian bugs during the last
merge window.  Fortunately, Cai and Christian noticed before 3.9
shipped.

----------------------------------------------------------------
Zheng Liu (1):
      ext4: fix big-endian bugs which could cause fs corruptions

 fs/ext4/extents.c  | 11 +++++++----
 fs/ext4/indirect.c |  4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)
