From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Replace iget with iget_locked in
	defrag-free-space-fragementation
Date: Tue, 05 Feb 2008 16:54:18 -0800
Message-ID: <1202259258.3935.13.camel@localhost.localdomain>
References: <E1JLLPj-0006dq-9C@closure.thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47146 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbYBFAyS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2008 19:54:18 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m160sHZS021459
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 19:54:17 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m160sHUg236194
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 19:54:17 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m160sHCW030408
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 19:54:17 -0500
In-Reply-To: <E1JLLPj-0006dq-9C@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-02-02 at 11:40 -0500, Theodore Ts'o wrote:
> FYI, since iget() is going to be disappearing in 2.6.25, and akpm has
> disabled ext4 in the -mm tree as a result, I'm folding the following
> patch into the defrag-free-space-fragmentation.patch in the ext4 tree.
> 
> 
I noticed that you have merged the changes in the patch queue...

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
> index d9a14e4..6370fb8 100644
> --- a/fs/ext4/defrag.c
> +++ b/fs/ext4/defrag.c
> @@ -287,9 +287,13 @@ static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
>  	int entries = 0;
>  	int err = 0;
> 
> -	inode = iget(sb, ext_info->ino);
> +	inode = iget_locked(sb, ext_info->ino);
>  	if (!inode)
>  		return -EACCES;
> +	if (inode->i_state & I_NEW) {
> +		sb->s_op->read_inode(inode);
> +		unlock_new_inode(inode);
> +	}
> 
>  	down_write(&EXT4_I(inode)->i_data_sem);
> 
read_inode() also sunset, as removed in 
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/broken-out/iget-remove-iget-and-the-read_inode-super-op-as.patch

so above changes won't compile in mm tree.

I have fixed it in patch queue, using ext4_iget() to replace iget() and read-inode() as suggested in iget-stop-ext4-from-using-iget-and-read_inode-try.patch 

http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4-online-defrag-iget-read-inode-fix.patch;h=94660ca7371680fcd02bb5804016b4cae4f20846;hb=85589744f9d53579a12aa463ccd42fb450aec786

> We also have an issue where the read-only bind patches from Dave Hansen
> are making changes which conflict with the ext4 patch tree, which is
> making akpm very grumpy.  I'll try to take a look at this later in the
> weekend...
> 
> 						- Ted
> 



> @@ -588,9 +592,13 @@ static int ext4_ext_defrag_victim(struct file *target_filp,
>  	ext.len = 0;
> 
>  	/* Get the inode of the victim file */
> -	victim_inode = iget(sb, ex_info->ino);
> +	victim_inode = iget_locked(sb, ex_info->ino);
>  	if (!victim_inode)
>  		return -EACCES;
> +	if (victim_inode->i_state & I_NEW) {
> +		sb->s_op->read_inode(victim_inode);
> +		unlock_new_inode(victim_inode);
> +	}
> 
>  	/* Setup file for the victim file */
>  	victim_dent.d_inode = victim_inode;
