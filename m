From: Greg KH <gregkh@suse.de>
Subject: [patch 096/104] ext4: calculate journal credits correctly
Date: Wed, 3 Dec 2008 11:56:42 -0800
Message-ID: <20081203195642.GS8950@kroah.com>
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
Received: from kroah.org ([198.145.64.141]:56771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755241AbYLCT6D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:03 -0500
Content-Disposition: inline; filename="ext4-calculate-journal-credits-correctly.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit ac51d83705c2a38c71f39cde99708b14e6212a60)

This fixes a 2.6.27 regression which was introduced in commit a02908f1.

We weren't passing the chunk parameter down to the two subections,
ext4_indirect_trans_blocks() and ext4_ext_index_trans_blocks(), with
the result that massively overestimate the amount of credits needed by
ext4_da_writepages, especially in the non-extents case.  This causes
failures especially on /boot partitions, which tend to be small and
non-extent using since GRUB doesn't handle extents.

This patch fixes the bug reported by Joseph Fannin at:
http://bugzilla.kernel.org/show_bug.cgi?id=11964

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4444,9 +4444,10 @@ static int ext4_indirect_trans_blocks(st
 static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
-		return ext4_indirect_trans_blocks(inode, nrblocks, 0);
-	return ext4_ext_index_trans_blocks(inode, nrblocks, 0);
+		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
+	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 }
+
 /*
  * Account for index blocks, block groups bitmaps and block group
  * descriptor blocks if modify datablocks and index blocks

