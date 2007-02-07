From: akpm@linux-foundation.org
Subject: + ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:19:18 -0800
Message-ID: <200702070019.l170JI9W001545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Cc: Markus.Rechberger@amd.com, adilger@dilger.ca,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems
has been added to the -mm tree.  Its filename is
     ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems
From: Markus Rechberger <Markus.Rechberger@amd.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=5079

signed long ranges from -2.147.483.648 to 2.147.483.647 on x86 32bit

10000011110110100100111110111101 .. -2,082,844,739
10000011110110100100111110111101 ..  2,212,122,557 <- this currently gets 
stored on the disk but when converting it to a 64bit signed long value it loses 
its sign and becomes positive.

Cc: Andreas Dilger <adilger@dilger.ca>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    6 +++---
 fs/ext3/inode.c |    6 +++---
 fs/ext4/inode.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ext2/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems
+++ a/fs/ext2/inode.c
@@ -1077,9 +1077,9 @@ void ext2_read_inode (struct inode * ino
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
@@ -2670,9 +2670,9 @@ void ext3_read_inode(struct inode * inod
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
@@ -2673,9 +2673,9 @@ void ext4_read_inode(struct inode * inod
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

Patches currently in -mm which might be from Markus.Rechberger@amd.com are

ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems.patch
