From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4-stable build failure (Re: Ext4 tree backports for
	2.6.27.10 and 2.6.28)
Date: Sat, 17 Jan 2009 18:03:22 -0500
Message-ID: <20090117230322.GA25943@mit.edu>
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090117231651.78b2cce5@highlander.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
To: Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41912 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925AbZAQXD0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 18:03:26 -0500
Content-Disposition: inline
In-Reply-To: <20090117231651.78b2cce5@highlander.home.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 17, 2009 at 11:16:51PM +0100, Malte Schr=F6der wrote:
>=20
> kernel 2.6.28 with ext4-stable fails to build for SMP on AMD64.
>=20
> Building modules, stage 2.
> MODPOST 905 modules
> ERROR: "inode_lock" [fs/ext4/ext4.ko] undefined!
>=20
> I had to revert 5cb8613e44b6e6c77dcf231d691b96c91a5adeab (ext4: Add a
> delayed allocation debugging ioctl), after that it works.

I see the problem; inode_lock isn't currently an exported symbol, and
I generally don't compile ext4 as a module, so I didn't notice the
problem.  The patch in question is a debugging patch that is never
meant for mainline or a for-stable series, so the simplest thing to do
for now is just to revert the patch.  I'll look into a module-friendly
way of accomplishing the same goal.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
