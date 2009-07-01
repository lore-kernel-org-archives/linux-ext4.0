From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:
	libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 17:43:45 -0400
Message-ID: <20090701214345.GG17054@mit.edu>
References: <200905311113.23004.arvidjaar@mail.ru> <20090601124857.GF31943@mit.edu> <20090603085140.GA4060@nb.net.home> <1244021945.4120.4.camel@quest> <20090628133430.GA3594@mit.edu> <ac3eb2510906300317q3997f283p80248e44b0c5133d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:32819 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZGAVnx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2009 17:43:53 -0400
Content-Disposition: inline
In-Reply-To: <ac3eb2510906300317q3997f283p80248e44b0c5133d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 30, 2009 at 12:17:02PM +0200, Kay Sievers wrote:
> 
> And another thing is your custom "silent build" which can not be
> disabled. Our build system requires the command output for fancy
> analysis, so it would be good if it could be disabled, like it can for
> the kernel (V=1). Any ideas, or do I miss some switch?
> 

Is a configure-level switch all that you need?  I hadn't done a
make-level switch because I was trying to avoid adding a requirement
of using GNU make in building e2fsprogs, since it gets used by *BSD
and Solaris systems as well.  (And in fact some of the recent UUID bug
fixes come from FreeBSD bug reports, and I suspect FreeBSD will
continue to use UUID library from e2fsprogs rather than pulling in
util-linux-ng....)

						- Ted

			
