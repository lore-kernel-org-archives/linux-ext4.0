From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: linux ext filesystem errors
Date: Sun, 20 Oct 2013 11:24:37 -0400
Message-ID: <20131020152437.GA21285@thunk.org>
References: <l40job$n86$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Markus Moeller <huaraz@moeller.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48233 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab3JTPYn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Oct 2013 11:24:43 -0400
Content-Disposition: inline
In-Reply-To: <l40job$n86$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's not clear how or why e2fsck is getting killed, so it's hard to
say.  It could be bug in e2fsck; or it could be any number of things.
If you're willing to compile your own version of e2fsprogs, it would
be great to download the latest e2fsprogs git tree, use the maint
branch, and then build the latest version of e2fsck, which by default
will come with debugging enabled, and see if you can replicate the
failure using the latest version of e2fsck.  (1.42.6 is a bit old, so
it might not be applicable with the latest version; I also don't know
how your distro might have compiled e2fsprogs).

If you can still get it to fail, it would be good to run it under gdb
so we can see the stack trace when it got killed.  Also, if you can
grab a raw e2image dump while the file system is unmounted, that could
be useful for us to try to debug what is going on.

Regards,

						- Ted
