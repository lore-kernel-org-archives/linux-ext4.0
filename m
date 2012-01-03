From: Sushil Mantri <sushilmantri@gmail.com>
Subject: Re: A stackable filesystem to trace low level filesystem operations
Date: Tue, 3 Jan 2012 16:50:57 -0500
Message-ID: <CAFFtA87zc0-puJG2uxy7fUN7gkTLXiV3RJtZYsTeMPf_joTrZQ@mail.gmail.com>
References: <CAFFtA8429YabMVLp-f15GXBknK+W2oMpqYkZT42zLFaSJ-RBVA@mail.gmail.com>
	<CAGpXXZLvwKJOHt2gR24OpyiYZN+Wrev8Pei13OuAVHQA_pF6-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34168 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 16:50:58 -0500
In-Reply-To: <CAGpXXZLvwKJOHt2gR24OpyiYZN+Wrev8Pei13OuAVHQA_pF6-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please read the following:

On Tue, Jan 3, 2012 at 4:45 PM, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> On Tue, Jan 3, 2012 at 4:20 PM, Sushil Mantri <sushilmantri@gmail.com> wrote:
>> Hi All,
>>
>> Sorry but this isn't a ext4 specific question but a general filesystem question.
>>
>> I am looking for a way to track filesystem level operation like
>> operation(read/write), filename, offset, size of read/write, pid of
>> the requesting process. The goal of my project is to collect such
>> traces and understand access usage of directories and more. I would
>> like to filter other operation like open,close, etc and requests to
>> procfs, etc. There was a stackable file system earlier called Tracefs.
>> It isn't supported anymore though. The original paper can be found
>> here: filesystems.org/docs/tracefs-fast04/tracefs.ps
>>
>> Can you please suggest me what is the best option i have. I am
>> currently looking at SystemTap.
>>
>> Thanks,
>> Sushil
>
> I think you're looking for either inotify or fanotify.
This will only notify me when an event occurs,but is doesn't provide
tracing information. Further i think it will be very slow if i have to
trace the whol filesystem
>
> You might have better luck asking in the vfs mailinglist.
>
> (linux-fsdevel@vger.kernel.org)
>
> Greg
