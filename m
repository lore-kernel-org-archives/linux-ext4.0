From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.37-rc6
Date: Wed, 15 Dec 2010 11:32:42 -0500
Message-ID: <E1PSuHS-00071A-1U@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

To get some regression fixes for ext4.  They're both hard to hit, and
unfortunately I'm going to have to back out the multi-page submission
feature for 2.6.37 (disabled by default; can be re-enable with a mount
option) until I can figure what's going on with an edge case which Jon
Nelson reported.

						- Ted

Aaro Koskinen (1):
      ext4: fix typo which broke '..' detection in ext4_find_entry()

Theodore Ts'o (1):
      ext4: Turn off multiple page-io submission by default

 fs/ext4/ext4.h  |    1 +
 fs/ext4/inode.c |    5 ++++-
 fs/ext4/namei.c |    2 +-
 fs/ext4/super.c |   14 ++++++++++++--
 4 files changed, 18 insertions(+), 4 deletions(-)
