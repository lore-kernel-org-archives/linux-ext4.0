From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 1/2] ext3: don't update sb journal_devnum when RO dev
Date: Sun, 26 Sep 2010 15:38:28 -0700
Message-ID: <1285540709-16217-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61822 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0IZWkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Sep 2010 18:40:23 -0400
Received: by qwh6 with SMTP id 6so2988275qwh.19
        for <linux-ext4@vger.kernel.org>; Sun, 26 Sep 2010 15:40:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An ext3 filesystem on a read-only device, with an external journal
which is at a different device number then recorded in the superblock
will fail to honor the read-only setting of the device and trigger
a superblock update (write).

=46or example:
  - ext3 on a software raid which is in read-only mode
  - external journal on a read-write device which has changed device nu=
m
  - attempt to mount with -o journal_dev=3D<new_number>
  - hits BUG_ON(mddev->ro =3D 1) in md.c

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
---
 fs/ext3/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5dbf4db..19dfbe9 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2299,7 +2299,7 @@ static int ext3_load_journal(struct super_block *=
sb,
 	EXT3_SB(sb)->s_journal =3D journal;
 	ext3_clear_journal_err(sb, es);
=20
-	if (journal_devnum &&
+	if (!really_read_only && journal_devnum &&
 	    journal_devnum !=3D le32_to_cpu(es->s_journal_dev)) {
 		es->s_journal_dev =3D cpu_to_le32(journal_devnum);
=20
--=20
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
