From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 09:34:47 -0400
Message-ID: <20090824133447.GH23677@mit.edu>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Fischer <Christian.Fischer@easterngraphics.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33306 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZHXNeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 09:34:50 -0400
Content-Disposition: inline
In-Reply-To: <200908241033.10527.Christian.Fischer@easterngraphics.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 10:33:10AM +0200, Christian Fischer wrote:
> I try to figure out reasonable mount options for ext4.
> 
> I've seen a "Enable asynchronous commits by default" patch from Sun, 21 Sep 
> 2008.
> 
> Why is it revoked?

It patch was never merged because the ayschronous commits feature
disabled all write barriers, so under heavy workloads a power failure
could cause data loss.

No one has gotten around to looking at this closely; I think adding a
strategically placed blkdev_issue_flush() will allow us to safely
enable this feature, but it needs careful study.

Thanks for reminding us about this bit of unfinished business.  I'll
put it back on our todo list, where it had fallen off.  For now, it's
not safe to use, which is why it's not enabled by default.

    	    	       	      	       	       - Ted
