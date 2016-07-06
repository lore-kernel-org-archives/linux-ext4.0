From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: ext4 crash in 4.4.10
Date: Wed, 6 Jul 2016 14:08:28 +0300
Message-ID: <577CE6AC.8090707@kyup.com>
References: <57513FAF.5030800@kyup.com> <20160603091936.GA2470@quack2.suse.cz>
 <577A2317.2070609@kyup.com> <20160706102224.GH14067@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	SiteGround Operations <operations@siteground.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35935 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbcGFLIc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2016 07:08:32 -0400
Received: by mail-wm0-f45.google.com with SMTP id f126so169339498wma.1
        for <linux-ext4@vger.kernel.org>; Wed, 06 Jul 2016 04:08:31 -0700 (PDT)
In-Reply-To: <20160706102224.GH14067@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 07/06/2016 01:22 PM, Jan Kara wrote:
> On Mon 04-07-16 11:49:27, Nikolay Borisov wrote:
>> Hello again Jan, 
>>
>> On 06/03/2016 12:19 PM, Jan Kara wrote:
>>> Hi,
[SNIP]
>> The crash again points to test_bit in info_idq_free.  I followed
>> your advise to search for the address and here is what I got: 
>>
>> crash> search -m ffffffff00000000 d9c01f11
>>
>> ffff88000181e030: d9c01927d9c01f11 
>> ffff880996894680: ffffffffd9c01f11 
>> ffff881d5019b858: ffffffffd9c01f11 
>> ffff881d5019b998: ffffffffd9c01f11 - <stack frame of crash_kexec>
>> ffff881d5019bbe8: ffffffffd9c01f11 - <stack frame of page_fault)
>> ffffffff8181e030: d9c01927d9c01f11
>>
>> So two of the values are in the stack frames of function involved, 
>> in the crash so I'd say they are of no interest. What's interesting
>> is that ffffffff8181e030 seems to be quota_magics: 
>>
>> readelf -s vmlinux-4.4.10-clouder1 | grep ffffffff8181e030
>> 15605: ffffffff8181e030    12 OBJECT  LOCAL  DEFAULT    4 quota_magics.24849
>>
>> #define V2_INITQMAGICS {\
>>         0xd9c01f11,     /* USRQUOTA */\
>>         0xd9c01927,     /* GRPQUOTA */\
>>         0xd9c03f14,     /* PRJQUOTA */\
>> }
>>
>> So it seems that somehow the USRQUOTA magic values overwrites
>> the dquot pointer. Looking at the code I'm not entirely 
>> sure how this can happen though.
> 
> This is indeed interesting. Can you dump full struct ext4_inode * of the inode
> for which dquot_free_inode() was crashing? Command
> 
> kmem -s ffff880996894680

Unfortunately I can't use that command, since my kernel is not compiled
with SLUB_DEBUG. However, I was able to retrieve the contents of both
ext4_inode_info and inode and they seem to be in some semi-freed state.
I've put the contents of the ext4_inode_info and containing inode here:

http://pastie.org/private/c1ptyg8abgzqbphmb9mng

I also verified that those struct indeed look legitimate since the
inode->i_sb is indeed the superblock pointer of the fs which crashed.
And the i_dquot member of the ext4_inode_info holds the USRQUOTA magic
value:

i_dquot = {0xffffffffd9c01f11, 0x0, 0x0},



> 
> should show you that this address is part of an object in ext4_inode_cache
> (please verify that) and give you pointer to the beginning of the object
> which is ext4_inode... Thanks!
> 
> 								Honza
> 
