From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCHSET v2] ext4: removal of alloc_sem locks from block
 allocation paths
Date: Tue, 10 May 2011 21:30:16 +0300
Message-ID: <BANLkTimuBxQCQa3437ZzB0ynAmuWhTduLQ@mail.gmail.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1105101543570.17175@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63794 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1EJSaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 14:30:17 -0400
Received: by vxi39 with SMTP id 39so6906454vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 11:30:16 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1105101543570.17175@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 4:48 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Thu, 24 Mar 2011, amir73il@users.sourceforge.net wrote:
>
>> The purpose of this patch set is the removal of grp->alloc_sem locks
>> from block allocation paths.
>>
>> The resulting code is cleaner and should perform better in concurren=
t
>> allocating tasks workloads.
> Hi Amir,
>
> Do you have any performance numbers indicating performance improvemen=
t
> in concurrent allocations ? The only point where I can see taking
> write semaphore is in filesystem resize code. Or am I missing somethi=
ng ?

Yes, you are. down_write is also taken when initializing a block group
buddy cache for the first time (NEED_INIT flag is set).
Anyway, I do NOT have any performance number since this wasn't the purp=
ose of
this work. This work was done for snapshots, but I do think that as I w=
rote:
1. The resulting code is cleaner
2. Getting rid of an unneeded semaphore in allocation path can only do =
good
to performance, but I certainly don't have the kind of high scalability=
 testing
setup to show the performance improvements if there are any.

>
> Thanks!
> -Lukas
>
>>
>> I ran several xfstests runs with these patches (4K and 1K block size=
).
>> I tried several online resizes and verifyed that both in-core and on=
-disk
>> group counters are correct.
>>
>> v2->v1:
>> - fix silly bug in patch 4/5 that triggers BUG_ON(incore =3D=3D NULL=
)
>> - replace get_undo_access() with get_write_access()
>> - ran xfstests with block size 1K (where 2 groups share a buddy page=
)
>>
>> [PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
>> [PATCH v2 2/5] ext4: implement ext4_add_groupblocks() by freeing blo=
cks
>> [PATCH v2 3/5] ext4: synchronize ext4_mb_init_group() with buddy pag=
e lock
>> [PATCH v2 4/5] ext4: teach ext4_mb_init_cache() to skip uptodate bud=
dy caches
>> [PATCH v2 5/5] ext4: remove alloc_semp
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> --
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
