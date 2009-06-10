From: Greg KH <gregkh@suse.de>
Subject: [patch 39/60] ext4: Print the find_group_flex() warning only once
Date: Tue, 09 Jun 2009 17:14:07 -0700
Message-ID: <20090610002348.671477859@blue.kroah.org>
References: <20090610001328.251476848@blue.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbZFJDf4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:56 -0400
Content-Disposition: inline; filename=ext4-print-the-find_group_flex-warning-only-once.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 2842c3b5449f31470b61db716f1926b594fb6156)

This is a short-term warning, and even printk_ratelimit() can result
in too much noise in system logs.  So only print it once as a warning.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ialloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -687,6 +687,7 @@ struct inode *ext4_new_inode(handle_t *h
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	static int once = 1;
 	ext4_group_t flex_group;
 
 	/* Cannot create files in a deleted directory */
@@ -706,7 +707,8 @@ struct inode *ext4_new_inode(handle_t *h
 		ret2 = find_group_flex(sb, dir, &group);
 		if (ret2 == -1) {
 			ret2 = find_group_other(sb, dir, &group);
-			if (ret2 == 0 && printk_ratelimit())
+			if (ret2 == 0 && once)
+				once = 0;
 				printk(KERN_NOTICE "ext4: find_group_flex "
 				       "failed, fallback succeeded dir %lu\n",
 				       dir->i_ino);


