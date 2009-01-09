From: Theodore Tso <tytso@mit.edu>
Subject: Re: [ltt-dev] Fw: [PATCH] ext4: Add markers for better
	debuggability
Date: Fri, 9 Jan 2009 13:58:40 -0500
Message-ID: <20090109185840.GD23869@mit.edu>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33274 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZAIS6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2009 13:58:45 -0500
Content-Disposition: inline
In-Reply-To: <20090109144901.GA7262@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 09, 2009 at 09:49:01AM -0500, Mathieu Desnoyers wrote:
> 
> Given this is meant to be in the mainline kernel, using tracepoints
> rather than markers would be more appropriate. Please see
> Documentation/tracepoints.txt and samples/tracepoints/ for details.

I saw that, but I'm still not sure how I would actually *use*
tracepoints.  I can use markers today with Systemtap, and I need an
easy way to be able to selectively do things like "trap and print all
of the logged data when the ext4_request_inode tracepoint/marker is
tripped where dev=='dm-8'".

Unfortunately, Systemtap seems doomed given its current course and
direction, so I'm not opposed to moving to another solution --- I just
need a HOWTO that demonstrates how I can do this painlessly and
easily; preferably without having me have to manually hack up a kernel
module each time I want to implement the tracing

Is there an easy way to do that using ltt today?  Can you point me at
a sample of how this could be done?

						- Ted
