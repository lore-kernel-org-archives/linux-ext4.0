From: Jim Garlick <garlick@llnl.gov>
Subject: [PATCH] e2fsprogs - pass1c terminates early if hard links
Date: Tue, 10 Apr 2007 13:51:12 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0704101344050.29750@webb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-3.llnl.gov ([128.115.41.83]:39922 "EHLO
	nspiron-3.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030654AbXDJUvN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Apr 2007 16:51:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

I think this is a small buglet in e2fsck:  if a file has multiple hard 
links, e2fsck pass1c search_dirent_proc() doesn't maintain its count 
properly and may return DIRENT_ABORT before it has found containing 
directories for all inodes sharing blocks.

Signed-off-by: Jim Garlick <garlick@llnl.gov>

Index: e2fsprogs+chaos/e2fsck/pass1b.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass1b.c
+++ e2fsprogs+chaos/e2fsck/pass1b.c
@@ -372,8 +372,10 @@ static int search_dirent_proc(ext2_ino_t
  	if (!n)
  		return 0;
  	p = (struct dup_inode *) dnode_get(n);
-	p->dir = dir;
-	sd->count--;
+	if (!p->dir) {
+		p->dir = dir;
+		sd->count--;
+	}

  	return(sd->count ? 0 : DIRENT_ABORT);
  }
