From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH resend 0/6] use little-endian bitops properly
Date: Sun, 26 Jun 2011 14:57:50 +0900
Message-ID: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	dm-devel@redhat.com, NeilBrown <neilb@suse.de>,
	linux-raid@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63942 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1FZF4i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Jun 2011 01:56:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All patches in this patch set were sent before. Individual patches
improve little-endian bitops usage in several places.

Akinobu Mita (6):
  ext4: use proper little-endian bitops
  dm: use use proper little-endian bitops
  md: use proper little-endian bitops
  reiserfs: use proper little-endian bitops
  reiserfs: use hweight_long()
  ocfs2: avoid unaligned access to dqc_bitmap

 drivers/md/bitmap.c         |    4 +-
 drivers/md/dm-log.c         |    9 +++----
 fs/ext4/ext4.h              |    7 +++--
 fs/ext4/ialloc.c            |    4 +-
 fs/ocfs2/ocfs2.h            |   47 +++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c      |   10 ++++----
 fs/reiserfs/bitmap.c        |    8 +-----
 fs/reiserfs/resize.c        |    6 ++--
 include/linux/reiserfs_fs.h |    2 +
 9 files changed, 71 insertions(+), 26 deletions(-)

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel@oss.oracle.com

-- 
1.7.4.4

