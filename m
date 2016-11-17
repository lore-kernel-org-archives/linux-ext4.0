From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: ext4 corruption causing a crash
Date: Thu, 17 Nov 2016 09:12:34 +0200
Message-ID: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
References: <f4fcebfd-292e-5238-b592-65fa605f1445@kyup.com>
 <d2aea076-15c1-2131-faca-0fb977f3d082@kyup.com>
 <6afc40e8-50fd-0019-a172-03e52028ba25@kyup.com>
 <20161116181750.vjyqznnbucvpaoix@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>,
        bp@alien8.de
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34298 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbcKQHMi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2016 02:12:38 -0500
Received: by mail-wm0-f43.google.com with SMTP id u144so39101423wmu.1
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2016 23:12:36 -0800 (PST)
In-Reply-To: <20161116181750.vjyqznnbucvpaoix@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11/16/2016 08:17 PM, Theodore Ts'o wrote:
> On Wed, Nov 16, 2016 at 03:03:35PM +0200, Nikolay Borisov wrote:
>>
>> Ok so with the help of bpetkov we managed to get to the bottom it, 
>> essentially what happens is that we overflow the page allocated in 
>> ext4_calculate_overhead while working in the following loop in count_overhead: 
>>
>> for (j = ext4_bg_num_gdb(sb, grp); j > 0; j--) {
>> 	ext4_set_bit(EXT4_B2C(sbi, s++), buf);
>> 	count++;
>> }
>>
>> so ext4_bg_num_gdb returns a big number - 32768 and since sbi->s_cluster_bits 
>> is 0 the result of EXT4_B2C(sbi, s++) becomes just s, which incremented on 
>> every iteration and eventually becomes a large number. This causes to overflow 
>> the page used as a buf. This can be seen easily from the crash produced when 
>> debug_pagealloc is enabled:
> 
> Thanks for digging into this!  It sounds like we need to add more
> sanity checking at mount time, as well as some safety constraints to
> make sure we don't overrun memory.
> 
> Can you send me dumpe2fs -h output from the drive that provoked this?

Sorry, no. 

dumpe2fs -h -f OSS-2016-22-image 
dumpe2fs 1.42.12 (29-Aug-2014)
dumpe2fs: Filesystem revision too high while trying to open OSS-2016-22-image
Couldn't find valid filesystem superblock.

Here is what 'file' reports though: 
 
OSS-2016-22-image: Linux rev 65537.0 ext2 filesystem data (extents) (huge files)

Also you can find the offending image here: 
https://os-s.net/advisories/OSS-2016-23-image


> 
> Thanks,
> 
> 						- Ted
> 
