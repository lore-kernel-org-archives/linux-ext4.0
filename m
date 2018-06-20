From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6] ext4: use timespec64 for all inode times
Date: Wed, 20 Jun 2018 17:33:01 +0200
Message-ID: <20180620153322.54221-4-arnd@arndb.de>
References: <20180620153322.54221-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-ext4@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is the last missing piece for the inode times on 32-bit systems:
now that VFS interfaces use timespec64, we just need to stop truncating
the tv_sec values for y2038 compatibililty.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/ext4.h   | 18 +++++++-----------
 fs/ext4/ialloc.c |  2 +-
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0b127853c584..6b4f4369a08c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -789,17 +789,16 @@ struct move_extent {
  * affected filesystem before 2242.
  */
 
-static inline __le32 ext4_encode_extra_time(struct timespec *time)
+static inline __le32 ext4_encode_extra_time(struct timespec64 *time)
 {
 	u32 extra = sizeof(time->tv_sec) > 4 ?
 		((time->tv_sec - (s32)time->tv_sec) >> 32) & EXT4_EPOCH_MASK : 0;
 	return cpu_to_le32(extra | (time->tv_nsec << EXT4_EPOCH_BITS));
 }
 
-static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
+static inline void ext4_decode_extra_time(struct timespec64 *time, __le32 extra)
 {
-	if (unlikely(sizeof(time->tv_sec) > 4 &&
-			(extra & cpu_to_le32(EXT4_EPOCH_MASK)))) {
+	if (unlikely(extra & cpu_to_le32(EXT4_EPOCH_MASK))) {
 
 #if 1
 		/* Handle legacy encoding of pre-1970 dates with epoch
@@ -821,9 +820,8 @@ static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 do {										\
 	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);		\
 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     {\
-		struct timespec ts = timespec64_to_timespec((inode)->xtime);	\
 		(raw_inode)->xtime ## _extra =					\
-				ext4_encode_extra_time(&ts);			\
+				ext4_encode_extra_time(&(inode)->xtime);	\
 		}								\
 } while (0)
 
@@ -840,10 +838,8 @@ do {									       \
 do {										\
 	(inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);	\
 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra)) {	\
-		struct timespec ts = timespec64_to_timespec((inode)->xtime);	\
-		ext4_decode_extra_time(&ts,					\
+		ext4_decode_extra_time(&(inode)->xtime,				\
 				       raw_inode->xtime ## _extra);		\
-		(inode)->xtime = timespec_to_timespec64(ts);			\
 		}								\
 	else									\
 		(inode)->xtime.tv_nsec = 0;					\
@@ -993,9 +989,9 @@ struct ext4_inode_info {
 
 	/*
 	 * File creation time. Its function is same as that of
-	 * struct timespec i_{a,c,m}time in the generic inode.
+	 * struct timespec64 i_{a,c,m}time in the generic inode.
 	 */
-	struct timespec i_crtime;
+	struct timespec64 i_crtime;
 
 	/* mballoc */
 	struct list_head i_prealloc_list;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f525f909b559..8c00c871f5dc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1073,7 +1073,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	/* This is the optimal IO size (for stat), not the fs block size */
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
-	ei->i_crtime = timespec64_to_timespec(inode->i_mtime);
+	ei->i_crtime = inode->i_mtime;
 
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_dir_start_lookup = 0;
-- 
2.9.0
