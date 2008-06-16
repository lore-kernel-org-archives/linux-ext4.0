From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix file system hang due to corrupt jinode
	values.
Date: Mon, 16 Jun 2008 22:00:11 +0530
Message-ID: <20080616163011.GD14214@skywalker>
References: <1213541578-1351-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080616134503.GA3279@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:39195 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756939AbYFPQan (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 12:30:43 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5GGULjF007597
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 22:00:21 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GGTWCT897214
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 21:59:32 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5GGUKWw008642
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 22:00:20 +0530
Content-Disposition: inline
In-Reply-To: <20080616134503.GA3279@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 16, 2008 at 03:45:03PM +0200, Jan Kara wrote:
> > While commiting the transaction we set the i_flags
> > of jbd2_inode to JI_COMMIT_RUNNING. This is needed to ensure
> > that when we are commiting the transaction we don't release
> > the inode via iput. In ext4_clear_inode we wait for the
> > flag to be cleared before we release the inode.
> > 
> > In ext4_new_inode we call iput for different failure cases
> > before initializing the jbd2_inode. This cause the failure
> > case to hang in iput as show below. Fix the same by initializing
> > jbd2_inode early.
> > 
> >  [<c022d20e>] ? prepare_to_wait+0x49/0x4e
> >  [<c02cf430>] jbd2_journal_release_jbd_inode+0x86/0xcc
> >  [<c022d0e4>] ? wake_bit_function+0x0/0x43
> >  [<c02b329b>] ext4_clear_inode+0x45/0x4a
> >  [<c02748f7>] clear_inode+0x5f/0xae
> >  [<c0274e8f>] generic_drop_inode+0x119/0x13a
> >  [<c0274071>] iput+0x4b/0x4e
> >  [<c02ab200>] ext4_new_inode+0xb29/0xb7a
> >  [<c0272761>] ? dput+0x19/0xdc
> >  [<c02cca5f>] ? jbd2_journal_start+0x8c/0xb9
> >  [<c02b1cb4>] ext4_create+0x81/0xe7
> >  [<c02b1c33>] ? ext4_create+0x0/0xe7
> >  [<c026aa3c>] vfs_create+0x6c/0xdb
> >  [<c026cfd6>] do_filp_open+0x1a6/0x6b5
> >  [<c026284e>] do_sys_open+0x40/0xb6
> >  [<c0262906>] sys_open+0x1e/0x26
> >  [<c0202be6>] syscall_call+0x7/0xb
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>   Oh yes, thanks for fixing this. I think there is place in
> super.c which also calls jbd2_journal_init_jbd_inode() and which doesn't
> need to call it when you do so already in alloc_inode().
> 

Like this ?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fef2574..43d67e0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3125,7 +3125,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
-	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = __ext4_get_inode_loc(inode, &iloc, 0);
 	if (ret < 0)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 034f00f..e511b95 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2259,8 +2259,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
 		goto err_freesgi;
 	}
-	jbd2_journal_init_jbd_inode(&EXT4_I(sbi->s_buddy_cache)->jinode,
-				    sbi->s_buddy_cache);
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 
 	metalen = sizeof(*meta_group_info) << EXT4_DESC_PER_BLOCK_BITS(sb);
