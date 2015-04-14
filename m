From: akpm@linux-foundation.org
Subject: [patch 1/2] fs/ext4/fsync.c: generic_file_fsync call based on
 barrier flag
Date: Tue, 14 Apr 2015 13:25:31 -0700
Message-ID: <552d77bb.NxPkttc8NtgPTL7d%akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, fabf@skynet.be, hch@infradead.org,
	jack@suse.cz, lczerner@redhat.com, viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbbDNUZc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2015 16:25:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ext4/fsync.c: generic_file_fsync call based on barrier flag

generic_file_fsync has been updated to issue a flush for older
filesystems.

This patch tests for barrier flag in ext4 mount flags and calls the right
function.


Lukas said:

: Note that the actual generic_file_fsync change fixes a real bug in ext4
: where we would _not_ send a flush on sync if we have file system
: without journal.
:
: Ted, it would be useful to mention that in the commit description
: along with the commit id:
:
: ac13a829f6adb674015ab399594c089990104af7 fs/libfs.c: add generic
: data flush to fsync

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
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
