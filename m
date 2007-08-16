From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] provide missing mode for open-create in check_mntent_file
Date: Thu, 16 Aug 2007 17:37:02 -0500
Message-ID: <46C4D18E.3080509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761918AbXHPWjo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2007 18:39:44 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7GMdixI000487
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 18:39:44 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7GMdhc9028489
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 18:39:43 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l7GMdhTR024680
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 18:39:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

F8 is catching opens with O_CREAT flags and no mode now, and refusing
to build them... 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-git/lib/ext2fs/ismounted.c
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/ismounted.c
+++ e2fsprogs-git/lib/ext2fs/ismounted.c
@@ -147,7 +147,7 @@ static errcode_t check_mntent_file(const
 is_root:
 #define TEST_FILE "/.ismount-test-file"		
 		*mount_flags |= EXT2_MF_ISROOT;
-		fd = open(TEST_FILE, O_RDWR|O_CREAT);
+		fd = open(TEST_FILE, O_RDWR|O_CREAT, 0644);
 		if (fd < 0) {
 			if (errno == EROFS)
 				*mount_flags |= EXT2_MF_READONLY;
