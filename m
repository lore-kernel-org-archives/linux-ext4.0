From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fuzz testing an ext4fs file system under a 32 bit Linux user
 mode linux guest let task jbd2/ubda hang
Date: Sat, 9 Aug 2014 16:00:18 -0400
Message-ID: <20140809200018.GG15431@thunk.org>
References: <53DE3E92.3060304@gmx.de>
 <20140803184210.GV24826@thunk.org>
 <53E66C57.8010303@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	UML devel <user-mode-linux-devel@lists.sourceforge.net>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52557 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaHIUJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 16:09:52 -0400
Content-Disposition: inline
In-Reply-To: <53E66C57.8010303@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 09, 2014 at 08:45:43PM +0200, Toralf F=F6rster wrote:
>=20
> BTW may I just ask, if the following (same 32 bit system, host and
> UML guest are both at v3.16, 4 trinity childs hammering victims
> files in a ramdisk within the uML guest) matches the above too ? Or
> does the BUG output here more helpful data ? :

Unfortunately, there's nothing useful here.  There is more than one
BUG_ON() in this mpage_release_unused_pages function, and what's more,
we have no idea which syscall or combination of syscalls might have
left a page in a particular state.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
