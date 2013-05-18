From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: Re: Aw: Re: Ext4: Slow performance on first write after mount
Date: Sat, 18 May 2013 20:34:02 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DAE3CB76@ATLEXMBX4.ARRS.ARRISI.com>
References: <1323812284.643758.1368874202987.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironmail.arrisi.com ([216.234.147.20]:48591 "EHLO arrisi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752988Ab3ERUeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 May 2013 16:34:20 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank,

Well, the main point was to use bigalloc. Unfortunately it requires
reformat.
W/o bigalloc there will be ~7800 block groups for 1T drive. Those groups
take 32M of ondisk data and up to 64M when it comes to RAM because of
runtime buddy bitmaps. I don't think it worth storing buddy bitmaps on
drive. It's not a surprise it can take long time to read lots of block
bitmaps scattered over drive and construct buddies out of them. And it's
not a surprise some these pages are evicted under high memory pressure.
With bigalloc 1M cluster size you get 256 times less metadata (128K
instead of 32M) and you get all the benefits of faster allocate,
truncate and lesser fragmentation.

Yes, you don't know file size in advance, but speculating say each 128M
is clearly a benefit. truncate to real file size once recording finished
to release unused preallocated space.
There are some caveats with O_DIRECT, but it is faster if done correctly.

Regards,
Andrei.

On 18.05.2013 03:50, frankcmoeller@arcor.de wrote:
> Hi Andrei,
>
> thanks for your quick answer!
> Perhaps you understood me wrong. The general write performance is quite good. We can record more than 4 HD channels at the same time without problems. Except the problems with the first write after mount. And there are also some users which have problems 1-2 times during a recording.
> I think the ext4 group initialization is the main problem, because it takes so long (as written before: around 1300 groups per second). Why don't you store the gathered informations on disk when a umount takes place?
>
> With fallocate the group initialization is partly made before first write. This helps, but it's no solution, because the finally file size is unknown. So I cannot preallocate space for the complete file. And after the preallocated space is consumed the same problem with the initialization arises until all groups are initialized.
>
> I also made some tests with O_DIRECT (my first tests ever). Perhaps I did something wrong, but it isn't very fast. And you have to take care about alignment and there are several threads in the internet which explain why you shouldn't use it (or only in very special situations and I don't think that my situation is one of them). And ext4 group initialization takes also place when using O_DIRECT (as said before perhaps I did something wrong).
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
>
>

