From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC -V2 4/4] ext4: Avoid group preallocation for
	closed files
Date: Thu, 20 Aug 2009 12:10:35 +0530
Message-ID: <20090820064035.GB23232@skywalker.linux.vnet.ibm.com>
References: <1249874635-24250-1-git-send-email-tytso@mit.edu> <1249874635-24250-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46717 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZHTGk6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 02:40:58 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7K6cqp1031550
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 16:38:52 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7K6ew2m1069164
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 16:40:58 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7K6ewoL019578
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 16:40:58 +1000
Content-Disposition: inline
In-Reply-To: <1249874635-24250-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 09, 2009 at 11:23:55PM -0400, Theodore Ts'o wrote:
....

> 
>  static inline void ext4_unlock_group(struct super_block *sb,
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a103cb0..6c7be0d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4191,9 +4191,17 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
>  		return;
> 
>  	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
> -	isize = i_size_read(ac->ac_inode) >> bsbits;
> +	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
> +		>> bsbits;
>  	size = max(size, isize);
> 
> +	if ((size == isize) &&

What is this check supposed to help us ?. This would also imply we disable prealloc
only if we are allocating the last chunk in the file. Why not just

if (atomic_read(&ac->ac_inode->i_writecount) == 0) && !ext4_fs_is_busy(sbi) {
    ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;                                                                                  
}



> +	    ext4_fs_is_busy(sbi) &&
> +	    (atomic_read(&ac->ac_inode->i_writecount) == 0)) {
> +		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
> +		return;
> +	}

shouldn't it be !ext4_fs_is_busy(sbi) ?. Can you also write function documentation
for ext4_fs_is_busy. I found in confusing that you are decrementing s_lock_busy
if we are going to spin on spin_lock.


> +
>  	/* don't use group allocation for large files */
>  	if (size >= sbi->s_mb_stream_request) {
>  		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
> -- 

-aneesh
