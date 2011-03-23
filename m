From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: ext4: removal of alloc_sem locks from block allocation paths
Date: Wed, 23 Mar 2011 23:04:22 +0200
Message-ID: <AANLkTi=Q4JCnP-5GDw8RYpCmqbRHxWHVXgn_7gXxGh+b@mail.gmail.com>
References: <1300656770-14994-1-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57957 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1CWVEX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 17:04:23 -0400
Received: by qwk3 with SMTP id 3so6247764qwk.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 14:04:22 -0700 (PDT)
In-Reply-To: <1300656770-14994-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I have been running some more tests, including 1K, with no problems observed
and Yongqiang has also reviewed the patches.

Is there any chance to merge these patches in current merge window?

Thanks,
Amir.

On Sun, Mar 20, 2011 at 11:32 PM,  <amir73il@users.sourceforge.net> wrote:
> The purpose of this patch set is the removal of grp->alloc_sem locks
> from block allocation paths.
>
> This resulting code is cleaner and should perform better in concurrent
> allocating tasks workloads.
>
> I ran several xfstests runs with these patches (4K block only).
> I tried several online resizes and verifyed that both in-core and on-disk
> group counters are correct.
>
> ext4: move ext4_add_groupblocks() to mballoc.c
> ext4: implement ext4_add_groupblocks() by freeing blocks
> ext4: synchronize ext4_mb_init_group() with buddy page lock
> ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
> ext4: remove alloc_semp
>
