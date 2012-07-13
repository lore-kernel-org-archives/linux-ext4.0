From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add support for DragonFly BSD operating system.
Date: Thu, 12 Jul 2012 20:30:26 -0400
Message-ID: <20120713003026.GA30092@thunk.org>
References: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Antonio Huete =?iso-8859-1?Q?Jim=E9nez?= <ahuete.devel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38813 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2GMAaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2012 20:30:30 -0400
Content-Disposition: inline
In-Reply-To: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 12, 2012 at 09:48:37PM +0200, Antonio Huete Jim=E9nez wrote=
:
>=20
> - Add a new OS tag.

Is there a particular reason why you need the OS tag?  That's really
more of a historical thing than anything else.  I'd be much happier
renaming the FreeBSD tag to BSD.

The only thing where we change what we do based on the OS tag was for
the Hurd operating system, and I consider what was done back then by
Remy Card (one of the original ext2 authors) to be a design mistake.

Also, for future reference, it's highly preferable to have separate
patches for each logically distinct change; it's easier to review,
especially if it's only one patch out of several that needs to be
modified/reworked.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
