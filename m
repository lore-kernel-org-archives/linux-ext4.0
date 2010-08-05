From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Crash after umount'ing a disconnected disk (Re: extfs
 reliability)
Date: Thu, 5 Aug 2010 17:17:58 -0400
Message-ID: <20100805211758.GA12358@thunk.org>
References: <20100804180325.GL9453@thunk.org>
 <4C5B1137.1070001@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0HEVSC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 17:18:02 -0400
Content-Disposition: inline
In-Reply-To: <4C5B1137.1070001@vlnb.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 05, 2010 at 11:29:59PM +0400, Vladislav Bolkhovitin wrote:
> >Have you had a chance to check out whether this patch solves the
> >problem you were complaining with respect to yanking out the last
> >iSCSI or FC link to a hard drive, and then umounting the disk
> >afterwards?
> 
> Looks like it works. I was able to reach that branch (see AAA in the
> attached log) and it was handled well.

OK, great!

> I've also got other (see the attached log file):
> 
> 1. A bunch of detected hung tasks with call traces.
> 

Is this unique to ext4?  It looks like a problem where we're either
(a) not getting an I/O error from the block device in time before we
get the hung task timeout (which might be the right thing, if the link
eventually comes back --- what I've seen is there's a no clear
consensus how long the last FC or iSCSI link should be done before we
give up on an I/O operation), or (b) for some reason we're not
noticing the I/O error and waiting forever.  I believe (a) is more
likely here, but it's possible it's (b).  Do you eventually get file
system I/O errors that abort the journal transaction?  You should...

> 2. "JBD: recovery failed" I reported before.

I've searched my mail archives, and I'm not sure what you're talking
about here.  Maybe this was in an e-mail that you sent that perhaps
got lost?

						- Ted
