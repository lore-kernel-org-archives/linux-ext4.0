From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-e2fsprogs-resend] filefrag: fix fm_start in filefrag_fiemap loop
Date: Thu,  4 Jun 2009 09:18:40 +0800
Message-ID: <1244078320-13888-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:42107 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZFDBTL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 21:19:11 -0400
Received: by pxi12 with SMTP id 12so410442pxi.33
        for <linux-ext4@vger.kernel.org>; Wed, 03 Jun 2009 18:19:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When used with -v and the targeted file has more than 144 extents(double of
the length of fm_extents array provided by buf), filefrag_fiemap loops and
calls fiemap ioctl() multiple times to calculate the actual number of extents
in a file. Each call to fiemap ioctl() uses  fm_start as the starting logical
offset. The patch fixes fm_start in each loop( except for the first one) and
makes the extent calculation correct for files with more that 144 extents.  

To produce the problem, first run filefrag -v on a highly fragmented file.
Then change the buf size in filefrag_fiemap to make it large enough to have
all the extent mapped in a single loop and run filefrag -v after recompiling.
The former will produce a much smaller extent count because of the false
fm_start used in the loop. And the two will produce different extent output
since the 145th extent.

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

