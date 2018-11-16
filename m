Return-Path: <SRS0=OKzU=N3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36395 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389824AbeKPXCS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Nov 2018 18:02:18 -0500
Received: by mail-pg1-f194.google.com with SMTP id n2so3407569pgm.3
        for <linux-ext4@vger.kernel.org>; Fri, 16 Nov 2018 04:50:03 -0800 (PST)
From: Eiichi Tsukata <devel@etsukata.com>
To: andi@firstfloor.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
Subject: [RFC PATCH 1/1] ext4: fix race between llseek SEEK_END and write
Date: Fri, 16 Nov 2018 17:37:37 +0900
Message-Id: <20181116083737.10596-2-devel@etsukata.com>
In-Reply-To: <20181116083737.10596-1-devel@etsukata.com>
References: <20181116083737.10596-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
removed almost all locks in llseek() including SEEK_END. It based on the
idea that write() updates size atomically. But in fact, write() can be
divided into two or more parts in generic_perform_write() when pos
straddles over the PAGE_SIZE, which results in updating size multiple
times in one write(). It means that llseek() can see the size being
updated during write().

This race changes behavior of some applications. 'tail' is one of those
applications. It reads range [pos, pos_end] where pos_end is obtained
via llseek() SEEK_END. Sometimes, a read line could be broken.

reproducer:

  $ while true; do echo 123456 >> out; done
  $ while true; do tail out | grep -v 123456 ; done

example output(take 30 secs):

  12345
  1
  1234
  1
  12
  1234

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/ext4/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 69d65d49837b..6479f3066043 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -477,6 +477,16 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	default:
 		return generic_file_llseek_size(file, offset, whence,
 						maxbytes, i_size_read(inode));
+	case SEEK_END:
+		/*
+		 * protects against inode size race with write so that llseek
+		 * doesn't see inode size being updated in generic_perform_write
+		 */
+		inode_lock_shared(inode);
+		offset = generic_file_llseek_size(file, offset, whence,
+						  maxbytes, i_size_read(inode));
+		inode_unlock_shared(inode);
+		return offset;
 	case SEEK_HOLE:
 		inode_lock_shared(inode);
 		offset = iomap_seek_hole(inode, offset, &ext4_iomap_ops);
-- 
2.19.1
