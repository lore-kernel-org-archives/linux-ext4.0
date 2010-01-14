From: Andreas Dilger <adilger@sun.com>
Subject: Re: [REPOST][RFC][PATCH] ext4: unify each meaning of the offset in
 ext4_check_dir_entry calling from some functions.
Date: Thu, 14 Jan 2010 10:18:53 -0500
Message-ID: <F9B87217-D6BA-4BF6-BD13-1B960DB4B20C@sun.com>
References: <20100114155739.99150559.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41231 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0ANPS5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 10:18:57 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0EFIsJ6025162
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2010 07:18:56 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KW800000T1AQF00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 14 Jan 2010 07:18:54 -0800 (PST)
In-reply-to: <20100114155739.99150559.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-14, at 01:57, Toshiyuki Okajima wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
>
> "offset" of the error message of ext4_check_dir_entry() might change  
> the
> meaning by the caller. There are 2 meanings:
> - "File offset"
>  called by:
>   ext4_readdir, htree_dirblock_to_tree, search_dirblock,  
> ext4_dx_find_entry,
>   empty_dir
> - "Buffer offset"
>  called by:
>   add_dirent_to_buf, ext4_delete_entry

This makes sense to fix.

> The best way to solve this problem is to change the meaning of
> "Buffer offset" into "File offset" but it is not easy.
> However, we can solve this problem easily if we unify the meanings  
> into
> "Buffer offset". So, instead of "File Offset" meaning, we add the  
> block number information to this message.
>
> --- Examples ---
> Error message which is changed by this patch:
> EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in  
> directory
> #12: rec_len is too small for name_len - block_nr=78:offset=0,  
> inode=216,
> rec_len=12, name_len=11

I personally would prefer to see "block=78, offset=0" instead of the  
above.

> @@ -84,9 +84,10 @@ int ext4_check_dir_entry(const char *fun
>
> 	if (error_msg != NULL)
> 		ext4_error(dir->i_sb, function,
> +			"bad entry in directory #%lu: %s - block_nr=%llu:"
> 			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
> +			dir->i_ino, error_msg,
> +			(u64)bh->b_blocknr, (u32)(offset%bh->b_size),


One problem here is that "(u64)" is not necessarily a "long long".  On  
some 64-bit platforms it will be a "long" and this will generate a  
compiler warning.  Better to use "(unsigned long long)", and you may  
as well use "(unsigned)" for the offset value.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

