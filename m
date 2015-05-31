From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic question: user-only directory w/o root access
Date: Sun, 31 May 2015 14:59:34 -0400
Message-ID: <20150531185934.GE11642@thunk.org>
References: <mkfbkb$fo1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39524 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbbEaS7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 14:59:37 -0400
Content-Disposition: inline
In-Reply-To: <mkfbkb$fo1$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 31, 2015 at 06:07:38PM +0200, U.Mutlu wrote:
> how can a non-root user have a directory of his own, without any root access?
> Is this somehow possible, or will it be made possible with the new ext4 (ext5?)?

You're not going a lot of details about exactly what the use case you
have in mind; are you talking about a non-root user creating a file
system which then gets mounted somwhere?  In practice you still need
root to do the mount, or at the very least to set up the /etc/fstab to
allow a non-root user to mount a file system at a particular mount
point.

If it's the latter which you are envisioning, then the root_owner
extended option to mke2fs(8) may be what you're looking for.

If it isn't please go into a much greater detail about what exactly it
is you are trying to do, and why.

Regards,

					- Ted
