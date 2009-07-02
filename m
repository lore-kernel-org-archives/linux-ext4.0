From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:
	libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 20:58:58 -0400
Message-ID: <20090702005858.GH17054@mit.edu>
References: <200905311113.23004.arvidjaar@mail.ru> <20090701214345.GG17054@mit.edu> <ac3eb2510907011452g3c2c2b3cs8d0ed398117879be@mail.gmail.com> <200907011835.08501.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56201 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZGBA7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2009 20:59:14 -0400
Content-Disposition: inline
In-Reply-To: <200907011835.08501.vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 01, 2009 at 06:35:06PM -0400, Mike Frysinger wrote:
> > In older udev releases, before we switched to automake, I had
> > something like this, which behaves a bit like the Linux kernel build,
> > and V=1 switches off the silent mode:
> 
> why not just use automake-1.11's silent-rules option.  then you dont have to 
> waste time reinventing the wheel.

Because I consider automake the spawn of Satan?  :-)

							- Ted
