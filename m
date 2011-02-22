From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH]ext4: Fix compile warnings with EXT4FS_DEBUG
Date: Tue, 22 Feb 2011 12:05:14 +0900
Message-ID: <4D6327EA.6020305@rs.jp.nec.com>
References: <4D393732.5020301@rs.jp.nec.com> <20110222015216.GB2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64979 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1BVDFf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 22:05:35 -0500
In-Reply-To: <20110222015216.GB2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> s_itb_per_group is defined to be an unsigned long, so a much better
> fix is simply to change the format string.

Thanks for your work. ;)

(2011/02/22 10:52), Ted Ts'o wrote:
> On Fri, Jan 21, 2011 at 04:35:14PM +0900, Akira Fujita wrote:
>>          ext4_debug("clear inode table blocks %#04llx ->  %#04llx\n",
>> -                       block, sbi->s_itb_per_group);
>> +                       block, (ext4_fsblk_t)sbi->s_itb_per_group);
> 
> s_itb_per_group is defined to be an unsigned long, so a much better
> fix is simply to change the format string.
> 
>         	      	 	    	   - Ted
> 
>> From da488945f4bf4096f4ab6091938469bd8822cfec Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o<tytso@mit.edu>
> Date: Mon, 21 Feb 2011 20:39:58 -0500
> Subject: [PATCH] ext4: fix compile warnings with EXT4FS_DEBUG enabled
> 
> Compile 2.6.38-rc1 with turning EXT4FS_DEBUG on,
> we get following compile warnings. This patch fixes them.
> 
>    CC      fs/ext4/hash.o
>    CC      fs/ext4/resize.o
> fs/ext4/resize.c: In function 'setup_new_group_blocks':
> fs/ext4/resize.c:233:2: warning: format '%#04llx' expects type 'long long
> unsigned int', but argument 3 has type 'long unsigned int'
> fs/ext4/resize.c:251:2: warning: format '%#04llx' expects type 'long long
> unsigned int', but argument 3 has type 'long unsigned int'
>    CC      fs/ext4/extents.o
>    CC      fs/ext4/ext4_jbd2.o
>    CC      fs/ext4/migrate.o
> 
> Reported-by: Akira Fujita<a-fujita@rs.jp.nec.com>
> Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> ---
>   fs/ext4/resize.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 3ecc6e4..66fec4e 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -230,7 +230,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>   	}
> 
>   	/* Zero out all of the reserved backup group descriptor table blocks */
> -	ext4_debug("clear inode table blocks %#04llx ->  %#04llx\n",
> +	ext4_debug("clear inode table blocks %#04llx ->  %#04lx\n",
>   			block, sbi->s_itb_per_group);
>   	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
>   			       GFP_NOFS);
> @@ -248,7 +248,7 @@ static int setup_new_group_blocks(struct super_block *sb,
> 
>   	/* Zero out all of the inode table blocks */
>   	block = input->inode_table;
> -	ext4_debug("clear inode table blocks %#04llx ->  %#04llx\n",
> +	ext4_debug("clear inode table blocks %#04llx ->  %#04lx\n",
>   			block, sbi->s_itb_per_group);
>   	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
>   	if (err)

