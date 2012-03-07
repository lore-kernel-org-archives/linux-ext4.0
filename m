From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4 v2] ext4: Do not discard group with BLOCK_UNINIT set
Date: Wed, 7 Mar 2012 12:22:20 -0500
Message-ID: <20120307172220.GC11457@thunk.org>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-4-git-send-email-lczerner@redhat.com>
 <20120306221815.GA5472@thunk.org>
 <alpine.LFD.2.00.1203070807220.5117@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40394 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab2CGRWW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 12:22:22 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203070807220.5117@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 07, 2012 at 08:10:00AM +0100, Lukas Czerner wrote:
> 
> Ok, if there is a plan to implement that, I am fine with dropping th
> patches. But since this optimization would be helpful for discard, we
> can introduce BLOCK_DISCARDED/UNPROVISIONED flag maybe ? Which would be
> sen only after discard and cleared with the first allocation ?

Heh, great minds think alike.  I was thinking about a the possibility
of having a BLOCK_DISCARDED flag this morning, with exactly the
semantics that you are suggesting.  There may be devices in the future
that have fast trims which will prefer to always get the duplicate
trim requests, but there is no question there are a lot of crappy
devices out there right now where trims are extremely expensive, so
that seems fair.

Something else to think about for the future, for battery driven
devices (such as handsets) automatically sending tirm commands might
not be a good idea when the device is sleeping/has the screen turned
off.  Given that we don't have an easy way of determining whether or
not the device is in a low powered state (ideally we only send the
trims right after work has been queued to the device, so it's woken up
already, but when there isn't anything else that needs to be sent to
the device).

					- Ted
