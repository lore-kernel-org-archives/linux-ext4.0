From: Greg KH <gregkh@suse.de>
Subject: [patch 091/104] ext4: Do mballoc init before doing filesystem
	recovery
Date: Wed, 3 Dec 2008 11:56:30 -0800
Message-ID: <20081203195630.GN8950@kroah.com>
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
	alan@lxorguk.ukuu.org.uk,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751543AbYLCT54 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:56 -0500
Content-Disposition: inline; filename="ext4-do-mballoc-init-before-doing-filesystem-recovery.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit c2774d84fd6cab2bfa2a2fae0b1ca8d8ebde48a2)

During filesystem recovery we may be doing a truncate
which expects some of the mballoc data structures to
be initialized. So do ext4_mb_init before recovery.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2449,6 +2449,21 @@ static int ext4_fill_super(struct super_
 			"available.\n");
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
+				"requested data journaling mode\n");
+		clear_opt(sbi->s_mount_opt, DELALLOC);
+	} else if (test_opt(sb, DELALLOC))
+		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
+
+	ext4_ext_init(sb);
+	err = ext4_mb_init(sb, needs_recovery);
+	if (err) {
+		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
+		       err);
+		goto failed_mount4;
+	}
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -2468,16 +2483,6 @@ static int ext4_fill_super(struct super_
 	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 	       "writeback");
 
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
-				"requested data journaling mode\n");
-		clear_opt(sbi->s_mount_opt, DELALLOC);
-	} else if (test_opt(sb, DELALLOC))
-		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
-
-	ext4_ext_init(sb);
-	ext4_mb_init(sb, needs_recovery);
