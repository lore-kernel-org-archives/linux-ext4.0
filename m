From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Wed, 22 Apr 2009 09:49:45 -0400
Message-ID: <20090422134945.GQ15541@mit.edu>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <1240407745.2902.3.camel@wing-commander>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39421 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZDVNtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 09:49:51 -0400
Content-Disposition: inline
In-Reply-To: <1240407745.2902.3.camel@wing-commander>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 22, 2009 at 02:42:25PM +0100, Scott James Remnant wrote:
> 
> Obviously this doesn't solve the debian/control problem - that would
> require generating it with/without the libblkid parts depending on
> target distro.

One of the things I need to look at, but maybe you know off-hand, is
whether the debian/rules can safely modify debian/control file.  I
haven't looked deeply into the underbelly of how dpkg-buildpackage and
its descendents work to know whether or not that can be done safely.
If not, we might have to have a separate shell script which is run
manually that adjusts debian/control and debian/rules file.  That
would be annoying/unfortunate, but doable.

						- Ted
