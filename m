From: "John Stoffel" <john@stoffel.org>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Date: Wed, 13 Apr 2011 12:45:07 -0400
Message-ID: <19877.54035.501749.870641@quad.stoffel.home>
References: <4DA48AF4.5080803@teksavvy.com>
	<20110413004938.GE3682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Mark Lord <kernel@teksavvy.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:61597 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab1DMQw6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 12:52:58 -0400
In-Reply-To: <20110413004938.GE3682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted> On Tue, Apr 12, 2011 at 01:25:08PM -0400, Mark Lord wrote:
>> Ted et al.
>> 
>> I've only just noticed this, so I have no idea how long it has been this way.
>> 
>> When I build a kernel with CONFIG_EXT4_USE_FOR_EXT23=y and boot from it,
>> the ext4 root filesystem shows up as "ext2" mode, rather than "ext4".
>> 
>> This looks very wrong to me, and quite dangerous.

Ted> It's a cosemtic bug, I agree, but I'm not sure why you consider it
Ted> dangerous.

Ted> CONFIG_EXT4_USE_FOR_EXT23 means that ext4 registers itself as
Ted> ext2 and/or ext3, if ext2 and/or ext3 are not configured into the
Ted> kernel.  Since the kernel tries to mount the file system as ext2,
Ted> ext3, and then ext4, and uses whichever one works first.

Should it instead be:  CONFIG_EXT4_MASQUERADE_AS_EXT23 instead, so
it's blindingly obvious what's going on here.

John
