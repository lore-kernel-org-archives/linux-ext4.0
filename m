From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Tue, 18 Jul 2017 21:06:57 -0500
Message-ID: <7c7a251e-efa3-d46b-8320-61a7eb14b5e2@redhat.com>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
 <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbdGSCG7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 22:06:59 -0400
In-Reply-To: <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/18/2017 05:28 PM, Andreas Dilger wrote:
> On Jul 18, 2017, at 3:10 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>
>> Time & mount-count based checks have been off by default for quite some
>> time now, but the dire warning about disabling them remains in the
>> tune2fs manpage, which is confusing.  We did "strongly consider
>> the consequences" and disabled it by default, no need to scare the
>> user about it now.
> 
> Sigh, I still think this is going in the wrong direction.

Well, the upstream defaults have been not-check for /years/ now,
this just makes the docs match reality.

> I'm happily
> running a weekly e2fsck on a snapshot of the filesystem, and then reset
> the time and mount-count fields in the superblock with tune2fs.  That
> way I never see any warnings, or have slow boots because of a scan, but
> I'm also notified if there are ever problems on the filesystem (which
> happens occasionally, since I'm sometimes running experimental code).
*nod* it's a nice mechanism.

> Since virtually everyone is using MD/LVM devices these days, I don't
> think that is hard to do.  I offered up my "lvcheck" script a few times,
> but nobody at RH or on the DM team seemed interested at the time...

No, I think it's great.  It needs to go into some package, somewhere,
and not just float around on the internet ... e2sfprogs comes to mind.
or util-linux, or lvm-tools, or whatever... ;)  Send a proper patch to
the appropriate package maintainer, and it'll get into fedora and every
other distro.

> I'd also be happy if there was some other similar mechanism included with
> the distro to do periodic background checks of the filesystem, rather
> than letting them find any problem at some random time.  This is pretty
> standard for RAID systems, I think it makes sense for the filesystem too.

well, tbh "every 27th boot" was pretty random, too, in practice.  ;)

Ok, I see ted pointed out e2croncheck, too - and yes, actually installing
it and dropping someting in cron.d would complete the circle, to get it
out of the some-assembly-required mode.

-Eric

> Cheers, Andreas
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
>> index 5c885f9..a8cacc7 100644
>> --- a/misc/tune2fs.8.in
>> +++ b/misc/tune2fs.8.in
>> @@ -134,17 +134,6 @@ Staggering the mount-counts at which filesystems are forcibly
>> checked will avoid all filesystems being checked at one time
>> when using journaled filesystems.
>> .sp
>> -You should strongly consider the consequences of disabling
>> -mount-count-dependent checking entirely.  Bad disk drives, cables,
>> -memory, and kernel bugs could all corrupt a filesystem without
>> -marking the filesystem dirty or in error.  If you are using
>> -journaling on your filesystem, your filesystem will
>> -.B never
>> -be marked dirty, so it will not normally be checked.  A
>> -filesystem error detected by the kernel will still force
>> -an fsck on the next reboot, but it may already be too late
>> -to prevent data loss at that point.
>> -.sp
>> See also the
>> .B \-i
>> option for time-dependent checking.
>>
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
