From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fs/ext4/mballoc.c: Convert to list_for_each_entry_rcu()
Date: Tue, 19 Feb 2008 15:19:45 +0530
Message-ID: <20080219094945.GA6743@skywalker>
References: <47BA2356.90203@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:54528 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYBSJuC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 04:50:02 -0500
Content-Disposition: inline
In-Reply-To: <47BA2356.90203@tiscali.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 01:31:18AM +0100, Roel Kluin wrote:
> Please verify, this patch was not yet tested
> ---
> Convert list_for_each_rcu() to list_for_each_entry_rcu()
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>


NACK. This patch doesn't build. You have extra cur in the conversion.
Right changes attached. 

ext4:  Convert list_for_each_rcu() to list_for_each_entry_rcu()

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The list_for_each_entry_rcu() primitive should be used instead of
list_for_each_rcu(), as the former is easier to use and provides
better type safety.

http://groups.google.com/group/linux.kernel/browse_thread/thread/45749c83451cebeb/0633a65759ce7713?lnk=raot

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/mballoc.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 52d3af2..89772b9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3135,10 +3135,10 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 {
 	int bsbits, max;
 	ext4_lblk_t end;
-	struct list_head *cur;
 	loff_t size, orig_size, start_off;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
+	struct ext4_prealloc_space *pa;
 
 	/* do normalize only data requests, metadata requests
 	   do not need preallocation */
@@ -3224,12 +3224,9 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* check we don't cross already preallocated blocks */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		struct ext4_prealloc_space *pa;
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 		unsigned long pa_end;
 
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
-
 		if (pa->pa_deleted)
 			continue;
 		spin_lock(&pa->pa_lock);
@@ -3271,10 +3268,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* XXX: extra loop to check we really don't overlap preallocations */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		struct ext4_prealloc_space *pa;
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 		unsigned long pa_end;
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0) {
 			pa_end = pa->pa_lstart + pa->pa_len;
@@ -3401,7 +3396,6 @@ static noinline int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
-	struct list_head *cur;
 
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
@@ -3409,8 +3403,7 @@ static noinline int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 
 	/* first, try per-file preallocation */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 
 		/* all fields in this condition don't change,
 		 * so we can skip locking for them */
@@ -3442,8 +3435,7 @@ static noinline int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 		return 0;
 
 	rcu_read_lock();
-	list_for_each_rcu(cur, &lg->lg_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
+	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list, pa_inode_list) {
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0 && pa->pa_free >= ac->ac_o_ex.fe_len) {
 			atomic_inc(&pa->pa_count);
