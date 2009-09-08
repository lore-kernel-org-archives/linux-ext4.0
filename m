From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Odd "leak" of extent info into data blocks?
Date: Tue, 8 Sep 2009 11:21:11 -0700
Message-ID: <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com>
References: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com>
	 <20090908175605.GB7801@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:51817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZIHSVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 14:21:13 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n88ILFS4002185
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 11:21:15 -0700
Received: from pxi40 (pxi40.prod.google.com [10.243.27.40])
	by zps19.corp.google.com with ESMTP id n88ILC9j031279
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 11:21:12 -0700
Received: by pxi40 with SMTP id 40so3522504pxi.5
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2009 11:21:12 -0700 (PDT)
In-Reply-To: <20090908175605.GB7801@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Valerie:

On Tue, Sep 8, 2009 at 10:56 AM, Valerie Aurora<vaurora@redhat.com> wro=
te:
> Hey, did you figure this out? =A0If not, I want to have a bug open
> somewhere.

Yes, sorry.  I was going to post a patch for this, but have been
waiting to verify that it really fixes the issue.  And see the thread
started by Frank Mayhar about fsync issues as well...

The problem is a race, between the last write to a to-be-freed
metadata block (to update the extent header) and the block being
marked free in the on-disk/buddy bitmaps.  Note that this only happens
without a journal, since *with* a journal the ordering is done
correctly.

Without a journal, the block buffer_head is written to, the
buffer_head is marked dirty, and the bitmaps are updated via
ext4_free_blocks().  In rare cases, the block is re-allocated for
another inode and written to -- subsequently, the writeback mechanism
will then flush the dirty extent header back to disk.  That's why it
looks like "leaked extent data" in the data block.

I'm discussing with Frank whether we should handle this in
ext4_handle_dirty_metadata(), as per Ted's suggestion, or in separate
one-off patches, or what.

Thanks,
Curt

>
> Thanks,
>
> -VAL
>
> On Sat, Aug 22, 2009 at 04:10:56PM -0700, Curt Wohlgemuth wrote:
>> On the off chance that this sounds familiar to anyone out there...
>>
>> I've got a situation in which data files written by an application a=
re
>> showing very occasional checksum errors sometimes. =A0The data files=
 are
>> all around 8MB long, written using O_DIRECT into fallocated space.
>> (The entire fallocated space for the example file below is written t=
o
>> with valid data; i.e., no holes, no truncation, no uninitialized
>> extents.)
>>
>> When these occasional checksum failures show up, the data in the fil=
es
>> is rather odd. =A0I've seen 4 cases of this so far, and the "bad" da=
ta
>> always starts on a block boundary, and always has the first 12 bytes
>> that are identical to what an extent header would look like (for a
>> header at the start of a block of extents or extent indexes):
>>
>> Here's the "od -Ad -x" output from one such file:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A08388608 f30a 0000 0154 0000 0000 0000 000=
0 0000
>>
>> (I.e., the first 2 bytes are EXT4_EXT_MAGIC, and bytes 4-5 are 0x154=
,
>> or what eh_max would be for a block size of 4096 bytes.)
>>
>> In this case, the "bad" data starts at block 2048. =A0Two cases have
>> this pattern at block 2048; two at block 2050. =A0A syscall trace of=
 one
>> such corrupted file shows that this block was written with a single
>> write encompassing many adjacent blocks:
>>
>> =A0 =A0 =A0 =A0 =A0write(fd=3D10, size=3D192512, offset=3D8204288)
>>
>> The file in question above has only two (in-inode) extents, which I
>> verified look valid. =A0The block in question (2048) above is covere=
d by
>> the second extent: =A0logical blocks 2037-2050.
>>
>> I've seen the amount of "bad" data (including the "extent header"
>> above) to be pretty variable: between 70 and 800 bytes; I haven't be=
en
>> able to correlate the rest of the bad data to any particular ext4 da=
ta
>> structures.
>>
>> My guess is that a block of extents from a truncated or removed file
>> was reused for data for this file, and somehow was not written
>> correctly. =A0This seems (slightly) more plausible to me than the ex=
tent
>> metadata of an existing file was "leaked" into this one.
>>
>> Does any of this ring a bell to anybody?
>>
>> Thanks,
>> Curt
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
