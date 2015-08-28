From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Fri, 28 Aug 2015 10:44:37 -0600
Message-ID: <74941AF5-DEEA-47CB-8EAC-9265F03CAEE0@dilger.ca>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com> <CAETWcfuDjBC+qgd30v3f9_tGYn1HjBCB00gdFnaTmzt_5GAV3A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35491 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbH1Qof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2015 12:44:35 -0400
Received: by pacdd16 with SMTP id dd16so67855071pac.2
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2015 09:44:35 -0700 (PDT)
In-Reply-To: <CAETWcfuDjBC+qgd30v3f9_tGYn1HjBCB00gdFnaTmzt_5GAV3A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 28, 2015, at 1:56 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
> 
> Hi,
> 
> A brief story of problem.
> 
> - hardware raid6 became partially degraded because one of disks failed
> (slot0 - mention it) as controller said
> - provider was asked to replace the failed drive (hot-swap)
> - while it was performing the task, the 2nd disk (slot4) has failed
> and raid became degraded (fully)
> - so provider was asked to replace 2nd disk too
> - I don't know what exactly happened (and how) but they replace disk
> in slot4 with disk from slot0 (see below - it's really looks like
> this) and inserted new disk into slot0

I would suspect that the slot0 disk started to be overwritten by
the RAID rebuild while it was installed in slot4?  It seems like
there is likely "confusing" corruption such as valid inode blocks
written to the wrong offset rather than just "random" corruption.

> - system not booted due to 'no partitions' found (gpt)
> - I booted from rescue disk and found the cool thing:
> 
> 1st LBA sector (GPT master sector) of LD0 (there was only one logical
> disk configured on controller) moved 1MB from start of logical disk.
> Paying attention that the strip size is 256K - this looks logical. In
> fact, controller holds raid metadata info on drives so the order which
> they are inserted into slots should not be a difference.I had
> experience with LSI controllers and it was so all the time. But this
> time it failed to recognize that disk was simply moved from one slot
> to another (may be due to the fact it has marked disk as failed - but
> suddenly it returned to life). I don't know if there's a bug in
> firmware or something else happened but when disk was placed back into
> original slot0 (keeping slot4 open) - GPT partition map has returned.
> 
> But ... It seems that automatic rebuild had been started since first
> disk's replacement. And did its job.
> 
> So I have partially broken ext4 that wish to fix.
> 
> P.S. Raid hardware (performed by controller) rebuild process has been
> completed without errors.

In my experience, just because the RAID rebuild doesn't report
any errors, doesn't mean that it didn't write random corruption
across the disk.  Depending on how badly the filesystem is corrupted,
you might be able to recover some data, or you might have corruption
every 8th or 10th block in your filesystem.

Running e2fsck in such a case will make the metadata "valid" but it
will not make the data correct.

Definitely, if you have a filesystem over 16TB you should be running
e2fsprogs-1.42.13 to get the latest fixes.

Cheers, Andreas
> 
> Regards,
> Alexander
> 
> On Tue, Aug 25, 2015 at 6:30 PM, Alexander Afonyashin
> <a.afonyashin@madnet-team.ru> wrote:
>> Hi,
>> 
>> Recently I had to run fsck on 47TB ext4 partition backed by hardware
>> RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
>> is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
>> 100% of single CPU. It detected errors (and fixed them) but doesn't
>> finish yet.
>> 
>> Rescue disc is based on Debian 7.8.
>> kernel: 4.1.4-5
>> e2fsprogs: 1.42.5-1.1+deb7u1
>> 
>> Any suggestions?
>> 
>> Regards,
>> Alexander Afonyashin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





