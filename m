From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v4 6/6] Add project ID support for chattr/lsattr
Date: Sun, 6 Mar 2016 00:56:45 -0500
Message-ID: <20160306055645.GL10297@thunk.org>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
 <1457237696-13770-7-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36972 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbcCFF4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 00:56:48 -0500
Content-Disposition: inline
In-Reply-To: <1457237696-13770-7-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'll take a closer look at the changes in your v4 patchset over v3,
but the f[sg]etproject.c files I put together are better in that they
are more portable for non-Linux architectures, so I think I'm going to
keep my version.

I'll push out an updated e2fsprogs git tree on Monday, and at that
point if you have any questions about the integration work I did, or
you have any other bugs, let's handle them as patches against the
updated next branch.

Cheers,

						- Ted
