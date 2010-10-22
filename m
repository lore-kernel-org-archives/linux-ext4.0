From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 11:41:08 -0400
Message-ID: <4CC1B094.3090403@gmail.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca> <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com> <4CC175E6.5000700@gmail.com> <alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC19BC2.9010503@gmail.com> <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC1A3AA.6040004@gmail.com> <4CC1AFD2.2020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63805 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0JVPlL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 11:41:11 -0400
Received: by gxk23 with SMTP id 23so514812gxk.19
        for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 08:41:10 -0700 (PDT)
In-Reply-To: <4CC1AFD2.2020803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 10/22/2010 11:37 AM, Eric Sandeen wrote:
> Ric Wheeler wrote:
>
> ...
>
>>> Well, so far the only breakages I have seen was with lots of small TRIMs
>>> (or UNMAPs, etc) issued in random pattern, never in case of mkfs which
>>> is quite a opposite - big sequential ranges.
>>>
>>> Hangs should be covered by those two patches:
>>>
>>> http://marc.info/?l=linux-ext4&m=128774558623608&w=2
>>> http://marc.info/?l=linux-ext4&m=128767099123375&w=2
>>>
>>> if, of course, they get upstream. Also there is a big win, when discard
>>> also zeroes data, because in that case we can just skip inode table
>>> initialization (zeroing) without any need of in-kernel lazyinit code
>>> enabled. And we get all this for free. It was introduced with Sandeens
>>> patch:
>>>
>>> http://marc.info/?l=linux-ext4&m=128234048208327&w=2
>>>
>>> So, I would rather leave it on by default.
>>>
>>> -Lukas
>> You cannot 100% depend on discard zeroing blocks - that is not a
>> universal requirement of devices that support it. Specifically, for ATA
>> devices, I think that there are optional bits that specify how a device
>> will behave when you read from a trimmed region.
> But don't we have the ability to test whether discard -does- zero blocks,
> as advertised by the device?  And honestly if the device mis-reports, that
> sounds like a device vendor problem to fix.
>
> The proposal wasn't to discard and assume zero, but to check for that
> behavior:
>
> http://kerneltrap.org/mailarchive/linux-ext4/2010/9/21/6885628/thread
>
> +		if (!retval&&  mke2fs_discard_zeroes_data(fs)) {
> +			if (verbose)
> +				printf(_("Discard succeeded and will return 0s "
> +					 " - enabling lazy_itable_init\n"));
> +			lazy_itable_init = 1;
> +			lazy_itable_zeroed = 1;
> +		}
>
> so we're not depending on it zeroing blocks, we're just depending on it
> advertising correctly whether or not it -does- zero.
>
> -Eric
>
>

I think that ATA devices have historically not done this correctly, but the T13 
committee is working on it. The question is whether the bit we check and rely on 
has the right semantics (and then if the device will reliably implement this).

Historically, array vendors did rely on SCSI commands like the old fashioned 
"WRITE_SAME" to initialize storage for them, but that takes a *long* time to run :)

Ric


