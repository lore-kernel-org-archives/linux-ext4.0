From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] If the filesystem supports extents create an extent-based journal inode
Date: Wed, 27 Aug 2008 17:14:36 -0400
Message-ID: <1219871676-18456-4-git-send-email-tytso@mit.edu>
References: <20080827210636.GC26987@mit.edu>
 <1219871676-18456-1-git-send-email-tytso@mit.edu>
 <1219871676-18456-2-git-send-email-tytso@mit.edu>
 <1219871676-18456-3-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Boh=C3=A9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51448 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752832AbYH0VOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 17:14:38 -0400
In-Reply-To: <1219871676-18456-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/mkjournal.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index cd3df07..c112be9 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -298,6 +298,12 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	es.err = 0;
 	es.zero_count = 0;
 
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		inode.i_flags |= EXT4_EXTENTS_FL;
+		if ((retval = ext2fs_write_inode(fs, journal_ino, &inode)))
+			return retval;
+	}
+
 	/*
 	 * Set the initial goal block to be roughly at the middle of
 	 * the filesystem.  Pick a group that has the largest number
-- 
1.5.6.1.205.ge2c7.dirty

