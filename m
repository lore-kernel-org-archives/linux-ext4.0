From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: ext4: removal of alloc_sem locks from block allocation paths
Date: Thu, 24 Mar 2011 07:19:46 +0200
Message-ID: <AANLkTikFPQHU78NLfurU1QgeBK07LZD_fEJR2zGyU8ZT@mail.gmail.com>
References: <1300656770-14994-1-git-send-email-amir73il@users.sourceforge.net>
	<AANLkTi=Q4JCnP-5GDw8RYpCmqbRHxWHVXgn_7gXxGh+b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44382 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1CXFTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2011 01:19:47 -0400
Received: by qwk3 with SMTP id 3so6423420qwk.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 22:19:46 -0700 (PDT)
In-Reply-To: <AANLkTi=Q4JCnP-5GDw8RYpCmqbRHxWHVXgn_7gXxGh+b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 23, 2011 at 11:04 PM, Amir G.
<amir73il@users.sourceforge.net> wrote:
> Hi Ted,
>
> I have been running some more tests, including 1K, with no problems o=
bserved

Take that back. My test setup was wrong.
xfstest 131 does hit a BUG in ext4_mb_init_cache() with 1K blocks.
I will post a fix when I have it.

> and Yongqiang has also reviewed the patches.
>
> Is there any chance to merge these patches in current merge window?
>
> Thanks,
> Amir.
>
> On Sun, Mar 20, 2011 at 11:32 PM, =A0<amir73il@users.sourceforge.net>=
 wrote:
>> The purpose of this patch set is the removal of grp->alloc_sem locks
>> from block allocation paths.
>>
>> This resulting code is cleaner and should perform better in concurre=
nt
>> allocating tasks workloads.
>>
>> I ran several xfstests runs with these patches (4K block only).
>> I tried several online resizes and verifyed that both in-core and on=
-disk
>> group counters are correct.
>>
>> ext4: move ext4_add_groupblocks() to mballoc.c
>> ext4: implement ext4_add_groupblocks() by freeing blocks
>> ext4: synchronize ext4_mb_init_group() with buddy page lock
>> ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
>> ext4: remove alloc_semp
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
