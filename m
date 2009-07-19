From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] ext4: fix build warning when EXT4FS_DEBUG is on
Date: Mon, 20 Jul 2009 01:20:57 +0800
Message-ID: <1248024057-21418-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:59615 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbZGSRVq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 13:21:46 -0400
Received: by wa-out-1112.google.com with SMTP id j5so298222wah.21
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2009 10:21:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When compiling with EXT4FS_DEBUG on, gcc will complain with following w=
arnings:

linux-2.6/fs/ext4/ialloc.c: In function =E2=80=98ext4_count_free_inodes=
=E2=80=99:
linux-2.6/fs/ext4/ialloc.c:1192: warning: format =E2=80=98%lu=E2=80=99 =
expects type
=E2=80=98long unsigned int=E2=80=99, but argument 2 has type =E2=80=98e=
xt4_group_t=E2=80=99

So add a type cast to suppress it.=20

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2f64573..cd77f03 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1189,7 +1189,7 @@ unsigned long ext4_count_free_inodes(struct super=
_block *sb)
=20
 		x =3D ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
 		printk(KERN_DEBUG "group %lu: stored =3D %d, counted =3D %lu\n",
-			i, ext4_free_inodes_count(sb, gdp), x);
+			(unsigned long)i, ext4_free_inodes_count(sb, gdp), x);
 		bitmap_count +=3D x;
 	}
 	brelse(bitmap_bh);
--=20
1.6.2-rc2.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
