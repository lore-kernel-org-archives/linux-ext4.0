From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: A stackable filesystem to trace low level filesystem operations
Date: Tue, 3 Jan 2012 17:53:12 -0500
Message-ID: <CAGpXXZJBvUg-VwDU9NLeTtdBNnXsDv8zpTYcCtdTitaChC9L7A@mail.gmail.com>
References: <CAFFtA8429YabMVLp-f15GXBknK+W2oMpqYkZT42zLFaSJ-RBVA@mail.gmail.com>
 <CAGpXXZLvwKJOHt2gR24OpyiYZN+Wrev8Pei13OuAVHQA_pF6-A@mail.gmail.com> <CAFFtA87zc0-puJG2uxy7fUN7gkTLXiV3RJtZYsTeMPf_joTrZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Sushil Mantri <sushilmantri@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51834 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab2ACWxo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 17:53:44 -0500
In-Reply-To: <CAFFtA87zc0-puJG2uxy7fUN7gkTLXiV3RJtZYsTeMPf_joTrZQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 3, 2012 at 4:50 PM, Sushil Mantri <sushilmantri@gmail.com> wrote:
> Please read the following:
>
> On Tue, Jan 3, 2012 at 4:45 PM, Greg Freemyer <greg.freemyer@gmail.com> wrote:
>> On Tue, Jan 3, 2012 at 4:20 PM, Sushil Mantri <sushilmantri@gmail.com> wrote:
>>> Hi All,
>>>
>>> Sorry but this isn't a ext4 specific question but a general filesystem question.
>>>
>>> I am looking for a way to track filesystem level operation like
>>> operation(read/write), filename, offset, size of read/write, pid of
>>> the requesting process. The goal of my project is to collect such
>>> traces and understand access usage of directories and more. I would
>>> like to filter other operation like open,close, etc and requests to
>>> procfs, etc. There was a stackable file system earlier called Tracefs.
>>> It isn't supported anymore though. The original paper can be found
>>> here: filesystems.org/docs/tracefs-fast04/tracefs.ps
>>>
>>> Can you please suggest me what is the best option i have. I am
>>> currently looking at SystemTap.
>>>
>>> Thanks,
>>> Sushil
>>
>> I think you're looking for either inotify or fanotify.
> This will only notify me when an event occurs,but is doesn't provide
> tracing information. Further i think it will be very slow if i have to
> trace the whol filesystem

inotify  and fanotify can both be set to work one file at a time I'm
pretty sure.

ie. You can register to be notified only for specific files and their actions.

There are kernel space hooks for them both I think that allow your
kernel code to be called upon an event.  So if you want to create a
basic kernel log tracing package it should be easy enough.  (It may be
you need to use the fsnotify API directly for that.)

I don't know if patches for that are floating around.  Again, you
should ask on fs-devel, not here.

Greg
