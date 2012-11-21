From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unaligned AIO warning printk
Date: Wed, 21 Nov 2012 14:47:28 -0500
Message-ID: <20121121194728.GA6895@thunk.org>
References: <50AD09F0.6090706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33998 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab2KUTrc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 14:47:32 -0500
Content-Disposition: inline
In-Reply-To: <50AD09F0.6090706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 21, 2012 at 11:05:52AM -0600, Eric Sandeen wrote:
> Although I put this in, I now think it was a bad decision.
> For most users, there is very little to be done in this case.  They
> get the message, once per day, with no real context or proposed action.
> TBH, it generates support calls when it probably does not need to;
> the message sounds more dire than the situation really is.
> 
> Just nuke it.  Normal investigation via blktrace or whatnot can
> reveal poor IO patterns if bad performance is encountered.

I wonder if this might be a good thing to enable or disable via sysfs
tuning knob, just to make it a little easier for a random application
developer to test for this?

And do you have a list of the bad applications so we can nag them to
fix them?

					- Ted
