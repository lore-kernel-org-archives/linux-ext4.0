From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Fri, 28 Aug 2015 10:56:44 +0300
Message-ID: <CAETWcfuDjBC+qgd30v3f9_tGYn1HjBCB00gdFnaTmzt_5GAV3A@mail.gmail.com>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35677 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbH1H5Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2015 03:57:24 -0400
Received: by obbwr7 with SMTP id wr7so36529409obb.2
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2015 00:57:23 -0700 (PDT)
In-Reply-To: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

A brief story of problem.

- hardware raid6 became partially degraded because one of disks failed
(slot0 - mention it) as controller said
- provider was asked to replace the failed drive (hot-swap)
- while it was performing the task, the 2nd disk (slot4) has failed
and raid became degraded (fully)
- so provider was asked to replace 2nd disk too
- I don't know what exactly happened (and how) but they replace disk
in slot4 with disk from slot0 (see below - it's really looks like
this) and inserted new disk into slot0
- system not booted due to 'no partitions' found (gpt)
- I booted from rescue disk and found the cool thing:

1st LBA sector (GPT master sector) of LD0 (there was only one logical
disk configured on controller) moved 1MB from start of logical disk.
Paying attention that the strip size is 256K - this looks logical. In
fact, controller holds raid metadata info on drives so the order which
they are inserted into slots should not be a difference.I had
experience with LSI controllers and it was so all the time. But this
time it failed to recognize that disk was simply moved from one slot
to another (may be due to the fact it has marked disk as failed - but
suddenly it returned to life). I don't know if there's a bug in
firmware or something else happened but when disk was placed back into
original slot0 (keeping slot4 open) - GPT partition map has returned.

But ... It seems that automatic rebuild had been started since first
disk's replacement. And did its job.

So I have partially broken ext4 that wish to fix.

P.S. Raid hardware (performed by controller) rebuild process has been
completed without errors.

Regards,
Alexander

On Tue, Aug 25, 2015 at 6:30 PM, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi,
>
> Recently I had to run fsck on 47TB ext4 partition backed by hardware
> RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
> is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
> 100% of single CPU. It detected errors (and fixed them) but doesn't
> finish yet.
>
> Rescue disc is based on Debian 7.8.
> kernel: 4.1.4-5
> e2fsprogs: 1.42.5-1.1+deb7u1
>
> Any suggestions?
>
> Regards,
> Alexander Afonyashin
