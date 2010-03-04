From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Thu, 04 Mar 2010 17:38:50 -0600
Message-ID: <4B90448A.2030609@redhat.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>	 <1267553925-6308-12-git-send-email-tytso@mit.edu>	 <4B8E1410.1010107@rs.jp.nec.com> <20100303175217.GA3530@thunk.org>	 <4B8F47C6.9060408@rs.jp.nec.com> <1267739098.4204.12.camel@michlmayr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, tytso@mit.edu,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab0CDXjB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 18:39:01 -0500
In-Reply-To: <1267739098.4204.12.camel@michlmayr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Leonard Michlmayr wrote:
> Akira Fujita:
>> <kernel-space>
>> fs/ioctl.c ioctl_fimap():
>>
>> filemap_check_ranges():
>> 	len(~0ULL)
>> 	new_len(4398046511103 = s_maxbytes)  <--- Because 'len > s_maxbytes'
>>
>> fs/ext4/extents.c ext4_fiemap():
>> 	last_blk = start(0) + len(4398046511103) - 1 >> s_blocksize_bits(11)
>> 	         = 4294967295 (0xFFFFFFFF)
>> 	len_blks = 4294967295 + 1 (0xFFFFFFFF + 0x00000001)
>> 		 = 4294967296 (0x100000000)  <--- _OVERFLOW!!_
>> 	
>> ext4_ext_walk_space():
>> 	num = 0
>>
>> This overflow leads to incorrect output like the below,
>> even though 2 extents exist.
>>
> 
> Thank you for pointing this out. I had not checked s_maxbytes.
> Appearently s_maxbytes can be 1<<(32 + s_blocksize_bits) - 1. Therefore
> the number of blocks in a file cannot be stored in a 32bit integer.

For extent-based files it had better be....

struct ext4_extent {
        __le32  ee_block;       /* first logical block extent covers */
        __le16  ee_len;         /* number of blocks covered by extent */

The start block can't be more than 32 bits; this essentially limits
the file size / maximum logical block to 2^32 blocks right?

s_maxbytes comes out to 17592186044415

2^32 4k blocks is 17592186044416 bytes, or max byte offset 17592186044415

What am I missing?  (confusion between max byte count and max
byte offset, perhaps?)

-Eric

> I have a patch that should fix it for fiemap. I have just compiled it
> and I will do some testing and double checking tomorrow. I will send a
> separate email with the patch.
> 
> regards
> Leonard
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

