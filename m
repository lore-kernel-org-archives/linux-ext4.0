From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_bread usage audit
Date: Thu, 27 Sep 2012 09:20:26 -0400
Message-ID: <20120927132026.GA30464@thunk.org>
References: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52681 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab2I0NUb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 09:20:31 -0400
Content-Disposition: inline
In-Reply-To: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.

I fixed it the commit description so it was correctly word wrapped and
to make the English easier to read.  Also, I fixed up a missing check
at the beginning of dx_probe() where a check was missing:

	if (!(bh = ext4_bread(NULL, dir, 0, 0, err))) {
		if (*err == 0)
			*err = ERR_BAD_DX_DIR;
		goto fail;
	}

Thanks for the patch!!

							- Ted

ext4: ext4_bread usage audit

When ext4_bread() returns NULL and err is set to zero, this means
there is no phyical block mapped to the specified logical block
number.  (Previous to commit 90b0a97323, err was uninitialized in this
case, which caused other problems.)

The directory handling routines use ext4_bread() in many places, the
fact that ext4_bread() now returns NULL with err set to zero could
cause problems since a number of these functions will simply return
the value of err if the result of ext4_bread() was the NULL pointer,
causing the caller of the function to think that the function was
successful.

Since directories should never contain holes, this case can only
happen if the file system is corrupted.  This commit audits all of the
callers of ext4_bread(), and makes sure they do the right thing if a
hole in a directory is found by ext4_bread().

Some ext4_bread() callers did not need any changes either because they
already had its own hole detector paths.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
