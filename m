From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] ext4: use 64-bit timestamps for mmp_time
Date: Wed, 20 Jun 2018 17:32:59 +0200
Message-ID: <20180620153322.54221-2-arnd@arndb.de>
References: <20180620153322.54221-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-ext4@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The mmp_time field is 64 bits wide, which is good, but calling
get_seconds() results in a 32-bit value on 32-bit architectures. Using
ktime_get_real_seconds() instead returns 64 bits everywhere.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/mmp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 27b9a76a0dfa..39da4eb48361 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -147,7 +147,7 @@ static int kmmpd(void *data)
 
 	mmp_block = le64_to_cpu(es->s_mmp_block);
 	mmp = (struct mmp_struct *)(bh->b_data);
-	mmp->mmp_time = cpu_to_le64(get_seconds());
+	mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
 	/*
 	 * Start with the higher mmp_check_interval and reduce it if
 	 * the MMP block is being updated on time.
@@ -165,7 +165,7 @@ static int kmmpd(void *data)
 			seq = 1;
 
 		mmp->mmp_seq = cpu_to_le32(seq);
-		mmp->mmp_time = cpu_to_le64(get_seconds());
+		mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
 		last_update_time = jiffies;
 
 		retval = write_mmp_block(sb, bh);
@@ -244,7 +244,7 @@ static int kmmpd(void *data)
 	 * Unmount seems to be clean.
 	 */
 	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
-	mmp->mmp_time = cpu_to_le64(get_seconds());
+	mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
 
 	retval = write_mmp_block(sb, bh);
 
-- 
2.9.0
