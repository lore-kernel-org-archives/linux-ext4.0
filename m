From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
Date: Mon, 19 Mar 2012 11:48:12 -0700
Message-ID: <4F677F6C.8030902@gmail.com>
References: <cover.1331856299.git.joe@perches.com> <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com> <4F63646D.1040700@cavium.com> <20120319043937.GN31682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, David Daney <david.daney@cavium.com>,
	Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55431 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab2CSSsP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 14:48:15 -0400
In-Reply-To: <20120319043937.GN31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/18/2012 09:39 PM, Ted Ts'o wrote:
> On Fri, Mar 16, 2012 at 09:03:57AM -0700, David Daney wrote:
>>
>> In many other susbsystems/drivers, the definition of DEBUG is gated
>> by a separate Kconfig symbol used to select debugging just for that
>> susbsystem/driver (see CONFIG_MMC_DEBUG for example).
>
> In ext4 we have many different debugging patches, and in general you'd
> never want to enable them all at once (you'd get way too much noise).
> The debugging statements are there when a developer is debugging very
> specific section of code (i.e., the directory index, or the extent
> tree, or the block allocator, etc.).  It's really only ext4 developers
> who need to use those debugging statements, and even for them it's
> quite rare.
>
> So I've never considered it worthwhile to enable them via a CONFIG_*
> menu item; developers who are debugging a specific problem will
> generally just drop in the specific #define on an ad hoc basis, and
> that works fine.
>

If you want to unconditionally define DEBUG for all of ext4, that is 
fine with me.

I was just noting that it seemed a little odd to me, and different from 
what is done elsewhere.

Thanks,
David Daney
