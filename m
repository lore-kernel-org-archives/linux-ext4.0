From: Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 1/3] ext4: super: Fix spectre gadget in ext4_quota_on
Date: Fri, 27 Jul 2018 16:23:55 +0000
Message-ID: <20180727162357.30801-2-jcline@redhat.com>
References: <20180727162357.30801-1-jcline@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727162357.30801-1-jcline@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

'type' is a user-controlled value used to index into 's_qf_names', which
can be used in a Spectre v1 attack. Clamp 'type' to the size of the
array to avoid a speculative out-of-bounds read.

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6480e763080f..c04a09b51742 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -40,6 +40,7 @@
 #include <linux/crc16.h>
 #include <linux/dax.h>
 #include <linux/cleancache.h>
+#include <linux/nospec.h>
 #include <linux/uaccess.h>
 #include <linux/iversion.h>
 
@@ -5559,6 +5560,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	if (path->dentry->d_sb != sb)
 		return -EXDEV;
 	/* Journaling quota? */
+	type = array_index_nospec(type, EXT4_MAXQUOTAS);
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not in fs root? */
 		if (path->dentry->d_parent != sb->s_root)
-- 
2.17.1
