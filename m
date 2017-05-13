From: Shawn C <citypw@gmail.com>
Subject: Re: PAX: size overflow detected in function ext4_llseek
 fs/ext4/file.c:670
Date: Sat, 13 May 2017 12:23:30 +0800
Message-ID: <81b23073-00e7-9cd0-71e3-b9c085a2ac34@gmail.com>
References: <CABniQZMSW6DiSvJ7Y2TZTwUKX6sGH6-WkQRjL-kPOmdm7PnKHA@mail.gmail.com>
 <20170512050234.ohjoofele5gugxab@thunk.org>
 <5915875E.15260.4679D7CA@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, Brad Spengler <spender@grsecurity.net>
To: pageexec@freemail.hu, Theodore Ts'o <tytso@mit.edu>,
        Emese Revfy <re.emese@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34437 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdEMEXf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 May 2017 00:23:35 -0400
Received: by mail-pg0-f49.google.com with SMTP id u28so38362892pgn.1
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 21:23:35 -0700 (PDT)
In-Reply-To: <5915875E.15260.4679D7CA@pageexec.freemail.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 05/12/2017 05:58 PM, PaX Team wrote:
> On 12 May 2017 at 1:02, Theodore Ts'o wrote:
> 
> [added Emese to CC and thus kept the whole mail for context even if
> i'm responding to some parts of it only]
> 
>> On Fri, May 12, 2017 at 12:10:04PM +0800, Shawn wrote:
>>>
>>> thanks for the reports, keep them coming . this is an interesting one,
>>> here's the code (same at both lines in ext4_seek_hole and ext4_seek_data):
>>>
>>> 670 »·······start = offset >> blkbits;
>>>
>>> in types this is
>>>
>>> u32 = long long >> int;
>>>
>>> since the maximum value was exceeded it means that offset (long long,
>>> 64 bits even on 32 bit archs) had a value that didn't fit u32 when right
>>> shifted. based on some light code reading, blkbits is between 10-16 on
>>> ext4 (EXT4_MIN_BLOCK_SIZE-EXT4_MAX_BLOCK_SIZE) so depending on what the
>>> actual block size of the underlying filesystem was, offset must have been
>>> bigger than 2^42-2^48 (4TB-256TB).
>>
>> Yes, this is indeed an interesting one.  I actually suspect that
>> offset was *negative*, and since start is a u32, this got translated
>> into a large number.
> 
> Shawn, can you do the printk instrumentation i suggested to print out
> the value of offset (and isize too while at it)?
>
I inserted the printk info in fs/ext4/file.c:677

00------------------
        printk(KERN_DEBUG"offset: %lld, isize: %lld, blkbits: %d\n",
offset, isize, blkbits);
11------------------

result:

offset: 105, isize: 19595264, blkbits: 12


> thing is, IIRC the C standard makes right shifting a negative value
> implementation defined (so excluding such values would be good for that
> reason alone) and i think gcc simply executes it as an arithmetic shift,
> i.e., the sign of the result is preserved and thus the size overflow
> checks should have detected a minimum violation, not the maximum one.
> 
> to tell for sure what check triggered exactly, i'd like to ask Shawn
> to execute
> 
> 	make fs/ext4/file.o EXTRA_CFLAGS="-fdump-tree-all -fdump-ipa-all"
> 
> and send us (Emese in particular) all the resulting files (fs/ext4/file.*)
> 
find the file here:
https://ufile.io/9ie40

Let me know if you need anything else.


regards
Shawn
