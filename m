From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] debugfs: print "Xst" bits of file mode via stat
Date: Tue, 10 Oct 2017 16:38:50 -0600
Message-ID: <1507675130-69955-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:35459 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932243AbdJJWrD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 18:47:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, debugfs does not print the Xst high-order mode bits
in the "stat" output.  While "ls -l" shows these bits are set:

  # ls -il /mnt/tmp/O/0/d2/406306
  1588 0 -rwSrwSrw- 1 root root 0 Dec 31  1969 /mnt/tmp/O/0/d2/406306

debugfs currently only prints the low nine "ugo" mode bits:

  # debugfs -c -R "stat O/0/d2/406306" /dev/vgmyth/lvmythost4
  Inode: 1588   Type: regular    Mode:  0666   Flags: 0x80000

Fix debugfs so that the high-order mode bits are also printed,
if available, otherwise only print the standard low mode bits.

  # debugfs -c -R "stat O/0/d2/406306" /dev/vgmyth/lvmythost4
  Inode: 1588   Type: regular    Mode:  06666   Flags: 0x80000

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 0a4b536..4a533b5 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -830,8 +830,8 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	else if (LINUX_S_ISSOCK(inode->i_mode)) i_type = "socket";
 	else i_type = "bad type";
 	fprintf(out, "%sInode: %u   Type: %s    ", prefix, inode_num, i_type);
-	fprintf(out, "%sMode:  %04o   Flags: 0x%x\n",
-		prefix, inode->i_mode & 0777, inode->i_flags);
+	fprintf(out, "%sMode:  0%03o   Flags: 0x%x\n",
+		prefix, inode->i_mode & 07777, inode->i_flags);
 	if (is_large_inode && large_inode->i_extra_isize >= 24) {
 		fprintf(out, "%sGeneration: %u    Version: 0x%08x:%08x\n",
 			prefix, inode->i_generation, large_inode->i_version_hi,
-- 
1.8.0
