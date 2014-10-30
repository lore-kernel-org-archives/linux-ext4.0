From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Wed, 29 Oct 2014 21:44:06 -0400
Message-ID: <20141030014405.GE5000@thunk.org>
References: <54415991.1070907@pavlinux.ru>
 <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com>
 <544940EF.7090907@windriver.com>
 <alpine.DEB.2.11.1410261516020.5308@nanos>
 <544E7144.4080809@windriver.com>
 <alpine.DEB.2.11.1410291854090.5308@nanos>
 <54513BDA.1050804@windriver.com>
 <alpine.DEB.2.11.1410292013510.5308@nanos>
 <20141029231916.GD5000@thunk.org>
 <54517A1F.1060102@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	rt-users <linux-rt-users@vger.kernel.org>
To: Chris Friesen <chris.friesen@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52042 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbaJ3BoZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Oct 2014 21:44:25 -0400
Content-Disposition: inline
In-Reply-To: <54517A1F.1060102@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 29, 2014 at 05:37:03PM -0600, Chris Friesen wrote:
> 
> 1) Is this something that could hit mainline as well, or just the RT kernel?

Yes, it could hit the mainline as well.  It's more about the workload
and how the files are written to and/or sync'ed.

> 2) If it can hit mainline, is this something that should be considered for
> the various longterm-support kernels?  (3.10, maybe 3.4)

Yes, probably.

> 3) For 3.4, do you think that it's sufficient to backport the three commits
> I mentioned, or are you aware of others that I should be looking at as well?

No, those three commits would be quite sufficient.  If you could
handle doing the backports, I would greatly appreciate it!  Sounds
like you've done so for 3.4 already, and it should be fairly
straightforward to get them into 3.10, since b34090e landed in 3.11.

Thanks,

						- Ted







