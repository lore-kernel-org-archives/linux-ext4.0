From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Thu, 23 Dec 2010 17:47:40 -0500
Message-ID: <20101223224740.GE12763@thunk.org>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
 <AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
 <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
 <4D0A7278.3080506@gmail.com>
 <1292710543.17128.14.camel@nayuki>
 <AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
 <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
 <20101223224309.GH18264@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60862 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0LWWrp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Dec 2010 17:47:45 -0500
Content-Disposition: inline
In-Reply-To: <20101223224309.GH18264@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 24, 2010 at 09:43:09AM +1100, Dave Chinner wrote:
> 
> So you are looking for something like:
> 
> http://developer.apple.com/library/mac/#DOCUMENTATION/Darwin/Reference/ManPages/man2/exchangedata.2.html
> 

It doesn't look like the man page for exchangedata() states what
happens if the system crashes.  It says "atomic" the same way the
rename() system call says it is "atomic".... i.e., from the
perspective of processes running on the system see either the
pre-exchange or post-exchange state.

						- Ted
