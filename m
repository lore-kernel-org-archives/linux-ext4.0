From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] ext3: Remove outdated comment about lock_super()
Date: Mon, 14 Dec 2009 12:59:18 -0600
Message-ID: <4B268B06.7080108@redhat.com>
References: <4B268A3C.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853AbZLNS7R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 13:59:17 -0500
In-Reply-To: <4B268A3C.8060708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@mit.edu>

ext3_fill_super() is no longer called by read_super(), and it is no
longer called with the superblock locked.  The
unlock_super()/lock_super() is no longer present, so this comment is
entirely superfluous.

Crossport of 32ed5058ce90024efcd811254b4b1de0468099df

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext3/super.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 427496c..bed624c 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1974,14 +1974,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
-	/*
-	 * akpm: core read_super() calls in here with the superblock locked.
-	 * That deadlocks, because orphan cleanup needs to lock the superblock
-	 * in numerous places.  Here we just pop the lock - it's relatively
-	 * harmless, because we are now ready to accept write_super() requests,
-	 * and aviro says that's the only reason for hanging onto the
-	 * superblock lock.
-	 */
+
 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
 	ext3_orphan_cleanup(sb, es);
 	EXT3_SB(sb)->s_mount_state &= ~EXT3_ORPHAN_FS;
-- 1.6.0.6

