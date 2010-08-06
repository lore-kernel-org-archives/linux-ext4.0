From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Crash after umount'ing a disconnected disk (Re: extfs
 reliability)
Date: Fri, 6 Aug 2010 14:10:42 -0400
Message-ID: <20100806181042.GB24583@thunk.org>
References: <20100804180325.GL9453@thunk.org>
 <4C5B1137.1070001@vlnb.net>
 <20100805211758.GA12358@thunk.org>
 <4C5C0CE2.7030009@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52535 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0HFSKp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 14:10:45 -0400
Content-Disposition: inline
In-Reply-To: <4C5C0CE2.7030009@vlnb.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 06, 2010 at 05:23:46PM +0400, Vladislav Bolkhovitin wrote:
> >>
> >>1. A bunch of detected hung tasks with call traces.
> >>
> >
> >Do you eventually get file
> >system I/O errors that abort the journal transaction?  You should...
> 
> Yes, as you can see in the previously attached log.

OK, so what are you complaining about?  This is *normal*.  You can
change how long the kernel will wait before printing the warnings, by
adjusting /proc/sys/kernel/hung_task_timeout_secs, but the fact that
you're getting the detected hung tasks is the system performing as
designed.

> >>2. "JBD: recovery failed" I reported before.
> >
> >I've searched my mail archives, and I'm not sure what you're talking
> >about here.  Maybe this was in an e-mail that you sent that perhaps
> >got lost?
> 
> It's next to the message on which you originally replied. It was
> about ext3, but this time I saw it with ext4.

Can you resend, and with a new and specific subject line that is
helpful for finding it, and just that one message?  Sorry, but I get
literally hundreds, and some days over a thousand, e-mails a day, and
that doesn't include e-mails which get caught in spam traps....

     	     	     	     	       	      - Ted
