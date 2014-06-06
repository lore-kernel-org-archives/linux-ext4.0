From: akpm@linux-foundation.org
Subject: [patch 1/1] fs/ext4/fsync.c: generic_file_fsync call based on barrier flag
Date: Fri, 06 Jun 2014 12:51:50 -0700
Message-ID: <20140606195150.728635A45DE@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	fabf@skynet.be, hch@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33112 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaFFTvv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2014 15:51:51 -0400
Received: by mail-ob0-f202.google.com with SMTP id wm4so689894obc.5
        for <linux-ext4@vger.kernel.org>; Fri, 06 Jun 2014 12:51:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ext4/fsync.c: generic_file_fsync call based on barrier flag

generic_file_fsync has been updated to issue a flush for older
filesystems.

This patch tests for barrier flag in ext4 mount flags and calls the right
function.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/fsync.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ext4/fsync.c~fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag fs/ext4/fsync.c
--- a/fs/ext4/fsync.c~fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag
+++ a/fs/ext4/fsync.c
@@ -107,7 +107,10 @@ int ext4_sync_file(struct file *file, lo
 	}
 
 	if (!journal) {
-		ret = generic_file_fsync(file, start, end, datasync);
+		if (test_opt(inode->i_sb, BARRIER))
+			ret = generic_file_fsync(file, start, end, datasync);
+		else
+			ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
 		goto out;
_
