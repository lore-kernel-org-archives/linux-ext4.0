From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/6] ubifs: Provide a custom llseek for directories
Date: Sun, 21 May 2017 22:20:47 +0200
Message-ID: <1495398051-4604-3-git-send-email-richard@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1495398051-4604-1-git-send-email-richard@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When UBIFS is using 64bit cookies for directory offsets,
we have to support seeking that deep into direcoties.
Since generic_file_llseek() is uses sb->s_maxbytes it will
fail for use because on ubifs sb->s_maxbytes is the real maxmal
file size which can be much smaller than 64bit due to limitations
of the flash device.

Therefore provie a custom llseek operation.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c         | 12 +++++++++++-
 fs/ubifs/ubifs-media.h |  6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 566079d9b402..cada60690c22 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1686,6 +1686,16 @@ static int ubifs_dir_open(struct inode *dir, struct file *file)
 	return 0;
 }
 
+static loff_t ubifs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	return generic_file_llseek_size(file, offset, whence,
+					(loff_t)UBIFS_S_KEY_HASH_MASK <<
+					UBIFS_DH_BITS | UBIFS_DH_MASK,
+					i_size_read(inode));
+}
+
 const struct inode_operations ubifs_dir_inode_operations = {
 	.lookup      = ubifs_lookup,
 	.create      = ubifs_create,
@@ -1706,7 +1716,7 @@ const struct inode_operations ubifs_dir_inode_operations = {
 };
 
 const struct file_operations ubifs_dir_operations = {
-	.llseek         = generic_file_llseek,
+	.llseek         = ubifs_dir_llseek,
 	.release        = ubifs_dir_release,
 	.read           = generic_read_dir,
 	.iterate_shared = ubifs_readdir,
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index e8c23c9d4f4a..5939776c7359 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -214,6 +214,12 @@ enum {
 #define UBIFS_S_KEY_HASH_MASK  UBIFS_S_KEY_BLOCK_MASK
 
 /*
+ * We use 32 bits for the double hash cookie.
+ */
+#define UBIFS_DH_MASK 0xffffffff
+#define UBIFS_DH_BITS 32
+
+/*
  * Key types.
  *
  * UBIFS_INO_KEY: inode node key
-- 
2.12.0
