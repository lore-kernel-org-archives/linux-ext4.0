From: Theodore Ts'o <tytso@mit.edu>
Subject: ext4 bug fixes for 4.13
Date: Wed, 23 Aug 2017 00:16:34 -0400
Message-ID: <20170823041634.64t7aen42ifgduaz@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit aae4e7a8bc44722fe70d58920a36916b1043195e:

  Linux 4.13-rc4 (2017-08-06 18:44:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 32aaf194201e98db4235b7b71ac62a22e2ac355f:

  ext4: add missing xattr hash update (2017-08-14 08:30:06 -0400)

----------------------------------------------------------------
Fix a clang build regression and an potential xattr corruption bug.

----------------------------------------------------------------
Tahsin Erdogan (1):
      ext4: add missing xattr hash update

Theodore Ts'o (1):
      ext4: fix clang build regression

 fs/ext4/mballoc.c | 7 +++++--
 fs/ext4/xattr.c   | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)
