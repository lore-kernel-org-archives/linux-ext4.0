From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] ext4: Show journal_checksum option
Date: Mon,  3 May 2010 12:15:09 +0200
Message-ID: <1272881709-4973-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, sheridan@shezza.org,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab0ECKPO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 May 2010 06:15:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We failed to show journal_checksum option in /proc/mounts. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8f4f079..04fdaf1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -846,6 +846,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
 		seq_puts(seq, ",journal_async_commit");
+	else if (test_opt(sb, JOURNAL_CHECKSUM))
+		seq_puts(seq, ",journal_checksum");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 	if (test_opt(sb, I_VERSION))
-- 
1.6.0.2

