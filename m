From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: force ro mount if ext3_setup_super() fails
Date: Thu, 24 May 2012 12:00:47 -0500
Message-ID: <4FBE693F.6090705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337Ab2EXRAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 13:00:48 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4OH0mM6027356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:00:48 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4OH0lCm006842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:00:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_setup_super() fails i.e. due to a too-high revision,
the error is logged in dmesg but the fs is not mounted RO as
indicated.

Tested by:

# mkfs.ext4 -r 4 /dev/sdb6
# mount /dev/sdb6 /mnt/test
# dmesg | grep "too high"
[164919.759248] EXT4-fs (sdb6): revision level too high, forcing read-only mode
# grep sdb6 /proc/mounts
/dev/sdb6 /mnt/test2 ext4 rw,seclabel,relatime,data=ordered 0 0
                          ^^

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e1fb1d5..be67c0b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3592,7 +3592,8 @@ no_journal:
 		goto failed_mount4;
 	}
 
-	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
+	if (ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY))
+		sb->s_flags |= MS_RDONLY;
 
 	/* determine the minimum size of new large inodes, if present */
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {

