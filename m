From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 26 Sep 2007 13:05:33 +0100
Message-ID: <20070926120533.GA15894@infradead.org>
References: <20070925153735.GA26693@infradead.org> <20070926105946.GB429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48712 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXIZMFf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Sep 2007 08:05:35 -0400
Content-Disposition: inline
In-Reply-To: <20070926105946.GB429@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 26, 2007 at 06:59:46AM -0400, Theodore Tso wrote:
> It looks like you pulled fsck from the master branch of e2fsprogs git;
> there is one slight bug fix in the maint branch that hasn't been
> merged into master yet, commit ed773a263829493e4e4bf612dbec2380cf09349f:

I'll pick that up.

> BTW, I don't like this syntax in the fstab file AT ALL, but it is in
> use in the wild by at least some Fedora users, and it's not documented
> in the fstab man page.  I'd suggest using a filesystem type of bind,
> rather than ext3, as the officially "blessed" way of specifying it in
> fstab, but it badly needs to be documented in the fstab and/or mount
> man pages.  The above patch should probably get included, though, and
> backwards compatibility for allowing "bind" to be specified in the
> mount options, and with a warning message that the specifying "bind"
> in the options field has been deprecated.

The syntax is indeed horrible.  Is it supported by upstream util-linux?

> For future code movement, I don't mind fsck moving over, but I would
> like to manage moving over blkid to util-linux-ng myself, as I have
> some pretty strong feelings about the right way to do things.  I am
> quite willing to add some low-level interfaces so that fsid can use
> the same fs probing logic, and I'm willing to add some code so that
> the high-level interfaces of libblkid, if the /dev/disk/by-* links are
> present and the user isn't asking for information which isn't in the
> blkid cache, will use the symlinks instead.  However, I really don't
> want to encode a dependency on udev being there, and I think it should
> be possible to make the fallback be transparent instead of being a
> compile-time option.

I've started looking into this, and I think at least for the detect
which filesystem we have part libblkid is complete overkill.  libvolume_id
has a really nice lowlevel API for that that is much more suitable.

So if it was up to me I'd do the following:

 - move libvolume_id out of udev
 - make mount/fsck use libvolume_id unconditionally for detecting the
   filesystem type.  There's absolute no reason to use anything in
   libblkid for this, and caching the result doesn't help us at all
   as we're going to touch the disk anyway as part of the mount/fsck.
 - make libblkid use libvolume_id internally for filesystem detection

note that the latter might aswell be a static inclusion of the code,
I haven't looked at the details yet.

Another note on moving the libraries into util-linux vs a standalone package:
At least in xfs land people do upgrade xfsprogs frequently and sometimes
independent os the distro because new features get added quite a bit, including
new filesystem features that require support.  Having to upgrade util-linux
for that is not very helpful.  So I'm not so sure about moving this to
util-linux
