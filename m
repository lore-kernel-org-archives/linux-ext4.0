From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 12/28] ext4: Use i_generation in inode-related metadata
	checksums
Date: Sat, 08 Oct 2011 00:55:02 -0700
Message-ID: <20111008075502.20506.15728.stgit@elm3c44.beaverton.ibm.com>
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

Whenever we are calculating a checksum for a piece of metadata that is
associated with an inode, incorporate i_generation into that calculation so
that old metadata blocks cannot be re-associated after a delete/create cycle.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ialloc.c |    9 ++++++---
 fs/ext4/inode.c  |    9 ++++++---
 fs/ext4/ioctl.c  |    4 ++++
 3 files changed, 16 insertions(+), 6 deletions(-)


diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 6e5876a..d4b59e9 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1031,11 +1031,14 @@ got:
 	/* Precompute second piece of crc */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		__u32 crc;
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 		__le32 inum = cpu_to_le32(inode->i_ino);
-		ei->i_uuid_inum_crc = ext4_chksum(sbi, sbi->s_uuid_crc,
-						  (__u8 *)&inum,
-						  sizeof(inum));
+		__le32 gen = cpu_to_le32(inode->i_generation);
+		crc = ext4_chksum(sbi, sbi->s_uuid_crc, (__u8 *)&inum,
+				  sizeof(inum));
+		ei->i_uuid_inum_crc = ext4_chksum(sbi, crc, (__u8 *)&gen,
+						  sizeof(gen));
 	}
 
 	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b00315d..593f3bf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3492,10 +3492,13 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		__u32 crc;
 		__le32 inum = cpu_to_le32(inode->i_ino);
-		ei->i_uuid_inum_crc = ext4_chksum(sbi, sbi->s_uuid_crc,
-						  (__u8 *)&inum,
-						  sizeof(inum));
+		__le32 gen = raw_inode->i_generation;
+		crc = ext4_chksum(sbi, sbi->s_uuid_crc, (__u8 *)&inum,
+				  sizeof(inum));
+		ei->i_uuid_inum_crc = ext4_chksum(sbi, crc, (__u8 *)&gen,
+						  sizeof(gen));
 	}
 
 	if (!ext4_inode_csum_verify(inode, raw_inode, ei)) {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f18bfe3..fdf0b1e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -149,6 +149,10 @@ flags_out:
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 
+		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+			return -ENOTTY;
+
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
 			return err;
