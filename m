From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 33/40] ext4: Show journal_checksum option
Date: Tue,  1 Jun 2010 08:03:20 -0400
Message-ID: <1275393807-14369-33-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47269 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
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
index 459da7c..9803da8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -890,6 +890,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
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

