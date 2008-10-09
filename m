From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V3 04/11] ext4: Add percpu dirty block accounting.
Date: Thu, 09 Oct 2008 15:44:51 -0500
Message-ID: <48EE6D43.7070404@redhat.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbYJIUvP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Oct 2008 16:51:15 -0400
In-Reply-To: <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> This patch add dirty block accounting using percpu_counters.
> Delayed allocation block reservation is now done by updating
> dirty block counter. In the later patch we switch to non
> delalloc mode if the filesystem free blocks is < that
> 150 % of total filesystem  dirty blocks
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

...

(nitpick, I wish the changelog stated why the change was made, rather
than simply describing the change...) but anyway:

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 419009f..4da4b9a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2971,22 +2971,11 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
>  	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
>  	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
> -
> +	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
>  	/*
> -	 * free blocks account has already be reduced/reserved
> -	 * at write_begin() time for delayed allocation
> -	 * do not double accounting
> +	 * Now reduce the dirty block count also. Should not go negative
>  	 */
> -	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
> -			ac->ac_o_ex.fe_len != ac->ac_b_ex.fe_len) {
> -		/*
> -		 * we allocated less blocks than we calimed
> -		 * Add the difference back
> -		 */
> -		percpu_counter_add(&sbi->s_freeblocks_counter,
> -				ac->ac_o_ex.fe_len - ac->ac_b_ex.fe_len);
> -	}
> -
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, ac->ac_b_ex.fe_len);
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi,
>  							  ac->ac_b_ex.fe_group);

Why was this part removed?  Near as I can tell it's still needed; with
all patches in the queue applied, if I run fallocate to try and allocate
10G of space to a file, on a filesystem with 30G free, I run out of
space after only 1.6G is allocated!

# /mnt/test/fallocate-amit -f /mnt/test/testfile 0 10737418240

SYSCALL: received error 28, ret=-1
# FALLOCATE TEST REPORT #
	New blocks preallocated = 0.
	Number of bytes preallocated = 0
	Old file size = 0, New file size -474484472.
	Old num blocks = 0, New num blocks 0.
test_fallocate: ERROR ! ret=1


#!# TESTS FAILED #!#

I see the request for the original 2621440 blocks come in; this gets
limited to 32767 due to max uninit length.

Somehow, though, we seem to be allocating only 2048 blocks at a time
(haven't worked out why, yet - this also seems problematic) - but at any
rate, losing (32767-2048) blocks in each loop from fallocate seems to be
causing this space loss and eventual ENOSPC.

fallocate loops 243 times for me; losing (32767-2048) each time accounts
for the 28G:

(32767-2048)*243*4096/1024/1024/1024
28

(plus the ~2G actually allocated gets us back to 30G that was originally
free)

Anyway, fsck finds no errors, and remounting fixes it.  It's apparently
just the in-memory counters that get off.

-Eric
