From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.3 152/200] ext2, ext4: warn when mounting with dax enabled
Date: Sun, 14 Feb 2016 14:22:39 -0800
Message-ID: <20160214222222.900736920@linuxfoundation.org>
References: <20160214222217.084543173@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
	Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160214222217.084543173@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

4.3-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/super.c |    2 ++
 fs/ext4/super.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -566,6 +566,8 @@ static int parse_options(char *options,
 			/* Fall through */
 		case Opt_dax:
 #ifdef CONFIG_FS_DAX
+			ext2_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			set_opt(sbi->s_mount_opt, DAX);
 #else
 			ext2_msg(sb, KERN_INFO, "dax option not supported");
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1664,8 +1664,12 @@ static int handle_mount_opt(struct super
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
