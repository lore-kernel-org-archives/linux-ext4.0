From: Johann Lombardi <johann@Sun.COM>
Subject: [PATCH] Fix goal inum check
Date: Tue, 23 Jun 2009 13:15:21 +0200
Message-ID: <20090623111521.GA27273@lore>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:53564 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFWLaf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 07:30:35 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5NBFWbs029129
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 11:15:46 GMT
Content-disposition: inline
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KLO00600SSAJJ00@fe-emea-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 23 Jun 2009 12:15:32 +0100 (BST)
Received: from lore ([unknown] [129.150.124.47])
 by fe-emea-10.sun.com (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPSA id <0KLO008QSV9MFZ10@fe-emea-10.sun.com> for
 linux-ext4@vger.kernel.org; Tue, 23 Jun 2009 12:15:23 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The goal inode is specificed by inode number which belongs
to [1; s_inodes_count].

Signed-off-by: Johann Lombardi <johann@sun.com>
--

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2f64573..29e6dc7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -833,7 +833,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
 	if (!goal)
 		goal = sbi->s_inode_goal;
 
-	if (goal && goal < le32_to_cpu(sbi->s_es->s_inodes_count)) {
+	if (goal && goal <= le32_to_cpu(sbi->s_es->s_inodes_count)) {
 		group = (goal - 1) / EXT4_INODES_PER_GROUP(sb);
 		ino = (goal - 1) % EXT4_INODES_PER_GROUP(sb);
 		ret2 = 0;
