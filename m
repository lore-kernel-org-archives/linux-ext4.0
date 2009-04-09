From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Do not update mtime of a move directory when parent has not changed
Date: Thu,  9 Apr 2009 20:41:32 +0200
Message-ID: <1239302492-10455-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	ronny.pretzsch@dfs.de, hare@suse.de
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZDISlf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Apr 2009 14:41:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the parent of the moved directory has not changed, there's no real
reason to change mtime. Specs doesn't seem to say anything about this
particular case and e.g. ext3 does not change mtime in this case.
So we become a tiny bit more consistent.

Spotted by ronny.pretzsch@dfs.de, initial fix by J=C3=B6rn Engel <joern=
@logfs.org>.

CC: ronny.pretzsch@dfs.de
CC: hare@suse.de
Acked-by: J=C3=B6rn Engel <joern@logfs.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/namei.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 90ea179..556f258 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -352,7 +352,10 @@ static int ext2_rename (struct inode * old_dir, st=
ruct dentry * old_dentry,
 	inode_dec_link_count(old_inode);
=20
 	if (dir_de) {
-		ext2_set_link(old_inode, dir_de, dir_page, new_dir);
+		/* Set link only if parent has changed and thus avoid setting
+		 * of mtime of the moved directory on a pure rename. */
+		if (old_dir !=3D new_dir)
+			ext2_set_link(old_inode, dir_de, dir_page, new_dir);
 		inode_dec_link_count(old_dir);
 	}
 	return 0;
--=20
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
