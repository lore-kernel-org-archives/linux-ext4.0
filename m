From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: superblock completely overwritten
Date: Tue, 13 Dec 2016 10:15:25 -0600
Message-ID: <7a0b791c-8a9f-23e5-02a2-cd903024ef06@redhat.com>
References: <trinity-fba1c40f-e300-43ee-a4cd-f9d7f48ecef2-1481643547528@3capp-gmx-bs76>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Heinz Nimmervoll <bt1now@gmx.at>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933222AbcLMQQW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Dec 2016 11:16:22 -0500
In-Reply-To: <trinity-fba1c40f-e300-43ee-a4cd-f9d7f48ecef2-1481643547528@3capp-gmx-bs76>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/13/16 9:39 AM, Heinz Nimmervoll wrote:
> I still got no answer for my problem thats why I try it here... hopefully you could help me out.
>  
> System:
> 
> Embedded board with Atmel SAM9x25
> Debian Wheezy Kernel 3.11.6
> 32GB Samsung SDHC card with ext4 root- partition (journal activated)
>  
> 
> After system running two weeks or so superblock from rootfs (ext4) at block 0 got overwritten with "trash data".
> This is happening with like 20% of the embedded devices.
>  
> hex comparision between faulty and good superblock starting at byte 1024:
>  
> Before (good):
>  
> 00000000  00 ee 02 00 00 b8 0b 00  00 96 00 00 ab a9 05 00  |................|
> 00000010  c3 0c 02 00 00 00 00 00  02 00 00 00 02 00 00 00  |................|
> 00000020  00 80 00 00 00 80 00 00  40 1f 00 00 9e 68 46 58  |........@....hFX|
> 00000030  9e 68 46 58 2e 00 64 00  53 ef 01 00 01 00 00 00  |.hFX..d.S.......|

<snip>

>  
> After (corrupted):
>  
> 00000000  00 00 00 00 a4 81 00 00  dd 00 00 00 24 8e 5d 54  |............$.]T|
> 00000010  7e 8e 5d 54 18 a6 9f 41  00 00 00 00 00 00 01 00  |~.]T...A........|
> 00000020  08 00 00 00 00 00 08 00  01 00 00 00 0a f3 01 00  |................|
> 00000030  04 00 00 00 00 00 00 00  00 00 00 00 01 00 00 00  |................|


<snip>

> - How is it possible, that even the magic number (and everything else) got overwritten?
> - Why could it ever be overwritten?

I don't think anyone here can tell you what happened, it is almost certainly not
an ext4 bug.  Could be a driver bug, or an admin running a stray "dd" command,
or some other utility gone astray, or ... anything, really.

As a very long shot, what does "blkid" or "file -s" tell you about the block device
after it's been overwritten?  Perhaps it will recognize a signature.

Otherwise, you could do something like a modified kernel to trap any IO to block
zero on the device and issue a printk about the process which is doing it, filtering
out any expected ext4 accesses.

-Eric
  
> Thank you so much!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

