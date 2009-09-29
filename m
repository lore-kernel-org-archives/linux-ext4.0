From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH]ext4: Add checks whether two inodes are different
Date: Tue, 29 Sep 2009 14:18:39 +0900
Message-ID: <4AC198AF.1070600@rs.jp.nec.com>
References: <4ABC7FC5.5070803@rs.jp.nec.com> <20090925103453.GR10562@webber.adilger.int> <20090928200000.GA22733@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:54796 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZI2FTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Sep 2009 01:19:07 -0400
In-Reply-To: <20090928200000.GA22733@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted / Andreas,
Theodore Tso wrote:
> On Fri, Sep 25, 2009 at 04:34:53AM -0600, Andreas Dilger wrote:
>> Wouldn't it make more sense to just return an error (or no error
>> but do nothing) in the case of source/target inode being the same?
>> I don't see how that would be good to "defragment" the inode onto
>> itself, just like "cp f f" and "rename f f" don't make sense either.
> 
> The code actually checks to make sure the source and target inodes are
> different, but it does so too late.  So the following patch should fix
> the problem which Akira-san was attempting to solve, without
> introducing any extra code complexity (we just move some lines of code
> around instead.)

I thought the argument check (orig and donor inodes are different)
should be done in mext_check_arguments()
because this function checks the arguments whether they are fine
(according to its name).
So mext_double_{up, down}_{read, write} which may be called earlier than
mext_check_arguments() should take/release one inode of them,
if orig and donor inodes are same.

And in the point of view of each function (mext_double_{up, down}_{read, write}),
I thought that we have had better to care about the situation
that same inode is passed to it, they are "static" function though.

Anyway, I tested Ted's patch fixes the problem.
Thanks for your work. :-)

Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Regards,
Akira Fujita


> 
> commit 7cdf27b7241ef616b4158a26d7d85bd36f499462
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Sep 28 15:58:29 2009 -0400
> 
>     ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
>     
>     Move the check to make sure the original and donor inodes are
>     different earlier, to avoid a potential deadlock by trying to lock the
>     same inode twice.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 5332fd4..25b6b14 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -1001,14 +1001,6 @@ mext_check_arguments(struct inode *orig_inode,
>  		return -EINVAL;
>  	}
>  
> -	/* orig and donor should be different file */
> -	if (orig_inode->i_ino == donor_inode->i_ino) {
> -		ext4_debug("ext4 move extent: The argument files should not "
> -			"be same file [ino:orig %lu, donor %lu]\n",
> -			orig_inode->i_ino, donor_inode->i_ino);
> -		return -EINVAL;
> -	}
> -
>  	/* Ext4 move extent supports only extent based file */
>  	if (!(EXT4_I(orig_inode)->i_flags & EXT4_EXTENTS_FL)) {
>  		ext4_debug("ext4 move extent: orig file is not extents "
> @@ -1232,6 +1224,14 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  	int block_len_in_page;
>  	int uninit;
>  
> +	/* orig and donor should be different file */
> +	if (orig_inode->i_ino == donor_inode->i_ino) {
> +		ext4_debug("ext4 move extent: The argument files should not "
> +			"be same file [ino:orig %lu, donor %lu]\n",
> +			orig_inode->i_ino, donor_inode->i_ino);
> +		return -EINVAL;
> +	}
> +
>  	/* protect orig and donor against a truncate */
>  	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
>  	if (ret1 < 0)
> 
