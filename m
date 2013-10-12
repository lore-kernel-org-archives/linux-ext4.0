From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.12
Date: Sat, 12 Oct 2013 14:55:39 -0400
Message-ID: <20131012185539.GA18630@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit ad4eec613536dc7e5ea0c6e59849e6edca634d8b:

  ext4: allow specifying external journal by pathname mount option (2013-08-28 19:05:07 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 6e4ea8e33b2057b85d75175dd89b93f5e26de3bc:

  ext4: fix memory leak in xattr (2013-10-12 14:39:49 -0400)

----------------------------------------------------------------
A bug fix and performance regression fix for ext4.

----------------------------------------------------------------
Dave Jones (1):
      ext4: fix memory leak in xattr

Jan Kara (1):
      ext4: fix performance regression in writeback of random writes

 fs/ext4/inode.c | 2 +-
 fs/ext4/xattr.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)
