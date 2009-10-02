From: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] ext4: in ext4_dirty_inode() current_handle only needed for debugging
Date: Sat,  3 Oct 2009 00:20:48 +0200
Message-ID: <1254522048-15046-1-git-send-email-tobias.doerffel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:46177 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZJBWzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 18:55:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As of d3d1faf6a74496ea4435fd057c6a2cad49f3e523 in ext4_dirty_inode()
the current_handle variable is only used for debugging now. Therefore
compiling fs/ext4/inode.c without JBD_DEBUG set will result in a
compiler warning:

fs/ext4/inode.c: In function =E2=80=98ext4_dirty_inode=E2=80=99:
fs/ext4/inode.c:5818: warning: unused variable =E2=80=98current_handle=E2=
=80=99

This commit fixes the issue by adding an according #ifdef directive.
---
 fs/ext4/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f1a0a..e5daa6c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5815,7 +5815,9 @@ int ext4_mark_inode_dirty(handle_t *handle, struc=
t inode *inode)
  */
 void ext4_dirty_inode(struct inode *inode)
 {
+#ifdef CONFIG_JBD_DEBUG
 	handle_t *current_handle =3D ext4_journal_current_handle();
+#endif
 	handle_t *handle;
=20
 	handle =3D ext4_journal_start(inode, 2);
--=20
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
