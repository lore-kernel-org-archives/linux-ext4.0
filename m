From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature is
 enabled
Date: Tue, 4 Mar 2014 10:19:25 -0500
Message-ID: <20140304151925.GC23106@thunk.org>
References: <1372928710-10461-1-git-send-email-guaneryu@gmail.com>
 <20130705012128.GA11793@gmail.com>
 <20130707154140.GA11993@thunk.org>
 <alpine.LFD.2.00.1403031640020.2258@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36864 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbaCDPT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2014 10:19:29 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403031640020.2258@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 04:40:21PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> are you going to take this in ?
>=20
> > It's better to use the resize_inode for file systems that are small=
er
> > than 16TB, even if the 64-bit flag is enabled, since using the meta=
_bg
> > style resizing spreads out the block group descriptors, which
> > increases the time to mount the file system.  Using the resize_inod=
e
> > will defer the need to go to the meta_bg-style resizing until we cr=
oss
> > the 16TB boundary.

See my comments above.

If we create a file system which is say, 1T but with the 64-bit flag,
we do want the resize_inode feature to be used until we cross over the
32-bit boundary, because keeping block group descriptors contiguous
speeds up the mount time.

If I were to accept this patch, and/or Red Hat were to ship with it, I
will predict that you will get angry customer support calls about file
system mount times getting slow after doing a resize.

At some point what we may want to lazily load the block group
descriptors at mount time, to mitigate the slow mount time issue when
using meta_bg.  We have a lot of assumptions in the code that the
block group descriptors are always available, though.

      	    		    	   	      - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
