From: Jean-Noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 3/3] change attribute for ext4: user interface
Date: Wed, 29 Nov 2006 19:54:22 +0100
Message-ID: <456DD75E.4020001@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:2439 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S967540AbWK2SxQ
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 13:53:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 96AE919D920
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:53:11 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21654-02 for <linux-ext4@vger.kernel.org>;
 Wed, 29 Nov 2006 19:53:07 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B8C9119D925
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:53:06 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds a  ``st_change_attribute'' field in the stat
structure, and modifies the stat(2) syscall accordingly. Currently the
change is only visible on i386 and x86_64 archs.



Signed-off-by: Celine Bourde
Signed-off-by: Alexandre Ratchov
Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

Index: linux-2.6.19-rc2-mm2-CA/include/asm-i386/stat.h
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/include/asm-i386/stat.h        2006-11-09 
17:21:28.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/include/asm-i386/stat.h     2006-11-29 
16:03:30.000000000 +0100
@@ -32,7 +32,7 @@
         unsigned long  st_mtime_nsec;
         unsigned long  st_ctime;
         unsigned long  st_ctime_nsec;
-       unsigned long  __unused4;
+       unsigned long  st_change_attribute;
         unsigned long  __unused5;
  };

@@ -41,7 +41,7 @@
   */
  struct stat64 {
         unsigned long long      st_dev;
-       unsigned char   __pad0[4];
+       unsigned char   st_change_attribute;

  #define STAT64_HAS_BROKEN_ST_INO       1
         unsigned long   __st_ino;
Index: linux-2.6.19-rc2-mm2-CA/include/asm-x86_64/stat.h
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/include/asm-x86_64/stat.h      2006-11-13 
16:49:14.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/include/asm-x86_64/stat.h   2006-11-29 
16:04:24.000000000 +0100
@@ -23,7 +23,8 @@
         unsigned long   st_mtime_nsec;
         unsigned long   st_ctime;
         unsigned long   st_ctime_nsec;
-       long            __unused[3];
+       unsigned long   st_change_attribute;
+       long            __unused[2];
  };

  /* For 32bit emulation */
Index: linux-2.6.19-rc2-mm2-CA/include/linux/stat.h
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/include/linux/stat.h   2006-11-09 
17:21:49.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/include/linux/stat.h        2006-11-29 
16:06:02.000000000 +0100
@@ -68,6 +68,7 @@
         struct timespec  atime;
         struct timespec mtime;
         struct timespec ctime;
+       unsigned long   change_attribute;
         unsigned long   blksize;
         unsigned long long      blocks;
  };
Index: linux-2.6.19-rc2-mm2-CA/fs/stat.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/stat.c      2006-11-09 17:20:52.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/stat.c   2006-11-29 16:07:54.000000000 +0100
@@ -32,6 +32,7 @@
         stat->mtime = inode->i_mtime;
         stat->ctime = inode->i_ctime;
         stat->size = i_size_read(inode);
+       stat->change_attribute = inode->i_change_attribute;
         stat->blocks = inode->i_blocks;
         stat->blksize = (1 << inode->i_blkbits);
  }
@@ -233,6 +234,7 @@
         tmp.st_atime = stat->atime.tv_sec;
         tmp.st_mtime = stat->mtime.tv_sec;
         tmp.st_ctime = stat->ctime.tv_sec;
+       tmp.st_change_attribute = stat->change_attribute;
  #ifdef STAT_HAVE_NSEC
         tmp.st_atime_nsec = stat->atime.tv_nsec;
         tmp.st_mtime_nsec = stat->mtime.tv_nsec;
@@ -366,6 +368,7 @@
         tmp.st_mtime_nsec = stat->mtime.tv_nsec;
         tmp.st_ctime = stat->ctime.tv_sec;
         tmp.st_ctime_nsec = stat->ctime.tv_nsec;
+       tmp.st_change_attribute = stat->change_attribute;
         tmp.st_size = stat->size;
         tmp.st_blocks = stat->blocks;
         tmp.st_blksize = stat->blksize;
