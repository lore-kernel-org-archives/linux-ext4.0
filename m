From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 3/3] i_version update for ext4: user interface
Date: Tue, 23 Jan 2007 18:24:19 +0100
Message-ID: <45B644C3.6000607@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49067 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092AbXAWRZA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2007 12:25:00 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds a  ``st_i_version'' field in the stat
structure, and modifies the stat(2) syscall accordingly. Currently the
change is only visible on i386 and x86_64 archs.



Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

Index: linux-2.6.20-rc5/fs/stat.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/stat.c     2007-01-19 16:59:15.000000000 +0100
+++ linux-2.6.20-rc5/fs/stat.c  2007-01-23 16:21:17.000000000 +0100
@@ -31,6 +31,7 @@
         stat->atime = inode->i_atime;
         stat->mtime = inode->i_mtime;
         stat->ctime = inode->i_ctime;
+       stat->i_version = inode->i_version;
         stat->size = i_size_read(inode);
         stat->blocks = inode->i_blocks;
         stat->blksize = (1 << inode->i_blkbits);
@@ -226,6 +227,7 @@
         tmp.st_atime = stat->atime.tv_sec;
         tmp.st_mtime = stat->mtime.tv_sec;
         tmp.st_ctime = stat->ctime.tv_sec;
+       tmp.st_i_version = stat->i_version;
  #ifdef STAT_HAVE_NSEC
         tmp.st_atime_nsec = stat->atime.tv_nsec;
         tmp.st_mtime_nsec = stat->mtime.tv_nsec;
@@ -359,6 +361,7 @@
         tmp.st_mtime_nsec = stat->mtime.tv_nsec;
         tmp.st_ctime = stat->ctime.tv_sec;
         tmp.st_ctime_nsec = stat->ctime.tv_nsec;
+       tmp.st_i_version = stat->i_version;
         tmp.st_size = stat->size;
         tmp.st_blocks = stat->blocks;
         tmp.st_blksize = stat->blksize;
Index: linux-2.6.20-rc5/include/linux/stat.h
===================================================================
--- linux-2.6.20-rc5.orig/include/linux/stat.h  2006-11-29 
22:57:37.000000000 +0100
+++ linux-2.6.20-rc5/include/linux/stat.h       2007-01-23 
16:22:18.000000000 +0100
@@ -68,6 +68,7 @@
         struct timespec  atime;
         struct timespec mtime;
         struct timespec ctime;
+       unsigned long   i_version;
         unsigned long   blksize;
         unsigned long long      blocks;
  };
Index: linux-2.6.20-rc5/include/asm-i386/stat.h
===================================================================
--- linux-2.6.20-rc5.orig/include/asm-i386/stat.h       2006-11-29 
22:57:37.000000000 +0100
+++ linux-2.6.20-rc5/include/asm-i386/stat.h    2007-01-23 
17:48:36.000000000 +0100
@@ -32,7 +32,7 @@
         unsigned long  st_mtime_nsec;
         unsigned long  st_ctime;
         unsigned long  st_ctime_nsec;
-       unsigned long  __unused4;
+       unsigned long  st_i_version;
         unsigned long  __unused5;
  };

@@ -41,7 +41,7 @@
   */
  struct stat64 {
         unsigned long long      st_dev;
-       unsigned char   __pad0[4];
+       unsigned int    st_i_version;

  #define STAT64_HAS_BROKEN_ST_INO       1
         unsigned long   __st_ino;
Index: linux-2.6.20-rc5/include/asm-x86_64/stat.h
===================================================================
--- linux-2.6.20-rc5.orig/include/asm-x86_64/stat.h     2006-11-29 
22:57:37.000000000 +0100
+++ linux-2.6.20-rc5/include/asm-x86_64/stat.h  2007-01-23 
17:57:03.000000000 +0100
@@ -23,7 +23,8 @@
         unsigned long   st_mtime_nsec;
         unsigned long   st_ctime;
         unsigned long   st_ctime_nsec;
-       long            __unused[3];
+       unsigned long   st_i_version;
+       long            __unused[2];
  };

  /* For 32bit emulation */
