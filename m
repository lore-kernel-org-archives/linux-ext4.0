From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix file system hang due to corrupt jinode values.
Date: Mon, 16 Jun 2008 19:27:05 +0200
Message-ID: <20080616172705.GD3279@atrey.karlin.mff.cuni.cz>
References: <1213541578-1351-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080616134503.GA3279@atrey.karlin.mff.cuni.cz> <20080616163011.GD14214@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60442 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYFPR1G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 13:27:06 -0400
Content-Disposition: inline
In-Reply-To: <20080616163011.GD14214@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Jun 16, 2008 at 03:45:03PM +0200, Jan Kara wrote:
> > > While commiting the transaction we set the i_flags
> > > of jbd2_inode to JI_COMMIT_RUNNING. This is needed to ensure
> > > that when we are commiting the transaction we don't release
> > > the inode via iput. In ext4_clear_inode we wait for the
> > > flag to be cleared before we release the inode.
> > > 
> > > In ext4_new_inode we call iput for different failure cases
> > > before initializing the jbd2_inode. This cause the failure
> > > case to hang in iput as show below. Fix the same by initializing
> > > jbd2_inode early.
> > > 
> > >  [<c022d20e>] ? prepare_to_wait+0x49/0x4e
> > >  [<c02cf430>] jbd2_journal_release_jbd_inode+0x86/0xcc
> > >  [<c022d0e4>] ? wake_bit_function+0x0/0x43
> > >  [<c02b329b>] ext4_clear_inode+0x45/0x4a
> > >  [<c02748f7>] clear_inode+0x5f/0xae
> > >  [<c0274e8f>] generic_drop_inode+0x119/0x13a
> > >  [<c0274071>] iput+0x4b/0x4e
> > >  [<c02ab200>] ext4_new_inode+0xb29/0xb7a
> > >  [<c0272761>] ? dput+0x19/0xdc
> > >  [<c02cca5f>] ? jbd2_journal_start+0x8c/0xb9
> > >  [<c02b1cb4>] ext4_create+0x81/0xe7
> > >  [<c02b1c33>] ? ext4_create+0x0/0xe7
> > >  [<c026aa3c>] vfs_create+0x6c/0xdb
> > >  [<c026cfd6>] do_filp_open+0x1a6/0x6b5
> > >  [<c026284e>] do_sys_open+0x40/0xb6
> > >  [<c0262906>] sys_open+0x1e/0x26
> > >  [<c0202be6>] syscall_call+0x7/0xb
> > > 
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >   Oh yes, thanks for fixing this. I think there is place in
> > super.c which also calls jbd2_journal_init_jbd_inode() and which doesn't
> > need to call it when you do so already in alloc_inode().
> > 
> 
> Like this ?
  Yes, so it was mballoc.c and inode.c :). Thanks. You can add
Acked-by: Jan Kara <jack@suse.cz>
  to the merged patch (or maybe even fold your fix into the original
patch).

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index fef2574..43d67e0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3125,7 +3125,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
>  #endif
>  	ei->i_block_alloc_info = NULL;
> -	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
>  
>  	ret = __ext4_get_inode_loc(inode, &iloc, 0);
>  	if (ret < 0)
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 034f00f..e511b95 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2259,8 +2259,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
>  		goto err_freesgi;
>  	}
> -	jbd2_journal_init_jbd_inode(&EXT4_I(sbi->s_buddy_cache)->jinode,
> -				    sbi->s_buddy_cache);
>  	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
>  
>  	metalen = sizeof(*meta_group_info) << EXT4_DESC_PER_BLOCK_BITS(sb);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
