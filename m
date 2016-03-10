From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfix for 4.5
Date: Wed, 9 Mar 2016 22:18:46 -0500
Message-ID: <20160310031846.GA19171@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 1e9d180ba39f42e8ca4a808baef3a3ef034b1c2c:

  ext2, ext4: fix issue with missing journal entry in ext4_dax_mkwrite() (2016-02-27 14:01:16 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 6ffe77bad545f4a7c8edd2a4ee797ccfcd894ab4:

  ext4: iterate over buffer heads correctly in move_extent_per_page() (2016-03-09 21:37:53 -0500)

----------------------------------------------------------------
This fixes a regression which crept in v4.5-rc5.

----------------------------------------------------------------
Eryu Guan (1):
      ext4: iterate over buffer heads correctly in move_extent_per_page()

 fs/ext4/move_extent.c | 1 +
 1 file changed, 1 insertion(+)
