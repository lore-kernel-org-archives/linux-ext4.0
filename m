From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Sun, 24 Jul 2016 04:18:22 -0400
Message-ID: <20160724081822.GE10966@thunk.org>
References: <20160717140552.GA11276@thunk.org>
 <20160721202238.GA1514@localhost.localdomain>
 <20160723151026.GD26664@thunk.org>
 <20160723230634.GA3414@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53578 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbcGXIS1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jul 2016 04:18:27 -0400
Content-Disposition: inline
In-Reply-To: <20160723230634.GA3414@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 23, 2016 at 07:06:34PM -0400, Eric Whitney wrote:
> I've tried the image - the awk and quota tools problems are fixed, but the
> missing files in root noted above are still missing.

And that was due to rsync not being available in the build chroot.
I've uploaded a fixed tar.gz file.

Thanks for the feedback!  The armhf build driven from an automated
(and now debugged) build script, so we hopefully won't have any issues
moving forward.

						- Ted
