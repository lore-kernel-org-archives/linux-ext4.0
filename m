From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debugfs: dump a sparse file as a new sparse file
Date: Tue, 1 Jan 2013 17:47:40 -0500
Message-ID: <20130101224740.GD12554@thunk.org>
References: <20130101205709.GC12554@thunk.org>
 <20130101212504.11364.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gnehzuil.liu@gmail.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41245 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab3AAWrp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jan 2013 17:47:45 -0500
Content-Disposition: inline
In-Reply-To: <20130101212504.11364.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 01, 2013 at 04:25:04PM -0500, George Spelvin wrote:
> 
> That's a good enough reason; my only remaining objection is calling it
> "a non-standard/non-portable GCC extension".

Fair enough.  Basically, e2fsprogs is targetting C89, and with the
exception of inline functions (which is optional; e2fsprogs will build
on compilers which don't handle inline functions, and it's only
recently that I switched us over to use C99 inline functions instead
of the old gcc's gnu89 inline declarations), as far as I know we're
not dependent on any C99 language features.

Because I tend to use a very conservative coding standard for
porability's sake, I sometimes lose track of what's actually allowed
by C99, and what's a GCC extension.

BTW, I'll note that in C11 (ISO/IEC 9899:2011), VLA's have been made
**optional**.  Hence, even for programs targetting C11-compliant
compilers, it's still not a good idea to use VLA's in your code if you
are striving for maximal portability.

Regards,

	      		      	    	 - Ted
