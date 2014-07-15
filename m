From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
Date: Tue, 15 Jul 2014 09:05:29 +0800
Message-ID: <53C47E59.8030502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When SMP is disabled, 'struct percpu_counter' has no 'counters' member,
so need skip it when in !SMP.

The related git commit:

  "feab139 ext4: rearrange initialization to fix EXT4FS_DEBUG".

The related error (with allmodconfig under score):

    CC [M]  fs/ext4/super.o
  fs/ext4/super.c: In function 'ext4_commit_super':
  fs/ext4/super.c:4546:41: error: 'struct percpu_counter' has no member named 'counters'
    if (EXT4_SB(sb)->s_freeclusters_counter.counters)
                                           ^
  fs/ext4/super.c:4550:39: error: 'struct percpu_counter' has no member named 'counters'
    if (EXT4_SB(sb)->s_freeinodes_counter.counters)
                                         ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 fs/ext4/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30767cd..3cd4fe1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4543,11 +4543,15 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	else
 		es->s_kbytes_written =
 			cpu_to_le64(EXT4_SB(sb)->s_kbytes_written);
+#ifdef CONFIG_SMP
 	if (EXT4_SB(sb)->s_freeclusters_counter.counters)
+#endif
 		ext4_free_blocks_count_set(es,
 			EXT4_C2B(EXT4_SB(sb), percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeclusters_counter)));
+#ifdef CONFIG_SMP
 	if (EXT4_SB(sb)->s_freeinodes_counter.counters)
+#endif
 		es->s_free_inodes_count =
 			cpu_to_le32(percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeinodes_counter));
-- 
1.9.2.459.g68773ac
