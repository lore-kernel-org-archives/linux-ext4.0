From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4: add new ioctl EXT4_IOC_PRECACHE_EXTENTS
Date: Thu, 18 Jul 2013 11:21:29 -0400
Message-ID: <20130718152129.GD30405@thunk.org>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <1373987883-4466-6-git-send-email-tytso@mit.edu>
 <20130718011940.GA8785@gmail.com>
 <20130718025025.GA30405@thunk.org>
 <20130718130611.GB14274@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38980 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3GRPVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jul 2013 11:21:33 -0400
Content-Disposition: inline
In-Reply-To: <20130718130611.GB14274@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 18, 2013 at 09:06:11PM +0800, Zheng Liu wrote:
> 
> Yes, at least for a internet company we can control everything, but for
> upstream the kernel might run under some weird environments.  The lesson
> from this is that I need to think deeply for non-internet applications,
> and make a better design.

That's the main reaosn why there are patches that are in the Google
kernel for ext4 that haven't gone upstream yet, in fact.  It's not
that we didn't want them upstream (in fact it's more work when have to
constantly rebase patches upstream).  But often there are short cuts
we can take given a controlled environment, and getting something
which is suitable for mainline takes a lot more work.

One example of this is our patches to disable stable page writebacks,
which was a huge performance improvement but which didn't work for
iSCSI and drives with DIF/DIX support (fortunately we didn't care
about things like DIF/DIX in our environment).  Now that Darrick has
implemented patches which only enable stable page writeback when it's
needed, there is a much nicer solution upstream.

Another example of this is we have a direct I/O fastpath patches that
significantly reduce DIO's overhead on extremely high speed devices.
Unfortunately, it's too ugly to live (and not coincidentally,
incredibly painful to rebase).  Kent Overstreet was working on some
DIO improvements that will hopefully be clean enough that they can go
upstream at some point, at which point I will be so glad when we can
drop our ugly local hacks....

				- Ted

