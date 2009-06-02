From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 17/24] ext4: fix locking typo in mballoc which could cause soft lockup hangs
Date: Tue,  2 Jun 2009 08:09:29 -0400
Message-ID: <1243944576-20915-17-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
 <1243944576-20915-15-git-send-email-tytso@mit.edu>
 <1243944576-20915-16-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Chris Wright <chrisw@sous-sol.org>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59318 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZFBMJx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:53 -0400
In-Reply-To: <1243944576-20915-16-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5f87023..c7dc115 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4532,7 +4532,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
 		if (tmp_pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
+			spin_unlock(&tmp_pa->pa_lock);
 			continue;
 		}
 		if (!added && pa->pa_free < tmp_pa->pa_free) {
-- 
1.6.3.1.1.g75fc.dirty

