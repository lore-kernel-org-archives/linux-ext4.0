From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 3.13
Date: Mon, 6 Jan 2014 15:07:52 -0500
Message-ID: <20140106200752.GA31360@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit f5a44db5d2d677dfbf12deee461f85e9ec633961:

  ext4: add explicit casts when masking cluster sizes (2013-12-20 09:29:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to d0abafac8c9162f39c4f6b2f8141b772a09b3770:

  ext4: fix bigalloc regression (2014-01-06 14:00:23 -0500)

----------------------------------------------------------------
Fix a regression introduced in v3.13-rc6

----------------------------------------------------------------
Eric Whitney (1):
      ext4: fix bigalloc regression

 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
