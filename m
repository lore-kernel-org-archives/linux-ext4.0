From: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 14/32] ext4: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:38 +0200
Message-ID: <1401480116-1973111-15-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
	john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
	geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4fs uses unsigned 34-bit seconds for inode timestamps, which will work
for the next 500 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in ext4.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h    | 10 +++++-----
 fs/ext4/extents.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 92d9f1a..b60adc9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -726,14 +726,14 @@ struct move_extent {
 	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
 	    (einode)->i_extra_isize))			\
 
-static inline __le32 ext4_encode_extra_time(struct timespec *time)
+static inline __le32 ext4_encode_extra_time(struct inode_time *time)
 {
        return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
 			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
                           ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
 }
 
-static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
+static inline void ext4_decode_extra_time(struct inode_time *time, __le32 extra)
 {
        if (sizeof(time->tv_sec) > 4)
 	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
@@ -879,9 +879,9 @@ struct ext4_inode_info {
 
 	/*
 	 * File creation time. Its function is same as that of
-	 * struct timespec i_{a,c,m}time in the generic inode.
+	 * struct inode_time i_{a,c,m}time in the generic inode.
 	 */
-	struct timespec i_crtime;
+	struct inode_time i_crtime;
 
 	/* mballoc */
 	struct list_head i_prealloc_list;
@@ -1354,7 +1354,7 @@ static inline struct ext4_inode_info *EXT4_I(struct inode *inode)
 	return container_of(inode, struct ext4_inode_info, vfs_inode);
 }
 
-static inline struct timespec ext4_current_time(struct inode *inode)
+static inline struct inode_time ext4_current_time(struct inode *inode)
 {
 	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
 		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee14768..ed11d79 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4894,7 +4894,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	int ret = 0;
 	int flags;
 	ext4_lblk_t lblk;
-	struct timespec tv;
+	struct inode_time tv;
 	unsigned int blkbits = inode->i_blkbits;
 
 	/* Return error if mode is not supported */
-- 
1.8.3.2
