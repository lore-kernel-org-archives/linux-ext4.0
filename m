From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Which newer kernel is OK with ext4?
Date: Fri, 5 Jun 2015 10:30:21 -0400
Message-ID: <20150605143021.GB26550@thunk.org>
References: <mknlqf$m5d$1@ger.gmane.org>
 <20150604020852.GB5759@thunk.org>
 <mkpljk$al6$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49628 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbFEOaW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 10:30:22 -0400
Content-Disposition: inline
In-Reply-To: <mkpljk$al6$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2015 at 03:59:16PM +0200, U.Mutlu wrote:
> I have many times compiled a kernel and used it successfully,
> but when I dist-upgraded from Debian 7 to Debian 8 it installed
> it's own stock kernel maintained by Debian. No problem to switch
> to a newer kernel from kernel.org, but for me it was unclear
> if and how the ongoing ext4-developments will have an impact on
> existing ext4-partitions. Now I think everything is clear, I'll
> take a newer kernel from kernel.org.

Many Linux kernel developers use at least one or more ext4 file
systems, and they would be very cranky if things became unstable.  As
a result, we are regularly running regression tests to make sure we
don't break ext4 users.

This principle holds true for all open source projects, at those with
responsible developers.  Emacs is constantly adding features --- would
that lead you to be concerned after upgrading to Debian 8 that you
shouldn't use a new release of emacs because it might corrupt your
source files in the course of using it in normal operations, and send
e-mail to the emacs developer's list asking if it's safe to use "the
new emacs"?

Regards,

						- Ted

P.S.  There was a typo in my previous message.  To be clear, 4.0 is
**NOT** is not a long-term supported kernel.  (My previous e-mail
omitted the "not".)
