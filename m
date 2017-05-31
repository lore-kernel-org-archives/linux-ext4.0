From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 13/28] ext4: ext4_xattr_value_same() should return false for external data
Date: Wed, 31 May 2017 01:15:02 -0700
Message-ID: <20170531081517.11438-13-tahsin@google.com>
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
Received: from mail-pg0-f54.google.com ([74.125.83.54]:36353 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdEaIRN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 31 May 2017 04:17:13 -0400
Received: by mail-pg0-f54.google.com with SMTP id x64so4572810pgd.3
        for <linux-ext4@vger.kernel.org>; Wed, 31 May 2017 01:17:08 -0700 (PDT)
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_xattr_value_same() is used as a quick optimization in case the new
xattr value is identical to the previous value. When xattr value is
stored in a xattr inode the check becomes expensive so it is better to
just assume that they are not equal.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 4dd8be16d175..681a9b5eefd8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1428,6 +1428,9 @@ static int ext4_xattr_value_same(struct ext4_xattr_search *s,
 {
 	void *value;
 
+	/* When e_value_inum is set the value is stored externally. */
+	if (s->here->e_value_inum)
+		return 0;
 	if (le32_to_cpu(s->here->e_value_size) != i->value_len)
 		return 0;
 	value = ((void *)s->base) + le16_to_cpu(s->here->e_value_offs);
-- 
2.13.0.219.gdb65acc882-goog
