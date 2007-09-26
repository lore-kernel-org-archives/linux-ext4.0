From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 26 Sep 2007 06:59:46 -0400
Message-ID: <20070926105946.GB429@thunk.org>
References: <20070925153735.GA26693@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54101 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbXIZK7w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 06:59:52 -0400
Content-Disposition: inline
In-Reply-To: <20070925153735.GA26693@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2007 at 04:37:35PM +0100, Christoph Hellwig wrote:
> This adds fsck from latest e2fsprogs git to util-linux.  There are only
> tiny changes to integrate it into the build system and nls setup of
> util-linux and fixing up the trailing whitespaces quilt is complaining
> about.  I've not yet converted it to the fsprobe helpers as the discussion
> on those libs is still ongoing and I haven't read up on the fsprobe library
> either.

It looks like you pulled fsck from the master branch of e2fsprogs git;
there is one slight bug fix in the maint branch that hasn't been
merged into master yet, commit ed773a263829493e4e4bf612dbec2380cf09349f:

    fsck: Ignore /etc/fstab entries for bind mounts
    
    If a user specifies a bind mount with a non-zero fsck pass number, for
    example:
    
    /foo    /bar    ext3    bind,defaults   1 3
    
    print a warning and ignore the fstab entry.
    
    Addresses-Red-Hat-Bugzilla: #151533
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

BTW, I don't like this syntax in the fstab file AT ALL, but it is in
use in the wild by at least some Fedora users, and it's not documented
in the fstab man page.  I'd suggest using a filesystem type of bind,
rather than ext3, as the officially "blessed" way of specifying it in
fstab, but it badly needs to be documented in the fstab and/or mount
man pages.  The above patch should probably get included, though, and
backwards compatibility for allowing "bind" to be specified in the
mount options, and with a warning message that the specifying "bind"
in the options field has been deprecated.

So with the above patch included,

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

For future code movement, I don't mind fsck moving over, but I would
like to manage moving over blkid to util-linux-ng myself, as I have
some pretty strong feelings about the right way to do things.  I am
quite willing to add some low-level interfaces so that fsid can use
the same fs probing logic, and I'm willing to add some code so that
the high-level interfaces of libblkid, if the /dev/disk/by-* links are
present and the user isn't asking for information which isn't in the
blkid cache, will use the symlinks instead.  However, I really don't
want to encode a dependency on udev being there, and I think it should
be possible to make the fallback be transparent instead of being a
compile-time option.

Regards,

						- Ted
