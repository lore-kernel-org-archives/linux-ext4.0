From: Greg KH <gregkh@suse.de>
Subject: [patch 079/104] ext4: Update flex_bg free blocks and free inodes
	counters when resizing.
Date: Wed, 3 Dec 2008 11:56:04 -0800
Message-ID: <20081203195604.GB8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, Frederic Bohe <frederic.bohe@bull.net>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752201AbYLCT5k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:40 -0500
Content-Disposition: inline; filename="ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Frederic Bohe <frederic.bohe@bull.net>

(cherry picked from commit c62a11fd9555007b1caab83b5bcbb443a43e32bb)

This fixes a bug which prevented the newly created inodes after a
resize from being used on filesystems with flex_bg.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/resize.c |    9 +++++++++
 fs/ext4/super.c  |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -929,6 +929,15 @@ int ext4_group_add(struct super_block *s
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		ext4_group_t flex_group;
+		flex_group = ext4_flex_group(sbi, input->group);
+		sbi->s_flex_groups[flex_group].free_blocks +=
+			input->free_blocks_count;
+		sbi->s_flex_groups[flex_group].free_inodes +=
+			EXT4_INODES_PER_GROUP(sb);
+	}
+
 	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
 	sb->s_dirt = 1;
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1504,8 +1504,11 @@ static int ext4_fill_flex_info(struct su
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
 
-	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
-		groups_per_flex;
+	/* We allocate both existing and potentially added groups */
+	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
+			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
+			   groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {

