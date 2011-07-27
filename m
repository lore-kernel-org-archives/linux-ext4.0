From: NeilBrown <neilb@suse.de>
Subject: Re: RCU locking issues in jbd2_dev_to_name
Date: Thu, 28 Jul 2011 08:45:31 +1000
Message-ID: <20110728084531.06aa878a@notabene.brown>
References: <20110727174104.65fb9c1c@notabene.brown>
	<7A69E96B-0763-4440-BE10-A39B808C44FA@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab1G0Wpo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 18:45:44 -0400
In-Reply-To: <7A69E96B-0763-4440-BE10-A39B808C44FA@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 27 Jul 2011 07:28:27 -0400 Theodore Tso <tytso@MIT.EDU> wrote:

> 
> On Jul 27, 2011, at 3:41 AM, NeilBrown wrote:
> 
> > 
> > 
> > Hi Ted and all,
> > 
> > I've been exploring RCU usage in the kernel looking for strange things, and
> > jbd2_dev_to_name looks particularly strange.  The following patch explains
> > and addresses the issues that I found.  Comments welcome.
> 
> Yeah its broken.  But I have patches pending for the merge window that solve
> it by nuking the function altogether; the problem is calling a function from
> TP_PRINTK causes perf to die on the spot, terminating its tracing.  :-(
> 

Sounds painful...

If it is about to go, that is good enough for me.

Thanks,
NeilBrown
