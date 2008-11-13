From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 unlink performance
Date: Thu, 13 Nov 2008 15:42:40 -0500
Message-ID: <20081113204240.GF21652@mit.edu>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36260 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbYKMUmm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:42:42 -0500
Content-Disposition: inline
In-Reply-To: <20081113191000.GA11516@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:10:00PM -0600, Bruce Guenter wrote:
> On Thu, Nov 13, 2008 at 12:57:12PM -0600, Bruce Guenter wrote:
> > Ouch.  Why is ext4 so much slower than ext3 here,
> 
> I forgot to mention one important detail.  I started running 'vmstat 5'
> during one of the unlink runs, and noticed that there were intervals of
> 15 or 20 seconds where no blocks were being read or written, and minimal
> CPU was being used.  I do not observe the same stalls when using ext3.

Hmm... how very strange.  Can you run the command:

       ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:16,comm

during one of the quiescent periods, and see what is in the WCHAN
field for the unlink command?

						- Ted
