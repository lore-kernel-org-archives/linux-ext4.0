From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 18:12:39 +0300
Message-ID: <CADxRZqzQ+hnjVLkN+4L1u=k4iMOa_6j7UjGX-40F=uy9oUAppA@mail.gmail.com>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
 <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de> <20160830145810.rgms25xlnatnyxir@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:34292 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbcH3PMl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2016 11:12:41 -0400
Received: by mail-ua0-f196.google.com with SMTP id s91so1644555uas.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2016 08:12:40 -0700 (PDT)
In-Reply-To: <20160830145810.rgms25xlnatnyxir@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2016 at 5:58 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Aug 30, 2016 at 02:56:45PM +0200, John Paul Adrian Glaubitz wrote:
>> On 08/30/2016 02:42 PM, Anatoly Pugachev wrote:
>> > ../../e2fsck/recovery.c:866
>> > 866                             blocknr = ext2fs_be64_to_cpu(* ((__u64
>> > *) (bh->b_data+offset)));
>>
>> The reason is that this expression is casting "char * b_data" [1] into u64 [2]
>> which provokes unaligned access. Since such expression are often inevitable,
>> it's probably best to modify the conversion macros in bitops.h [3] to be
>> safe against unaligned accesses.
>
> I don't think that's it.  b_data is a 4k buffer should be 8 byte
> aligned.  For a file system with 64-bit blocks (which you presumably
> have since we're on the be64 path as shown in your debugger output)
> the offset is initially set to 16, and is incremented in chunks of 8
> bytes.  So there shouldn't be any unaligned access.
>
> Since you are able to provke this in a debugger, can you have gdb
> print out the value of bh->b_data and offset, so we can be sure what's
> going on?

(gdb) p bh->b_data
$1 = "\300;9\230\000\000\000\005\000\000\253\204\000\000\000\070\000\000\000\000\000\000$\022\000\000\000\000\000\000$<\000\000\000\000\000\000$\270\000\000\000\000\000\000$]\000\000\000\000\000\000$\024",
'\000' <repeats 967 times>
(gdb) p offset
$2 = 16
(gdb) p *bh->b_data
$3 = -64 '\300'
(gdb) p *(bh->b_data+offset)
$6 = 0 '\000'
