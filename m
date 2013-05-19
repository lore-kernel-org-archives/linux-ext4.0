From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Aw: Re: Ext4: Slow performance on first write after mount
Date: Sat, 18 May 2013 19:49:03 -0600
Message-ID: <BDA7A734-1326-4977-8068-FCEF1CF84CC1@dilger.ca>
References: <1323812284.643758.1368874202987.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58581 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3ESBtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 May 2013 21:49:06 -0400
Received: by mail-pd0-f180.google.com with SMTP id 10so3323756pdc.11
        for <linux-ext4@vger.kernel.org>; Sat, 18 May 2013 18:49:05 -0700 (PDT)
In-Reply-To: <1323812284.643758.1368874202987.JavaMail.ngmail@webmail11.arcor-online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-05-18, at 4:50, frankcmoeller@arcor.de wrote:
> thanks for your quick answer!
> Perhaps you understood me wrong. The general write performance is quite good. We can record more than 4 HD channels at the same time without problems. Except the problems with the first write after mount. And there are also some users which have problems 1-2 times during a recording.
> I think the ext4 group initialization is the main problem, because it takes so long (as written before: around 1300 groups per second). Why don't you store the gathered informations on disk when a umount takes place?

Part of the problem is that filesystems are rarely unmounted cleanly, so it means that this information would need to be updated periodically to disk so that it is available after a crash.

I wouldn't object to some kind of "lazy" updating of group information on disk that at least gives the newly-mounted filesystem a rough idea of what each group's usage is. It wouldn't have to be totally accurate (it wouldn't replace the bitmaps), but maybe 2 bits per group would be enough as a starting point?

For a 32 TB filesystem that would be about 16 4kB blocks of bits that would be updated periodically (e.g. every five minutes or so). Since the allocator will typically work in successive groups that might not cause too much churn. 

> With fallocate the group initialization is partly made before first write. This helps, but it's no solution, because the finally file size is unknown.

It would be possible to fallocate() at some expected size (e.g. average file size) and then either truncate off the unused space, or fallocate() some more in another thread when you are close to tunning out. 

> So I cannot preallocate space for the complete file. And after the preallocated space is consumed the same problem with the initialization arises until all groups are initialized.

If the fallocate() is done in a separate thread the latency can be hidden from the main application?
> 
> I also made some tests with O_DIRECT (my first tests ever). Perhaps I did something wrong, but it isn't very fast.

That is true, and depends heavily on your workload. 

Cheers, Andreas 

> And you have to take care about alignment and there are several threads in the internet which explain why you shouldn't use it (or only in very special situations and I don't think that my situation is one of them). And ext4 group initialization takes also place when using O_DIRECT (as said before perhaps I did something wrong).
> 
> Regards,
> Frank
> 
> ----- Original Nachricht ----
> Von:     "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
> An:      "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>, ext4 development <linux-ext4@vger.kernel.org>
> Datum:   17.05.2013 23:18
> Betreff: Re: Ext4: Slow performance on first write after mount
> 
>> Hi Frank,
>> 
>> Consider using bigalloc feature (requires reformat), preallocate space
>> with fallocate and use O_DIRECT for reads/writes. However, 188k writes
>> are too small for good throughput with O_DIRECT. You might also want to
>> adjust max_sectors_kb to something larger than 512k.
>> 
>> We're doing 6in+6out 20Mbps streams just fine.
>> 
>> Regards,
>> Andrei.
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
