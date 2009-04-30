From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Thu, 30 Apr 2009 10:28:34 +0200
Message-ID: <20090430082834.GA3774@nb.net.home>
References: <20090422133304.GP15541@mit.edu> <20090427092114.GA3193@nb.net.home> <20090428203635.GA3793@nb.net.home> <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <20090427092114.GA3193@nb.net.home> <20090429202338.GD17797@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZD3I2j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Apr 2009 04:28:39 -0400
Content-Disposition: inline
In-Reply-To: <20090429202338.GD17797@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 04:23:38PM -0400, Theodore Tso wrote:
> There have been a few bug fixes and I have some requests to detect
> some new interfaces, such as VMFS, which I'll probably apply to
> e2fsprogs blkid, but I don't expect to do any API or ABI changes, and
> the only changes will be bugfixes and some new detection functions ---
> and I'll make a point of synchronizing such improvements with
> util-linux-ng.  Fair enough?

 Yes, sounds good. My plan is send you all important patches for your
 e2fsprogs version and also periodically pull from your tree.

> As far as I know there are no applications which have used
> blkid_get_library_version(), but what I would suggest is that
> util-linux-bg use a lib_version of 2.15, and people who care about

 Yes, lib_version in my tree is already 2.15.0

> blkid_get_lib_version().  I don't anticipate e2fsprogs ever going to a
> 2.x version at this point --- we'll probably just always update the
> 1.xx version, just to avoid confusion, so I don't think we need to
> worry about freezing this version number.  I'll just put in a comment
> that util-linux-nh will have a 2.x version, and that e2fsprogs will
> have a 1.x version --- not that I think anyone will really care, or
> will try to sample the version number, as long as we're careful about
> not screwing with the ABI.

 OK. Thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
