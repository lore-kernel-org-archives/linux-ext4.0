From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: check if device support discard in FITRIM
 ioctl
Date: Wed, 23 Feb 2011 12:50:23 -0500
Message-ID: <20110223175023.GN2924@thunk.org>
References: <1297789585-5986-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32864 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab1BWRu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 12:50:26 -0500
Content-Disposition: inline
In-Reply-To: <1297789585-5986-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 06:06:24PM +0100, Lukas Czerner wrote:
> Right now we, are relying on the fact that when we attempt to actually do
> the discard, blkdev_issue_discar() returns -EOPNOTSUPP and the user is
> informed that the device does not support discard.
> 
> However, in the case where the we do not hit any suitable free extent to
> trim in FITRIM code, it will finish without any error. This is very
> confusing, because it seems that FITRIM was successful even though the
> device does not actually supports discard.
> 
> Solution: Check for the discard support before attempt to search for
> free extents.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Added to the ext4 patch queue, but I rewrote the commit description to
make it more understable.

						- Ted

ext4: check if device support discard in FITRIM ioctl

From: Lukas Czerner <lczerner@redhat.com>

For a device that does not support discard, the FITRIM ioctl returns
-EOPNOTSUPP when blkdev_issue_discard() returns this error code, which
is how the user is informed that the device does not support discard.

If there are no suitable free extents to be trimmed, then FITRIM will
return success even though the device does not support discard, which
could confuse the user.  So check explicitly if the device supports
discard and return an error code at the beginning of the FITRIM ioctl
processing.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
