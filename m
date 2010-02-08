From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: ext4_fiemap gives 0 extents for files smaller than a block (patch
 included)
Date: Mon, 08 Feb 2010 15:54:27 +0200
Message-ID: <4B701793.9010005@canonical.com>
References: <1257360161.22057.16.camel@michlmayr>	 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com> <1257371050.13852.28.camel@michlmayr>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	474597@bugs.launchpad.net
To: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:32927 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0BHNyc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 08:54:32 -0500
In-Reply-To: <1257371050.13852.28.camel@michlmayr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Leonard Michlmayr wrote:
> Thank you for your reply.
> 
>>> @@ -3700,7 +3701,8 @@
>>>  		start_blk = start >> inode->i_sb->s_blocksize_bits;
>>> -		len_blks = len >> inode->i_sb->s_blocksize_bits;
>>> +		end_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
>>> +		len_blks = end_blk - start_blk + 1;
>> I don't think this is quite correct either.  For example, if blocksize  
>> is 1024
>> and start is 1023 (start_blk = 0) and len is 2 (end = 1024, end_blk =  
>> 1) then
>> len_blks = 2 which is too much.
> 
> I think that len_blks = 2 is the correct value, because the requested
> region extends into 2 blocks (namely 0 and 1). If both blocks are in two
> separate extents, then ext4_ext_walk_space should report 2 extents. (If
> it's the same extent, only 1 will be reported anyways)
> 
>> I think the right calculation here is:
>>
>>                    end_blk = (start + len + inode->i_sb->s_blocksize - 1) >>
>>                              inode->i_sb->s_blocksize_bits;
>>                    len_blks = end_blk - start_blk;
>>
> 
> This is exactly the same (provided that len > 0). You can convince
> yourself easily that ((blocksize + x) >> blocksize_bits == x >>
> blocksize_bits + 1) for any positive x, because the lower bits of
> blocksize are all 0. (Your calculation would handle the case len == 0
> right, if that was allowed.)
> 
> Regards
> Leonard

I was wondering if there is any update on the status of this patch.
Thanks !

Warm Regards,
Surbhi.


