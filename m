From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/22] ext4: Create a rocompat flag for extended metadata
	checksumming
Date: Mon, 28 Nov 2011 15:26:29 -0800
Message-ID: <20111128232629.19194.43499.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch introduces a rocompat feature flag to signal the presence of
checksums for metadata blocks.  It also provides storage for a precomputed UUID
checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5b0e26a..414c2f8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1249,6 +1249,9 @@ struct ext4_sb_info {
 
 	/* record the last minlen when FITRIM is called. */
 	atomic_t s_last_trim_minblks;
+
+	/* Precomputed FS UUID checksum */
+	__u32 s_uuid_csum;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1397,6 +1400,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1440,7 +1444,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
 /*
  * Default values for user and/or group using reserved blocks
