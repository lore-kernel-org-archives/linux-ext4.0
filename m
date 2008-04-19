From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
	checker)
Date: Fri, 18 Apr 2008 21:29:52 -0400
Message-ID: <20080419012952.GE25797@mit.edu>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdev@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65049 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbYDSBbF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 21:31:05 -0400
Content-Disposition: inline
In-Reply-To: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 18, 2008 at 06:20:14PM +0400, Alexey Zaytsev wrote:
> Hello, guys.
> 
> It seems like the Linux-fountation was not able to find a mentor for
> my project. If somebody is willing to mentor this project through the
> Google Summer of Code, please contact Rik and me now, as little
> time is left.
> 
> A link to the application:
> http://rom.etherboot.org/share/xl0/gsoc2008/application-linux-foundation.txt

Hi Alexey,

I really don't think your project is likely to be successful given the
3 month timeframe of a GSoC.  At least not without a mentor spending
vast amounts of time educating you about how things works within ext2
and e2fsck.  Even given some broad hints about problems that you need
to address, you still have not addressed how you will solve
fundamental race conditions resulting from trying to read the multiple
blocks scattered all over the disk which comprise allocation bitmap
blocks while allocations might be taking place, for example.

Your approach of monitoring writes to the buffer cache for metadata
writes is completely busted; suppose the kernel modifies block #12345
in the filesystem; how do you know what that means?  Could that be an
indirect block?  If so, to which inode does it belong?  If all you are
doing is monitoring metadata blocks, you would have no idea!  The fact
that it apparently didn't even occur to you that this might be a
show-stopping problem scares the heck out of me.  It leads me to
believe that this project is very likely to fail, and/or will require
vast amounts of time from the mentor.  Unfortunately, the former is
something that I just don't have this summer.

Regards,

						- Ted
