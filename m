From: Dmitriy Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4:fix unexpected error from ext4_reserve_global
Date: Thu, 14 Jun 2007 19:29:27 +0400
Message-ID: <20070614152927.GC6517@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:45036 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXFNP24 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2007 11:28:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I just cant belive my eyes then i saw this at the first time...
simple test: strace dd if=/dev/zero of=/mnt/file

open("/dev/zero", O_RDONLY)             = 0
close(1)                                = 0
open("/mnt/test/file", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
write(1, "\0\0\0\0\0\0\0\0"..., 512) = 512
read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
write(1, "\0\0\0\0\0\0\0\0"..., 512) = -1 ENOENT (No such fil
e or directory)

This strange error returned from ext4_reserve_global().
It's just typo because:
a) In fact this is 100% ENOSPC situation
b) simular function ext4_reserve_local() returns -ENOSPC

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4d7bfd2..43ae8f8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1920,7 +1920,7 @@ int ext4_reserve_global(struct super_block *sb, int blocks)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_reservation_slot *rs;
-	int i, rc = -ENOENT;
+	int i, rc = -ENOSPC;
 	__u64 free = 0;
 
 	rs = sbi->s_reservation_slots;
-- 
1.5.2
