From: Theodore Tso <tytso@mit.edu>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Sat, 28 Mar 2009 00:06:57 -0400
Message-ID: <20090328040657.GB2155@mit.edu>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]> <20090327224616.GD5176@mit.edu> <p0624058ec5f30b501efb@[130.161.115.44]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41836 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZC1EHD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2009 00:07:03 -0400
Content-Disposition: inline
In-Reply-To: <p0624058ec5f30b501efb@[130.161.115.44]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch *might* solve your problem.  I can't be sure because I
haven't been able to reproduce the soft lockup problem when rm'ing a
file yet.  But if it's happening fairly often, it might be worth a
try; it definitely fixes a real bug in ext4 --- I'm just not sure it's
*your* bug.  :-)

						- Ted

commit 73cda61b58a060b6691791a44c01c16155617451
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Mar 27 19:43:21 2009 -0400

    ext4: fix locking typo in mballoc which could cause soft lockup hangs
    
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

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4f2f476..12d1081 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4389,7 +4389,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
 		if (tmp_pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
+			spin_unlock(&tmp_pa->pa_lock);
 			continue;
 		}
 		if (!added && pa->pa_free < tmp_pa->pa_free) {
