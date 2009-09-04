From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] resize2fs: calculate minimal fs size only once
Date: Fri,  4 Sep 2009 15:22:39 +0800
Message-ID: <1252048959-7936-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "Peng Tao" <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:61035 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZIDHXI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 03:23:08 -0400
Received: by pzk28 with SMTP id 28so583237pzk.27
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2009 00:23:09 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When running resize2fs -M, no need to recalculate the minimal fs size.

Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
---
 resize/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index c6cbb5e..220c192 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -375,7 +375,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 	if (force_min_size)
-		new_size = calculate_minimum_resize_size(fs);
+		new_size = min_size;
 	else if (new_size_str) {
 		new_size = parse_num_blocks(new_size_str,
 					    fs->super->s_log_block_size);
-- 
1.6.4.2.446.gbd046

