From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCHSET v2] ext4: removal of alloc_sem locks from block
 allocation paths
Date: Tue, 10 May 2011 21:58:26 +0300
Message-ID: <BANLkTimT2uEig3UmEQGev3s73cjCUNNDFg@mail.gmail.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1105101543570.17175@dhcp-27-109.brq.redhat.com>
	<BANLkTimuBxQCQa3437ZzB0ynAmuWhTduLQ@mail.gmail.com>
	<alpine.LFD.2.00.1105102035190.4184@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37867 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1EJS61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 14:58:27 -0400
Received: by vws1 with SMTP id 1so745754vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 11:58:27 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1105102035190.4184@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 9:43 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Tue, 10 May 2011, Amir G. wrote:
>
>> On Tue, May 10, 2011 at 4:48 PM, Lukas Czerner <lczerner@redhat.com>=
 wrote:
>> > On Thu, 24 Mar 2011, amir73il@users.sourceforge.net wrote:
>> >
>> >> The purpose of this patch set is the removal of grp->alloc_sem lo=
cks
>> >> from block allocation paths.
>> >>
>> >> The resulting code is cleaner and should perform better in concur=
rent
>> >> allocating tasks workloads.
>> > Hi Amir,
>> >
>> > Do you have any performance numbers indicating performance improve=
ment
>> > in concurrent allocations ? The only point where I can see taking
>> > write semaphore is in filesystem resize code. Or am I missing some=
thing ?
>>
>> Yes, you are. down_write is also taken when initializing a block gro=
up
>> buddy cache for the first time (NEED_INIT flag is set).
>> Anyway, I do NOT have any performance number since this wasn't the p=
urpose of
>> this work. This work was done for snapshots, but I do think that as =
I wrote:
>> 1. The resulting code is cleaner
>> 2. Getting rid of an unneeded semaphore in allocation path can only =
do good
>> to performance, but I certainly don't have the kind of high scalabil=
ity testing
>> setup to show the performance improvements if there are any.
>
> Well everyone who wants to use that group has to wait for this
> initialization anyway, right ?

Definitely right, but...
All the users that allocate blocks in any group, whether initialized or=
 not,
needed to take the read side of the semaphore.
That was totally unneeded, especially with the common case of
blocksize=3D=3Dpagesize.
Now I don't know the overhead of taking down_read, but I am sure there =
is some
overhead, which I will not be able to demonstrate on my system.

>
> Of course I know that the purpose of this was to ease your snapshot
> work, but I do not see that stated anywhere in the description ;).

As a matter of fact, I had a much smaller patch which bypassed taking t=
he
semaphore when blocksize=3D=3Dpagesize.
Since snapshots only work with  blocksize=3D=3Dpagesize, that was enoug=
h for me,
but Ted has requested that I look into getting rid of alloc_semp
altogether, so I did :-)

> Anyway I was just curious what impact does this have on the
> performance since you've mentioned that, if you do not have any I am =
ok
> with that.
>
> Btw, patches looks good to me, but I have not done _very_ deep review=
=2E
>
> Thanks!
> -Lukas
>
>>
>> >
>> > Thanks!
>> > -Lukas
>> >
>> >>
>> >> I ran several xfstests runs with these patches (4K and 1K block s=
ize).
>> >> I tried several online resizes and verifyed that both in-core and=
 on-disk
>> >> group counters are correct.
>> >>
>> >> v2->v1:
>> >> - fix silly bug in patch 4/5 that triggers BUG_ON(incore =3D=3D N=
ULL)
>> >> - replace get_undo_access() with get_write_access()
>> >> - ran xfstests with block size 1K (where 2 groups share a buddy p=
age)
>> >>
>> >> [PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
>> >> [PATCH v2 2/5] ext4: implement ext4_add_groupblocks() by freeing =
blocks
>> >> [PATCH v2 3/5] ext4: synchronize ext4_mb_init_group() with buddy =
page lock
>> >> [PATCH v2 4/5] ext4: teach ext4_mb_init_cache() to skip uptodate =
buddy caches
>> >> [PATCH v2 5/5] ext4: remove alloc_semp
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >>
>> >
>> > --
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
