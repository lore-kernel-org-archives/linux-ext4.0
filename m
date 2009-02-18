From: Greg KH <gregkh@suse.de>
Subject: [patch 14/36] ext4: tone down ext4_da_writepages warnings
Date: Wed, 18 Feb 2009 14:29:23 -0800
Message-ID: <20090218222923.GO10668@kroah.com>
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
Received: from kroah.org ([198.145.64.141]:34842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757286AbZBRWcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:04 -0500
Content-Disposition: inline; filename="ext4-tone-down-ext4_da_writepages-warnings.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 2a21e37e48b94388f2cc8c0392f104f5443d4bb8)

If the filesystem has errors, ext4_da_writepages() will return a *lot*
of errors, including lots and lots of stack dumps.  While it's true
that we are dropping user data on the floor, which is unfortunate, the
stack dumps aren't helpful, and they tend to obscure the true original
root cause of the problem.  So in the case where the filesystem has
aborted, return an EROFS right away.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2298,6 +2298,20 @@ static int ext4_da_writepages(struct add
 	 */
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
+
+	/*
+	 * If the filesystem has aborted, it is read-only, so return
+	 * right away instead of dumping stack traces later on that
+	 * will obscure the real source of the problem.  We test
+	 * EXT4_MOUNT_ABORT instead of sb->s_flag's MS_RDONLY because
+	 * the latter could be true if the filesystem is mounted
+	 * read-only, and in that case, ext4_da_writepages should
+	 * *never* be called, so if that ever happens, we would want
+	 * the stack trace.
+	 */
+	if (unlikely(sbi->s_mount_opt & EXT4_MOUNT_ABORT))
+		return -EROFS;
+
 	/*
 	 * Make sure nr_to_write is >= sbi->s_mb_stream_request
 	 * This make sure small files blocks are allocated in
@@ -2336,7 +2350,7 @@ restart_loop:
 		handle = ext4_journal_start(inode, needed_blocks);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-			printk(KERN_EMERG "%s: jbd2_start: "
+			printk(KERN_CRIT "%s: jbd2_start: "
 			       "%ld pages, ino %lu; err %d\n", __func__,
 				wbc->nr_to_write, inode->i_ino, ret);
 			dump_stack();

