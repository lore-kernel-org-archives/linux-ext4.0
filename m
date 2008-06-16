From: Mingming <cmm@us.ibm.com>
Subject: Re: Patch queue update
Date: Mon, 16 Jun 2008 15:03:09 -0700
Message-ID: <1213653789.27507.48.camel@BVR-FS.beaverton.ibm.com>
References: <20080615172136.GA7293@skywalker>
	 <20080616174944.GF14214@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36354 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546AbYFPWCk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2008 18:02:40 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5GM4w9V031179
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 18:04:58 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GM2eEH208434
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 18:02:40 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GM2dCh026907
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 18:02:39 -0400
In-Reply-To: <20080616174944.GF14214@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-06-16 at 23:19 +0530, Aneesh Kumar K.V wrote:
> On Sun, Jun 15, 2008 at 10:51:36PM +0530, Aneesh Kumar K.V wrote:
> > Hi Mingming,
> > 
> > Attached below are new patches for the patchqueue. Some of patches
> > update already existing patches, mostly to get them apply
> > cleanly after adding new patches or to fix sparse warning. The modified
> > patches should not have any functionality change. The diff between
> > the patchqueue and updated queue is attached below. That should help
> > to look at the changes easily.  The patch queue looked at is
> > as of commit 22d4c3124d50803222c14116b3fdf08dc447a119
> > 
> > The updated series file
> > http://www.radian.org/~kvaneesh/ext4/jun-15-2008/series
> > The patches
> > http://www.radian.org/~kvaneesh/ext4/jun-15-2008/
> > The complete patchset.
> > http://www.radian.org/~kvaneesh/ext4/jun-15-2008/patches.tar.gz
> > 
> > 
> 

I have updated the patch queue with your changes, and place them in the
right location.

Mingming
> Update for 12-ext4-jinode-hang.patch after review.
> 
> ext4: Fix file system hang due to corrupt jinode values.
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> While commiting the transaction we set the i_flags
> of jbd2_inode to JI_COMMIT_RUNNING. This is needed to ensure
> that when we are commiting the transaction we don't release
> the inode via iput. In ext4_clear_inode we wait for the
> flag to be cleared before we release the inode.
> 
> In ext4_new_inode we call iput for different failure cases
> before initializing the jbd2_inode. This cause the failure
> case to hang in iput as show below. Fix the same by initializing
> jbd2_inode early.
> 
>  [<c022d20e>] ? prepare_to_wait+0x49/0x4e
>  [<c02cf430>] jbd2_journal_release_jbd_inode+0x86/0xcc
>  [<c022d0e4>] ? wake_bit_function+0x0/0x43
>  [<c02b329b>] ext4_clear_inode+0x45/0x4a
>  [<c02748f7>] clear_inode+0x5f/0xae
>  [<c0274e8f>] generic_drop_inode+0x119/0x13a
>  [<c0274071>] iput+0x4b/0x4e
>  [<c02ab200>] ext4_new_inode+0xb29/0xb7a
>  [<c0272761>] ? dput+0x19/0xdc
>  [<c02cca5f>] ? jbd2_journal_start+0x8c/0xb9
>  [<c02b1cb4>] ext4_create+0x81/0xe7
>  [<c02b1c33>] ? ext4_create+0x0/0xe7
>  [<c026aa3c>] vfs_create+0x6c/0xdb
>  [<c026cfd6>] do_filp_open+0x1a6/0x6b5
>  [<c026284e>] do_sys_open+0x40/0xb6
>  [<c0262906>] sys_open+0x1e/0x26
>  [<c0202be6>] syscall_call+0x7/0xb
> 
> Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Acked-by: Jan Kara <jack@suse.cz>
> ---
> 
>  fs/ext4/ialloc.c  |    1 -
>  fs/ext4/inode.c   |    1 -
>  fs/ext4/mballoc.c |    2 --
>  fs/ext4/super.c   |    1 +
>  4 files changed, 1 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 7823405..dc8bfc4 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -820,7 +820,6 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
>  	ei->i_state = EXT4_STATE_NEW;
> 
>  	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
> -	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
> 
>  	ret = inode;
>  	if(DQUOT_ALLOC_INODE(inode)) {
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
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e207555..fde1ae9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -578,6 +578,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ei->i_allocated_meta_blocks = 0;
>  	ei->i_delalloc_reserved_flag = 0;
>  	spin_lock_init(&(ei->i_block_reservation_lock));
> +	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
>  	return &ei->vfs_inode;
>  }
> 

