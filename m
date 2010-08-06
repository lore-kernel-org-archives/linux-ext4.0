From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/3] Add batched discard support for ext4
Date: Fri, 06 Aug 2010 17:03:27 +0400
Message-ID: <871vabsxk0.fsf@dmon-lap.sw.ru>
References: <1281094276-11377-1-git-send-email-lczerner@redhat.com>
	<1281094276-11377-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59545 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab0HFNDg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 09:03:36 -0400
Received: by ewy23 with SMTP id 23so2755684ewy.19
        for <linux-ext4@vger.kernel.org>; Fri, 06 Aug 2010 06:03:31 -0700 (PDT)
In-Reply-To: <1281094276-11377-4-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Fri, 6 Aug 2010 13:31:16 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas Czerner <lczerner@redhat.com> writes:

> Walk through allocation groups and trim all free extents. It can be
> invoked through FITRIM ioctl on the file system. The main idea is to
> provide a way to trim the whole file system if needed, since some SSD's
> may suffer from performance loss after the whole device was filled (it
> does not mean that fs is full!).
>
> It search for free extents in allocation groups specified by Byte range
> start -> start+len. When the free extent is within this range, blocks
> are marked as used and then trimmed. Afterwards these blocks are marked
> as free in per-group bitmap.
>
> Since fstrim is a long operation it is good to have an ability to
> interrupt it by a signal. This was added by Dmitry Monakhov.
> Thanks Dimitry.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h    |    2 +
>  fs/ext4/mballoc.c |  194 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/super.c   |    1 +
>  3 files changed, 197 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 19a4de5..2f96dc5 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1558,6 +1558,8 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
>  extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
>  extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
>  						ext4_group_t, int);
> +extern int ext4_trim_fs(struct super_block *, uint64_t, uint64_t, uint64_t);
> +
>  /* inode.c */
>  struct buffer_head *ext4_getblk(handle_t *, struct inode *,
>  						ext4_lblk_t, int, int *);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 0e83dfd..5210676 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4690,3 +4690,197 @@ error_return:
>  		kmem_cache_free(ext4_ac_cachep, ac);
>  	return;
>  }
> +
> +/**
> + * ext4_trim_extent -- function to TRIM one single free extent in the group
> + * @sb:		super block for the file system
> + * @start:	starting block of the free extent in the alloc. group
> + * @count:	number of blocks to TRIM
> + * @group:	alloc. group we are working with
> + * @e4b:	ext4 buddy for the group
> + *
> + * Trim "count" blocks starting at "start" in the "group". To assure that no
> + * one will allocate those blocks, mark it as used in buddy bitmap. This must
> + * be called with under the group lock.
> + */
> +static int ext4_trim_extent(struct super_block *sb, int start, int count,
> +		ext4_group_t group, struct ext4_buddy *e4b)
> +{
> +	ext4_fsblk_t discard_block;
> +	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
> +	struct ext4_free_extent ex;
> +	int ret = 0;
> +
> +	assert_spin_locked(ext4_group_lock_ptr(sb, group));
> +
> +	ex.fe_start = start;
> +	ex.fe_group = group;
> +	ex.fe_len = count;
> +
> +	/*
> +	 * Mark blocks used, so no one can reuse them while
> +	 * being trimmed.
> +	 */
> +	mb_mark_used(e4b, &ex);
> +	ext4_unlock_group(sb, group);
> +
> +	discard_block = (ext4_fsblk_t)group *
> +			EXT4_BLOCKS_PER_GROUP(sb)
> +			+ start
> +			+ le32_to_cpu(es->s_first_data_block);
> +	trace_ext4_discard_blocks(sb,
> +			(unsigned long long)discard_block,
> +			count);
> +	ret = sb_issue_discard(sb, discard_block, count);
> +	if (ret == -EOPNOTSUPP) {
> +		ext4_warning(sb,
> +			"discard not supported!");
> +	} else if (ret < 0) {
> +		ext4_std_error(sb, ret);
> +	}
> +	cond_resched();
OOps seems i'm was wrong when suggested to put cond_resched() here.
It is useless because we probably already slept inside sb_issue_discard()
But it is reasonable to move it to ext4_trim_all_free()
because fs size may be huge so simple bitmap traverse will take long
enough, but almost fully populated so there are no extents longer than
minlen so discard would not being called.
BTW: Since Jan already noted about that in ext3's patch so ext3 version
is good.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d3a0763..00e6147 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4688,7 +4688,6 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 	} else if (ret < 0) {
 		ext4_std_error(sb, ret);
 	}
-	cond_resched();
 
 	ext4_lock_group(sb, group);
 	mb_free_blocks(NULL, e4b, start, ex.fe_len);
@@ -4745,6 +4744,11 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 		}
 		start = next + 1;
 
+		if (need_resched()) {
+			ext4_unlock_group(sb, group);
+			cond_resched();
+			ext4_lock_group(sb, group);
+		}
 		if (signal_pending(current)) {
 			count = -ERESTARTSYS;
 			break;

