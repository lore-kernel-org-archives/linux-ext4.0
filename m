From: Greg KH <gregkh@suse.de>
Subject: [patch 53/60] ext4: fix locking typo in mballoc which could cause soft lockup hangs
Date: Tue, 09 Jun 2009 17:14:21 -0700
Message-ID: <20090610002351.918798530@blue.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, Chris Wright <chrisw@sous-sol.org>,
	linux-ext4@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896AbZFJDgx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:36:53 -0400
Content-Disposition: inline; filename=ext4-fix-locking-typo-in-mballoc-which-could-cause-soft-lockup-hangs.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

upstream commit: e7c9e3e99adf6c49c5d593a51375916acc039d1e

Smatch (http://repo.or.cz/w/smatch.git/) complains about the locking in
ext4_mb_add_n_trim() from fs/ext4/mballoc.c

  4438          list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
  4439                                                  pa_inode_list) {
  4440                  spin_lock(&tmp_pa->pa_lock);
  4441                  if (tmp_pa->pa_deleted) {
  4442                          spin_unlock(&pa->pa_lock);
  4443                          continue;
  4444                  }

Brown paper bag time...

Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4532,7 +4532,7 @@ static void ext4_mb_add_n_trim(struct ex
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
 		if (tmp_pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
+			spin_unlock(&tmp_pa->pa_lock);
 			continue;
 		}
 		if (!added && pa->pa_free < tmp_pa->pa_free) {


