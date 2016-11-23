From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: fix inode checksum calculation problem of inode in some
 range of inode size
Date: Wed, 23 Nov 2016 09:28:46 +0900
Message-ID: <1479860927-4459-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>,
        Youngjin Gil <youngjin.gil@samsung.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47917 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752869AbcKWAYO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Nov 2016 19:24:14 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OH200EYPJRGM410@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 23 Nov 2016 09:24:00 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've fixed the race condition problem in calculating ext4 checksum
value in commit b47820edd163 ("ext4: avoid modifying checksum fields
directly during checksum veficationon"). However, by this change,
when calculating the checksum value of inode whose i_extra_size is
less than 4, we couldn't calculate the checksum value in a proper way.
This problem was found and reported by Nix, Thank you.

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/inode.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c06472..eaab3c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -71,10 +71,9 @@ static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 			csum = ext4_chksum(sbi, csum, (__u8 *)&dummy_csum,
 					   csum_size);
 			offset += csum_size;
-			csum = ext4_chksum(sbi, csum, (__u8 *)raw + offset,
-					   EXT4_INODE_SIZE(inode->i_sb) -
-					   offset);
 		}
+		csum = ext4_chksum(sbi, csum, (__u8 *)raw + offset,
+				   EXT4_INODE_SIZE(inode->i_sb) - offset);
 	}
 
 	return csum;
-- 
1.7.9.5

