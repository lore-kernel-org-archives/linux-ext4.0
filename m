From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCHSET v2] ext4: removal of alloc_sem locks from block
 allocation paths
Date: Tue, 10 May 2011 20:43:44 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105102035190.4184@dhcp-27-109.brq.redhat.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1105101543570.17175@dhcp-27-109.brq.redhat.com> <BANLkTimuBxQCQa3437ZzB0ynAmuWhTduLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-990637653-1305053028=:4184"
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1EJSn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 14:43:57 -0400
In-Reply-To: <BANLkTimuBxQCQa3437ZzB0ynAmuWhTduLQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-990637653-1305053028=:4184
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 10 May 2011, Amir G. wrote:

> On Tue, May 10, 2011 at 4:48 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Thu, 24 Mar 2011, amir73il@users.sourceforge.net wrote:
> >
> >> The purpose of this patch set is the removal of grp->alloc_sem locks
> >> from block allocation paths.
> >>
> >> The resulting code is cleaner and should perform better in concurrent
> >> allocating tasks workloads.
> > Hi Amir,
> >
> > Do you have any performance numbers indicating performance improvement
> > in concurrent allocations ? The only point where I can see taking
> > write semaphore is in filesystem resize code. Or am I missing something ?
> 
> Yes, you are. down_write is also taken when initializing a block group
> buddy cache for the first time (NEED_INIT flag is set).
> Anyway, I do NOT have any performance number since this wasn't the purpose of
> this work. This work was done for snapshots, but I do think that as I wrote:
> 1. The resulting code is cleaner
> 2. Getting rid of an unneeded semaphore in allocation path can only do good
> to performance, but I certainly don't have the kind of high scalability testing
> setup to show the performance improvements if there are any.

Well everyone who wants to use that group has to wait for this
initialization anyway, right ?

Of course I know that the purpose of this was to ease your snapshot
work, but I do not see that stated anywhere in the description ;).
Anyway I was just curious what impact does this have on the
performance since you've mentioned that, if you do not have any I am ok
with that.

Btw, patches looks good to me, but I have not done _very_ deep review.

Thanks!
-Lukas

> 
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> I ran several xfstests runs with these patches (4K and 1K block size).
> >> I tried several online resizes and verifyed that both in-core and on-disk
> >> group counters are correct.
> >>
> >> v2->v1:
> >> - fix silly bug in patch 4/5 that triggers BUG_ON(incore == NULL)
> >> - replace get_undo_access() with get_write_access()
> >> - ran xfstests with block size 1K (where 2 groups share a buddy page)
> >>
> >> [PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
> >> [PATCH v2 2/5] ext4: implement ext4_add_groupblocks() by freeing blocks
> >> [PATCH v2 3/5] ext4: synchronize ext4_mb_init_group() with buddy page lock
> >> [PATCH v2 4/5] ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
> >> [PATCH v2 5/5] ext4: remove alloc_semp
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > --
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-990637653-1305053028=:4184--
