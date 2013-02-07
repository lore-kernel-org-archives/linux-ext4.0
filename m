From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: How can I flush all writes before yanking the power cable?
Date: Thu, 7 Feb 2013 14:37:02 -0500
Message-ID: <CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
References: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com>
	<5113EE8F.2080104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:61866 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759051Ab3BGThE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 14:37:04 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so2374483lbb.40
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 11:37:02 -0800 (PST)
In-Reply-To: <5113EE8F.2080104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 7, 2013 at 1:12 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/7/13 10:43 AM, Autif Khan wrote:
>> The standard operating procedure to power down my machine is to switch
>> it off. To work around this, we use mSATA SSDs (actually we recently
>> switched from SATA SSDs) with linux on a read only partition.
>
> Not sure the SSD part makes any significant difference, but the RO
> mount should.
>
>> This works just fine, however, we want to be able to upgrade some
>> parts of the application. To do this, we have put the application on
>> /app partition. We mount it read only at start up. When we want to
>> upgrade the app, we remount read-write sync (mount -o remount,rw,sync
>> /app) perform the write operations and remount read only.
>>
>> If we yank the power cable after this, we get file system errors on
>> the next reboot.
>
> What kind of errors? (and on what kernel?  Are you mounted with
> barriers enabled?)

Filesystem check errors that the OS throws at you on an unclean
shutdown. Where it asks you to 'F'ix, 'S'kip, 'Ignore or 'M'anually
fix the error using fsck. The kernel is a custom kernel for our
hardware.

> If you use barriers, remount RO, that completes, you yank the power,
> and you see corruption, I would guess one of a few things is happening:
>
> 1) You're not mounting w/ barriers, and you lose data in the SSD's cache

That was precisely my ignorance. I did not know about barrier. Adding
it during mount ro and remount rw seems to have fixed these issues.

Thanks you very much for all your help.

Autif

> 2) You *are* mounting w/ barriers, and the SSD is lying to you
> 3) There's a bug in our remount,ro path which doesn't quiesce things properly
>
> mount -o remount,ro should be >this< close to an unmount; things should
> be stable on disk when it's done.
>
> -Eric
>
>> We can display a message to the user telling them that it is safe to
>> power down the machine.
>>
>> My question is
>>
>> 1) Is this the right place to discuss this or should I have posted
>> this in the file systems mailing list?
>>
>> 2) how can we determine that all the writes are flushed? (and this it
>> is safe to yank the power cable)
>>
>> 3) is there a better way to do this? - for example we may not have to
>> remount read write sync - and we can force a sync before remounting
>> read only or something
>>
>> I have already tried "sudo sync" before remounting the filesystem as
>> read only. It does not help.
>>
>> Please advise.
>>
>> Thanks
>>
>> Autif
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
