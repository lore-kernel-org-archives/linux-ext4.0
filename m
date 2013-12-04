From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfs over thin provisioning talk
Date: Tue, 3 Dec 2013 22:23:51 -0500
Message-ID: <20131204032351.GC15658@thunk.org>
References: <20131202165611.GA23816@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36258 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3LDDXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 22:23:53 -0500
Content-Disposition: inline
In-Reply-To: <20131202165611.GA23816@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 02:56:12PM -0200, Carlos Maiolino wrote:
> Hi guys,
> 
> Lukas told me that some guys here might be interested in a talk I did at LPC
> 2013 about XFS using dm-thin module.
> 
> For those interested, the slides can be downloaded here:
> http://people.redhat.com/~cmaiolin/talks/XFS-dmthin.pdf

Hi Carlos,

Thanks for sending these slides.  They are very interesting indeed.

Lukas mentioned that you had run some tests using ext4 and it didn't
do well at all using dm-thin?  Given that we're not doing proper raid
strip alignment in our allocation decisions, that's not too
surprising, but it would be useful if there are other things that we
should do in order to do a better job working with dm-thin drives.

One other question --- in your conclusion you say:

   Bypassing block zeroing while provisioning blocks adds a significant
   boost to the dm-thin performance, but, it can induce a security
   breach, at the risk of exposing stale data

This might be true if you are directly giving dm-thin volumes to
mutually suspicious VM's with different trust boundaries.  But if you
trust the file system, and the dm-thin devices are mediated by the a
file system running in the same context as the dm-thin volumes, there
wouldn't be any security issue, correct?

Cheers,

					- Ted
