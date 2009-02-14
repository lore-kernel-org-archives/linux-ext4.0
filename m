From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 20:50:18 -0500
Message-ID: <20090214015018.GB26628@mini-me.lan>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090213220606.AE8FC11D109@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40120 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZBNCH0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 21:07:26 -0500
Content-Disposition: inline
In-Reply-To: <20090213220606.AE8FC11D109@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Patch from Aneesh, un-whitespace-mangled.
> 
> Ted, can you push this out?  Works great.  :) We might want to ask
> the other reporter of something similar (next-20090206: deadlock on
> ext4) to test it too.  I'll ping him.

Do we completely understand the root cause, in terms of which commit
broken the mm/page-writeback.c code we were depending on?  And if so,
what of the code in mm/page-writeback.c?  Does anyone else use it?
Can anyone sanely use it?

And am I right in assuming that this only applies to 2.6.29-rcX
kernels, and is not needed for 2.6.28 or earlier kernels?

I hadn't yet pushed it out because I needed time to understand all of
these issues, hence these questions....

						- Ted

