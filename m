From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/16] ext4: Make inode checksum cover empty space
Date: Wed, 31 Aug 2011 17:32:07 -0700
Message-ID: <20110901003207.31048.55390.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
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
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Extend the inode checksum to cover the empty space between the end of the
inode's data fields and the end of the space allocated for the inode.  This
enables us to cover extended attribute data that might live in the empty space.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 44a7f88..e24ba98 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -53,7 +53,6 @@
 static __le32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_inode_info *ei = EXT4_I(inode);
 	int offset = offsetof(struct ext4_inode, i_checksum);
 	__le32 inum = cpu_to_le32(inode->i_ino);
 	__u32 crc = 0;
@@ -70,8 +69,7 @@ static __le32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
 	crc = crc32c_le(crc, (__u8 *)raw, offset);
 	offset += sizeof(raw->i_checksum); /* skip checksum */
 	crc = crc32c_le(crc, (__u8 *)raw + offset,
-		    EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize -
-		    offset);
+		    EXT4_INODE_SIZE(inode->i_sb) - offset);
 	return cpu_to_le32(crc);
 }
 
