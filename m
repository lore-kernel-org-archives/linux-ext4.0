From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext4/ialloc.c: functions should not be declared extern
Date: Fri, 23 Sep 2011 15:19:45 -0700
Message-ID: <201109231519.45350.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail127.messagelabs.com ([216.82.250.115]:23027 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1IWWTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 18:19:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function declaration in ext4.h is already marked extern. =C2=A0The =
function
definition should not have the tag.

This quiets the sparse noise:

warning: function 'ext4_init_inode_table' with external linkage has def=
inition

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index fd96ea1..ef9bdd6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1235,7 +1235,7 @@ unsigned long ext4_count_dirs(struct super_block =
* sb)
  * inode allocation from the current group, so we take alloc_sem lock,=
 to
  * block ext4_claim_inode until we are finished.
  */
-extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t =
group,
+int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 				 int barrier)
 {
 	struct ext4_group_info *grp =3D ext4_get_group_info(sb, group);
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
