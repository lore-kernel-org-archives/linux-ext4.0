From: Greg KH <gregkh@suse.de>
Subject: [patch 097/114] ext4: Add fallback for find_group_flex
Date: Fri, 13 Mar 2009 18:11:14 -0700
Message-ID: <20090314011045.758367881@mini.kroah.org>
References: <20090314010937.416083662@mini.kroah.org>
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
Received: from kroah.org ([198.145.64.141]:35738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755172AbZCNBVU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:20 -0400
Content-Disposition: inline; filename=ext4-add-fallback-for-find_group_flex.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 05bf9e839d9de4e8a094274a0a2fd07beb47eaf1)

This is a workaround for find_group_flex() which badly needs to be
replaced.  One of its problems (besides ignoring the Orlov algorithm)
is that it is a bit hyperactive about returning failure under
suspicious circumstances.  This can lead to spurious ENOSPC failures
even when there are inodes still available.

Work around this for now by retrying the search using
find_group_other() if find_group_flex() returns -1.  If
find_group_other() succeeds when find_group_flex() has failed, log a
warning message.

A better block/inode allocator that will fix this problem for real has
been queued up for the next merge window.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ialloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -703,6 +703,13 @@ struct inode *ext4_new_inode(handle_t *h
 
 	if (sbi->s_log_groups_per_flex) {
 		ret2 = find_group_flex(sb, dir, &group);
+		if (ret2 == -1) {
+			ret2 = find_group_other(sb, dir, &group);
+			if (ret2 == 0 && printk_ratelimit())
+				printk(KERN_NOTICE "ext4: find_group_flex "
+				       "failed, fallback succeeded dir %lu\n",
+				       dir->i_ino);
+		}
 		goto got_group;
 	}
 


