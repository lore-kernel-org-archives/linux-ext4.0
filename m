From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v6 4/4] utimes: Clamp the timestamps before update
Date: Sun, 21 Jan 2018 18:04:26 -0800
Message-ID: <20180122020426.2988-5-deepa.kernel@gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180122020426.2988-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

POSIX.1 section for futimens, utimensat and utimes says:
The file's relevant timestamp shall be set to the
greatest value supported by the file system that is
not greater than the specified time.

Clamp the timestamps accordingly before assignment.

Note that the clamp_t macro is used for clamping here as vfs
is not yet using struct timespec64 internally. This is
required for compilation purposes.
Also note that clamp won't do the right thing for timestamps
beyond 2038 on 32-bit machines until the vfs uses timespec64.
After the vfs is transitioned to use timespec64 for timestamps,
clamp_t() can be replaced by clamp().

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/utimes.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index e4b3d7c2c9f5..82fdcc3284b9 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -50,6 +50,7 @@ static int utimes_common(const struct path *path, struct timespec64 *times)
 	int error;
 	struct iattr newattrs;
 	struct inode *inode = path->dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
 	struct inode *delegated_inode = NULL;
 
 	error = mnt_want_write(path->mnt);
@@ -65,16 +66,24 @@ static int utimes_common(const struct path *path, struct timespec64 *times)
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
 		else if (times[0].tv_nsec != UTIME_NOW) {
-			newattrs.ia_atime.tv_sec = times[0].tv_sec;
-			newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
+			newattrs.ia_atime.tv_sec =
+				clamp_t(time64_t, times[0].tv_sec, sb->s_time_min, sb->s_time_max);
+			if (times[0].tv_sec >= sb->s_time_max)
+				newattrs.ia_atime.tv_nsec = 0;
+			else
+				newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
 			newattrs.ia_valid |= ATTR_ATIME_SET;
 		}
 
 		if (times[1].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_MTIME;
 		else if (times[1].tv_nsec != UTIME_NOW) {
-			newattrs.ia_mtime.tv_sec = times[1].tv_sec;
-			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
+			newattrs.ia_mtime.tv_sec =
+				clamp_t(time64_t, times[1].tv_sec, sb->s_time_min, sb->s_time_max);
+			if (times[1].tv_sec >= sb->s_time_max)
+				newattrs.ia_mtime.tv_nsec = 0;
+			else
+				newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
 		/*
-- 
2.14.1
