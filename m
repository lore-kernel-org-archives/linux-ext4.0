From: Akshay Nehe <akshaynehe785@gmail.com>
Subject: Re: Required help for understanding ext4 block allocation
Date: Thu, 22 Mar 2012 18:54:26 +0530
Message-ID: <CA+tw96C9kRHYhiQoyRRH8U_gPtcXZimJL0=kHBX4m7dLrXwaPg@mail.gmail.com>
References: <CA+tw96DSaJH50o1F4sW9XMnmPD8dFO9VCyvK4tbsLFqfgK9CWQ@mail.gmail.com>
	<20120316091810.GB24821@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36229 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab2CVNY3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 09:24:29 -0400
Received: by lahj13 with SMTP id j13so1687257lah.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 06:24:27 -0700 (PDT)
In-Reply-To: <20120316091810.GB24821@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yes, i got extents as you have suggested, but one thing i found that
each time modification occurs on any file from ext4 file system then
kernel deallocates all current blocks and allocate new blocks and
write modified data on newly allocated blocks.

Why kernel uses this policy? My main aim is to browse ext4 code and
try to get and understand functions which dose the job of allocation
and deallocation of blocks.

So by tracing kernel code i got some useful functions, for
deallocation: ext4_free_blocks, for allocation: ext4_map_blocks, but
found difficult to analyse each of them. Can anyone suggest correct
functions which actually dose allocation and deallocation?

On 3/16/12, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> On Thu 15-03-12 18:48:56, Akshay Nehe wrote:
>> I am trying to understand the block allocation in ext4 file sytem, I
>> have gone through all basic theory and browsing code to do it.
>>
>> I am writing a module in which i got ext4 on disk inode, now according
>> to theory first 12 bytes of i_block points to ext4_extent_header, so
>> can i use this array of i_block[EXT4_N_BLOCKS].
>>
>> Means how to fill objects of  struct ext4_extent_header (using first
>> 12 byte of i_block) and  struct ext4_extent (using reminder bytes of
>> i_block).
>   struct ext4_extent_header is just directly stored in the space occupied
> by i_block[EXT4_N_BLOCKS]. So for example ext_inode_hdr() does:
>   (struct ext4_extent_header *)EXT4_I(inode)->i_data
> (where i_data is just one-to-one copy of i_blocks from on disk inode).
>
> And it's the same with struct ext4_extent. See for example macro
> EXT_FIRST_EXTENT.
>
> 								Honza
>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>


-- 
Regards,
Akshay Nehe.
