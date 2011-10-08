From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 13/28] ext4: Create bitmap checksum helper functions
Date: Sat, 08 Oct 2011 00:55:09 -0700
Message-ID: <20111008075509.20506.61977.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

These helper functions will be used to calculate and verify the block and inode
bitmap checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/bitmap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index fa3af81..43d9173 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -29,3 +29,15 @@ unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 
 #endif  /*  EXT4FS_DEBUG  */
 
+static __u32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
+			      struct buffer_head *bh, int sz)
+{
+	__u32 crc;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	group = cpu_to_le32(group);
+	crc = ext4_chksum(sbi, sbi->s_uuid_crc, (__u8 *)&group, sizeof(group));
+	crc = ext4_chksum(sbi, crc, (__u8 *)bh->b_data, sz);
+
+	return crc;
+}
