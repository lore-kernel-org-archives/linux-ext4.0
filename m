From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: print more sysadmin-friendly message in check_block_validity()
Date: Tue, 08 Sep 2009 18:49:46 +0530
Message-ID: <4AA659F2.8010109@linux.vnet.ibm.com>
References: <4AA645F0.8050903@linux.vnet.ibm.com> <1252412562-738-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53835 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZIHNTy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 09:19:54 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp05.au.ibm.com (8.14.3/8.13.1) with ESMTP id n88DHL2s005240
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 23:17:21 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n88DJu2G372816
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 23:19:56 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n88DJuMM006173
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 23:19:56 +1000
In-Reply-To: <1252412562-738-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have tested this and it's working fine. I am not seeing any kernel 
stack/call traces.

Theodore Ts'o wrote:
> Drop the WARN_ON(1), as he stack trace is not appropriate, since it is
> triggered by file system corruption, and it misleads users into
> thinking there is a kernel bug.  In addition, change the message
> displayed by ext4_error() to make it clear that this is a file system
> corruption problem.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3400961..4d3fd0e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1121,16 +1121,15 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  		ext4_discard_preallocations(inode);
>  }
> 
> -static int check_block_validity(struct inode *inode, sector_t logical,
> -				sector_t phys, int len)
> +static int check_block_validity(struct inode *inode, const char *msg,
> +				sector_t logical, sector_t phys, int len)
>  {
>  	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), phys, len)) {
> -		ext4_error(inode->i_sb, "check_block_validity",
> +		ext4_error(inode->i_sb, msg,
>  			   "inode #%lu logical block %llu mapped to %llu "
>  			   "(size %d)", inode->i_ino,
>  			   (unsigned long long) logical,
>  			   (unsigned long long) phys, len);
> -		WARN_ON(1);
>  		return -EIO;
>  	}
>  	return 0;
> @@ -1182,8 +1181,8 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
>  	up_read((&EXT4_I(inode)->i_data_sem));
> 
>  	if (retval > 0 && buffer_mapped(bh)) {
> -		int ret = check_block_validity(inode, block,
> -					       bh->b_blocknr, retval);
> +		int ret = check_block_validity(inode, "file system corruption",
> +					       block, bh->b_blocknr, retval);
>  		if (ret != 0)
>  			return ret;
>  	}
> @@ -1264,8 +1263,9 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
> 
>  	up_write((&EXT4_I(inode)->i_data_sem));
>  	if (retval > 0 && buffer_mapped(bh)) {
> -		int ret = check_block_validity(inode, block,
> -					       bh->b_blocknr, retval);
> +		int ret = check_block_validity(inode, "file system "
> +					       "corruption after allocation",
> +					       block, bh->b_blocknr, retval);
>  		if (ret != 0)
>  			return ret;
>  	}


