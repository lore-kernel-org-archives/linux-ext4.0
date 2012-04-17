From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 regression fixes for 3.4
Date: Tue, 17 Apr 2012 14:54:33 -0400
Message-ID: <E1SKDXt-0003Hz-A7@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 57f73c2c89a5d3b2ed87201c8100d1fa989a1a65:

  ext4: fix handling of journalled quota options (2012-04-16 18:55:26 -0400)

----------------------------------------------------------------
Ext4 regression fixes for 3.4

This fixes a scalability problem reported by Andi Kleen and Tim Chen;
they were quite secretive about the precise nature of their workload,
but they later admitted that it only showed up when they were using a
large sparse file, so the amount of data I/O that was needed was close
to zero.  I'm not sure how realistic this is and it's only a
regression if you consider changes made since 2.6.39 to be a
"regression" vis-a-vis the policy regarding post-merge window bug
fixes, but Linus agreed it was worth fixing, so I'm including it in
this pull request.

This also fixes the journalled quota mount options, which I
accidentally broke while I was cleaning up the mount option handling.

----------------------------------------------------------------
Theodore Ts'o (2):
      ext4: address scalability issue by removing extent cache statistics
      ext4: fix handling of journalled quota options

 fs/ext4/ext4.h    |    3 ---
 fs/ext4/extents.c |    4 ----
 fs/ext4/super.c   |   48 +++++++++++++++---------------------------------
 3 files changed, 15 insertions(+), 40 deletions(-)
