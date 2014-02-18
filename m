From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 fixes for 3.14
Date: Tue, 18 Feb 2014 13:02:17 -0500
Message-ID: <20140218180217.GA7810@thunk.org>
References: <20140218165426.GA1482@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140218165426.GA1482@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Whoops, I realized the previous pull request had a few too many
commits on it.  If you did merge it in, it's not a disaster, since
they are low-risk cleanups.  But here's the tag moved a few commits
earlier so we only have the stable-worthy bug fixes.

Apologies for any possible confusion.

						- Ted

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 92e3b40537707001d17bbad800d150ab04e53bf4:

  jbd2: fix use after free in jbd2_journal_start_reserved() (2014-02-17 20:33:01 -0500)

----------------------------------------------------------------
Miscellaneous ext4 bug fixes for v3.14

----------------------------------------------------------------
Dan Carpenter (1):
      jbd2: fix use after free in jbd2_journal_start_reserved()

Eric Whitney (1):
      ext4: fix xfstest generic/299 block validity failures

Theodore Ts'o (4):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()

 fs/ext4/ext4.h        |  2 ++
 fs/ext4/extents.c     |  1 +
 fs/ext4/ioctl.c       |  3 ++-
 fs/ext4/resize.c      | 34 +++++++++++++++++++++-------------
 fs/ext4/super.c       | 20 +++++++++++++-------
 fs/jbd2/transaction.c |  6 ++++--
 6 files changed, 43 insertions(+), 23 deletions(-)
