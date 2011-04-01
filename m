From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: breaking ext4 to test recovery
Date: Fri, 01 Apr 2011 11:52:13 -0400
Message-ID: <4D95F4AD.2090804@gmail.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca> <4D9503C0.8080804@redhat.com> <alpine.LFD.2.00.1104011724140.3151@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51098 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1DAPwR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 11:52:17 -0400
Received: by ywj3 with SMTP id 3so1456853ywj.19
        for <linux-ext4@vger.kernel.org>; Fri, 01 Apr 2011 08:52:17 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1104011724140.3151@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/01/2011 11:26 AM, Lukas Czerner wrote:
> On Thu, 31 Mar 2011, Eric Sandeen wrote:
>
>> On 3/31/11 5:21 PM, Andreas Dilger wrote:
>>
>>> We have a kernel patch "dev_read_only" that we use with Lustre to
>>> disable writes to the block device while the device is in use.  This
>>> allows simulating crashes at arbitrary points in the code or test
>>> scripts.  It was based on Andrew Morton's test harness that he used
>>> for ext3 recovery testing back when it was being ported to the 2.4
>>> kernel.
>>>
>>> http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob_plain;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;hb=HEAD
>>>
>>>   The best part of this patch is that it works with any block device,
>>> can simulate power failure w/o any need for automated power control,
>>> and once the block device is unused (all buffers and references
>>> dropped) it can be re-activated safely.
>> It won't simulate a lost write cache though, will it?
> That's a very good question, I would like to know if there is any way at
> all to force the device to drop the write cache. That would really help
> the power failure testing filesystems.
>
> -Lukas
>

Write cache behavior can be really mysterious. Small writes (say single 4K 
blocks) might stay in cache and not get written for a very long time while 
large, streaming writes might bypass the write cache entirely.

It would be neat to be able to simulate these odd things for failure testing :)

Ric

