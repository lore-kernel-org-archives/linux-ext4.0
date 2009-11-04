From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4_fiemap gives 0 extents for files smaller than a block (patch
 included)
Date: Wed, 04 Nov 2009 12:44:11 -0700
Message-ID: <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
References: <1257360161.22057.16.camel@michlmayr>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56017 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbZKDToJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 14:44:09 -0500
In-reply-to: <1257360161.22057.16.camel@michlmayr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-04, at 11:42, Leonard Michlmayr wrote:
> Fiemap (ioctl) does not return any extents for small files on ext4.
> (fm_start=0, fm_length=filesize)
>
> File affected: fs/ext4/extents.c
>
> I found the reason of the bug: wrong rounding. It will not only affect
> small files, but any request that overlaps an extent boundary by less
> that blocksize.

>
> @@ -3700,7 +3701,8 @@
>  		start_blk = start >> inode->i_sb->s_blocksize_bits;
> -		len_blks = len >> inode->i_sb->s_blocksize_bits;
> +		end_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> +		len_blks = end_blk - start_blk + 1;

I don't think this is quite correct either.  For example, if blocksize  
is 1024
and start is 1023 (start_blk = 0) and len is 2 (end = 1024, end_blk =  
1) then
len_blks = 2 which is too much.

I think the right calculation here is:

                   end_blk = (start + len + inode->i_sb->s_blocksize -  
1) >>
                             inode->i_sb->s_blocksize_bits;
                   len_blks = end_blk - start_blk;

I'm also wondering (unrelated to this bug) why inode->i_sb- 
 >s_blocksize_bits
is used instead of inode->i_blkbits?  That is probably worth a  
separate cleanup
patch.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

