From: Greg KH <gregkh@suse.de>
Subject: [patch 101/104] ext3: dont try to resize if there are no reserved
	gdt blocks left
Date: Wed, 3 Dec 2008 11:56:53 -0800
Message-ID: <20081203195653.GX8950@kroah.com>
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
	alan@lxorguk.ukuu.org.uk, Josef Bacik <jbacik@redhat.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754559AbYLCT6J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:09 -0500
Content-Disposition: inline; filename="ext3-don-t-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Josef Bacik <jbacik@redhat.com>

commit 972fbf779832e5ad15effa7712789aeff9224c37 upstream.

When trying to resize a ext3 fs and you run out of reserved gdt blocks,
you get an error that doesn't actually tell you what went wrong, it just
says that the gdb it picked is not correct, which is the case since you
don't have any reserved gdt blocks left.  This patch adds a check to make
sure you have reserved gdt blocks to use, and if not prints out a more
relevant error.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -790,7 +790,8 @@ int ext3_group_add(struct super_block *s
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT3_HAS_COMPAT_FEATURE(sb,
-					     EXT3_FEATURE_COMPAT_RESIZE_INODE)){
+					     EXT3_FEATURE_COMPAT_RESIZE_INODE)
+		    || !le16_to_cpu(es->s_reserved_gdt_blocks)) {
 			ext3_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;

