From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 4.2.y-ckt 022/305] ext2,
 ext4: warn when mounting with dax enabled
Date: Fri, 15 Jan 2016 15:57:16 -0800
Message-ID: <1452902519-2754-23-git-send-email-kamal@canonical.com>
References: <1452902519-2754-1-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>,
 Matthew Wilcox <willy@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@lists.ubuntu.com
Return-path: <kernel-team-bounces@lists.ubuntu.com>
In-Reply-To: <1452902519-2754-1-git-send-email-kamal@canonical.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/kernel-team>,
 <mailto:kernel-team-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/kernel-team>
List-Post: <mailto:kernel-team@lists.ubuntu.com>
List-Help: <mailto:kernel-team-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
 <mailto:kernel-team-request@lists.ubuntu.com?subject=subscribe>
Errors-To: kernel-team-bounces@lists.ubuntu.com
Sender: kernel-team-bounces@lists.ubuntu.com
List-Id: linux-ext4.vger.kernel.org

4.2.8-ckt2 -stable review patch.  If anyone has any objections, please let me know.

---8<------------------------------------------------------------

From: Dan Williams <dan.j.williams@intel.com>

commit ef83b6e8f40bb24b92ad73b5889732346e54a793 upstream.

Similar to XFS warn when mounting DAX while it is still considered under
development.  Also, aspects of the DAX implementation, for example
synchronization against multiple faults and faults causing block
allocation, depend on the correct implementation in the filesystem.  The
maturity of a given DAX implementation is filesystem specific.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ext4@vger.kernel.org
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Acked-by: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext2/super.c | 2 ++
 fs/ext4/super.c | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 900e19c..2597b06 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -566,6 +566,8 @@ static int parse_options(char *options, struct super_block *sb)
 			/* Fall through */
 		case Opt_dax:
 #ifdef CONFIG_FS_DAX
+			ext2_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			set_opt(sbi->s_mount_opt, DAX);
 #else
 			ext2_msg(sb, KERN_INFO, "dax option not supported");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bc24d1b..b22d844 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1667,8 +1667,12 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		sbi->s_jquota_fmt = m->mount_opt;
 #endif
-#ifndef CONFIG_FS_DAX
 	} else if (token == Opt_dax) {
+#ifdef CONFIG_FS_DAX
+		ext4_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+			sbi->s_mount_opt |= m->mount_opt;
+#else
 		ext4_msg(sb, KERN_INFO, "dax option not supported");
 		return -1;
 #endif
-- 
1.9.1
