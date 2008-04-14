From: Mark Lord <lkml@rtr.ca>
Subject: Re: ext3: Freeing blocks not in datazone
Date: Mon, 14 Apr 2008 19:09:16 -0400
Message-ID: <4803E41C.1080003@rtr.ca>
References: <4803A109.5080800@rtr.ca> <4803AF3B.2020702@redhat.com> <4803BF54.4040205@rtr.ca> <4803C5E4.3030804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:3428 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761822AbYDNXJU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2008 19:09:20 -0400
In-Reply-To: <4803C5E4.3030804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Mark Lord wrote:
>> Eric Sandeen wrote:
>>> Mark Lord wrote:
>>>> One of my test systems here, running 2.6.25-rc8-git*,
>>>> just now crapped out with this in the tail end of dmesg:
>>>>
>>>> [   20.927780] EXT3-fs error (device sda1): ext3_free_blocks: Freeing blocks not in datazone - block
>>>> [   20.928756] Aborting journal on device sda1.
>>> I've got a similar report from the F9 installer, also on 2.6.25-rc8* ...
>>>  trying to reproduce locally.
>> ..
>>
>> Well, if it's of any help, here it was on a 2.4GHz Intel QuadCore,
>> 32-bit kernel/userspace, 4GB RAM, PAE-enabled.
> 
> Any chance you had done a resize2fs, online or offline, before this?
> Just a guess based on the installer thing I'm looking at...
..

No, nothing really special there.
It's just a single drive / single filesystem (K)Ubuntu install originally,
with various test 2.6.25-rc* kernels being substituted in.

There are lots of other drives in the box for driver development,
but they have nothing to do with the ext3 root fs.

My guess would be that the 4 fast CPU cores managed to race on something.

Cheers
