From: Greg KH <greg@kroah.com>
Subject: Re: [stable] Stable patches for ext4
Date: Sat, 18 Oct 2008 10:03:05 -0700
Message-ID: <20081018170305.GB20305@kroah.com>
References: <E1KrCdX-0006L5-2q@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751552AbYJRRG3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Oct 2008 13:06:29 -0400
Content-Disposition: inline
In-Reply-To: <E1KrCdX-0006L5-2q@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 18, 2008 at 10:18:35AM -0400, Theodore Ts'o wrote:
> 
> 
> I'm a bit concerned about asking Greg or Chris to take the delayed
> allocation ENOSPC patches, although they really are critical for someone
> considering using ext4 in production (and granted, they would probably
> be better waiting until 2.6.28).

Heh, you do realize that hundreds of thousands of users are going to be
using 2.6.27.x "for production" as at least 3 distros are being based
off of it?

So, either you send these patches to us if you want to have a sane idea
of what the distros are using, or you rely on the distros themselves to
get it right in cherry-picking from upstream here.  I know one distro
already has done this, and I'm sure others have as well.

It comes down to who you trust, a random distro engineer, or you and
your group of engineers :)

If you feel the second tree is something that you can support, and you
feel is necessary for users if they want to use ext4 on this kernel
release, I'd be glad to review them for inclusion.

thanks,

greg k-h
