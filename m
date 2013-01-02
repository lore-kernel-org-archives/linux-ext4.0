From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs update
Date: Wed, 2 Jan 2013 10:27:57 -0500
Message-ID: <20130102152757.GA17448@thunk.org>
References: <nsxpq1ol123.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41337 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3ABP2A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 10:28:00 -0500
Content-Disposition: inline
In-Reply-To: <nsxpq1ol123.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 01, 2013 at 10:24:20PM -0500, Theodore Ts'o wrote:
> 
> One known issue.  There still seems to be some resize2fs problems when
> the 64-bit feature is set when doing off-line (unmounted) resizing.

One thought.... since the problems are limited to issues with the bg
accounting and block bitmap, one hack we could do if we can't figure
out the bug sooner enough would be to throw in a check where if we are
doing an off-line resize with 64-bit filesystems, to mark the file
system has needing an fsck and requesting the user to run fsck before
using the file system.

It's ugly, and it will screw up programs like parted which invoke
resize2fs, but (a) it's better what happens if people try using
resize2fs with 64-bit file systems with current versions of e2fsprogs,
and (b) at least online resizing with 64-bit file systems works
(assuming you have a sufficiently new kernel).

Not something I want to do, but if it takes too long to track down
these last defects with resize2fs, I'd rather get 1.42.7 out the door
sooner rather later, given the other known bugs in resize2fs and
e2fsck which are unfixed in 1.42.6 and earlier versions (see the
updated RELEASE-NOTES for more details).

						- Ted
