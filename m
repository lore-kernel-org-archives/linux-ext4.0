From: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl
 updates inode
Date: Tue, 3 Jan 2012 02:31:52 +0100
Message-ID: <20120103013152.GA26455@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:56276 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2ACB2r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jan 2012 20:28:47 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The EXT{3,4}_IOC_SETVERSION ioctl() updates the inode without i_mutex,
this can lead to a race with the other operations that update the same
inode.

Patch tested.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/ext3/ioctl.c |    6 +++++-
 fs/ext4/ioctl.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index ba1b54e..e7b2ed9 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -134,10 +134,11 @@ flags_out:
 			goto setversion_out;
 		}
 
+		mutex_lock(&inode->i_mutex);
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
-			goto setversion_out;
+			goto unlock_out;
 		}
 		err = ext3_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
@@ -146,6 +147,9 @@ flags_out:
 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext3_journal_stop(handle);
+
+unlock_out:
+		mutex_unlock(&inode->i_mutex);
 setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a567968..46a8de6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -158,10 +158,11 @@ flags_out:
 			goto setversion_out;
 		}
 
+		mutex_lock(&inode->i_mutex);
 		handle = ext4_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
-			goto setversion_out;
+			goto unlock_out;
 		}
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
@@ -170,6 +171,9 @@ flags_out:
 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext4_journal_stop(handle);
+
+unlock_out:
+		mutex_unlock(&inode->i_mutex);
 setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
-- 
1.7.1
