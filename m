From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: force ro mount if ext3_setup_super() fails
Date: Thu, 24 May 2012 12:00:37 -0500
Message-ID: <4FBE6935.3000301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337Ab2EXRAo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 13:00:44 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4OH0iAY023474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:00:44 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4OH0bTM012171
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:00:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext3_setup_super() fails i.e. due to a too-high revision,
the error is logged in dmesg but the fs is not mounted RO as
indicated.

Tested by:

# mkfs.ext3 -r 4 /dev/sdb6
# mount /dev/sdb6 /mnt/test
# dmesg | grep "too high"
[164152.114551] EXT3-fs (sdb6): error: revision level too high, forcing read-only mode
# grep sdb6 /proc/mounts
/dev/sdb6 /mnt/test2 ext3 rw,seclabel,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
                          ^^

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cf0b592..fef7af2 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2043,7 +2043,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount3;
 	}
 
-	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+	if (ext3_setup_super(sb, es, sb->s_flags & MS_RDONLY))
+		sb->s_flags |= MS_RDONLY;
 
 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
 	ext3_orphan_cleanup(sb, es);

