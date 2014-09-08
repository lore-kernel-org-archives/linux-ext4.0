From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] an ext4 bug fix for 3.17
Date: Mon, 8 Sep 2014 18:42:57 -0400
Message-ID: <20140908224257.GA25719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit d4f03186c8986ffde34d06fe74a99aab08f7ee0b:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-08-29 11:52:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus_urgent

for you to fetch changes up to a9cfcd63e8d206ce4235c355d857c4fbdf0f4587:

  ext4: avoid trying to kfree an ERR_PTR pointer (2014-09-03 09:37:30 -0400)

----------------------------------------------------------------
Theodore Ts'o (1):
      ext4: avoid trying to kfree an ERR_PTR pointer

 fs/ext4/namei.c  | 2 ++
 fs/ext4/resize.c | 2 ++
 2 files changed, 4 insertions(+)
