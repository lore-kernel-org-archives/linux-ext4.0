From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Date: Fri, 16 Mar 2012 16:25:32 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1203161623130.18356@pobox.suse.cz>
References: <20120316142843.20538.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032796Ab2CPPZd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Mar 2012 11:25:33 -0400
In-Reply-To: <20120316142843.20538.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 Mar 2012, George Spelvin wrote:

> > I am not aware of anything, but I have a question -- George, did the 
> > machine get suspended/resumed before this happened?
> 
> I'm pretty sure it didn't.  It's a desktop machine, and I don't ever
> suspend it.  It had been up for a while, and /sys/power/state exists, and
> *maybe* I played with it sometime since boot, but the backup runs nightly
> and I *definitely* did not suspend it the day (or even several days)
> before the oops.
> 
> (I tried to preserve the machine state, but processes started getting
> stuck in the kernel a few hours after the report, so I had to reboot it.)
> 
> Jan Kara asked:
> >   And by any chance, do you use i915 driver? Because that one seems to
> > cause corruption - see: https://lkml.org/lkml/2012/3/9/217. I believe
> > Jiri's corruption is likely caused by that...
> 
> Yes!  lspci -nn and abbreviated .config attached.  But, as mentioned, the machine
> hasn't been suspended...

So it might be the culprit. As the reason of the corruption is not yet 
understood, it might be that suspend/resume cycle is not necessary 
pre-requisite for this to trigger, it might just make it more likely.

And the corruption is observed to be indeed several writes of 0x00000000, 
so it could easily lead to null pointer dereferences all over the place.

Are you able to reproduce the problem if you turn kernel modesetting off?

-- 
Jiri Kosina
SUSE Labs
