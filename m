From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 21:04:01 -0400
Message-ID: <20120320010401.GA14363@thunk.org>
References: <20120319153133.GA2502@thunk.org>
 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
 <20120319161425.GB2502@thunk.org>
 <20120319.141402.934377752041508724.davem@davemloft.net>
 <20120319183126.GA6031@thunk.org>
 <1332182773.3908.11.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46939 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab2CTBEI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:04:08 -0400
Content-Disposition: inline
In-Reply-To: <1332182773.3908.11.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 11:46:13AM -0700, Joe Perches wrote:
> On Mon, 2012-03-19 at 14:31 -0400, Ted Ts'o wrote:
> > On Mon, Mar 19, 2012 at 02:14:02PM -0400, David Miller wrote:
> > I've *already* gone far beyond the pr_fmt standardization, with the
> > ext4_msg() and ext4_error() system
> 
> Please note the defects that were recently corrected there
> which occurred because of a lack of standardization both
> in prefix and termination style.

For debugging printk's that are #ifdef'ed for anyone other than ext4
developers and can't be enabled via CONFIG_*.  Yawn.

> Any logging system, with or without an external notification
> mechanism, will be painful.  pr_<foo> is at least a small
> start.  I'd like to see a notification mechanism, perhaps ala
> netlink/ethtool to extend pr_<foo> or another call.  A lot of
> these printk/pr_<level> uses really could generate notifications.

Yes, but we can't do structured notifications with the current
pr_<foo>.  So why change literally tens of thousands of callsites when
in order to really realize the full promise of structured
notifications, we'll have to change them *again*?

	       	     	     	    	 - Ted
