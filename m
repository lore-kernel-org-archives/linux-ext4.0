From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: breaking ext4 to test recovery
Date: Sat, 02 Apr 2011 08:38:19 -0400
Message-ID: <4D9718BB.2070005@gmail.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca> <4D9503C0.8080804@redhat.com> <06ABAED6-3569-4A30-816B-6A7A53A652D1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	Johann Lombardi <johann@whamcloud.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49325 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab1DBMiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 08:38:23 -0400
Received: by qwk3 with SMTP id 3so2586674qwk.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Apr 2011 05:38:22 -0700 (PDT)
In-Reply-To: <06ABAED6-3569-4A30-816B-6A7A53A652D1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/01/2011 10:15 PM, Andreas Dilger wrote:
> On 2011-03-31, at 12:44 PM, Eric Sandeen wrote:
>> On 3/31/11 5:21 PM, Andreas Dilger wrote:
>>> We have a kernel patch "dev_read_only" that we use with Lustre to
>>> disable writes to the block device while the device is in use.  This
>>> allows simulating crashes at arbitrary points in the code or test
>>> scripts.  It was based on Andrew Morton's test harness that he used
>>> for ext3 recovery testing back when it was being ported to the 2.4
>>> kernel.
>>>
>>> http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob_plain;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;hb=HEAD
>>>
>>> The best part of this patch is that it works with any block device,
>>> can simulate power failure w/o any need for automated power control,
>>> and once the block device is unused (all buffers and references
>>> dropped) it can be re-activated safely.
>> It won't simulate a lost write cache though, will it?
> I'm not sure what you mean.  Since the patch works at the block device layer (in __generic_make_request()) it will drop the write at the time it is submitted to the device, not when it is put into the cache.
>
> That said, I notice in the linux git repo a line that is in the same place as our patch "if (should_fail_request(bio))" which looks like it might have similar functionality when CONFIG_FAIL_MAKE_REQUEST is enabled.  I'm not sure what kernel version it was added in.  It looks like it is possible to fail the IOs some fraction of the time, or permanently, by writing something into /sys/block/{dev}/fail.
>
> Cheers, Andreas

The device mapper developers are looking at having a device mapper target that 
can be used as a hot block cache - say given a S-ATA disk and a PCI-e SSD, you 
would store the hot blocks on the PCI-e card.

What might be a great simulation would be to have a way to destroy that cache, 
assuming we could get a cache policy that simulates some reasonable, disk like 
caching policy :)

Ric


