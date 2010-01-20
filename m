From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] default max mount count to unused
Date: Wed, 20 Jan 2010 16:37:25 -0600
Message-ID: <4B5785A5.2010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bill Nottingham <notting@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0ATWh1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jan 2010 17:37:27 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0KMbRW6024739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 17:37:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bill Nottingham <notting@redhat.com>

Anaconda has been setting the max mount count on the root fs
to -1 (unused) for ages.

I (Eric) tend to agree that using mount count as a proxy for potential
for corruption seems odd.  And waiting for fsck on a reboot just because
it's number 20 (or so) is painful.  Can we just turn it off by default?

I wouldn't mind killing the periodic check as well, but consider
this a trial balloon.  :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
index 19899bc..a0439bf 100644
--- a/doc/libext2fs.texinfo
+++ b/doc/libext2fs.texinfo
@@ -319,7 +319,8 @@ skip the filesystem check if the number of times that the filesystem has
 been mounted is less than @code{s_max_mnt_count} and if the interval
 between the last time a filesystem check was performed and the current
 time is less than @code{s_checkinterval} (see below).  The default value
-of @code{s_max_mnt_count} is 20.
+of @code{s_max_mnt_count} is -1 (which means that this check is not
+done).
 
 @item s_checkinterval
 This field defines the minimal interval between filesystem checks.  See
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 114b001..b98d6e8 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -484,7 +484,7 @@ struct ext2_inode_large {
 /*
  * Maximal mount counts between two filesystem checks
  */
-#define EXT2_DFL_MAX_MNT_COUNT		20	/* Allow 20 mounts */
+#define EXT2_DFL_MAX_MNT_COUNT		-1	/* Don't use mount check */
 #define EXT2_DFL_CHECKINTERVAL		0	/* Don't use interval check */
 
 /*

