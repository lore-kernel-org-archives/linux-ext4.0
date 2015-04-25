From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on small fs
Date: Fri, 24 Apr 2015 22:25:06 -0600
Message-ID: <D2BC34F2-AB5D-4923-A2D6-28CEC2807C9A@dilger.ca>
References: <1427280382-31120-1-git-send-email-lczerner@redhat.com> <553ABAF0.2020702@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34739 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbDYEZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Apr 2015 00:25:10 -0400
Received: by pacyx8 with SMTP id yx8so66608067pac.1
        for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2015 21:25:09 -0700 (PDT)
In-Reply-To: <553ABAF0.2020702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 24, 2015, at 3:51 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 3/25/15 5:46 AM, Lukas Czerner wrote:
>> Currently we're unable to online resize very small (smaller than 32 MB)
>> file systems with 1k block size because there is not enough space in the
>> journal to put all the reserved gdt blocks.
> 
> So, I'll get to the patch review if I need to, but this all seemed a little
> odd; this is a regression, so do we really need to restrict things at mkfs
> time?
> 
> On the userspace side, things were ok until:
> 
> 9f6ba88 resize2fs: add support for new in-kernel online resize ioctl
> 
> and even with that, on the kernelspace side, things were ok until:
> 
> 8f7d89f jbd2: transaction reservation support
> 
> I guess I'm trying to understand why that jbd2 commit regressed this.
> I've not been paying enough attention to ext4 lately.  ;)
> 
> I mean, the threshold got chopped in half:
> 
> -       if (nblocks > journal->j_max_transaction_buffers) {
> +       /*
> +        * 1/2 of transaction can be reserved so we can practically handle
> +        * only 1/2 of maximum transaction size per operation
> +        */
> +       if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
>                printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
> -                      current->comm, nblocks,
> -                      journal->j_max_transaction_buffers);
> +                      current->comm, blocks,
> +                      journal->j_max_transaction_buffers / 2);
>                return -ENOSPC;
>        }
> 
> so it's clear why the behavior changed, I guess, but it feels like I
> must be missing something here.

Is there some way to reserve these journal blocks only in the case of
delalloc usage?  This has caused a performance regression with Lustre
servers on 3.10 kernels because the journal commits twice as often.
We've worked around this for now by doubling the journal size, but it
seems a bit of a hack since we can never use the whole journal anymore.

> The reproducer, for those playing along at home, is something like:
> 
> mkfs.ext4 /dev/sda 20M
> mount /dev/sda /mnt/test
> resize2fs /dev/sda 200M
> 
> -Eric
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





