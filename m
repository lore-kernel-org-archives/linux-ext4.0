From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Date: Sat, 19 Feb 2011 19:05:50 -0500
Message-ID: <20110220000550.GA8765@thunk.org>
References: <4D604620.9060204@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58762 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1BTAFx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Feb 2011 19:05:53 -0500
Content-Disposition: inline
In-Reply-To: <4D604620.9060204@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 19, 2011 at 05:37:20PM -0500, Mark Lord wrote:
> 32-bit x86 system, 2.6.37 SMP kernel, Core2duo, 3.3GB RAM, no swap.
> 
> The system just suddenly switched to fbconsole and dumped a traceback.
> Here's the screen-shot photo:  http://rtr.ca/ext4_crash.jpg
> 
> Is this a known bug that got fixed in 2.6.37.1 ?

No, this looks like a new one.

And I can't make the Code: line make sense.  Can you send me the
fs/ext4/mballoc.s file after running the command "make
fs/ext4/mballoc.s" in your build tree where you built this kernel?

Thanks!!

						- Ted
