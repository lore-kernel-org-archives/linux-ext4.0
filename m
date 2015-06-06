From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic question: user-only directory w/o root access
Date: Sat, 6 Jun 2015 11:42:09 -0400
Message-ID: <20150606154209.GA15306@thunk.org>
References: <mkfbkb$fo1$1@ger.gmane.org>
 <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org>
 <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org>
 <20150605141429.GA26550@thunk.org>
 <mkst24$nbb$1@ger.gmane.org>
 <20150606003323.GC26550@thunk.org>
 <mku6uc$kb2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51021 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbbFFPmQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Jun 2015 11:42:16 -0400
Content-Disposition: inline
In-Reply-To: <mku6uc$kb2$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 06, 2015 at 09:19:40AM +0200, U.Mutlu wrote:
> I posted hello.c (a FUSE demo) in this thread. It is IMO even more secure
> than the private namespace mount method. The simple reason is:
> because granting access to the volume (or to a single dir/file)
> is done inside that user-code itself, ie. the user/owner controls
> whom he actually gives access.
> I'm sorry to say this, but this simply proves your last statement above wrong.

So the root user ptraces the FUSE daemon, and it's all she wrote.

							- Ted
