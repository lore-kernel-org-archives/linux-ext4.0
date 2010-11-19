From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 10:41:19 -0500
Message-ID: <20101119154119.GF10039@thunk.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56221 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0KSPlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 10:41:21 -0500
Content-Disposition: inline
In-Reply-To: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 08:36:48AM +0100, Lukas Czerner wrote:
> There was concern that FITRIM ioctl is not common enough to be included
> in core vfs ioctl, as Christoph Hellwig pointed out there's no real point
> in dispatching this out to a separate vector instead of just through
> ->ioctl.
> 
> So this commit removes ioctl_fstrim() from vfs ioctl and trim_fs
> from super_operation structure.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Trying to redirect this thread back to the original patches....

What do people think?  Should I try to push these two patches to Linus
now, to make it easier for other file systems who might be interested
in implementing FITRIM functionality?

Or should I wait until the 2.6.37-rc1 window?

We're at -rc3, so a change like this is a bit late, but so far no one
else is using trim_fs besides ext4, and it will make life easier for
other file systems, so I'm willing to try pushing this to Linus if
there is consensus from other fs developers.

						- Ted
