From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2] ext4: check for overlapping extents in ext4_valid_extent_entries()
Date: Sun, 20 Oct 2013 21:27:27 +0800
Message-ID: <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eryu Guan <guaneryu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61582 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3JTN2n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Oct 2013 09:28:43 -0400
Received: by mail-pd0-f176.google.com with SMTP id g10so5525223pdj.7
        for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 06:28:43 -0700 (PDT)
In-Reply-To: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A corrupted ext4 may have out of order leaf extents, i.e.

extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
             ^^^^ overlap with previous extent

Reading such extent could hit BUG_ON() in ext4_es_cache_extent().

	BUG_ON(end < lblk);

The problem is that __read_extent_tree_block() tries to cache holes as
well but assumes 'lblk' is greater than 'prev' and passes underflowed
length to ext4_es_cache_extent(). Fix it by checking for overlapping
extents in ext4_valid_extent_entries().

I hit this when fuzz testing ext4, and am able to reproduce it by
modifying the on-disk extent by hand.

Ran xfstests on patched ext4 and no regression.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
Hi,

My second try to find and report the corruption instead of hiding it,
how about this one?

Thanks!

Eryu

 fs/ext4/extents.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c9ebcb9..855b11d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -387,11 +387,21 @@ static int ext4_valid_extent_entries(struct inode=
 *inode,
 	if (depth =3D=3D 0) {
 		/* leaf entries */
 		struct ext4_extent *ext =3D EXT_FIRST_EXTENT(eh);
+		ext4_lblk_t block =3D 0;
+		ext4_lblk_t prev =3D 0;
+		int len =3D 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
+
+			/* Check for overlapping extents */
+			block =3D le32_to_cpu(ext->ee_block);
+			len =3D ext4_ext_get_actual_len(ext);
+			if ((block <=3D prev) && prev)
+				return 0;
 			ext++;
 			entries--;
+			prev =3D block + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx =3D EXT_FIRST_INDEX(eh);
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
