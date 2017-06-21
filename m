From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 16/32] ext4: fix ext4_xattr_cmp()
Date: Wed, 21 Jun 2017 14:21:26 -0700
Message-ID: <20170621212142.16581-16-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:35732 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbdFUVWR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:17 -0400
Received: by mail-pg0-f43.google.com with SMTP id 132so48540359pgb.2
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:11 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a xattr entry refers to an external inode, the value data is not
available in the inline area so we should not attempt to read it using
value offset.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 9c243b3510b7..739f73a5a345 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2169,7 +2169,8 @@ ext4_xattr_cmp(struct ext4_xattr_header *header1,
 		    entry1->e_value_inum != entry2->e_value_inum ||
 		    memcmp(entry1->e_name, entry2->e_name, entry1->e_name_len))
 			return 1;
-		if (memcmp((char *)header1 + le16_to_cpu(entry1->e_value_offs),
+		if (!entry1->e_value_inum &&
+		    memcmp((char *)header1 + le16_to_cpu(entry1->e_value_offs),
 			   (char *)header2 + le16_to_cpu(entry2->e_value_offs),
 			   le32_to_cpu(entry1->e_value_size)))
 			return 1;
-- 
2.13.1.611.g7e3b11ae1-goog
