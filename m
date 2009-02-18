From: Greg KH <gregkh@suse.de>
Subject: [patch 17/36] ext4: Widen type of ext4_sb_info.s_mb_maxs[]
Date: Wed, 18 Feb 2009 14:29:28 -0800
Message-ID: <20090218222928.GR10668@kroah.com>
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
	alan@lxorguk.ukuu.org.uk, Li Zefan <lizf@cn.fujitsu.com>,
	Yasunori Goto <y-goto@jp.fujitsu.com>,
	linux-ext4@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757892AbZBRWcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:08 -0500
Content-Disposition: inline; filename="ext4-widen-type-of-ext4_sb_info.s_mb_maxs.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yasunori Goto <y-goto@jp.fujitsu.com>

(cherry picked from commit ff7ef329b268b603ea4a2303241ef1c3829fd574)

I chased the cause of following ext4 oops report which is tested on
ia64 box.

http://bugzilla.kernel.org/show_bug.cgi?id=12018

The cause is the size of s_mb_maxs array that is defined as "unsigned
short" in ext4_sb_info structure.  If the file system's block size is
8k or greater, an unsigned short is not wide enough to contain the
value fs->blocksize << 3.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4_sb.h |    3 ++-
 fs/ext4/mballoc.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -103,7 +103,8 @@ struct ext4_sb_info {
 	struct list_head s_committed_transaction;
 	spinlock_t s_md_lock;
 	tid_t s_last_transaction;
-	unsigned short *s_mb_offsets, *s_mb_maxs;
+	unsigned short *s_mb_offsets;
+	unsigned int *s_mb_maxs;
 
 	/* tunables */
 	unsigned long s_stripe;
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2495,6 +2495,8 @@ int ext4_mb_init(struct super_block *sb,
 		clear_opt(sbi->s_mount_opt, MBALLOC);
 		return -ENOMEM;
 	}
+
+	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);

