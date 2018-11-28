Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32819 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbeK2DLR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2018 22:11:17 -0500
Received: by mail-lj1-f195.google.com with SMTP id v1-v6so23972519ljd.0
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 08:09:07 -0800 (PST)
Received: from localhost.localdomain ([195.208.173.203])
        by smtp.gmail.com with ESMTPSA id u26-v6sm1191116lji.22.2018.11.28.08.09.04
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 08:09:05 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Subject: [PATCH] Fix tst_super_size after ext2_super_block changes
Date: Wed, 28 Nov 2018 19:08:34 +0300
Message-Id: <20181128160834.1729-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commits "Reserve feature bit and SB field bit for filename encoding"
and "Add timestamp extension bits to superblock" change
ext2_super_block structure, but don't change tst_super_size test,
so "make check" fails with message:

error: s_reserved size 380 should be 392

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 lib/ext2fs/tst_super_size.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index 0adac411..a932685d 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -142,7 +142,16 @@ int main(int argc, char **argv)
 	check_field(s_lpf_ino, 4);
 	check_field(s_prj_quota_inum, 4);
 	check_field(s_checksum_seed, 4);
-	check_field(s_reserved, 98 * 4);
+	check_field(s_wtime_hi, 1);
+	check_field(s_mtime_hi, 1);
+	check_field(s_mkfs_time_hi, 1);
+	check_field(s_lastcheck_hi, 1);
+	check_field(s_first_error_time_hi, 1);
+	check_field(s_last_error_time_hi, 1);
+	check_field(s_pad, 2);
+	check_field(s_encoding, 2);
+	check_field(s_encoding_flags, 2);
+	check_field(s_reserved, 95 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif
-- 
2.14.3
