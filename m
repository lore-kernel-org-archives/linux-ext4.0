From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Question on block group allocation
Date: Sun, 26 Apr 2009 23:29:39 -0600
Message-ID: <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
	 <20090423190817.GN3209@webber.adilger.int>
	 <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com>
	 <20090427021411.GA9059@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:33996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZD0F3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 01:29:44 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id n3R5TgFI020438
	for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2009 22:29:43 -0700
Received: from qw-out-2122.google.com (qwd5.prod.google.com [10.241.193.197])
	by spaceape9.eur.corp.google.com with ESMTP id n3R5TeOn008974
	for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2009 22:29:41 -0700
Received: by qw-out-2122.google.com with SMTP id 5so1668228qwd.45
        for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2009 22:29:40 -0700 (PDT)
In-Reply-To: <20090427021411.GA9059@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

I don't have access to the actual data right now, because I created
the files and ran the benchmark just before leaving for a few days,
but...

On Sun, Apr 26, 2009 at 8:14 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Apr 23, 2009 at 03:02:05PM -0700, Curt Wohlgemuth wrote:
>> > This is likely the "uninit_bg" feature that is causing the allocat=
ions
>> > to skip groups which are marked BLOCK_UNINIT. =A0In some sense the=
 benefit
>> > of skipping the block bitmap read during e2fsck is probably not at=
 all
>> > beneficial compared to the cost of the extra seeking during IO. =A0=
As the
>> > filesystem gets more full, the BLOCK_UNIIT flags would be cleared =
anyways,
>> > so we might as well just keep the early allocations contiguous.
>
> Well, I tried out Andreas' patch, by doing an rsync copy from my SSD
> root partition to a 5400 rpm laptop drive, and then ran e2fsck and
> dumpe2fs. =A0The results were interesting:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Before Patch =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 After Patch
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Time in seconds =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Time in seconds
> =A0 =A0 =A0 =A0 =A0 =A0Real / =A0User/ =A0Sys =A0 MB/s =A0 =A0 =A0Rea=
l / =A0User/ =A0Sys =A0 =A0MB/s
> Pass 1 =A0 =A0 =A08.52 / 2.21 / 0.46 =A020.43 =A0 =A0 =A08.84 / 4.97 =
/ 1.11 =A0 19.68
> Pass 2 =A0 =A0 21.16 / 1.02 / 1.86 =A011.30 =A0 =A0 =A06.54 / 1.77 / =
1.78 =A0 36.39
> Pass 3 =A0 =A0 =A00.01 / 0.00 / 0.00 139.00 =A0 =A0 =A00.01 / 0.01 / =
0.00 =A0128.90
> Pass 4 =A0 =A0 =A00.16 / 0.15 / 0.00 =A0 0.00 =A0 =A0 =A00.17 / 0.17 =
/ 0.00 =A0 =A00.00
> Pass 5 =A0 =A0 =A02.52 / 1.99 / 0.09 =A0 0.79 =A0 =A0 =A02.31 / 1.78 =
/ 0.06 =A0 =A00.86
> Total =A0 =A0 =A032.40 / 5.11 / 2.49 =A012.81 =A0 =A0 17.99 / 8.75 / =
2.98 =A0 23.01
>
> The surprise is in the gross inspection of the dumpe2fs results:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Before Patch =
=A0 =A0After Patch
> # of non-contig files =A0 =A0 =A0 =A0 =A0 762 =A0 =A0 =A0 =A0 =A0 =A0=
 779
> # of non-contig directories =A0 =A0 571 =A0 =A0 =A0 =A0 =A0 =A0 570
> # of BLOCK_UNINIT bg's =A0 =A0 =A0 =A0 =A0307 =A0 =A0 =A0 =A0 =A0 =A0=
 293
> # of INODE_UNINIT bg's =A0 =A0 =A0 =A0 =A0503 =A0 =A0 =A0 =A0 =A0 =A0=
 503
>
> So the interesting thing is that the patch only "broke open" an
> additional 14 block groups (out of a 333 block groups in use when the
> filesystem was created with the unpatched kernel). =A0However, this
> allowed the pass 2 directory time to go *down* by over a factor of
> three (from 21.2 seconds with the unpatched ext4 code to 6.5 seconds
> with the the patch.
>
> I think what the patch did was to diminish allocation pressure on the
> first block group in the flex_bg, so we weren't mixing directory and
> regular file contents. =A0This eliminated seeks during pass 2 of e2fs=
ck,
> which was actually a Very Good Thing.
>
>> > A simple change to verify this would be something like the followi=
ng,
>> > but it hasn't actually been tested.
>>
>> Tell you what: =A0I'll try this out and see if it helps out my test =
case.
>
> Let me know what this does for your test case. =A0Hopefully the patch
> also makes things better, since this patch is looking very interestin=
g
> right now.

The random read throughput on the 10GB file went from ~16 MB/s to ~22
MB/s after Andreas' patch; the total fragmentation of the file was
much lower than before his patch.

However, the number of extents went up by quite a bit (I don't have
the debugfs output in front of me at the moment, sorry).  It seemed
that no extent crossed a block group; I didn't have time to see if
Andreas' patch disabled flex BGs or not, as to what was going on.

I'll be able to send details out on Tuesday.

Curt

>
> Andreas, can I get a Signed-off-by from you for this patch?
>
> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
