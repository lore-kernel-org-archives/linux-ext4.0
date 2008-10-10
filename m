From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 04/11] ext4: Add percpu dirty block accounting.
Date: Fri, 10 Oct 2008 10:22:11 +0530
Message-ID: <20081010045211.GC4301@skywalker>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48EE6D43.7070404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41414 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751312AbYJJEwZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 00:52:25 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9A4qMUw016847
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 10:22:22 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9A4qM0n1077278
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 10:22:22 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9A4qMD7017087
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 15:52:22 +1100
Content-Disposition: inline
In-Reply-To: <48EE6D43.7070404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 03:44:51PM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > This patch add dirty block accounting using percpu_counters.
> > Delayed allocation block reservation is now done by updating
> > dirty block counter. In the later patch we switch to non
> > delalloc mode if the filesystem free blocks is < that
> > 150 % of total filesystem  dirty blocks
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ...
> 
> (nitpick, I wish the changelog stated why the change was made, rather
> than simply describing the change...) but anyway:
> 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 419009f..4da4b9a 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -2971,22 +2971,11 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
> >  	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
> >  	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
> >  	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
> > -
> > +	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
> >  	/*
> > -	 * free blocks account has already be reduced/reserved
> > -	 * at write_begin() time for delayed allocation
> > -	 * do not double accounting
> > +	 * Now reduce the dirty block count also. Should not go negative
> >  	 */
> > -	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
> > -			ac->ac_o_ex.fe_len != ac->ac_b_ex.fe_len) {
> > -		/*
> > -		 * we allocated less blocks than we calimed
> > -		 * Add the difference back
> > -		 */
> > -		percpu_counter_add(&sbi->s_freeblocks_counter,
> > -				ac->ac_o_ex.fe_len - ac->ac_b_ex.fe_len);
> > -	}
> > -
> > +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, ac->ac_b_ex.fe_len);
> >  	if (sbi->s_log_groups_per_flex) {
> >  		ext4_group_t flex_group = ext4_flex_group(sbi,
> >  							  ac->ac_b_ex.fe_group);
> 
> Why was this part removed?  Near as I can tell it's still needed; with
> all patches in the queue applied, if I run fallocate to try and allocate
> 10G of space to a file, on a filesystem with 30G free, I run out of
> space after only 1.6G is allocated!
> 
> # /mnt/test/fallocate-amit -f /mnt/test/testfile 0 10737418240
> 
> SYSCALL: received error 28, ret=-1
> # FALLOCATE TEST REPORT #
> 	New blocks preallocated = 0.
> 	Number of bytes preallocated = 0
> 	Old file size = 0, New file size -474484472.
> 	Old num blocks = 0, New num blocks 0.
> test_fallocate: ERROR ! ret=1
> 
> 
> #!# TESTS FAILED #!#
> 
> I see the request for the original 2621440 blocks come in; this gets
> limited to 32767 due to max uninit length.
> 
> Somehow, though, we seem to be allocating only 2048 blocks at a time
> (haven't worked out why, yet - this also seems problematic) - but at any
> rate, losing (32767-2048) blocks in each loop from fallocate seems to be
> causing this space loss and eventual ENOSPC.
> 
> fallocate loops 243 times for me; losing (32767-2048) each time accounts
> for the 28G:
> 
> (32767-2048)*243*4096/1024/1024/1024
> 28
> 
> (plus the ~2G actually allocated gets us back to 30G that was originally
> free)
> 
> Anyway, fsck finds no errors, and remounting fixes it.  It's apparently
> just the in-memory counters that get off.
> 

Can you test this patch

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 64eeb9a..6e81c38 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2800,7 +2800,7 @@ void exit_ext4_mballoc(void)
  */
 static noinline_for_stack int
 ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
-				handle_t *handle)
+				handle_t *handle, unsigned long reserv_blks)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_super_block *es;
@@ -2893,7 +2893,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	/*
 	 * Now reduce the dirty block count also. Should not go negative
 	 */
-	percpu_counter_sub(&sbi->s_dirtyblocks_counter, ac->ac_b_ex.fe_len);
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
@@ -4284,12 +4284,13 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				 struct ext4_allocation_request *ar, int *errp)
 {
+	int freed;
 	struct ext4_allocation_context *ac = NULL;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
-	int freed;
-	int inquota;
+	unsigned long inquota;
+	unsigned long reserv_blks;
 
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
@@ -4308,6 +4309,8 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 			return 0;
 		}
 	}
+	/* Number of reserv_blks for both delayed an non delayed allocation */
+	reserv_blks = ar->len;
 	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
 		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
 		ar->len--;
@@ -4353,7 +4356,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	}
 
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
-		*errp = ext4_mb_mark_diskspace_used(ac, handle);
+		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
 		if (*errp ==  -EAGAIN) {
 			ac->ac_b_ex.fe_group = 0;
 			ac->ac_b_ex.fe_start = 0;
