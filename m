From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: initialize large inodes for journal & resize
Date: Tue, 16 Jun 2009 21:50:53 -0500
Message-ID: <4A385A0D.3040505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZFQCux (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jun 2009 22:50:53 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5H2otEl028166
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 22:50:55 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5H2otbr021116
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 22:50:55 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5H2orcR012539
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 22:50:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I noticed that neither the journal nor resize inodes have
i_extra_isize set post-mkfs; while this isn't likely
to be a big problem, I think the below patch tidies
it up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index f5a9dba..412f50b 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -354,7 +354,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	inode.i_links_count = 1;
 	inode.i_mode = LINUX_S_IFREG | 0600;
 
-	if ((retval = ext2fs_write_inode(fs, journal_ino, &inode)))
+	if ((retval = ext2fs_write_new_inode(fs, journal_ino, &inode)))
 		goto errout;
 	retval = 0;
 
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index dda7c2b..62b5988 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -208,7 +208,7 @@ out_inode:
 #endif
 	if (inode_dirty) {
 		inode.i_atime = inode.i_mtime = fs->now ? fs->now : time(0);
-		retval2 = ext2fs_write_inode(fs, EXT2_RESIZE_INO, &inode);
+		retval2 = ext2fs_write_new_inode(fs, EXT2_RESIZE_INO, &inode);
 		if (!retval)
 			retval = retval2;
 	}

