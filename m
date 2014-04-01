From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fsck.ext4: Memory Allocation Failed
Date: Tue, 1 Apr 2014 16:36:02 -0400
Message-ID: <20140401203602.GC30033@thunk.org>
References: <CAKZK7uwTp2cMoWLiWZSa5UfZ2dCxRaB7KLZ0PtVVSqimp=tLJA@mail.gmail.com>
 <20140401022231.GC4911@thunk.org>
 <CAKZK7uwC=M0F6dtYZXjo6dd9yh=0PObsg5BYvP=UjyN0Pr5H-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Justin Brown <justin.brown@fandingo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48494 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaDAUgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 16:36:06 -0400
Content-Disposition: inline
In-Reply-To: <CAKZK7uwC=M0F6dtYZXjo6dd9yh=0PObsg5BYvP=UjyN0Pr5H-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 01, 2014 at 03:15:54PM -0500, Justin Brown wrote:
> Hi Ted,
> 
> Thanks for the reply. I had to repeat that on a couple other blocks,
> but it seems to work.
> 
> I do have one other question. The fsck has been running for several
> hours now, and while it was fixing lots of errors at the beginning,
> there hasn't been any output from fsck in ~2 hours. I assume that it's
> still on stage 1 block and inode check. There are two interesting
> things. First, memory utilization is 9GiB (not including cache) and
> has been stable for a long time now, which seems quite odd that memory
> utilization has remained so high. Second, I attached strace to the
> fsck process. It's not particularly easy for me to tell what's
> happening, but it seems like fsck is going through every inode doing a
> 4096 write, lseek -4096, read 4096, and then lseek off to some other
> place. I'm surprised that fsck would be doing such a large number of
> writes, especially given that there's no new messages on
> stdout/stderr. It's more like behavior that I would expect from
> defragmentation. Does this seem normal?

What was the last series of messages that you saw?  Was it messages
about Pass 1b / Pass 1c / Pass 1d?

There should have been some console output, though, so the fact that
you're not seeing anything does seem a bit surprising.

       	   	  	   	     - Ted
