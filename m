From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 df regression introduced by commit 9d0be50
Date: Thu, 20 May 2010 18:11:21 +0200
Message-ID: <20100520161121.GB28963@atrey.karlin.mff.cuni.cz>
References: <20100510180531.GA13538@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bruce Guenter <bruce@untroubled.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47985 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752691Ab0ETQLm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 12:11:42 -0400
Content-Disposition: inline
In-Reply-To: <20100510180531.GA13538@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I think I have found a regression introduced by commit 9d0be50 "ext4:
> Calculate metadata requirements more accurately".
  Thanks for report!

> I am using ext4 on a NFSv4 server running unpatched kernel 2.6.33.3.
> The client is currently running unpatch 2.6.33.3, although I also saw
> the problem with the client running 2.6.32.10.
> 
> The output from 'df' on the client varies wildly in the presence of
> certain writes.  I have not pinned down an exact write pattern that
> causes it, but I do have an application that causes it fairly reliably.
> When the bug happens, I see swings like this:
> 
> Sun May  9 23:04:58 2010 blocks=961173888 available=28183168
> Sun May  9 23:04:59 2010 blocks=961173888 available=12823424
> Sun May  9 23:05:00 2010 blocks=961173888 available=28183040
> 
> (produced by a script that checks statvfs output every second; units are
> kB, df output is effectively identical)
  Hmm, I'm not seeing anything obviously wrong with that patch but
apparently the number of blocks reserved for delayed allocation is
miscomputed by a lot...
  Is your ext4 filesystem create from scratch or converted from ext3? Is
your application using lots of different files or rather a couple of small
ones? Anyways a reproducing program would be the best in this case...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
