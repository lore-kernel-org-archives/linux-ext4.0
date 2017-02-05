From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/7] ext4: return EROFS if device is r/o and journal replay is needed
Date: Sun,  5 Feb 2017 02:34:27 -0500
Message-ID: <20170205073430.9109-4-tytso@mit.edu>
References: <20170205073430.9109-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34014 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbdBEHef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 5 Feb 2017 02:34:35 -0500
In-Reply-To: <20170205073430.9109-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system requires journal recovery, and the device is
read-ony, return EROFS to the mount system call.  This allows xfstests
generic/050 to pass.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3fef82e79131..514e5fc59893 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3925,7 +3925,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * root first: it may be modified in the journal!
 	 */
 	if (!test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb)) {
-		if (ext4_load_journal(sb, es, journal_devnum))
+		err = ext4_load_journal(sb, es, journal_devnum);
+		if (err)
 			goto failed_mount3a;
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 		   ext4_has_feature_journal_needs_recovery(sb)) {
-- 
2.11.0.rc0.7.gbe5a750
