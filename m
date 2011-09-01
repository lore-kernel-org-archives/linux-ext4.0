From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/16] ext4: Create a rocompat flag for extended metadata
	checksumming
Date: Wed, 31 Aug 2011 17:31:04 -0700
Message-ID: <20110901003104.31048.86177.stgit@elm3c44.beaverton.ibm.com>
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

This patch introduces a rocompat feature flag to signal the presence of
checksums for metadata blocks.  It also pulls in CRC32c since we'll be
using that for the new checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/Kconfig |    1 +
 fs/ext4/ext4.h  |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..97f4a7d 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -2,6 +2,7 @@ config EXT4_FS
 	tristate "The Extended 4 (ext4) filesystem"
 	select JBD2
 	select CRC16
+	select LIBCRC32C
 	help
 	  This is the next generation of the ext3 filesystem.
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ecb86c2..f79ddac 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1359,6 +1359,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
+#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1401,7 +1402,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
-					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
 /*
  * Default values for user and/or group using reserved blocks
