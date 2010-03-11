From: tytso@mit.edu
Subject: Re: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 15:37:49 -0500
Message-ID: <20100311203749.GJ1497@thunk.org>
References: <4B991C81.5040506@redhat.com>
 <20100311172748.GC19923@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47334 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0CKUhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 15:37:54 -0500
Content-Disposition: inline
In-Reply-To: <20100311172748.GC19923@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 11, 2010 at 06:27:48PM +0100, Jan Kara wrote:
>   Yeah, this is a good point... Honestly, I don't quite understand what's
> the problem with "minimalist kernel fanatics" going and mounting all the
> devices as ext4 (when they decided to compile kernel without ext2/3) - no
> need for special kernel option. It will probably need some tweaks in
> automounters but still...

The number of places in userspace that try to automatically decide
whether to mount a particular filesystem as "ext2", "ext3", or "ext4",
is somewhat large.  It's not just blkid (which is no longer under my
control); there are magic programs in various distributions
initramfs's, and I don't blame people who don't want to mess with that
that; at least for some distributions, it's a fragile PoS that the
less you have to mess with, the better.  (Since any failures in the
initramfs image are effectively impossible to debug.)

So if some people want to be able to seemlessly start using ext4 and
not have to worry about doing a search through all of userspace and
their config files, and we get a bit more testing of ext4 in somewhat
"nonstandard" configurations, as far as I'm concerned it's all good.

I agree that most distributions are highly unlikely to ever want to
turn on this CONFIG option; it's really more for the Linux From
Scratch or maybe Gentoo users.

				- Ted
