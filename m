From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] e2fsprogs: Update man pages, usage texts, and docs.
Date: Thu, 14 Dec 2017 12:24:33 -0500
Message-ID: <20171214172433.i5hny5mt2j653zer@thunk.org>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45654 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753412AbdLNRYg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Dec 2017 12:24:36 -0500
Content-Disposition: inline
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 13, 2017 at 11:13:08PM -0800, Tyson Nottingham wrote:
> These patches add missing feature descriptions and command arguments to
> man pages and usage texts. They also fix some minor typos.

Thanks so much for working on the e2fsprogs documentation!  It is an
often an underappreciated work, and I'm glad to have someone working
to improve the documentation.

> The patches are based off of the master branch of e2fsprogs. Should I be
> working from a different branch? Also, I did not update any of the
> localization files. Do I need to worry about handling that?

The maint branch corresponds to the 1.43.x release series, and the
master and next branches present what will (soon) become the 1.44(.x)
release.  There will be at least one more 1.43.x release before I
release 1.44, so it's not that of an issue.

I can handle trying to apply these patches to the maint branch,
pulling out the feature improvements that only appear in the master
branch and applying that in a separate patch for the master branch.
But in the future, it would be preferable for bug fixes and doc fixes
to be done against the maint branch (if applicable).  The master/next
branch will get fixes via git merges.

Cheers,

					- Ted
