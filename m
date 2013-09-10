From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix performance regression in writeback of random writes
Date: Tue, 10 Sep 2013 21:40:06 +0200
Message-ID: <1378842006-15237-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Yan Zheng <ukernel@gmail.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3IJTkN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 15:40:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linux Kernel Performance project guys have reported that commit 4e7ea81db5
introduces a performance regression for the following fio workload:
[global]
direct=0
ioengine=mmap
size=1500M
bs=4k
pre_read=1
numjobs=1
overwrite=1
loops=5
runtime=300
group_reporting
invalidate=0
directory=/mnt/
file_service_type=random:36
file_service_type=random:36

[job0]
startdelay=0
rw=randrw
filename=data0/f1:data0/f2

[job1]
startdelay=0
rw=randrw
filename=data0/f2:data0/f1
...

[job7]
startdelay=0
rw=randrw
filename=data0/f2:data0/f1

The culprit of the problem is that after the commit ext4_writepages()
are more aggressive in writing back pages. Thus we have less consecutive
dirty pages resulting in more seeking.

This increased aggressivity is caused by a bug in the condition
terminating ext4_writepages(). We start writing from the beginning of
the file even if we should have terminated ext4_writepages() because
wbc->nr_to_write <= 0.

After fixing the condition the throughput of the fio workload is about 20%
better than before writeback reorganization.

Reported-by: "Yan, Zheng" <zheng.z.yan@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c79fd7d..7914c05 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2563,7 +2563,7 @@ retry:
 			break;
 	}
 	blk_finish_plug(&plug);
-	if (!ret && !cycled) {
+	if (!ret && !cycled && wbc->nr_to_write > 0) {
 		cycled = 1;
 		mpd.last_page = writeback_index - 1;
 		mpd.first_page = 0;
-- 
1.8.1.4

