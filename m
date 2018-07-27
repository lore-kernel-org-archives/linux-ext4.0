From: Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 2/3] ext4: super: Fix spectre gadgets in ext4_quota_{read,write,off}
Date: Fri, 27 Jul 2018 16:23:56 +0000
Message-ID: <20180727162357.30801-3-jcline@redhat.com>
References: <20180727162357.30801-1-jcline@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180727162357.30801-1-jcline@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

'type' is a user-controlled value used to index 'sb_dqopt(sb)->files'.
Clamp 'type' to the size of the array to avoid a speculative
out-of-bounds read.

These gadgets were found with the help of smatch:

* fs/ext4/super.c:5741 ext4_quota_read() warn: potential spectre issue
  'sb_dqopt(sb)->files' [r]

* fs/ext4/super.c:5778 ext4_quota_write() warn: potential spectre issue
  'sb_dqopt(sb)->files' [r]

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---
 fs/ext4/super.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c04a09b51742..de358eba024a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5693,10 +5693,13 @@ static int ext4_enable_quotas(struct super_block *sb)
 
 static int ext4_quota_off(struct super_block *sb, int type)
 {
-	struct inode *inode = sb_dqopt(sb)->files[type];
+	struct inode *inode;
 	handle_t *handle;
 	int err;
 
+	type = array_index_nospec(type, MAXQUOTAS);
+	inode = sb_dqopt(sb)->files[type];
+
 	/* Force all delayed allocation blocks to be allocated.
 	 * Caller already holds s_umount sem */
 	if (test_opt(sb, DELALLOC))
@@ -5740,13 +5743,17 @@ static int ext4_quota_off(struct super_block *sb, int type)
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off)
 {
-	struct inode *inode = sb_dqopt(sb)->files[type];
+	struct inode *inode;
 	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
 	int offset = off & (sb->s_blocksize - 1);
 	int tocopy;
 	size_t toread;
 	struct buffer_head *bh;
-	loff_t i_size = i_size_read(inode);
+	loff_t i_size;
+
+	type = array_index_nospec(type, MAXQUOTAS);
+	inode = sb_dqopt(sb)->files[type];
+	i_size = i_size_read(inode);
 
 	if (off > i_size)
 		return 0;
@@ -5777,13 +5784,16 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off)
 {
-	struct inode *inode = sb_dqopt(sb)->files[type];
+	struct inode *inode;
 	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
 	int err, offset = off & (sb->s_blocksize - 1);
 	int retries = 0;
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
+	type = array_index_nospec(type, MAXQUOTAS);
+	inode = sb_dqopt(sb)->files[type];
+
 	if (EXT4_SB(sb)->s_journal && !handle) {
 		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
 			" cancelled because transaction is not started",
-- 
2.17.1
