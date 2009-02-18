From: Greg KH <gregkh@suse.de>
Subject: [patch 33/36] ext4: only use i_size_high for regular files
Date: Wed, 18 Feb 2009 14:29:57 -0800
Message-ID: <20090218222957.GH10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757954AbZBRWcY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:24 -0500
Content-Disposition: inline; filename="ext4-only-use-i_size_high-for-regular-files.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 06a279d636734da32bb62dd2f7b0ade666f65d7c)

Directories are not allowed to be bigger than 2GB, so don't use
i_size_high for anything other than regular files.  E2fsck should
complain about these inodes, but the simplest thing to do for the
kernel is to only use i_size_high for regular files.

This prevents an intentially corrupted filesystem from causing the
kernel to burn a huge amount of CPU and issuing error messages such
as:

EXT4-fs warning (device loop0): ext4_block_to_path: block 135090028 > max

Thanks to David Maciejak from Fortinet's FortiGuard Global Security
Research Team for reporting this issue.

http://bugzilla.kernel.org/show_bug.cgi?id=12375

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h  |    7 +++++--
 fs/ext4/inode.c |    4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1174,8 +1174,11 @@ static inline void ext4_r_blocks_count_s
 
 static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
 {
-	return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
-		le32_to_cpu(raw_inode->i_size_lo);
+	if (S_ISREG(le16_to_cpu(raw_inode->i_mode)))
+		return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
+			le32_to_cpu(raw_inode->i_size_lo);
+	else
+		return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
 }
 
 static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -351,9 +351,9 @@ static int ext4_block_to_path(struct ino
 		final = ptrs;
 	} else {
 		ext4_warning(inode->i_sb, "ext4_block_to_path",
-				"block %lu > max",
+				"block %lu > max in inode %lu",
 				i_block + direct_blocks +
-				indirect_blocks + double_blocks);
+				indirect_blocks + double_blocks, inode->i_ino);
 	}
 	if (boundary)
 		*boundary = final - 1 - (i_block & (ptrs - 1));

