From: Greg KH <gregkh@suse.de>
Subject: [patch 40/60] ext4: fix bogus BUG_ONs in in mballoc code
Date: Tue, 09 Jun 2009 17:14:08 -0700
Message-ID: <20090610002348.904322248@blue.kroah.org>
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
Received: from kroah.org ([198.145.64.141]:57240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbZFJDf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:59 -0400
Content-Disposition: inline; filename=ext4-fix-bogus-bug_ons-in-in-mballoc-code.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Sandeen <sandeen@redhat.com>

(cherry picked from commit 8d03c7a0c550e7ab24cadcef5e66656bfadec8b9)

Thiemo Nagel reported that:

# dd if=/dev/zero of=image.ext4 bs=1M count=2
# mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 \
  -O large_file,dir_index,flex_bg,extent,sparse_super image.ext4
# mount -o loop image.ext4 mnt/
# dd if=/dev/zero of=mnt/file

oopsed, with a BUG_ON in ext4_mb_normalize_request because
size == EXT4_BLOCKS_PER_GROUP

It appears to me (esp. after talking to Andreas) that the BUG_ON
is bogus; a request of exactly EXT4_BLOCKS_PER_GROUP should
be allowed, though larger sizes do indicate a problem.

Fix that an another (apparently rare) codepath with a similar check.

Reported-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1450,7 +1450,7 @@ static void ext4_mb_measure_extent(struc
 	struct ext4_free_extent *gex = &ac->ac_g_ex;
 
 	BUG_ON(ex->fe_len <= 0);
-	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
 
@@ -3400,7 +3400,7 @@ ext4_mb_normalize_request(struct ext4_al
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 


