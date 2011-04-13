From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Date: Wed, 13 Apr 2011 14:17:10 -0400
Message-ID: <4DA5E8A6.7080304@gmail.com>
References: <4DA48AF4.5080803@teksavvy.com>	<20110413004938.GE3682@thunk.org> <19877.54035.501749.870641@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Mark Lord <kernel@teksavvy.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47461 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1DMSRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 14:17:16 -0400
In-Reply-To: <19877.54035.501749.870641@quad.stoffel.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/13/2011 12:45 PM, John Stoffel wrote:
>>>>>> "Ted" == Ted Ts'o<tytso@mit.edu>  writes:
> Ted>  On Tue, Apr 12, 2011 at 01:25:08PM -0400, Mark Lord wrote:
>>> Ted et al.
>>>
>>> I've only just noticed this, so I have no idea how long it has been this way.
>>>
>>> When I build a kernel with CONFIG_EXT4_USE_FOR_EXT23=y and boot from it,
>>> the ext4 root filesystem shows up as "ext2" mode, rather than "ext4".
>>>
>>> This looks very wrong to me, and quite dangerous.
> Ted>  It's a cosemtic bug, I agree, but I'm not sure why you consider it
> Ted>  dangerous.
>
> Ted>  CONFIG_EXT4_USE_FOR_EXT23 means that ext4 registers itself as
> Ted>  ext2 and/or ext3, if ext2 and/or ext3 are not configured into the
> Ted>  kernel.  Since the kernel tries to mount the file system as ext2,
> Ted>  ext3, and then ext4, and uses whichever one works first.
>
> Should it instead be:  CONFIG_EXT4_MASQUERADE_AS_EXT23 instead, so
> it's blindingly obvious what's going on here.
>
> John

No - the idea is to have use eliminate duplicate code and still be able to run 
ext2 and ext3 in the same way.

How close we come to that goal will probably vary between ext2 and ext3 now but 
it would be great to get that done eventually.

We did discuss this at LSF last week and we had some enthusiasm for keeping ext2 
code around forever more or less as "the simple" file system template :)

Ric

