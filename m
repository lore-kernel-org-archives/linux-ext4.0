From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fix for 4.6
Date: Sat, 27 Feb 2016 14:17:47 -0500
Message-ID: <20160227191747.GA23919@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 74dae4278546b897eb81784fdfcce872ddd8b2b8:

  ext4: fix crashes in dioread_nolock mode (2016-02-19 00:33:21 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/tags/ext4_for_linus_stable

for you to fetch changes up to 1e9d180ba39f42e8ca4a808baef3a3ef034b1c2c:

  ext2, ext4: fix issue with missing journal entry in ext4_dax_mkwrite() (2016-02-27 14:01:16 -0500)

----------------------------------------------------------------
This fixes a file system corruption bug with DAX

----------------------------------------------------------------
Ross Zwisler (1):
      ext2, ext4: fix issue with missing journal entry in ext4_dax_mkwrite()

 fs/ext2/file.c | 19 +------------------
 fs/ext4/file.c | 19 ++-----------------
 2 files changed, 3 insertions(+), 35 deletions(-)
