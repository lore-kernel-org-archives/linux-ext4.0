From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] debugfs.8: fix name of argument to blocks command
Date: Sun, 12 Feb 2017 16:00:09 -0800
Message-ID: <20170213000009.14084-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34146 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdBMAB0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2017 19:01:26 -0500
Received: by mail-pg0-f66.google.com with SMTP id v184so8107259pgv.1
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 16:01:26 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 debugfs/debugfs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index e151d43a..87d487e7 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -179,7 +179,7 @@ This is a list of the commands which
 .B debugfs
 supports.
 .TP
-.BI blocks " filespace"
+.BI blocks " filespec"
 Print the blocks used by the inode
 .I filespec
 to stdout.
-- 
2.11.1
