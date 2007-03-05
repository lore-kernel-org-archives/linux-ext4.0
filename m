From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck and human intervention
Date: Mon, 5 Mar 2007 11:48:47 -0500
Message-ID: <20070305164847.GB9444@thunk.org>
References: <1173112017.6300.14.camel@systems03.mmm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <ddrake@brontes3d.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58327 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXCEQsu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2007 11:48:50 -0500
Content-Disposition: inline
In-Reply-To: <1173112017.6300.14.camel@systems03.mmm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 05, 2007 at 11:26:57AM -0500, Daniel Drake wrote:
> Hi,
> 
> I'm working with ext3 partitions in a product environment, where
> numerous embedded Linux systems will be shipped to various locations.
> 
> In testing we occasionally find that system boot is halted by e2fsck
> with an "UNEXPECTED INCONSISTENCY" error message. This is while running
> in preen mode.
> 
> This usually happens during e2fsck's regular "check every X mounts"
> thing, as opposed to immediately after booting up after power loss, so
> to begin with it's not immediately obvious why there is a problem.
> 
> It's of course understandable and inevitable that power loss will
> occasionally cause some file loss or corruption, and that's fine. My
> main concern is that fsck is halting the boot process, and in a product
> scenario this would require an engineer to perform a service call. If
> e2fsck could unconditionally perform a best-effort attempt at solving
> the problems, it would be ideal.

Actually, power loss by itself should *not* cause any corruption when
you are using ext3; that's the whole point of the journal.  If there
is, you probably have some other problem that you might do well to try
to debug before youi ship your product, since that may lead to
significant data loss in the long-term.

> Are there any better approaches than something like the following?
> 
> 1. Run "e2fsck -p /"
> 
> 2. If bit 3 is set in exit code (i.e. preen functionality detected
> unexpected inconsistency) then run "e2fsck -y /"
> 
> Is there significant risk of further data loss through using -y than
> might be experienced otherwise?

You could do this, but if you are using ext3, this is really papering
over the problem.  With ext3, there really should not be any
corruptions caused by power loss.  

What sort of errors are being reported by e2fsck?

							- Ted
