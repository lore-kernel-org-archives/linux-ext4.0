From: Greg KH <gregkh@suse.de>
Subject: [patch 38/60] ext4: fix header check in ext4_ext_search_right() for deep extent trees.
Date: Tue, 09 Jun 2009 17:14:06 -0700
Message-ID: <20090610002348.446310545@blue.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbZFJDfx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:53 -0400
Content-Disposition: inline; filename=ext4-fix-header-check-in-ext4_ext_search_right-for-deep-extent-trees.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Sandeen <sandeen@redhat.com>

(cherry picked from commit 395a87bfefbc400011417e9eaae33169f9f036c0)

The ext4_ext_search_right() function is confusing; it uses a
"depth" variable which is 0 at the root and maximum at the leaves,
but the on-disk metadata uses a "depth" (actually eh_depth) which
is opposite: maximum at the root, and 0 at the leaves.

The ext4_ext_check_header() function is given a depth and checks
the header agaisnt that depth; it expects the on-disk semantics,
but we are giving it the opposite in the while loop in this
function.  We should be giving it the on-disk notion of "depth"
which we can get from (p_depth - depth) - and if you look, the last
(more commonly hit) call to ext4_ext_check_header() does just this.

Sending in the wrong depth results in (incorrect) messages
about corruption:

EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 340,
max 340(0), depth 1(2)

http://bugzilla.kernel.org/show_bug.cgi?id=12821

Reported-by: David Dindorp <ddi@dubex.dk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1118,7 +1118,8 @@ ext4_ext_search_right(struct inode *inod
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
 	ext4_fsblk_t block;
-	int depth, ee_len;
+	int depth;	/* Note, NOT eh_depth; depth from top of tree */
+	int ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1177,7 +1178,8 @@ ext4_ext_search_right(struct inode *inod
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
-		if (ext4_ext_check_header(inode, eh, depth)) {
+		/* subtract from p_depth to get proper eh_depth */
+		if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
 			put_bh(bh);
 			return -EIO;
 		}


