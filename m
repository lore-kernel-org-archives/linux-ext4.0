From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3: Freeing blocks not in datazone
Date: Mon, 14 Apr 2008 16:00:20 -0500
Message-ID: <4803C5E4.3030804@redhat.com>
References: <4803A109.5080800@rtr.ca> <4803AF3B.2020702@redhat.com> <4803BF54.4040205@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbYDNVAY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2008 17:00:24 -0400
In-Reply-To: <4803BF54.4040205@rtr.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mark Lord wrote:
> Eric Sandeen wrote:
>> Mark Lord wrote:
>>> One of my test systems here, running 2.6.25-rc8-git*,
>>> just now crapped out with this in the tail end of dmesg:
>>>
>>> [   20.927780] EXT3-fs error (device sda1): ext3_free_blocks: Freeing blocks not in datazone - block
>>> [   20.928756] Aborting journal on device sda1.
>> I've got a similar report from the F9 installer, also on 2.6.25-rc8* ...
>>  trying to reproduce locally.
> ..
> 
> Well, if it's of any help, here it was on a 2.4GHz Intel QuadCore,
> 32-bit kernel/userspace, 4GB RAM, PAE-enabled.

Any chance you had done a resize2fs, online or offline, before this?
Just a guess based on the installer thing I'm looking at...

Thanks,
-Eric
