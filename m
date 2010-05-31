From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 46/53] ext4: Show journal_checksum option
Date: Sun, 30 May 2010 22:49:59 -0400
Message-ID: <1275274206-3900-46-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44541 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

commit 39a4bade8c1826b658316d66ee81c09b0a4d7d42 upstream (as of v2.6.34-git13)

We failed to show journal_checksum option in /proc/mounts. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea9ad5b..03e5cae 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -877,6 +877,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
 		seq_puts(seq, ",journal_async_commit");
+	else if (test_opt(sb, JOURNAL_CHECKSUM))
+		seq_puts(seq, ",journal_checksum");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 	if (test_opt(sb, I_VERSION))
-- 
1.6.6.1.1.g974db.dirty

