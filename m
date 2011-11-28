From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/22] ext4: Create bitmap checksum helper functions
Date: Mon, 28 Nov 2011 15:27:03 -0800
Message-ID: <20111128232703.19194.55084.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40601 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab1K1X1L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 18:27:11 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 18:27:10 -0500
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These helper functions will be used to calculate and verify the block and inode
bitmap checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/bitmap.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index fa3af81..285d23a 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -29,3 +29,16 @@ unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 
 #endif  /*  EXT4FS_DEBUG  */
 
+static __u32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
+			      struct buffer_head *bh, int sz)
+{
+	__u32 csum;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	group = cpu_to_le32(group);
+	csum = ext4_chksum(sbi, sbi->s_uuid_csum, (__u8 *)&group,
+			   sizeof(group));
+	csum = ext4_chksum(sbi, csum, (__u8 *)bh->b_data, sz);
+
+	return csum;
+}

