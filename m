From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: add missing save_error_info() to ext4_error()
Date: Wed, 30 May 2012 23:03:56 -0400
Message-ID: <1338433436-2782-2-git-send-email-tytso@mit.edu>
References: <1338433436-2782-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, ksumrall@google.com,
	stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46614 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab2EaDD6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 23:03:58 -0400
In-Reply-To: <1338433436-2782-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_error() function is missing a call to save_error_info().
Since this is the function which marks the file system as containing
an error, this oversight (which was introduced in 2.6.36) is quite
significant, and should be backported to older stable kernels with
high urgency.

Reported-by: Ken Sumrall <ksumrall@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: ksumrall@google.com
Cc: stable@kernel.org
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9f1ae6b..b8d5fc1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -539,6 +539,7 @@ void __ext4_error(struct super_block *sb, const char *function,
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
 	       sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
+	save_error_info(sb, function, line);
 
 	ext4_handle_error(sb);
 }
-- 
1.7.10.2.552.gaa3bb87

