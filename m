From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 16/28] ext4: fix ext4_xattr_cmp()
Date: Wed, 31 May 2017 01:15:05 -0700
Message-ID: <20170531081517.11438-16-tahsin@google.com>
References: <20170531081517.11438-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33540 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdEaIRJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 31 May 2017 04:17:09 -0400
Received: by mail-pg0-f53.google.com with SMTP id u187so4573777pgb.0
        for <linux-ext4@vger.kernel.org>; Wed, 31 May 2017 01:17:09 -0700 (PDT)
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
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
2.13.0.219.gdb65acc882-goog
