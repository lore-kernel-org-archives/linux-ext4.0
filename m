From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: kernel BUG at fs/jbd2/transaction.c:1086!
Date: Fri, 1 Apr 2011 22:05:24 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1104012203570.3151@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com> <20110331164319.GG21524@quack.suse.cz> <alpine.LFD.2.00.1103312255270.3020@dhcp-27-109.brq.redhat.com> <20110331222306.GI21524@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Eric Sandeen <esandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab1DAUFf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Apr 2011 16:05:35 -0400
In-Reply-To: <20110331222306.GI21524@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 1 Apr 2011, Jan Kara wrote:

> On Thu 31-03-11 22:59:24, Lukas Czerner wrote:
> > On Thu, 31 Mar 2011, Jan Kara wrote:
> > 
> > > On Wed 30-03-11 17:32:06, Lukas Czerner wrote:
> > > > Hello,
> > > > 
> > > > I have hit BUG_ON while running xfstest 234 in the loop
> > > > on the ext4. Backtrace below .
> > > > 
> > > > I thought that this problem was solved with
> > > > 67eeb5685d2a211c0252ac7884142e503c759500 however it is still present.
> > > > I might be a bit hard to hit, but once you run
> > > > 
> > > > while true; do sync; sleep 0.3; done
> > > > 
> > > > concurrently it is reproducible almost all the time. I have tried to
> > > > understand what is going on but only thing I can see is this course
> > > > of action:
> > > > 
> > > > ext4_write_dquot
> > > >   ext4_journal_start <- h_buffer_credits = 2
> > > >   dquot_commit
> > > >     v2_write_dquot
> > > >       qtree_write_dquot
> > > >         ext4_quota_write
> > > >           ext4_handle_dirty_metadata	<- this takes one block reserved
> > > > 	  				   for journal
> > > > 					   h_buffer_credits--
> > > >     v2_write_file_info
> > > >       ext4_quota_write
> > > >         ext4_handle_dirty_metadata	<- this takes second block reserved
> > > > 	  				   for journal
> > > > 					   h_buffer_credits--
> > > >   ext4_journal_stop
> > > > 
> > > > However apparently I am missing something, because according to the
> > > > backtrace the second call of jbd2_journal_dirty_metadata() may end up
> > > > with BUG_ON -> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
> > > > 
> > > > So someone else is touching our handle apparently, but I go not exacly
> > > > know what is going on. From my simple debugging printk information I
> > > > have put with before ext4_handle_dirty_metadata() in ext4_quota_write()
> > > > we can see:
> > > > 
> > > > [  226.450263] ext4_quota_write: len 48, off 5136, type 0 h_ref 1
> > > > credits 2
> > > > [  226.458950] ext4_quota_write: len 24, off 8, type 0 h_ref 1 credits 0
> > > > 
> > > > It is clear someone changed handle between v2_write_dquot() and
> > > > v2_write_file_info() does anyone have idea what is going on ?
> > >   It's simpler than that I believe. ext4_write_dquot() does also
> > >         inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> > >         ext4_mark_inode_dirty(handle, inode);
> > > and that eats another credit. Looking at the comment before
> > > EXT4_QUOTA_TRANS_BLOCKS, we in fact counted with inode and data update but
> > > didn't count with the info update. It's actually a race that we ended up
> > > doing info update in our transaction - someone marked info dirty and before
> > > he managed to write it, we went in, saw the dirty flag and wrote it for
> > > him. So the attached patch should fix the problem for you.
> > > 
> > 
> > The patch fixes the problem, you can add
> > 
> > Reported-and-tested-by: Lukas Czerner <lczerner@redhat.com>
> > 
> > Ted, could you pick this up ASAP ? Also I think this needs to go into
> > stable as well.
>   I'll merge it from my tree next week, OK? I don't think there's so much
> hurry as the bug has been there for years and you're the first one to
> report it :).

Of course :) sometimes I am a bit hasty.

> 
> BTW, I've also created the patch below which can slightly improve
> performance of quotas on ext4. The modification of the inode was
> unnecessary as well... Ted, can you merge this patch? It's independent from
> the previous one.
> 
> 								Honza
> --
> From 51741760fe3682ea37bd264471f897bda9d5bd6d Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 31 Mar 2011 23:12:14 +0200
> Subject: [PATCH] ext4: Remove unnecessary [cm]time update of quota file
> 
> It is not necessary to update [cm]time of quota file on each quota file
> write and it wastes journal space and IO throughput with inode writes. So
> just remove the updating from ext4_quota_write() and only update times when
> quotas are being turned off. Userspace cannot get anything reliable from
> quota files while they are used by the kernel anyway.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4_jbd2.h |    4 ++--
>  fs/ext4/super.c     |   16 ++++++++++++++--
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d8b992e..3163583 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -86,8 +86,8 @@
>  
>  #ifdef CONFIG_QUOTA
>  /* Amount of blocks needed for quota update - we know that the structure was
> - * allocated so we need to update only inode+data */
> -#define EXT4_QUOTA_TRANS_BLOCKS(sb) (test_opt(sb, QUOTA) ? 2 : 0)
> + * allocated so we need to update only data block */
> +#define EXT4_QUOTA_TRANS_BLOCKS(sb) (test_opt(sb, QUOTA) ? 1 : 0)
>  /* Amount of blocks needed for quota insert/delete - we do some block writes
>   * but inode, sb and group updates are done only once */
>  #define EXT4_QUOTA_INIT_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_INIT_ALLOC*\
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1f0acd4..baee1b4 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4608,11 +4608,24 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  
>  static int ext4_quota_off(struct super_block *sb, int type)
>  {
> +	struct inode *inode = sb_dqopt(sb)->files[type];
> +	handle_t *handle;
> +
>  	/* Force all delayed allocation blocks to be allocated.
>  	 * Caller already holds s_umount sem */
>  	if (test_opt(sb, DELALLOC))
>  		sync_filesystem(sb);
>  
> +	/* Update modification times of quota files when userspace can
> +	 * start looking at them */
> +	handle = ext4_journal_start(inode, 1);
> +	if (IS_ERR(handle))
> +		goto out;
> +	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	ext4_mark_inode_dirty(handle, inode);
> +	ext4_journal_stop(handle);
> +
> +out:
>  	return dquot_quota_off(sb, type);
>  }
>  
> @@ -4708,9 +4721,8 @@ out:
>  	if (inode->i_size < off + len) {
>  		i_size_write(inode, off + len);
>  		EXT4_I(inode)->i_disksize = inode->i_size;
> +		ext4_mark_inode_dirty(handle, inode);
>  	}
> -	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> -	ext4_mark_inode_dirty(handle, inode);
>  	mutex_unlock(&inode->i_mutex);
>  	return len;
>  }
> 

-- 
