From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] ext4: Retry allocation when inline->extent conversion failed
Date: Tue, 10 Dec 2013 11:13:58 +0100
Message-ID: <1386670440-3158-2-git-send-email-jack@suse.cz>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3LJKOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 05:14:05 -0500
In-Reply-To: <1386670440-3158-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Similarly as other ->write_begin functions in ext4, also
ext4_da_write_inline_data_begin() should retry allocation if the
conversion failed because of ENOSPC. This avoids returning ENOSPC
prematurely because of uncommitted block deletions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index bae987549dc3..ed6e71fe5e9d 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -849,11 +849,13 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
 	handle_t *handle;
 	struct page *page;
 	struct ext4_iloc iloc;
+	int retries;
 
 	ret = ext4_get_inode_loc(inode, &iloc);
 	if (ret)
 		return ret;
 
+retry_journal:
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -875,6 +877,11 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
 							    inode,
 							    flags,
 							    fsdata);
+		ext4_journal_stop(handle);
+		handle = NULL;
+		if (ret == -ENOSPC &&
+		    ext4_should_retry_alloc(inode->i_sb, &retries))
+			goto retry_journal;
 		goto out;
 	}
 
-- 
1.8.1.4

