From: Simon Ruderich <simon@ruderich.org>
Subject: [PATCH] ext4: mention noload when recovering on read-only device
Date: Thu, 14 Sep 2017 12:23:06 +0200
Message-ID: <977f189abb1ff382dedd6916b7140081d47d3e8d.1505383806.git.simon@ruderich.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zucker2.schokokeks.org ([178.63.68.90]:40949 "EHLO
        zucker2.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbdINKXI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Sep 2017 06:23:08 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Help the user to find the appropriate mount option to continue mounting
the file system on a read-only device if the journal requires recovery.

Signed-off-by: Simon Ruderich <simon@ruderich.org>
---
Hello,

I tried to mount an ext4 which required recovery from a read-only
device and stumbled over this error. I freaked out for a second
(trying to restore from a backup) and it took me a (short) while
to figure out what to do and I thought it would be useful to give
the user a hand by pointing to the required mount option.

Regards
Simon

 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d61a70e2193a..f497b79da5cc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4589,7 +4589,8 @@ static int ext4_load_journal(struct super_block *sb,
 					"required on readonly filesystem");
 			if (really_read_only) {
 				ext4_msg(sb, KERN_ERR, "write access "
-					"unavailable, cannot proceed");
+					"unavailable, cannot proceed "
+					"(try mounting with noload)");
 				return -EROFS;
 			}
 			ext4_msg(sb, KERN_INFO, "write access will "
-- 
2.14.1

-- 
+ privacy is necessary
+ using gnupg http://gnupg.org
+ public key id: 0x92FEFDB7E44C32F9
