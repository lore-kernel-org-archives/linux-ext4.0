From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4: batched discard support - simplified version
Date: Fri, 23 Jul 2010 13:00:05 -0400
Message-ID: <20100723170005.GJ13090@thunk.org>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
 <20100723143604.GF13090@thunk.org>
 <x49hbjqjknj.fsf@segfault.boston.devel.redhat.com>
 <20100723151925.GI13090@thunk.org>
 <x49bp9yjjed.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, eshishki@redhat.com,
	rwheeler@redhat.com, linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42280 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab0GWRAK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 13:00:10 -0400
Content-Disposition: inline
In-Reply-To: <x49bp9yjjed.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 23, 2010 at 11:40:58AM -0400, Jeff Moyer wrote:
> 
> You are right, and we have to consider thinly provisioned luns, as well.
> The only case I can think of where it makes sense to issue those
> discards immediately is if you are running tight on allocated space in
> your thinly provisioned lun.  Aside from that, I'm not sure why you
> would want to send those commands down with every journal commit,
> instead of batched daily, for example.  But, I can certainly understand
> wanting to allow this flexibility.

The two reasons I could imagine is to give more flexibility to the
wear leveling algorithms (depending on how often you are turning over
files --- i.e., deleting blocks and then reusing them), and to
minimize latency (it might be nicer for the system to send down the
deleted blocks on a continuing basis rather than to send them down all
at once).  

The other issue is that by sending TRIM commands for all free extents,
even those that haven't been recently been released, the flash
translation layer needs to look up a large number of blocks in its
translation table to see if it needs to update it.  This can end up
burning CPU unnecessarily, especially for those flash devices (such as
FusionIO, for example) manage their FTL using the host CPU.

So this is one of the reasons why I want to leave some flexibility
here; BTW, for some systems, it may make sense for the FITRIM ioctl to
throttle the rate at which it locks block groups and sends down TRIM
requests so it doesn't end up causing performance hiccups for live
applications while the FITRIM ioctl is running.

	     	     	       	      	       - Ted
