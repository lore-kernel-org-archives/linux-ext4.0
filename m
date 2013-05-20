From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4: Slow performance on first write after mount
Date: Mon, 20 May 2013 01:04:01 -0600
Message-ID: <CC59A792-F373-4E75-B3FF-BAA36ED90357@dilger.ca>
References: <1626815623.663380.1368957713809.JavaMail.ngmail@webmail08.arcor-online.net> <1545375580.3424480.1368968403367.JavaMail.ngmail@webmail10.arcor-online.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:44599 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3ETHEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 May 2013 03:04:01 -0400
Received: by mail-da0-f42.google.com with SMTP id r6so2442031dad.15
        for <linux-ext4@vger.kernel.org>; Mon, 20 May 2013 00:04:00 -0700 (PDT)
In-Reply-To: <1545375580.3424480.1368968403367.JavaMail.ngmail@webmail10.arcor-online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-05-19, at 7:00, frankcmoeller@arcor.de wrote:
>> One question regarding fallocate: I create a new file and do a 100MB
>> fallocate 
>> with FALLOC_FL_KEEP_SIZE. Then I write only 70MB to that file and close it.
>> Is the 30 MB unused preallocated space still preallocated for that file
>> after closing
>> it? Or does a close release the preallocated space?
> 
> I did some tests and now I can answer it by myself ;-)
> The space stays preallocated after closing the file. Also umount don't releases 
> the space. Interesting!

Yes, this is how it is expected to work. Your application would need
to truncate the file to the final size when it is finished writing to it. 

> I was testing concurrent fallocates and writes to the same file descriptor. It 
> seems to work. If it is quick enough I cannot say at the moment.
> 
>> it would be really good if 
>> right after mount the filesystem
>> would knew something more to find a good group quicker.
>> What do you think of this:
>> 1. I read this already in some discussions: You already store the
>> free space amount for every group. Why not also storing how
>> big the biggest contiguous free space block in a group is?
>> Then you don't have to read the whole group.

Yes, this is done in memory already, and updating it on disk is no
more effort than updating the free block count when blocks are allocated
or freed in that group.

One option would be to store the first 32 bits of the buddy bitmap
in the bg_reserved field for each group. That would give us the
distribution down to 4 MB chunks in each group (if I calculate correctly).

That would consume the last free field in the group descriptor, but it
might be worthwhile?  Alternately, it could be put into a separate
file, but that would cause more IO. 

>> 2. What about a list (in memory and also stored on disk) with all unused
>> groups (1 bit for every group).

Having only 1 bit per group is useless. The full/not full information
can already be had from the free blocks counter in the group descriptor,
which is always in memory.

The problem is with groups that appear to have _some_ free space,
but need the bitmap to be read to see if it is contiguous or not. Some
heuristics might be used to improve this scanning, but having part of
the buddy bitmap loaded would be more useful. 

>>  If the allocator cannot find a good group within lets say half second, a
>> group from this list is used.
>>  The list is also not be 100% reliable (because of the mentioned unclean
>> unmounts), so you need to search
>>  a good group in the list. If no good group was found in the list, the
>> allocator can continue searching.
>>  This don't helps in all situations (e.g. almost full disk or every group
>> contains a small amount of data),
>>  but it should be in many cases much faster, if the list is not totally
>> outdated.

I think this could be an administrator tunable, if latency is more
important than space efficiency. It can already do this from the
data in the group descriptors that are loaded at mount time.  

Cheers, Andreas 
>>> It would be possible to fallocate() at some expected size (e.g. average
>> file
>>> size) and then either truncate off the unused space, or fallocate() some
>>> more in another thread when you are close to tunning out. 
>>> If the fallocate() is done in a separate thread the latency can be hidden
>>> from the main application?
>> Adding a new thread for fallocate shouldn't be a big problem. But fallocate
>> might 
>> generate high disk usage (while searching for a good group). I don't know
>> whether
>> parallel writing from the other thread is quick enough.
>> 
>> One question regarding fallocate: I create a new file and do a 100MB
>> fallocate 
>> with FALLOC_FL_KEEP_SIZE. Then I write only 70MB to that file and close it.
>> Is the 30 MB unused preallocated space still preallocated for that file
>> after closing
>> it? Or does a close release the preallocated space?
>> 
>> Regards,
>> Frank
>> 
>>> 
>>> Cheers, Andreas 
>>> 
>>>> And you have to take care about alignment and there are several threads
>> in
>>> the internet which explain why you shouldn't use it (or only in very
>> special
>>> situations and I don't think that my situation is one of them). And ext4
>>> group initialization takes also place when using O_DIRECT (as said before
>>> perhaps I did something wrong).
>>>> 
>>>> Regards,
>>>> Frank
>>>> 
>>>> ----- Original Nachricht ----
>>>> Von:     "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
>>>> An:      "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>, ext4
>>> development <linux-ext4@vger.kernel.org>
>>>> Datum:   17.05.2013 23:18
>>>> Betreff: Re: Ext4: Slow performance on first write after mount
>>>> 
>>>>> Hi Frank,
>>>>> 
>>>>> Consider using bigalloc feature (requires reformat), preallocate space
>>>>> with fallocate and use O_DIRECT for reads/writes. However, 188k writes
>>>>> are too small for good throughput with O_DIRECT. You might also want
>> to
>>>>> adjust max_sectors_kb to something larger than 512k.
>>>>> 
>>>>> We're doing 6in+6out 20Mbps streams just fine.
>>>>> 
>>>>> Regards,
>>>>> Andrei.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4"
>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
