From: Greg KH <gregkh@suse.de>
Subject: [patch 098/104] ext4: add checksum calculation when clearing
	UNINIT flag in ext4_new_inode
Date: Wed, 3 Dec 2008 11:56:46 -0800
Message-ID: <20081203195646.GU8950@kroah.com>
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
	alan@lxorguk.ukuu.org.uk, Frederic Bohe <frederic.bohe@bull.net>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752709AbYLCT6F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:05 -0500
Content-Disposition: inline; filename="ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Frederic Bohe <frederic.bohe@bull.net>

(cherry picked from commit 23712a9c28b9f80a8cf70c8490358d5f562d2465)

When initializing an uninitialized block group in ext4_new_inode(),
its block group checksum must be re-calculated.  This fixes a race
when several threads try to allocate a new inode in an UNINIT'd group.

There is some question whether we need to be initializing the block
bitmap in ext4_new_inode() at all, but for now, if we are going to
init the block group, let's eliminate the race.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ialloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -717,6 +717,8 @@ got:
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_free_blocks_count = cpu_to_le16(free);
+			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
+								gdp);
 		}
 		spin_unlock(sb_bgl_lock(sbi, group));
 

