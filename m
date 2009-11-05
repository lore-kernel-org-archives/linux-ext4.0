From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/27] ext2: Add ext2_sb_info mutex
Date: Thu, 5 Nov 2009 14:55:21 +0100
Message-ID: <20091105135521.GD12770@duck.suse.cz>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-5-git-send-email-jblunck@suse.de> <20091102102654.GG31511@one.firstfloor.org> <20091102165752.GF21750@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33419 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbZKENzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2009 08:55:21 -0500
Content-Disposition: inline
In-Reply-To: <20091102165752.GF21750@bolzano.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-11-09 17:57:52, Jan Blunck wrote:
> On Mon, Nov 02, Andi Kleen wrote:
> 
> > > @@ -762,6 +767,12 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> > >  	sbi->s_sb_block = sb_block;
> > >  
> > >  	/*
> > > +	 * mutex for protection of modifications of the superblock while being
> > > +	 * write out by ext2_write_super() or ext2_sync_fs().
> > > +	 */
> > > +	mutex_init(&sbi->s_mutex);
> > 
> > I didn't go over all the code paths in detail, but if you replace
> > the BKL with a mutex that is hold over a longer write-out sleep
> > period you potentially limit IO parallelism a lot.
> 
> Right. I converted it to be a spinlock and unlock before calling
> ext2_sync_super().
> 
> What do you think?
  The patch is generally fine. I have just a few minor comments below:

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 5af1775..70c326c 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -52,8 +52,10 @@ void ext2_error (struct super_block * sb, const char * function,
>  	struct ext2_super_block *es = sbi->s_es;
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
> +		spin_lock(&sbi->s_lock);
>  		sbi->s_mount_state |= EXT2_ERROR_FS;
>  		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
> +		/* drops sbi->s_lock */
>  		ext2_sync_super(sb, es);
   I don't like this dropping of spinlock inside ext2_sync_super. Can we
just drop it here and retake it in ext2_sync_super? It's by far not a
performance critical path so it should not really matter.

> diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
> index 1cdb663..0d20278 100644
> --- a/include/linux/ext2_fs_sb.h
> +++ b/include/linux/ext2_fs_sb.h
> @@ -106,6 +106,8 @@ struct ext2_sb_info {
>  	spinlock_t s_rsv_window_lock;
>  	struct rb_root s_rsv_window_root;
>  	struct ext2_reserve_window_node s_rsv_window_head;
> +	/* protect against concurrent modifications of this structure */
> +	spinlock_t s_lock;
>  };
  As I'm reading the code s_lock protects some of the fieds but definitely
not all. I'd say it protects s_mount_state, s_blocks_last, s_overhead_last,
and a content of superblock's buffer pointed to by sbi->s_es. The rest just
either does not change during lifetime of the filesystem or has different
locks (either s_umount semaphore or other spinlocks).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
