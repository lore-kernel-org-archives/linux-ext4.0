From: tytso@mit.edu
Subject: Re: [PATCH V2] fix type of "offset" in ext4_io_end
Date: Fri, 5 Feb 2010 11:34:17 -0500
Message-ID: <20100205163417.GP25885@thunk.org>
References: <4B6327C4.4000100@redhat.com>
 <4B6344E7.9050503@redhat.com>
 <20100205133751.GO25885@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, fmayhar@google.com,
	Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52742 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0BEQeU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2010 11:34:20 -0500
Content-Disposition: inline
In-Reply-To: <20100205133751.GO25885@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 05, 2010 at 08:37:51AM -0500, tytso@MIT.EDU wrote:
> So I was going to submit this patch to Linus, but the last two times
> I've run xfsqa ("xfsqa -g quick" and "xfsqa -g auto"), test #126 has
> failed.  If I run the test stand-alone, it passes.  It's a bit of a
> head-scratcher.  I'm currently backing out the patch and trying to do
> an xfsqa -g auto run to make sure this was something that had crept in
> before applying this patch, so this may very well not be this patch
> --- I certainly can't see anything wrong with it.  But I thought I
> would give a heads up....

Eric and I did more looking at this, and looks like it's a busted
test.  So we're considering this a false alarm for now.

(Safety Pup says: "Null terminate your arguments to fopen!")

	    	  		       - Ted
