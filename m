From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] - ignore bind mounts in fsck
Date: Wed, 19 Sep 2007 15:20:14 -0500
Message-ID: <46F1847E.6080400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbXISUUR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 16:20:17 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l8JKKGi7006575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 16:20:16 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8JKKF3v029872
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 16:20:15 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l8JKKF8W018543
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 16:20:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

An entry like this in /etc/fstab:

/foo	/bar	ext3	bind,defaults	1 3

will stop boot, as fsck.ext3 tries to check it and fails:

e2fsck 1.40.2 (12-Jul-2007)
fsck.ext3: Is a directory while trying to open /foo

The superblock could not be read or does not describe a correct ext2
filesystem. ...

Granted, asking for fsck of a bind mount in the fstab is a bit odd, 
but it doesn't seem like it should stop the boot process if you make
this mistake.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/misc/fsck.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/fsck.c
+++ e2fsprogs-1.40.2/misc/fsck.c
@@ -867,6 +867,12 @@ static int ignore(struct fs_info *fs)
 	if (fs->passno == 0)
 		return 1;
 
+	/*
+	 * If this is a bind mount, ignore it.
+	 */
+	if (opt_in_list("bind", fs->opts))
+		return 1;
+
 	interpret_type(fs);
 
 	/*
