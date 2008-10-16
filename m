From: mspang@csclub.uwaterloo.ca (Michael Spang)
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 11:33:00 -0400
Message-ID: <20081016153300.GA15313@csclub.uwaterloo.ca>
References: <20081016070735.GA28486@csclub.uwaterloo.ca> <20081016143035.GA10825@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39797 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYJPPdB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 11:33:01 -0400
Content-Disposition: inline
In-Reply-To: <20081016143035.GA10825@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 10:30:35AM -0400, Theodore Tso wrote:
> On Thu, Oct 16, 2008 at 03:07:35AM -0400, Michael Spang wrote:
> > I switched my laptop over to ext4 yesterday. Then I used tune2fs to
> > enable the features from mke2fs.conf's defaults for ext4 (some failed).
> > 
> > It worked fine initially but today I am getting a panic when the machine
> > boots: http://csclub.uwaterloo.ca/~mspang/panic.jpg .
> > 
> > Let me know if there's anything I can do to rescue it. Otherwise I'll
> > just reinstall.
> 
> What version of the kernel are you using, and what patches (if any)
> have you installed?  Are you using a distribution kernel?
> 
> 							- Ted

Linus' head as of 2 days ago, at
278429cff8809958d25415ba0ed32b59866ab1a8. I looked at your
tree yesterday and saw that nothing had been applied since.

Merging the patch queue a moment ago made no interesting changes.

Thanks,
Michael Spang
