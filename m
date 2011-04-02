From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: breaking ext4 to test recovery
Date: Fri, 1 Apr 2011 16:15:34 -1000
Message-ID: <06ABAED6-3569-4A30-816B-6A7A53A652D1@dilger.ca>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca> <4D9503C0.8080804@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	Johann Lombardi <johann@whamcloud.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:37071 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1DBCPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 22:15:42 -0400
In-Reply-To: <4D9503C0.8080804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-31, at 12:44 PM, Eric Sandeen wrote:
> On 3/31/11 5:21 PM, Andreas Dilger wrote:
>> We have a kernel patch "dev_read_only" that we use with Lustre to
>> disable writes to the block device while the device is in use.  This
>> allows simulating crashes at arbitrary points in the code or test
>> scripts.  It was based on Andrew Morton's test harness that he used
>> for ext3 recovery testing back when it was being ported to the 2.4
>> kernel.
>> 
>> http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob_plain;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;hb=HEAD
>> 
>> The best part of this patch is that it works with any block device,
>> can simulate power failure w/o any need for automated power control,
>> and once the block device is unused (all buffers and references
>> dropped) it can be re-activated safely.
> 
> It won't simulate a lost write cache though, will it?

I'm not sure what you mean.  Since the patch works at the block device layer (in __generic_make_request()) it will drop the write at the time it is submitted to the device, not when it is put into the cache.

That said, I notice in the linux git repo a line that is in the same place as our patch "if (should_fail_request(bio))" which looks like it might have similar functionality when CONFIG_FAIL_MAKE_REQUEST is enabled.  I'm not sure what kernel version it was added in.  It looks like it is possible to fail the IOs some fraction of the time, or permanently, by writing something into /sys/block/{dev}/fail.

Cheers, Andreas





