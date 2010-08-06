From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/3] Batched discard support
Date: Fri, 06 Aug 2010 19:02:04 +0400
Message-ID: <87d3tvrdhv.fsf@dmon-lap.sw.ru>
References: <1281094276-11377-1-git-send-email-lczerner@redhat.com>
	<87zkwzriwm.fsf@dmon-lap.sw.ru>
	<alpine.LFD.2.00.1008061539010.3645@localhost>
	<alpine.LFD.2.00.1008061624000.3645@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab0HFPCM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 11:02:12 -0400
Received: by ewy23 with SMTP id 23so2816371ewy.19
        for <linux-ext4@vger.kernel.org>; Fri, 06 Aug 2010 08:02:10 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1008061624000.3645@localhost> (Lukas Czerner's
	message of "Fri, 6 Aug 2010 16:32:13 +0200 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas Czerner <lczerner@redhat.com> writes:

> On Fri, 6 Aug 2010, Lukas Czerner wrote:
>
>> On Fri, 6 Aug 2010, Dmitry Monakhov wrote:
>> 
>> > Lukas Czerner <lczerner@redhat.com> writes:
>> > 
>> > > Hi, all
>> > >
>> > > because people were worried about possibly long stalls appearing
>> > > when FITRIM ioctl is working, I have changed the FITRIM interface
>> > > as Dimitry suggested. Now you can choose whether to trim whole
>> > > file system or just a part of it, resp. you can specify the range
>> > > of Bytes to trim.
>> > Agree with whole patch-set, except minor note for ext4'th path.
>> > Please feel free to add
>> > Reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org> to the series
>> > 
>> > The only thing what is still not obvious for me is that, there are
>> > several types of discard request possible
>> > 1) Simple discard 
>> > 2) Secure discard which was proposed here http://lkml.org/lkml/2010/6/24/71
>> > Should we specify which type should be used in ioctl flags?
>> > But i hope that we can just stick maximum security scenario
>> > Use secure discard if possible.
>> 
>> First of all, thanks for you review Dimitry. And second, to be honest I
>> am not entirely familiar with the Secure discard implementation. Right
>> now it just doing the simple discard like "send TRIM command", so it
>> does work just for devices which supports it. I suppose we can just
>> check blk_queue_discard() at some level and then decide whether to do
>> simple discard (TRIM), or secure discard "Write zeroes", when the device
>> does not support TRIM - if it is what you mean by secure discard.
>> 
>> Regards
>> -Lukas
>> 
>
> When I am thinking about this, it may not be a bad idea to create a
> completely new ioctl for this purpose of "zeroing all free space". We
> do the trimming for completely different reasons, and the "secure"
Actually you may be right here.
For example it is usual to give some one an usb stick, 
and always assumes what USB stick is WhatYouSeeIsWhatYouGet storage.
but this is obviously not true, a man now has full access to that
device, so  stale data is almost transparently available.
Off course i can use SECRM but it has runtime overhead.
So i can easily call SECDISCARD (even in emulation mode) before umount
in order to be on safe side and then share my USB stick without any
fears.

> thing is just an side effect, so we probably should not mix it together.
>
> The new ioclt (FISECER ?) and FITRIM can use the same infrastructure in
> ext3/4, but we should add a flag to distinguish what we need to do -
> TRIM or secure erase. What do you think ?
Or we can just add a behavior flags filed
DISCARD    :will works only for SDD and return ENOTSUPP for others
SECURE_DEL :will guarantee that data will be zeroed on success.

DISCARD ->    (simple discard) send discard requests
SECURE_DEL -> (simple emulation) write free space with zeroes
(DISCARD|SECURE_DEL) -> send discards request with secure flag enabled.
>
> Regards
> -lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
