From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Wed, 29 Apr 2009 16:23:38 -0400
Message-ID: <20090429202338.GD17797@mit.edu>
References: <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <20090427092114.GA3193@nb.net.home> <20090428203635.GA3793@nb.net.home> <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <20090427092114.GA3193@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50262 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760668AbZD2UXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 16:23:44 -0400
Content-Disposition: inline
In-Reply-To: <20090428203635.GA3793@nb.net.home> <20090427092114.GA3193@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 10:36:35PM +0200, Karel Zak wrote:
> >  I forgot that we need to freeze blkid version number in e2fsprogs to
> >  avoid collisions between e2fsprogs and util-linux-ng. Currently the
> >  blkid version number is shared with e2fsprogs version number. 
> 
>  It seems we can ignore this problem for now. I can release
>  libblkid 2.15 (=util-linux-ng version) and keep the same SONAME as
>  you have in e2fsprogs -- it means soname "libblkid.so.1".
> 
>  It seems people prefer the same version for library as well as for
>  whole package.

Right, I made a point of not changing the libblkid ABI, and I tend to
prefer to keep the library SONAME version independent of the package
version, because I'm a firm believer in stable ABI's.  In terms of the
package version, that's going to depend on distribution.  So the blkid
shared library version has never changed because I've been careful
about not screwing with the ABI.  Technically I should have bumped the
minor version when I added new interfaces, but since no one really
pays attention to the minor version number of shared libraries, I was
lazy and the shared library version number has always stayed at 1.0.

As far as package versions are concerned, Debian and Ubuntu uses a
package name of "libblkid1" (where the 1 comes from the shared library
version), and a version number which is equal to the e2fsprogs version
(1.45).  Red Hat and Novell will use different version numbers, but if
it's based on the package version, then 2.15 is greater than 1.45 (the
e2fsprogs version), so that should work just fine.

On Mon, Apr 27, 2009 at 11:21:14AM +0200, Karel Zak wrote:
>
>  I forgot that we need to freeze blkid version number in e2fsprogs to
>  avoid collisions between e2fsprogs and util-linux-ng. Currently the
>  blkid version number is shared with e2fsprogs version number. 
> 
>  The e2fsprogs blkid should be in maintenance mode only. All development
>  should happen in util-linux-ng only. Right?

There have been a few bug fixes and I have some requests to detect
some new interfaces, such as VMFS, which I'll probably apply to
e2fsprogs blkid, but I don't expect to do any API or ABI changes, and
the only changes will be bugfixes and some new detection functions ---
and I'll make a point of synchronizing such improvements with
util-linux-ng.  Fair enough?

>  (See the patch below -- it's example. I don't know if you want to add
>   LIBBLKID_VERSION to the global version.h or something other to
>   configure.in, or so...)

As far as I know there are no applications which have used
blkid_get_library_version(), but what I would suggest is that
util-linux-bg use a lib_version of 2.15, and people who care about
whether they have the e2fsprogs or util-linug-ng version of e2fsprogs
can simply check for a 1.x or 2.x blkid version number as returned by
blkid_get_lib_version().  I don't anticipate e2fsprogs ever going to a
2.x version at this point --- we'll probably just always update the
1.xx version, just to avoid confusion, so I don't think we need to
worry about freezing this version number.  I'll just put in a comment
that util-linux-nh will have a 2.x version, and that e2fsprogs will
have a 1.x version --- not that I think anyone will really care, or
will try to sample the version number, as long as we're careful about
not screwing with the ABI.

					- Ted
