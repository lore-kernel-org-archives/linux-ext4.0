From: Theodore Tso <tytso@mit.edu>
Subject: Re: Preparing to push patches for the merge window
Date: Fri, 18 Sep 2009 13:54:24 -0400
Message-ID: <20090918175424.GG26991@mit.edu>
References: <E1MmDzB-000357-Po@closure.thunk.org> <1252938276.4920.11.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33120 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413AbZIRRyZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 13:54:25 -0400
Content-Disposition: inline
In-Reply-To: <1252938276.4920.11.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2009 at 07:24:36AM -0700, Mingming wrote:
> On Fri, 2009-09-11 at 17:48 -0400, Theodore Ts'o wrote:
> > See below for a list for what I currently have in the ext4 patch queue.
> > 
> > Patches which are NOT yet included are:
> > 
> > o  Mingming's Fallocate / Direct I/O patches.
> > 
> > 	Mingming, it looked like you were still polishing these two
> > 	patches?
> 
> Yeah, the aio fsync issue is till being working on. I also have some
> issue with using igrab/iput to hold the inode in cache. 

Hi Mingming,

Any news on the Direct I/O patches?  I pushed a large set of patches
to Linus today, but I'll try to assemble a set of patches that can be
tested and qualified to Linus towards the end of the merge window.

Thanks,

						- Ted
