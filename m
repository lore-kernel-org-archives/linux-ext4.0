From: Eric Biggers <ebiggers@google.com>
Subject: Re: Attempts to use ext4 encryption on kernel 4.1.15 keep resulting
 in kernel crash
Date: Fri, 16 Feb 2018 10:30:55 -0800
Message-ID: <20180216183055.GA245245@google.com>
References: <CACfi_Z1Lf+VODomcoS3ekHexTjMueEDjdANmq2CvqTuJd=i-tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Davis Roman <davis.roman84@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38389 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752025AbeBPSbA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2018 13:31:00 -0500
Received: by mail-it0-f54.google.com with SMTP id k6so2878902ita.3
        for <linux-ext4@vger.kernel.org>; Fri, 16 Feb 2018 10:31:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CACfi_Z1Lf+VODomcoS3ekHexTjMueEDjdANmq2CvqTuJd=i-tQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Davis,

On Fri, Feb 16, 2018 at 11:04:32AM -0500, Davis Roman wrote:
> Hello,
> 
> I would also like to enable ext4 encryption on our product. We're
> using a 4.1.15 kernel.
> 
> Our kernel has CONFIG_KEYS and CONFIG_EXT4_ENCRYPTION enabled and I
> made sure to have an up to date version of e2fsprogs. We're using
> 1.43.8.
> 
> Unfortunately, I get a kernel panic whenever I try the above steps show below.
> 
> Any ideas on what I could do next would be extremely appreciated.
> 

Is this reproducible on the latest 4.1-stable?  4.1.15 is over two years old so
you are missing thousands of bug fixes all over the kernel.

Also I don't in general recommend using ext4 encryption on 4.1 kernels at all,
as that was the first kernel version ever to have ext4 encryption and it is
missing a lot of bug fixes that haven't been backported.  I've been backporting
fixes to 4.4, but 4.1 has just been too broken to bother most of the time.

> [<8001f9e8>] (v7_dma_clean_range) from [<8001b8b0>]
> (__dma_page_cpu_to_dev+0x28/0x94)
> [<8001b8b0>] (__dma_page_cpu_to_dev) from [<8001b9d0>]
> (arm_dma_map_page+0x70/0x74)
> [<8001b9d0>] (arm_dma_map_page) from [<8058f33c>]
> (ablkcipher_edesc_alloc.constprop.1+0x180/0x568)
> [<8058f33c>] (ablkcipher_edesc_alloc.constprop.1) from [<8058f740>]
> (ablkcipher_encrypt+0x1c/0x90)
> [<8058f740>] (ablkcipher_encrypt) from [<801b4f50>]
> (ext4_derive_key_aes+0x104/0x15c)
> [<801b4f50>] (ext4_derive_key_aes) from [<801b5114>]
> (ext4_generate_encryption_key+0x16c/0x1bc)

But in this case it actually crashed in some hardware crypto driver (maybe CAAM?
you didn't say) so the bug is probably there, not in ext4.  Maybe the crypto
driver you are using doesn't handle ECB mode correctly.  Have you checked
whether there have been any bug fixes to it within the last 2 years...?

Eric
