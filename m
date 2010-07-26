From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mballoc: allocate stripe-multiple IOs on stripe
 boundaries
Date: Mon, 26 Jul 2010 18:52:23 -0400
Message-ID: <20100726225223.GB14072@thunk.org>
References: <4C3E27BF.2000005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36338 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab0GZWwZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jul 2010 18:52:25 -0400
Content-Disposition: inline
In-Reply-To: <4C3E27BF.2000005@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 14, 2010 at 04:10:23PM -0500, Eric Sandeen wrote:
> For some reason, today mballoc only allocates IOs which are exactly
> stripe-sized on a stripe boundary.  If you have a multiple (say, a
> 128k IO on a 64k stripe) you may end up unaligned.
> 
> It seems to me that a simple change to align stripe-multiple IOs
> on stripe boundaries would be a very good idea, unless this breaks
> some other mballoc heuristic for some reason...

I've added this to the ext4 tree, thanks.

						- Ted
