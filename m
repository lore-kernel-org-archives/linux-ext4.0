From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Mon, 28 Jul 2014 11:11:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407281107530.2077@localhost.localdomain>
References: <loom.20140727T010632-633@post.gmane.org> <20140727000733.GV6725@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vlad Dobrotescu <vlad@dobrotescu.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbaG1JL5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 05:11:57 -0400
In-Reply-To: <20140727000733.GV6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 26 Jul 2014, Theodore Ts'o wrote:

> Date: Sat, 26 Jul 2014 20:07:33 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Vlad Dobrotescu <vlad@dobrotescu.ca>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Question: errors=continue behaviour for failed external journal
>     device
> 
> On Sat, Jul 26, 2014 at 11:07:59PM +0000, Vlad Dobrotescu wrote:
> > If this isn't the proper place for this question, please point me in 
> > the right direction.
> > 
> > I couldn't find any description on Ext4's behaviour when mounted 
> > with errors=continue and external journal if the journal block device 
> > is unavailable at mount time (or becomes unavailable at some point).
> > 
> > I would be using CentOS 7 (kernel 3.10.0-123.4.4.el7 x86_64) and 
> > (probably) full data journaling on a SSD. Can someone help?
> 
> So there are two different questions.
> 
> If you use errors=continue, there is the chance that the file system
> inconsistencies that discovered could cause further file system
> damage, which might lead to the loss or corruption of data files
> written earlier.  So it's not really recommended for most purposes,

I very much agree with that, that's why I was quite surprised that I
found out recently that this is the default. I was living in the
delusion that the default was ERRORS_RO for as long as I can remember.
So my question is, should we change it ? This really does not seem
like a sane default.

Thanks!
-Lukas

> unless you have some scheme where you are monitoring dmesgs and having
> some strategy to deal with detected file system errors, or when the
> system absolutely, positively must continue running, and this is more
> important than potential data loss. 
> 
> If the journal block device is not present then the file system can't
> be mounted, and if the system was uncleanly shut down you won't be
> able to recover from the unclean shutdown by replaying the journal.
> 
> If the journal block device is *gone*, it is possible to remove the
> external journal block device, and then force a file system repair,
> but if this happens after an unclean shutdown, you may very well lose
> data.
> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
