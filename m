From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 13/32] ext4: ext4_xattr_value_same() should return false for external data
Date: Wed, 21 Jun 2017 14:21:23 -0700
Message-ID: <20170621212142.16581-13-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
2.13.1.611.g7e3b11ae1-goog
