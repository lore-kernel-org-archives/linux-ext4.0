From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4 v2] ext4: Do not discard group with BLOCK_UNINIT
 set
Date: Wed, 7 Mar 2012 08:10:00 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203070807220.5117@dhcp-27-109.brq.redhat.com>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com> <1330690318-22627-4-git-send-email-lczerner@redhat.com> <20120306221815.GA5472@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2CGHKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 02:10:04 -0500
In-Reply-To: <20120306221815.GA5472@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Mar 2012, Ted Ts'o wrote:

> On Fri, Mar 02, 2012 at 01:11:58PM +0100, Lukas Czerner wrote:
> > Because the BLOCK_UNINIT is only set on mke2fs time and cleared when
> > allocation from that group takes place we know that when set, there was
> > not anything allocated from that group, hence there should not be anything
> > to discard from the file system point of view.
> 
> There's a really good reason to set BLOCK_UNINIT once we have noticed
> that all of the blocks in the block group have been released....
> 
> If you have a 3TB HDD, running e2fsck takes 4 times as long if all of
> the block groups have BLOCK_UNINIT cleared, compared to a freshly
> mkfs'ed file system.  As a result of my getting really annoyed at how
> long it took in this case, I'm planning on making e2fsck clear
> BLOCK_UNINIT if possible, so that subsequent e2fsck's (and dumpe2fs
> and debugfs invocations) can also be fast.
> 
> 					- Ted

Ok, if there is a plan to implement that, I am fine with dropping th
patches. But since this optimization would be helpful for discard, we
can introduce BLOCK_DISCARDED/UNPROVISIONED flag maybe ? Which would be
sen only after discard and cleared with the first allocation ?

Thanks!
-Lukas
