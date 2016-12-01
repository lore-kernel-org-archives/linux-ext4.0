From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/6] ubifs: Provide a custom llseek for directories
Date: Thu,  1 Dec 2016 23:02:17 +0100
Message-ID: <1480629741-18375-3-git-send-email-richard@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
 Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
 adrian.hunter@intel.com, adilger.kernel@dilger.ca,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org
To: linux-mtd@lists.infradead.org
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1480629741-18375-1-git-send-email-richard@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
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
index 7f01f3d2ac3b..883b2fdf51df 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1721,6 +1721,16 @@ static int ubifs_dir_open(struct inode *dir, struct file *file)
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
@@ -1741,7 +1751,7 @@ const struct inode_operations ubifs_dir_inode_operations = {
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
2.7.3


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
