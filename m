From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/10] ext4: serialize dio nonlocked reads with defrag
 workers V3
Date: Wed, 26 Sep 2012 15:49:38 +0200
Message-ID: <20120926134938.GF10145@quack.suse.cz>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
 <1348487060-19598-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab2IZNtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 09:49:51 -0400
Content-Disposition: inline
In-Reply-To: <1348487060-19598-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-09-12 15:44:15, Dmitry Monakhov wrote:
> Inode's block defrag and ext4_change_inode_journal_flag() may
> affect nonlocked DIO reads result, so proper synchronization
> required.
> 
> - Add missed inode_dio_wait() calls where appropriate
> - Check inode state under extra i_dio_count reference.
> 
> 
> Changes from V1:
> - add missed memory bariers
> - move DIOREAD_LOCK state check out from generic should_dioread_nolock
>   otherwise it will affect existing DIO readers.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h        |   17 +++++++++++++++++
>  fs/ext4/indirect.c    |   13 +++++++++++++
>  fs/ext4/inode.c       |    5 +++++
>  fs/ext4/move_extent.c |    8 ++++++++
>  4 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cc423cf..fccd263 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1350,6 +1350,8 @@ enum {
>  	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
>  	EXT4_STATE_NEWENTRY,		/* File just added to dir */
>  	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
> +	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
> +					   nolocking */
>  };
>  
>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> @@ -2462,6 +2464,21 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
>  	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
>  }
>  
> +/*
> + * Disable DIO read nolock optimization, so new dioreaders will be forced
> + * to grab i_mutex
> + */
> +static inline void ext4_inode_block_unlocked_dio(struct inode *inode)
> +{
> +	ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> +	smp_mb();
> +}
> +static inline void ext4_inode_resume_unlocked_dio(struct inode *inode)
> +{
> +	smp_mb();
> +	ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> +}
> +
>  #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
>  
>  /* For ioend & aio unwritten conversion wait queues */
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 251e35f..ec38f81 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -810,10 +810,23 @@ retry:
>  		if (unlikely(!list_empty(&ei->i_completed_io_list)))
>  			ext4_unwritten_wait(inode);
>  
> +		/*
> +		 * Nolock dioread optimization may be dynamically disabled
> +		 * via ext4_inode_block_unlocked_dio(). Check inode's state
> +		 * while holding extra i_dio_count ref.
> +		 */
> +		atomic_inc(&inode->i_dio_count);
> +		smp_mb();
> +		if (!unlikely(ext4_test_inode_state(inode,
> +						    EXT4_STATE_DIOREAD_LOCK))) {
  Isn't this condition reverted? We want to retry if
EXT4_STATE_DIOREAD_LOCK is set, don't we?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
