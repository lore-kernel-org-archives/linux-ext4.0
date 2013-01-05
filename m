From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ext4: release buffer in failed path in dx_probe()
Date: Sat,  5 Jan 2013 15:43:00 +0800
Message-ID: <1357371781-18194-2-git-send-email-yan@linux.vnet.ibm.com>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55291 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3AEHnN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 02:43:13 -0500
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Sat, 5 Jan 2013 13:12:05 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id E65CD125804C
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jan 2013 13:13:16 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r057h4FG5046684
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jan 2013 13:13:04 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r057h53w001775
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jan 2013 07:43:05 GMT
In-Reply-To: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If checksum fails, we should also release the buffer
read from previous iteration.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 843e29f..e249a47 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -722,7 +722,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 			ext4_warning(dir->i_sb, "Node failed checksum");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
-			goto fail;
+			goto fail2;
 		}
 		set_buffer_verified(bh);
 
-- 
1.7.9.5

