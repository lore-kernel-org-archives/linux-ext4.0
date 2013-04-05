From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Date: Fri, 5 Apr 2013 19:16:35 -0400
Message-ID: <20130405231635.GA6521@thunk.org>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130402151436.GC31577@thunk.org>
 <20130403101925.GA7341@suse.de>
 <515F4DA3.2000000@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59685 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321Ab3DEXRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 19:17:23 -0400
Content-Disposition: inline
In-Reply-To: <515F4DA3.2000000@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 06, 2013 at 12:18:11AM +0200, Jiri Slaby wrote:
> Ok, so now I'm runnning 3.9.0-rc5-next-20130404, it's not that bad, but
> it still sucks. Updating a kernel in a VM still results in "Your system
> is too SLOW to play this!" by mplayer and frame dropping.

What was the first kernel where you didn't have the problem?  Were you
using the 3.8 kernel earlier, and did you see the interactivity
problems there?

What else was running in on your desktop at the same time?  How was
the file system mounted, and can you send me the output of dumpe2fs -h
/dev/XXX?  Oh, and what options were you using to when you kicked off
the VM?

The other thing that would be useful was to enable the jbd2_run_stats
tracepoint and to send the output of the trace log when you notice the
interactivity problems.

Thanks,

						- Ted
