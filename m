From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: zero out nanosecond timestamps for small inodes
Date: Mon, 22 Nov 2010 11:45:48 -0600
Message-ID: <4CEAAC4C.3070406@redhat.com>
References: <4CE76938.8050304@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jordan Russell <jr-list-2010@quo.to>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab0KVRpw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 12:45:52 -0500
In-Reply-To: <4CE76938.8050304@quo.to>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As reported by Jordan Russell:

When nanosecond timestamp resolution isn't supported on an ext4
partition (inode size = 128), stat() appears to be returning
uninitialized garbage in the nanosecond component of timestamps.

EXT4_INODE_GET_XTIME should zero out tv_nsec when EXT4_FITS_IN_INODE
evaluates to false.

Reported-by: Jordan Russell <jr-list-2010@quo.to>
Signed-of-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6a5edea..1541e3e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -709,6 +709,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
 		ext4_decode_extra_time(&(inode)->xtime,			       \
 				       raw_inode->xtime ## _extra);	       \
+	else								       \
+		(inode)->xtime.tv_nsec = 0;				       \
 } while (0)
 
 #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
@@ -719,6 +721,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
+	else								       \
+		(einode)->xtime.tv_nsec = 0;				       \
 } while (0)
 
 #define i_disk_version osd1.linux1.l_i_version

