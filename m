From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4: batched discard support - simplified version
Date: Fri, 23 Jul 2010 10:36:04 -0400
Message-ID: <20100723143604.GF13090@thunk.org>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eshishki@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39777 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0GWOgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 10:36:06 -0400
Content-Disposition: inline
In-Reply-To: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 07, 2010 at 09:53:30AM +0200, Lukas Czerner wrote:
> 
> Hi all,
> 
> since my last post I have done some more testing with various SSD's and the
> trend is clear. Trim performance is getting better and the performance loss
> without trim is getting lower. So I have decided to abandon the initial idea
> to track free blocks within some internal data structure - it takes time and
> memory.

Do you have some numbers about how bad trim actually might be on
various devices?  I can imagine some devices where it might be better
(for wear levelling and better write endurance if nothing else) where
it's better to do the trim right away instead of batching things.

So what I'm thinking about doing is keeping the "discard" mount option
to mean non-batched discard.  If you want to use the explicit FITRIM
ioctl, I don't think we need to test to see if the dicard mount option
is set; if the user issues the ioctl, then we should do the batched
discard, and if we don't trust the user to do that, then well, the
ioctl should be restricted to privileged users only --- especially if
it could take up to a minute.

						- Ted
