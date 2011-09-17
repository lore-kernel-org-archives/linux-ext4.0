From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: initialize inode to 0 in list_dir_proc() if no inode
 nr
Date: Fri, 16 Sep 2011 20:36:02 -0500
Message-ID: <4E73F982.3020806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab1IQBgD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 21:36:03 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p8H1a3xC019518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 21:36:03 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p8H1a2Cp030855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 21:36:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If (!ino), the inode will be uninitialized when we print it
in the PARSE_OPT case.

So do the same as the LONG_OPT case, and memset it to 0 if
(!ino).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/ls.c b/debugfs/ls.c
index e01fd20..f21e96e 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -73,15 +73,18 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 		lbr = rbr = ' ';
 	}
 	if (ls->options & PARSE_OPT) {
-		if (ino && debugfs_read_inode(ino, &inode, name)) return 0;
+		if (ino) {
+			if (debugfs_read_inode(ino, &inode, name))
+				return 0;
+		} else
+			memset(&inode, 0, sizeof(struct ext2_inode));
 		fprintf(ls->f,"/%u/%06o/%d/%d/%s/",ino,inode.i_mode,inode.i_uid, inode.i_gid,name);
 		if (LINUX_S_ISDIR(inode.i_mode))
 			fprintf(ls->f, "/");
 		else
 			fprintf(ls->f, "%lld/", EXT2_I_SIZE(&inode));
 		fprintf(ls->f, "\n");
-	}
-	else if (ls->options & LONG_OPT) {
+	} else if (ls->options & LONG_OPT) {
 		if (ino) {
 			if (debugfs_read_inode(ino, &inode, name))
 				return 0;

