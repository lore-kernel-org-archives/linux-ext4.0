From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: check missed return value ext4_sync_file
Date: Fri, 12 Mar 2010 11:37:43 +0300
Message-ID: <87y6hy9bqg.fsf_-_@openvz.org>
References: <87wrxij28h.fsf@openvz.org>
	<20100311162707.GB19923@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39354 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0CLIhs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Mar 2010 03:37:48 -0500
Received: by bwz1 with SMTP id 1so822874bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 12 Mar 2010 00:37:46 -0800 (PST)
In-Reply-To: <20100311162707.GB19923@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Thu, 11 Mar 2010 17:27:08 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Jan Kara <jack@suse.cz> writes:

>> We have to submit barrier before we start journal commit process.
>> otherwise transaction may be committed before data flushed to disk.
>> There is no difference from performance of view, but definitely
>> fsync becomes more correct.
Unfortunately this change does affect performance because latency
will be increased since we have to wait barrier before we start
journal commit. 
>> 
>> If jbd2_log_start_commit return 0 then it means that transaction
>> was already committed. So we don't have to issue barrier for
>> ordered mode, because it was already done during commit.
>   Umm, we have to - when a file has just been rewritten (i.e. no block
> allocation), then i_datasync_tid is not updated and thus we won't commit
> any transaction as a part of fdatasync (and that is correct because there
> are no metadata that need to be written for that fdatasync). But we still
> have to flush disk caches with data submitted by filemap_fdatawrite_and_wait.
Yepp. I've missed that. i thought that transaction id updated
even in that case.
The most unpleasant part in ext4_sync_file implementation is that 
barrier is issued on each fsync() call.  So some bad user may perform:
while(1) fsync(fd);
which result in bad system performance. And since barrier request is 
empty it is hard to detect the reason of troubles.
Off course we may solve it by introducing some sort of dirty flag
which is set in write_page, and clear in fsync. But it looks as
ugly workaround.
>
>> By unknown reason we ignored ret val from jbd2_log_wait_commit()
>> so even in case of EIO fsync will succeed.
>   I just forgot jbd2_log_wait_commit can return a failure...
In respect to previous comments the patch reduced to simple missed
error check fix.
BTW: While investigating similar code in ext3 i've found what
fsync is broken in case of external journal. JBD itself does not
send barrier to j_fs_dev. So if fsync goes via
log_start_commit/log_wait_commit path data loss is still possible.
I'm able to reproduce this via simple write test
wile (1) {
 write(fd, buf, 1024*1024)
 fsync(fd);
}
and then reboot in the middle of operation.
Later file content check spotted data inconsistency.
Will send a fix ASAP.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-check-missed-return-value-ext4_sync_file.patch

>From 1f7382ea4a8b8e3880e1938d161f924ea572a1e1 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 11 Mar 2010 20:14:13 +0300
Subject: [PATCH] ext4: check missed return value ext4_sync_file


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..42bd94a 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -101,7 +101,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		    (journal->j_fs_dev != journal->j_dev) &&
 		    (journal->j_flags & JBD2_BARRIER))
 			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-		jbd2_log_wait_commit(journal, commit_tid);
+		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
-- 
1.6.6


--=-=-=--
