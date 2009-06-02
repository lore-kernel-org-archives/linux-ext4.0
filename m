From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-e2fsprogs] filefrag: fix fm_start in filefrag_fiemap loop
Date: Wed,  3 Jun 2009 02:03:03 +0800
Message-ID: <1243965783-31950-1-git-send-email-bergwolf@gmail.com>
Cc: tytso@mit.edu, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:40499 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZFBSDh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2009 14:03:37 -0400
Received: by pzk7 with SMTP id 7so6867121pzk.33
        for <linux-ext4@vger.kernel.org>; Tue, 02 Jun 2009 11:03:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/filefrag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 6bea2cd..7786646 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -239,7 +239,7 @@ int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 			n++;
 		}
 
-		fiemap->fm_start += fm_ext[i-1].fe_logical +
+		fiemap->fm_start = fm_ext[i-1].fe_logical +
 							fm_ext[i-1].fe_length;
 	} while (last == 0);
 
-- 
1.6.2.GIT

