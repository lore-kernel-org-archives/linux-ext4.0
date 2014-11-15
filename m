From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/1] fs-ext4: Deletion of an unnecessary check before the
 function call "iput"
Date: Sat, 15 Nov 2014 19:19:36 +0100
Message-ID: <54679938.3020106@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58821 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbaKOSTp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Nov 2014 13:19:45 -0500
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 15 Nov 2014 19:04:06 +0100

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8b0f9ef..e1a2521 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2712,8 +2712,7 @@ int ext4_mb_release(struct super_block *sb)
 	}
 	kfree(sbi->s_mb_offsets);
 	kfree(sbi->s_mb_maxs);
-	if (sbi->s_buddy_cache)
-		iput(sbi->s_buddy_cache);
+	iput(sbi->s_buddy_cache);
 	if (sbi->s_mb_stats) {
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u blocks %u reqs (%u success)",
-- 
2.1.3


