From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.18
Date: Mon, 1 Dec 2014 22:43:18 -0500
Message-ID: <20141202034318.GA13101@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_urgent

for you to fetch changes up to 32f3869184d498850d36b7e6aa3b9f5260ea648a:

  jbd2: fix regression where we fail to initialize checksum seed when loading (2014-12-01 21:57:06 -0500)

----------------------------------------------------------------
Fix an ext4 metadata checksum regression introduced in v3.18-rc3.

----------------------------------------------------------------
Darrick J. Wong (1):
      jbd2: fix regression where we fail to initialize checksum seed when loading

 fs/jbd2/journal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
