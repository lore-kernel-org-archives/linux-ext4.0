From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: don't require fsck to print min size
Date: Sun, 14 Dec 2014 19:12:06 -0500
Message-ID: <20141215001206.GS29787@thunk.org>
References: <5488649C.8020809@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55732 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaLOAMJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 19:12:09 -0500
Content-Disposition: inline
In-Reply-To: <5488649C.8020809@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 10, 2014 at 09:19:56AM -0600, Eric Sandeen wrote:
> My previous change ended up requiring that the filesystem
> be fsck'd after the last mount, even if we are only querying
> the minimum size.  This is a bit draconian, and it burned
> the Fedora installer, which wants to calculate minimum size
> for every filesystem in the box at install time, which in turn
> requires a full fsck of every filesystem.
> 
> Try this one more time, and separate out the tests to make things
> a bit more clear.  If we're only printing the min size, don't
> require the fsck, as this is a bit less dangerous/critical.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied with a minor whitespace fixup, thanks.

				- Ted
