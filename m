From: Greg KH <gregkh@suse.de>
Subject: [patch 34/39] ext4: Add sanity checks for the superblock before
	mounting the filesystem
Date: Wed, 18 Feb 2009 13:33:18 -0800
Message-ID: <20090218213318.GI19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754186AbZBRVgA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 16:36:00 -0500
Content-Disposition: inline; filename="ext4-add-sanity-checks-for-the-superblock-before-mounting-the-filesystem.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 4ec110281379826c5cf6ed14735e47027c3c5765)

This avoids insane superblock configurations that could lead to kernel
oops due to null pointer derefences.

http://bugzilla.kernel.org/show_bug.cgi?id=12371

Thanks to David Maciejak at Fortinet's FortiGuard Global Security
Research Team who discovered this bug independently (but at
approximately the same time) as Thiemo Nagel, who submitted the patch.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1869,8 +1869,8 @@ static int ext4_fill_super(struct super_
 	char *cp;
 	int ret = -EINVAL;
 	int blocksize;
-	int db_count;
-	int i;
+	unsigned int db_count;
+	unsigned int i;
 	int needs_recovery, has_huge_files;
 	__le32 features;
 	__u64 blocks_count;
@@ -2153,20 +2153,30 @@ static int ext4_fill_super(struct super_
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
-	/* ensure blocks_count calculation below doesn't sign-extend */
-	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
-	    le32_to_cpu(es->s_first_data_block) + 1) {
-		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
-		       "first data block %u, blocks per group %lu\n",
-			ext4_blocks_count(es),
-			le32_to_cpu(es->s_first_data_block),
-			EXT4_BLOCKS_PER_GROUP(sb));
+        /*
+         * It makes no sense for the first data block to be beyond the end
+         * of the filesystem.
+         */
+        if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
+                printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
+		       "block %u is beyond end of filesystem (%llu)\n",
+		       le32_to_cpu(es->s_first_data_block),
+		       ext4_blocks_count(es));
 		goto failed_mount;
 	}
 	blocks_count = (ext4_blocks_count(es) -
 			le32_to_cpu(es->s_first_data_block) +
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
+	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
+		printk(KERN_WARNING "EXT4-fs: groups count too large: %u "
+		       "(block count %llu, first data block %u, "
+		       "blocks per group %lu)\n", sbi->s_groups_count,
+		       ext4_blocks_count(es),
+		       le32_to_cpu(es->s_first_data_block),
+		       EXT4_BLOCKS_PER_GROUP(sb));
+		goto failed_mount;
+	}
 	sbi->s_groups_count = blocks_count;
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);

