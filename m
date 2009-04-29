From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Question on block group allocation
Date: Wed, 29 Apr 2009 13:21:09 -0700
Message-ID: <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
	 <20090423190817.GN3209@webber.adilger.int>
	 <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com>
	 <20090427021411.GA9059@mit.edu>
	 <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com>
	 <20090427224052.GC22104@mit.edu> <20090429191646.GF14264@mit.edu>
	 <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com>
	 <20090429193744.GA17797@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:20458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbZD2UVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 16:21:17 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n3TKLB4o007487
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 13:21:12 -0700
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by zps75.corp.google.com with ESMTP id n3TKKvWa020202
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 13:21:10 -0700
Received: by qw-out-1920.google.com with SMTP id 5so1047435qwc.26
        for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 13:21:10 -0700 (PDT)
In-Reply-To: <20090429193744.GA17797@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Wed, Apr 29, 2009 at 12:37 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Apr 29, 2009 at 03:16:47PM -0400, Theodore Tso wrote:
>>
>> When you have a chance, can you send out the details from your test =
run?
>>
>
> Oops, sorry, our two e-mails overlapped. =A0Sorry, I didn't see your =
new
> e-mail when I sent my ping-o-gram.
>
> On Wed, Apr 29, 2009 at 11:38:49AM -0700, Curt Wohlgemuth wrote:
>>
>> Okay, my phrasing was not as precise as it could have been. =A0What =
I
>> meant by "total fragmentation" was simply that the range of physical
>> blocks for the 10GB file was much lower with Andreas' patch:
>>
>> Before patch: =A08282112 - 103266303
>> After patch: 271360 - 5074943
>>
>> The number of extents is much larger. =A0See the attached debugfs ou=
tput.
>
> Ah, OK. =A0You didn't attach the "e2fsck -E fragcheck" output, but I'=
m
> going to guess that the blocks for 10g, 4g, and 4g-2 ended up getting
> interleaved, possibly because they were written in parallel, and not
> one after each other? =A0Each of the extents in the "after" debugfs w=
ere
> proximately 2k blocks (8 megabytes) in length, and are separated by a
> largish cnumber of blocks.

Hmm, I thought I attached the output from "e2fsck -E fragcheck"; yes,
I did: one simple line:

        /dev/hdm3: clean, 14/45760512 files, 7608255/183010471 blocks

And actually, I created the files sequentially:

dd if=3D/dev/zero of=3D$MNT_PT/4g bs=3D1G count=3D4
dd if=3D/dev/zero of=3D$MNT_PT/4g-2 bs=3D1G count=3D4
dd if=3D/dev/zero of=3D$MNT_PT/10g bs=3D1G count=3D10

> Now, if my theory that the files were written in an interleaved
> fashion is correct, if it is also true that they will be read in an
> interleaved pattern, the layout on disk might actually be the best
> one. =A0If however they are going to be read sequentially, and you
> really want them to be allocated contiguously, then if you know what
> the final size of these files will be, then the probably the best
> thing to do is to use the fallocate system call.
>
> Does that make sense?

Sure, in this sense.

The test in question does something like this:

1. Create 20 or so large files, sequentially.
2. Randomly choose a file.
3. Randomly choose an offset in this file.
4. Read from that file/offset a fixed buffer size (say 256k); the file
was opened with O_DIRECT
5. Go back to #2
6. Stop after some time period

This might not be the most realistic workload we want (the test
actually can be run by doing #1 above with multiple threads), but it's
certainly interesting.

The point that I'm interested in is why the physical block spread is
so different for the 10GB file between (a) the above 'dd' command
sequence; and (b) simply creating the "10g" file alone, without
creating the 4GB files first.

I just did (b) above on a kernel without Andreas' patch, on a freshly
formatted ext4 FS, and here's (most of) the debugfs output for it:

BLOCKS:
(IND):164865, (0-63487):34816-98303, (63488-126975):100352-163839, (126=
976-19046
3):165888-229375, (190464-253951):231424-294911, (253952-481279):296960=
-524287,
(481280-544767):821248-884735, (544768-706559):886784-1048575, (706560-=
1196031):
1607680-2097151, (1196032-1453067):2656256-2913291
TOTAL: 1453069

The total spread of the blocks is tiny compared to the total spread
from the 3 "dd" commands above.

I haven't yet really looked at the block allocation results using
Andreas' patch, except for the "10g" file after the three "dd"
commands above.  So I'm not sure what the effects are with, say,
larger numbers of files.  I'll be doing some more experimentation
soon.

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
