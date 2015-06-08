From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] rename configure.in to configure.ac
Date: Mon, 8 Jun 2015 10:59:22 -0400
Message-ID: <20150608145922.GA15795@thunk.org>
References: <1432546352-1855-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52992 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbbFHO7Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 10:59:24 -0400
Content-Disposition: inline
In-Reply-To: <1432546352-1855-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 25, 2015 at 05:32:32AM -0400, Mike Frysinger wrote:
> From: Mike Frysinger <vapier@chromium.org>
> 
> Newer versions of autotools have started warning when using the old
> configure.in name.
> 
> Signed-off-by: Mike Frysinger <vapier@chromium.org>

Note that I ship a version of configure (and keep one checked in to
git) because I do not trust the autoconf maintainers' ability to
maintain backwards compatibility, having gotten badly burned in the
past.  I am currently using autoconf 2.69, and people who try to rerun
autoconf on some other version of autoconf are venturing into
unsupported territory.  It may work; it may screw up in amazing ways.
Some autoconf macro may silently assume that some feature is present
when it is not, or vice versa.

And if it breaks, you get to keep both pieces.  :-)

      	      	     	       - Ted
