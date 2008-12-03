From: Greg KH <gregkh@suse.de>
Subject: [patch 092/104] ext4: Fix duplicate entries returned from
	getdents() system call
Date: Wed, 3 Dec 2008 11:56:34 -0800
Message-ID: <20081203195634.GO8950@kroah.com>
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
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756097AbYLCT55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:57 -0500
Content-Disposition: inline; filename="ext4-fix-duplicate-entries-returned-from-getdents-system-call.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 3c37fc86d20fe35be656f070997d62f75c2e4874)

Fix a regression caused by commit d0156417, "ext4: fix ext4_dx_readdir
hash collision handling", where deleting files in a large directory
(requiring more than one getdents system call), results in some
filenames being returned twice.  This was caused by a failure to
update info->curr_hash and info->curr_minor_hash, so that if the
directory had gotten modified since the last getdents() system call
(as would be the case if the user is running "rm -r" or "git clean"),
a directory entry would get returned twice to the userspace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This patch fixes the bug reported by Markus Trippelsdorf at:
http://bugzilla.kernel.org/show_bug.cgi?id=11844

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/dir.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -458,17 +458,8 @@ static int ext4_dx_readdir(struct file *
 	if (info->extra_fname) {
 		if (call_filldir(filp, dirent, filldir, info->extra_fname))
 			goto finished;
-
 		info->extra_fname = NULL;
-		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
-			if (info->next_hash == ~0) {
-				filp->f_pos = EXT4_HTREE_EOF;
-				goto finished;
-			}
-			info->curr_hash = info->next_hash;
-			info->curr_minor_hash = 0;
-		}
+		goto next_node;
 	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
@@ -500,9 +491,14 @@ static int ext4_dx_readdir(struct file *
 		info->curr_minor_hash = fname->minor_hash;
 		if (call_filldir(filp, dirent, filldir, fname))
 			break;
