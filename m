From: Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH] ext4: do not try to write superblock on journal-less readonly remount
Date: Thu, 25 Oct 2012 12:39:57 +0400
Message-ID: <1351154397-14743-1-git-send-email-mjt@msgid.tls.msk.ru>
Cc: sandeen@redhat.com, Michael Tokarev <mjt@tls.msk.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:33215 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933317Ab2JYIkL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 04:40:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a journal-less ext4 filesystem is mounted on a read-only block
device (blockdev --setro will do), each remount (for other, unrelated,
flags, like suid=>nosuid etc) results in a series of scary messages
from kernel telling about I/O errors on the device.

This is becauese of the following code ext4_remount():

       if (sbi->s_journal == NULL)
                ext4_commit_super(sb, 1);

at the end of remount procedure, which forces writing (flushing) of
a superblock regardless whenever it is dirty or not, if the filesystem
is readonly or not, and whenever the device itself is readonly or not.

The proposed fix tests whenever both old mount flags and new mount
flags does not include MS_READONLY, and only in this case calls
ext4_commit_super().

Maybe it is sufficient to check for MS_READONLY just in old mount
options (old_sb_flags).  Note this is journal-less mode, so, for
example, we weren't have journal replay operation, so if old flags
include MS_REASONLY, we shuold have no dirty blocks at all, and
there's no reason to call ext4_commit_super().

But only in case both old and new flags include MS_READONLY we're
certain we will not write anything - if new flag does not include
this bit, we will write sooner or later anyway, so preventing just
one commit_super() at the _beginning_ of mount is not really necessary.

This change probably applicable to -stable, -- not because it fixes
a serious bug, but because the messages printed by the kernel are
rather scary for an average user.  On the other hand, actual usage
of ext4 in nojournal mode on a read-only medium is very rare.

Thanks to Eric Sandeen for help in diagnosing this issue.

Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3e0851e..2e896fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4687,7 +4687,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	ext4_setup_system_zone(sb);
-	if (sbi->s_journal == NULL)
+	if (sbi->s_journal == NULL && !(sb->s_flags & old_sb_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
 	unlock_super(sb);
-- 
1.7.10.4

