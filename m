From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH] resize2fs: fix 32bit overflow during minimal size calculation for 64bit fs.
Date: Sat, 26 Jul 2014 11:19:27 +0400
Message-ID: <1406359167-13610-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lists2009@fnarfbargle.com, tytso@mit.edu,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48456 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaGZHTi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 03:19:38 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so4115163lbi.15
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jul 2014 00:19:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

calculate_minimum_resize_size() multiplying two 32bit numbers, however =
the
result must be 64bit, but it will be truncated to 32bit, and because of=
 this
data_blocks will be zero, and it will never leave loop:
blocks_per_group=3D32768 (u32)
extra_groups=3D131072 (u32)
data_blocks=3D4294967296 # overflow

And here is messages from log with resize2fs -f 255:
fs has 4007207 inodes, 1957 groups required.
fs requires 4374122900 data blocks.
With 1957 group(s), we have 63820826 blocks available.
Added 131540 extra group(s), blks_needed 4374122900, data_blocks=C2=B76=
2023030, last_start 4356599580
Added 131595 extra group(s), blks_needed 4374122900, data_blocks=C2=B77=
3483100, last_start 5781212288
Added 131246 extra group(s), blks_needed 4374122900, data_blocks=C2=B77=
9184732, last_start 5781244926
Added 131072 extra group(s), blks_needed 4374122900, data_blocks=C2=B77=
9184732, last_start 5781277564
Added 131072 extra group(s), blks_needed 4374122900, data_blocks=C2=B77=
9184732, last_start 5781310202
=2E..

Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
Tested-by: Brad Campbell <lists2009@fnarfbargle.com>
Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 resize/resize2fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 546b1d8..6777bfa 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2479,7 +2479,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys=
 fs, int flags)
 		extra_grps =3D ext2fs_div64_ceil(remainder,
 					       EXT2_BLOCKS_PER_GROUP(fs->super));
=20
-		data_blocks +=3D extra_grps * EXT2_BLOCKS_PER_GROUP(fs->super);
+		data_blocks +=3D (unsigned long long)extra_grps *
+			EXT2_BLOCKS_PER_GROUP(fs->super);
=20
 		/* ok we have to account for the last group */
 		overhead =3D calc_group_overhead(fs, groups-1, old_desc_blocks);
--=20
2.0.1

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
