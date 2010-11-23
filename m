From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [4/6] mke2fs: Deprecate -K option, introduce discard/nodiscard
Date: Tue, 23 Nov 2010 10:17:30 -0500
Message-ID: <20101123151730.GD32759@thunk.org>
References: <1290087521-9123-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, adilger@dilger.ca, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52331 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0KWPSt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:49 -0500
Content-Disposition: inline
In-Reply-To: <1290087521-9123-5-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 03:38:39AM -0000, Lukas Czerner wrote:
> It would be nice to have consistent "discard" options in every system
> tool (mount, fsck, mkfs) taking advantage of discards. Also "discard"
> and "nodiscard" is more descriptive instead of just "-K" and can be
> easily defaulted and it is something we can not do with "-K".
> 
> With this commit you need to specify extended option like this:
> 
> ./mke2fs -T <fstype> -E nodiscard <device>
> 
> in order make a filesystem without discarding the device first. And
> 
> ./mke2fs -T <fstype> -E discard <device>
> 
> respectively.
> 
> -K option is with this commit deprecated and should not be used anymore.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied to the maint branch of e2fsprogs, so it will make 1.41.13.

	       	     	       		     - Ted
