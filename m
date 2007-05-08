From: akpm@linux-foundation.org
Subject: [patch 014/455] ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems
Date: Tue, 08 May 2007 00:23:39 -0700
Message-ID: <200705080723.l487NdmU016386@shell0.pdx.osdl.net>
Cc: akpm@linux-foundation.org, Markus.Rechberger@amd.com,
	adilger@dilger.ca, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbXEHHYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2007 03:24:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Markus Rechberger <Markus.Rechberger@amd.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=5079

signed long ranges from -2.147.483.648 to 2.147.483.647 on x86 32bit

10000011110110100100111110111101 .. -2,082,844,739
10000011110110100100111110111101 ..  2,212,122,557 <- this currently gets 
stored on the disk but when converting it to a 64bit signed long value it loses 
its sign and becomes positive.

Cc: Andreas Dilger <adilger@dilger.ca>
Cc: <linux-ext4@vger.kernel.org>

Andreas says:

This patch is now treating timestamps with the high bit set as negative
times (before Jan 1, 1970).  This means we lose 1/2 of the possible range
of timestamps (lopping off 68 years before unix timestamp overflow -
now only 30 years away :-) to handle the extremely rare case of setting
timestamps into the distant past.

If we are only interested in fixing the underflow case, we could just
limit the values to 0 instead of storing negative values.  At worst this
will skew the timestamp by a few hours for timezones in the far east
(files would still show Jan 1, 1970 in "ls -l" output).

That said, it seems 32-bit systems (mine at least) allow files to be set
into the past (01/01/1907 works fine) so it seems this patch is bringing
the x86_64 behaviour into sync with other kernels.

On the plus side, we have a patch that is ready to add nanosecond timestamps
to ext3 and as an added bonus adds 2 high bits to the on-disk timestamp so
this extends the maximum date to 2242.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    6 +++---
 fs/ext3/inode.c |    6 +++---
 fs/ext4/inode.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ext2/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems
+++ a/fs/ext2/inode.c
@@ -1079,9 +1079,9 @@ void ext2_read_inode (struct inode * ino
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
-	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
-	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
-	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
+	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
+	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
+	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
 	/* We now have enough fields to check if the inode was active or not.
diff -puN fs/ext3/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems
+++ a/fs/ext3/inode.c
@@ -2608,9 +2608,9 @@ void ext3_read_inode(struct inode * inod
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
-	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
-	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
-	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
+	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
+	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
+	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
 
 	ei->i_state = 0;
diff -puN fs/ext4/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems
+++ a/fs/ext4/inode.c
@@ -2611,9 +2611,9 @@ void ext4_read_inode(struct inode * inod
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
-	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
-	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
-	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
+	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
+	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
+	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
 
 	ei->i_state = 0;
_
