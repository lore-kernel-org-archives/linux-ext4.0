From: Greg KH <gregkh@suse.de>
Subject: [patch 41/60] ext4: fix bb_prealloc_list corruption due to wrong group locking
Date: Tue, 09 Jun 2009 17:14:09 -0700
Message-ID: <20090610002349.130372706@blue.kroah.org>
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
Received: from kroah.org ([198.145.64.141]:57253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbZFJDgC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:36:02 -0400
Content-Disposition: inline; filename=ext4-fix-bb_prealloc_list-corruption-due-to-wrong-group-locking.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Sandeen <sandeen@redhat.com>

(cherry-picked from commit d33a1976fbee1ee321d6f014333d8f03a39d526c)

This is for Red Hat bug 490026: EXT4 panic, list corruption in
ext4_mb_new_inode_pa

ext4_lock_group(sb, group) is supposed to protect this list for
each group, and a common code flow to remove an album is like
this:

    ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
    ext4_lock_group(sb, grp);
    list_del(&pa->pa_group_list);
    ext4_unlock_group(sb, grp);

so it's critical that we get the right group number back for
this prealloc context, to lock the right group (the one
associated with this pa) and prevent concurrent list manipulation.

however, ext4_mb_put_pa() passes in (pa->pa_pstart - 1) with a
comment, "-1 is to protect from crossing allocation group".

This makes sense for the group_pa, where pa_pstart is advanced
by the length which has been used (in ext4_mb_release_context()),
and when the entire length has been used, pa_pstart has been
advanced to the first block of the next group.

However, for inode_pa, pa_pstart is never advanced; it's just
set once to the first block in the group and not moved after
that.  So in this case, if we subtract one in ext4_mb_put_pa(),
we are actually locking the *previous* group, and opening the
race with the other threads which do not subtract off the extra
block.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3698,6 +3698,7 @@ static void ext4_mb_put_pa(struct ext4_a
 			struct super_block *sb, struct ext4_prealloc_space *pa)
 {
 	unsigned long grp;
+	ext4_fsblk_t grp_blk;
 
 	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
 		return;
@@ -3712,8 +3713,12 @@ static void ext4_mb_put_pa(struct ext4_a
 	pa->pa_deleted = 1;
 	spin_unlock(&pa->pa_lock);
 
-	/* -1 is to protect from crossing allocation group */
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
+	grp_blk = pa->pa_pstart;
+	/* If linear, pa_pstart may be in the next group when pa is used up */
+	if (pa->pa_linear)
+		grp_blk--;
+
+	ext4_get_group_no_and_offset(sb, grp_blk, &grp, NULL);
 
 	/*
 	 * possible race:


