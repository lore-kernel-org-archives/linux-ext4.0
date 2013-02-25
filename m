From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] ext4: cleanup sbi->s_kobj after quota initialization failure
Date: Mon, 25 Feb 2013 15:55:23 -0500
Message-ID: <512BCFBB.30208@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Aditya Kali <adityakali@google.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759800Ab3BYUzb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 15:55:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_enable_quotas fails, it jumps to failed_mount7, which doesn't
tear down the kobj.

Cc: Aditya Kali <adityakali@google.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/ext4/super.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3794,7 +3794,7 @@ no_journal:
 	    !(sb->s_flags & MS_RDONLY)) {
 		err = ext4_enable_quotas(sb);
 		if (err)
-			goto failed_mount7;
+			goto failed_mount8;
 	}
 #endif  /* CONFIG_QUOTA */
 
@@ -3813,6 +3813,10 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+failed_mount8:
+	kobject_del(&sbi->s_kobj);
+	kobject_put(&sbi->s_kobj);
+	wait_for_completion(&sbi->s_kobj_unregister);
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:

-- 
Jeff Mahoney
SUSE Labs
