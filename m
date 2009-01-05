From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 05 Jan 2009 21:50:13 +0100
Message-ID: <49627285.8060407@ph.tum.de>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:54136 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbZAEUr6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 15:47:58 -0500
In-Reply-To: <20090105170259.GB8939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Jan 05, 2009 at 02:19:55AM +0100, Thiemo Nagel wrote:
>> I came across a null pointer dereference when mounting an intentionally  
>> corrupted filesystem (cf. debug.dmesg).  In my opinion, the problem lies  
>> in ext4_fill_super(), where truncation may occur on setting the integer  
>> db_count, which results in too little memory being allocated for  
>> sbi->s_group_desc.  The attached patch (against 2.6.28) fixes this by  
>> changing the type of db_count to unsigned long.  I also took the  
>> opportunity to make the check against sign extension in calculation of  
>> db_count more strict, so that it now excludes cases in which db_count  
>> comes out as zero.
> 
> Usigned unsigned long is almost always wrong, because it's not a fixed
> size; it's 32 bits on x86_32, but 64 bits on x86_64.  In this
> particular case, db_count is always going to well under 32-bits for
> any legitimate filesystem. 

I have chosen unsigned long for the sole reason to avoid truncation in 
the assignment

db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
	   EXT4_DESC_PER_BLOCK(sb);

where the operands on the right side are of type unsigned long and 
ext4_group_t (which is typedef unsigned long), so I don't think to make 
db_count an unsigned long is hurting anything.

But maybe it's not desireable to allow filesystems which are mountable 
on x86_64 but not on x86_32?  Then a different solution would be to 
enforce s_groups_count < (1<<31).

But there is another caveat:  We also need to take care of the overflow 
in the argument to kmalloc(), and that further reduces the allowed range 
of s_groups_count for x86_32 (but not for x86_64):

sbi->s_group_desc = kmalloc(db_count * sizeof(struct buffer_head *),
			    GFP_KERNEL);

So, which approach do you think would be best?

> If it isn't we need to have better checks;
> it sounds like the checks we need are ones that do a better job
> checking s_blocks_per_group; am I right in assuming that
> s_blocks_per_group was something ridiculous and that is what caused
> the overflow?

No, it was a very large block count (but the small blocks per group 
helped, too):

block count 562949953423360, first data block 8257, blocks per group 512

BTW:  In case anybody likes to have a look at the corrupt filesystem:
It's available at 
http://www.e18.physik.tu-muenchen.de/~tnagel/misc/ext4.null_deref.image.bz2
The size of the download is 88k.

Kind regards,
Thiemo
