From: Solofo.Ramangalahy@bull.net
Subject: [PATCH] ext4: update ctime and mtime for truncate with extents.
Date: Mon, 7 Apr 2008 10:43:23 +0200
Message-ID: <18425.57003.125097.61814@frecb006361.adech.frec.bull.fr>
References: <Pine.LNX.4.62.0804030034200.664@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57684 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbYDGIow (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 04:44:52 -0400
In-Reply-To: <Pine.LNX.4.62.0804030034200.664@tamago.serverit.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: update ctime and mtime for truncate with extents.

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

The recently announced "Linux POSIX file system test suite"
catched a truncate issue when using extents:
mtime and ctime are not updated when truncate is successful.

This is the single issue catched with "default" ext4 (mkfs and mount
with minimal options).
The testsuite does not report failure with -o noextents.

With the following patch, all tests of the testsuite passes.

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/extents.c
===================================================================
--- linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d.orig/fs/ext4/extents.c
+++ linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/extents.c
@@ -2947,6 +2947,7 @@ out_stop:
 		ext4_orphan_del(handle, inode);
 
 	up_write(&EXT4_I(inode)->i_data_sem);
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_journal_stop(handle);
 }
 
