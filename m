From: Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: Ext4 inode & trim errors on Micron eUSB SSD with 2.6.37 kernel
Date: Thu, 24 Apr 2014 20:14:59 -0400
Message-ID: <CAFZh4h_kXwRZXSrWA96922xnv91=sxvEh9sqanW1BLFxXz-ofg@mail.gmail.com>
References: <CAFZh4h9avyDGPMcJnbHZxLFKHr2fAopz_26LqmnSn3Hobni+nA@mail.gmail.com>
	<20140424235028.GA15873@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:52819 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDYAO7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Apr 2014 20:14:59 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so3379080oag.26
        for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2014 17:14:59 -0700 (PDT)
In-Reply-To: <20140424235028.GA15873@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 24, 2014 at 7:51 PM,  <tytso@mit.edu> wrote:
> On Thu, Apr 24, 2014 at 04:05:26PM -0400, Brian Hutchinson wrote:
>> Hi,
>>
>> First post here but have been lurking and searching archives for a while.
>>
>> I have a custom embedded board that I support which is running Yocto
>> 1.5.  The mkfs.ext4 and all other efs2progs files are fairly
>> up-to-date ... the kernel is just kind of old (yea, I know, I need to
>> move up some but that is easier said than done on this thing).
>
> Huh?  Yocto 1.5 ships with the 3.10 kernel (and Yocto 1.6 should be
> shipping soon with an even newer kernel.)
>
> 2.6.37 dates back to 2011, and there have been a *huge* number of bug
> fixes since then.
>
> If you can't upgrade to a newer kernel, you might be better off
> falling back to ext3, and see if the problem still presents itself
> there.  Ext3 will create much more flash wear, but that's the price you
> pay for staying on an ancient kernel.  :-)
>
>
                                      - Ted
Hi Ted,

The rootfs only (and the sdk generated toolchain) is from Yocto,
u-boot & kernel are from the TI PSP (which happens to be the latest
release by the way ... newer kernels never were released beyond 2.6.37
... and I don't think they were ever mainlined either).

Yes, 1.6 was announced today but there is no modern oe-core based
support for the evm this board is based on ... only older oe-classic.

I've tried the same tests with ext3 and it did appear to run better
... I didn't get any inode errors and the load on the processor while
running the copy script I mentioned was a bit lower (reported by top)
than what I observed testing with ext4.

I'm attempting to get one of the latest kernels going with this board
but it is a slow process.

Thanks for the response.  I had pretty much concluded going to ext3
was the best option but wanted to bounce it on the list as a sanity
check/confirmation.

In the meantime I'm trying to convince mgmt that effort spent moving
toward a new kernel is better than the effort of trying to back port a
bunch of patches into an old kernel.

Regards,

Brian
