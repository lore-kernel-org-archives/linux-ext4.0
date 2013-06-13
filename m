From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] ext4: delete unused mapping variable
Date: Thu, 13 Jun 2013 09:48:18 -0400
Message-ID: <1371131298-2059-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:34519 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3FMNsZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jun 2013 09:48:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code refactoring in commit "ext4: refactor punch hole code"
left behind a now unused variable, causing:

fs/ext4/inode.c: In function =E2=80=98ext4_punch_hole=E2=80=99:
fs/ext4/inode.c:3495:24: warning: unused variable =E2=80=98mapping=E2=80=
=99 [-Wunused-variable]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Feel free to also fold this trivial change back into the original
punch hole commit on the dev branch]

 fs/ext4/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4411130..2644679 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3492,7 +3492,6 @@ int ext4_punch_hole(struct file *file, loff_t off=
set, loff_t length)
 	struct inode *inode =3D file_inode(file);
 	struct super_block *sb =3D inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
-	struct address_space *mapping =3D inode->i_mapping;
 	loff_t first_block_offset, last_block_offset;
 	handle_t *handle;
 	unsigned int credits;
--=20
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
